class InkindPdf < Prawn::Document
  def initialize(gift, activity, timeframe, sortby, user)
    super()
    @gifts = gift
    @activity = Activity.find(activity).name
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
    text "In Kind Report", size: 24, style: :bold, :align => :center
  end
  
  def text_content
    y_position = cursor - 20

    bounding_box([0, y_position], :width => 658, :height => 50) do
      text "This Gift Garden report created " + Time.zone.now.to_date.to_s + 
      " by " + @user['username'].to_s + ".", size: 15
      text "Report options: " + @activity.to_s + "; " + timeframe_exalanation(@timeframe) + 
       "; " +  "sorted by " + @sortby.to_s + ".", size: 15
    end
  end

  def table_content
    table gift_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [60, 100, 70, 80, 225]
      style(column(5), align: :right)
    end
  end

  def gift_rows
    [['ID', 'Donor Name', 'Donor ID', 'Gift Date', 'Notes']] +
      @gifts.map do |gift|

        donor = Donor.find([gift.donor_id])
        donorName = ''
        donorID = ''
        donor.each do |d|
          donorName = d.last_name + ", " + d.first_name
          donorID = d.id.to_s
        end
        giftNotes = gift.notes.to_s
      [("GFT" + gift.id.to_s), donorName, 
      ("DON" + donorID), gift.donation_date, 
        giftNotes]
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
  
end