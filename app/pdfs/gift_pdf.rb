class GiftPdf < Prawn::Document
  def initialize(gift, timeframe, sortby)
    super()
    @gifts = gift
    @timeframe = timeframe
    @sortby = sortby
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
      text "This GiftGarden report created " + Time.zone.now.to_date.to_s + " by Pat M.", size: 15
      text "Report options: Timeframe " + @timeframe + ", Sorted by " + @sortby + ".", size: 15
    end
  end

  def table_content
    table gift_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [40, 155, 115, 60, 80, 80]
      style(column(5), align: :right)
    end
    table total_row do
      row(0).font_style = :bold
      self.row_colors = ['DDDDDD']
      self.column_widths = [40, 155, 115, 60, 80, 80]
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
        giftAmount = '$' + gift.amount.to_s
        2.times do giftAmount.to_s.chop! end
      [gift.id.to_s, activityName, donorName, donorID, gift.donation_date, 
        giftAmount]
    end
  end   
  
  def total_row
    @giftTotal = '$' + @giftTotal.to_s
    2.times do @giftTotal.to_s.chop! end
    [['', '', 'Total', '', '', @giftTotal]]
  end
end