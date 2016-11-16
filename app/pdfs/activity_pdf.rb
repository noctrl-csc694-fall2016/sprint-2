class ActivityPdf < Prawn::Document
  def initialize(activity, timeframe, sortby, progressFilter, user)
    super()
    @activities = activity
    @timeframe = timeframe
    @sortby = sortby
    @user = user
    header
    text_content
    table_content
  end

  # Source: https://www.sitepoint.com/pdf-generation-rails/
  # under the first section for prawn.
  
  def header
    image "#{Rails.root}/app/assets/images/giftgardensmall.jpg", 
    width: 40, height: 40
    move_up 30
    text "Activities Report", size: 24, style: :bold, :align => :center
  end
  
  def text_content
    y_position = cursor - 20
    
    bounding_box([0, y_position], :width => 658, :height => 50) do
      text "This Gift Garden report created " + Time.zone.now.to_date.to_s + 
      " by " + @user['username'].to_s + ".", size: 15
      text "Report options: " + timeframe_exalanation(@timeframe) + 
      ", sorted by " + @sortby + ".", size: 15
    end

  end

  #defines table layout format
  def table_content
    table activity_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [65, 175, 75, 85, 75, 65]
      style(column(3), align: :right)
      style(column(4), align: :right)
      style(column(5), align: :right)
      end
  end
  
  #defines column labels
  def activity_rows
    [['ID', 'Activity Name', 'End Date', 'Goal', 'Gift total', 'Progress']] +
      @activities.map do |activity|
      
      #calculate associated gifts total
      begin
        gifts = Gift.find([activity.id])
      rescue ActiveRecord::RecordNotFound
        gifts = nil #if no matches found
      end
      giftTotal = '0';
      if gifts.nil? || gifts == 0
        giftTotal = ''
      else
        giftTotal = giftTotal.to_i
        gifts.each do |gift|
          giftTotal += gift.amount.to_i
        end
        
      end
      
      goal = '$' + activity.goal.to_s
      2.times do goal.chop! end #takes off the .0 for goals
      
      
      #calculate progress % to goal
      if ((giftTotal == '') or (activity.goal == 0))#handles General activity
        progressPercentage = ''
      else
        progressTotal = goal[1..-1]
        progressAmount = giftTotal
        begin
        progressFloat = (progressAmount.to_f) / (progressTotal.to_f) * 100
        rescue FloatDomainError
        progressFloat = ''
        end
        progressPercentage = format_currency(progressFloat.round.to_s, false) + "%"
        progressPercentage[0] = ''
      end
      giftTotal = format_currency(giftTotal, false)
      #define the content that goes in each column per activity    
      [("ACT" + activity.id.to_s), activity.name.to_s, activity.end_date.to_s, 
        format_currency(activity.goal, true), giftTotal, progressPercentage]
      end
  end
  
  #custom currency formatting method for reports
  #handles any monetary amounts under $1bn
  def format_currency(amount, chopOff)
    result = amount.to_s
    if chopOff
      2.times do result.chop! end #takes off the .0
    end
    if result.length <= 3
      result = "$" + result
    elsif result.length >= 4 && result.length <=6
      idx = result.length - 3
      result = "$" + result[0,idx] + "," + result[(idx)..(idx + 2)]
    elsif result.length >= 7 && result.length <=9
      idx = result.length - 6
      result = "$" + result[0,idx] + "," + result[(idx)..(idx + 2)] + "," + 
        result[(idx + 3)..(idx + 5)]
    end
    return result
  end
  
  #timeframe 'more-English-like' conversion
  def timeframe_exalanation(range)
    result = ""
    case range
      when "All"
        result += "All Activities listed"
      when "This Year"
        result += "This year's Activities"
      when "This Quarter"
        result += "This quarter's Activities"
      when "This Month"
        result += "This month's Activities"
      when "Last Year"
        result += "Last year's Activities"
      when "Last Quarter"
        result += "Last quarter's Activities"
      when "Last Month"   
        result += "Last month's Activities"
      when "Past 2 Years"
        result += "Activities from " + Time.now.year.to_s + " and " + 
          (Time.now.year - 1).to_s
      when "Past 5 Years"
        result += "Activities from " + (Time.now.year - 4).to_s + " to " + 
          Time.now.year.to_s
      when "Past 2 Quarters"
        result += "Activities from the Past 2 quarters"
      when "Past 3 Months"
        result += "Activities from the Past 3 months"
      when "Past 6 Months"
        result += "Activities from the Past 6 months"
    end
    result
  end
end