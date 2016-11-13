class GiftPdf < Prawn::Document
  def initialize(gift, timeframe, sortby, topn)
    super()
    @gifts = gift
    @timeframe = timeframe
    @sortby = sortby
    @topn = topn
    @giftTotal = 0
    header
    text_content
    table_content
  end

  # Source: https://www.sitepoint.com/pdf-generation-rails/
  # under the first section for prawn.
  
  def header
    text "Gifts Report", size: 24, style: :bold, :align => :center
  end
  
  def text_content
    y_position = cursor - 20

    bounding_box([0, y_position], :width => 658, :height => 50) do
      text "This Gift Garden report created " + Time.zone.now.to_date.to_s + " by Pat M.", size: 15
      text "Report options: " + timeframe_exalanation(@timeframe) + 
       "," + topn_explanation(@topn) +  "sorted by " + @sortby.to_s, size: 15
    end
  end

  def table_content
    table gift_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [60, 145, 115, 60, 75, 80]
      style(column(5), align: :right)
    end
    table total_row do
      row(0).font_style = :bold
      self.row_colors = ['DDDDDD']
      self.column_widths = [60, 145, 115, 60, 75, 80]
      style(column(5), align: :right)
    end
  end

  def gift_rows
    [['ID', 'Activity Name', 'Donor Name', 'Donor ID', 'Gift Date', 'Gift Amount']] +
      @gifts.map do |gift|
        activity = Activity.find([gift.activity_id])
        activityName = ''
        activity.each do |a|
          activityName = a.name
        end
        donor = Donor.find([gift.donor_id])
        donorName = ''
        donorID = ''
        donor.each do |d|
          donorName = d.last_name + ", " + d.first_name
          donorID = d.id.to_s
        end
        @giftTotal += gift.amount
        giftAmount = format_currency(gift.amount.to_s, true)
      [("GFT" + gift.id.to_s), activityName, donorName, 
      ("DON" + donorID), gift.donation_date, 
        giftAmount]
    end
  end   
  
  def total_row
    @giftTotal = format_currency(@giftTotal.to_s, true)
    [['', '', 'Total', '', '', @giftTotal]]
  end
  
  #custom currency formatting method for reports
  #handles any monetary amounts under $1bn
  def format_currency(amount, chopOff)
    if amount.length > 0
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
    else
      return ''
    end
  end
  
    #timeframe 'more-English-like' conversion
  def timeframe_exalanation(range)
    result = ""
    case range
      when "All"
        result += "All Gifts listed"
      when "This Year"
        result += "This year's Gifts"
      when "This Quarter"
        result += "This quarter's Gifts"
      when "This Month"
        result += "This month's Gifts"
      when "Last Year"
        result += "Last year's Gifts"
      when "Last Quarter"
        result += "Last quarter's Gifts"
      when "Last Month"   
        result += "Last month's Gifts"
      when "Past 2 Years"
        result += "Gifts from " + Time.now.year.to_s + " and " + 
          (Time.now.year - 1).to_s
      when "Past 5 Years"
        result += "Gifts from " + (Time.now.year - 4).to_s + " to " + 
          Time.now.year.to_s
      when "Past 2 Quarters"
        result += "Gifts from the Past 2 quarters"
      when "Past 3 Months"
        result += "Gifts from the Past 3 months"
      when "Past 6 Months"
        result += "Gifts from the Past 6 months"
    end
    result
  end
  
  #topn 'more-English-like' conversion
  def topn_explanation(range)
    result = " "
    case @topn
    when 'all'
      result += ""
    when '10'
      result += "Top 10 Gifts "
    when '20'
      result += "Top 20 Gifts "
    when '50'
      result += "Top 50 Gifts "
    when '100'
      result += "Top 100 Gifts "
    end
    result
  end
end