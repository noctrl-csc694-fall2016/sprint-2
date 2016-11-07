class ActivityPdf < Prawn::Document
  def initialize(activity, timeframe, sortby)
    super()
    @activities = activity
    @timeframe = timeframe
    @sortby = sortby
    header
    text_content
    table_content
  end

  # Source: https://www.sitepoint.com/pdf-generation-rails/
  # under the first section for prawn.
  
  def header
    text "Activities Report", size: 24, style: :bold, :align => :center
  end
  
  def text_content
    y_position = cursor - 20

    bounding_box([0, y_position], :width => 658, :height => 50) do
      text "This Gift Garden report created " + Time.zone.now.to_date.to_s + " by Jane Doe.", size: 15
      text "Report options: Timeframe " + @timeframe + ", Sorted by " + @sortby + ".", size: 15
    end

  end

  #defines table layout format
  def table_content
    table activity_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [40, 175, 90, 80, 65, 65]
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
        giftTotal = '$' + giftTotal.to_s
      end
      
       #clean fields up if needed
      goal = '$' + activity.goal.to_s
      2.times do goal.chop! end #takes off the .0 for goals
      
      #calculate progress % to goal
      if ((giftTotal == '') or (activity.goal == 0))#handles General activity
        progressPercentage = ''
      else
        progressTotal = goal[1..-1]
        progressAmount = giftTotal[1..-1]
        begin
        progressFloat = (progressAmount.to_f) / (progressTotal.to_f) * 100
        rescue FloatDomainError
        progressFloat = ''
        end
        progressPercentage = progressFloat.round.to_s + '%'
      end
      
      #define the content that goes in each column per activity    
      [activity.id.to_s, activity.name.to_s, activity.end_date.to_s, 
        goal, giftTotal, progressPercentage]
      end
  end
end