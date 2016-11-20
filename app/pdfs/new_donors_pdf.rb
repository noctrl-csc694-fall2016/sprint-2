class NewDonorsPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  
  def initialize(reportDonorsArray, times, sortby, fullcontact, current_user)
    super()
    @donors = reportDonorsArray
    @timeFrame = times
    @sort = sortby
    @full = fullcontact
    @requestor = current_user
    header
    text_content
    table_content
  end
  
  def header
    image "#{Rails.root}/app/assets/images/giftgardensmall.jpg", 
    width: 40, height: 40
    move_up 30
    text "New Donors Report", size: 24, style: :bold, :align => :center
  end 
  
  def text_content
    y_position = cursor - 20

    bounding_box([0, y_position], :width => 658, :height => 80) do
      text "New Donors report created " + Time.zone.now.to_date.to_s + 
      " by " + @requestor + ".", size: 15
      text "Report options: New Donors in " + @timeFrame + "." + " Sorted by" + @sort + ")", size: 15
      if @full
        text "Full contact info for donors.", size: 15
      end
    end
  end
  
  def table_content
    table new_donors_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [80, 150, 135, 80, 80]
      style(column(4), align: :right)
      end
  end
  
  def new_donors_rows
    if @full
    else
      [['ID', 'Donor Name', 'Last Gift Date', 'Num Gifts', 'Gift total']] +
        @donors.map do |donor|
          [("DON" + donor.id.to_s), donor.last_name.to_s + ", " + donor.first_name.to_s, 
             donor.title, Gift.where(:donor_id => donor.id).count, format_currency(donor.nickname, false)]
      end
    end
  end
  
  def gift_count_per_donor(donor)
    selected_gifts = Gift.where(:donor_id => donor)
    selected_gifts.count
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
  
end