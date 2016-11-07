class ContactPdf < Prawn::Document
  def initialize(donor, timeframe, sortby, topn)
    super(:page_layout => :landscape)
    @donors = donor
    @timeframe = timeframe
    @sortby = sortby
    @topn = topn
    header
    text_content
    table_content
  end

  def header
    image "#{Rails.root}/app/assets/images/giftgardensmall.jpg", 
    width: 79, height: 79
    move_up 35
    text "Full Contact Donors Report", size: 24, style: :bold, :align => :center  
  end
  
  def text_content
    y_position = cursor - 20

    bounding_box([0, y_position], :width => 658, :height => 25) do
      text "This Gift Garden report created " + Time.zone.now.to_date.to_s + 
      " by John Smith.", size: 15
    end
  end
  
  def table_content
    table donor_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      #width is 720px total
    self.column_widths = [35, 130, 150, 150, 85, 165]
      style(column(4), align: :right)
    end
  end
  
  def donor_rows
    [['ID', 'Donor Name', 'Address', 'City State Zip', 'Phone', 'Email']] +
      @donors.map do |donor|
      [donor.id.to_s, 
      donor.last_name.to_s + ", " + donor.first_name.to_s, 
      donor.address.to_s + "\n" + donor.address2.to_s, 
      donor.city.to_s + ", " + donor.state.to_s + " " + donor.zip.to_s,
      donor.phone.to_s,
      donor.email.to_s]
    end
  end
  
end
