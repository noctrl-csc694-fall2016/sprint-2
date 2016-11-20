  #----------------------------------#
  # One Donor PDF Output
  # original written by: Jason K, Nov 12 2016
  # major contributions by:
  #
  #----------------------------------#
class OneDonorPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  
  def initialize(requestorData, donorData, selectedGiftsArray, selectedGiftsCount, selectedGiftsSum)
    super()
    @requestor = requestorData
    @donorData = donorData
    @gifts = selectedGiftsArray
    @countGifts = selectedGiftsCount
    @sumGifts = selectedGiftsSum
    header
    text_content
    contact_text_content
    contact_table_content
    gift_text_content
    gift_sum_content
  end
  
  #################################
  # Output header of PDF document
  #################################
  def header
    image "#{Rails.root}/app/assets/images/giftgardensmall.jpg", 
    width: 40, height: 40
    move_up 30
    text "One Donor Report", size: 24, style: :bold, :align => :center
  end
  
  #################################
  # Output search criteria
  #################################  
  def text_content
    y_position = cursor - 20

    bounding_box([0, y_position], :width => 658, :height => 75) do
      text "This Gift Garden report created " + Time.zone.now.to_date.strftime("%b %d, %Y") + " by " + @requestor, size: 15
      text "Report options: Donor is "+ @donorData[0] + " (" + @donorData[2] + ", " + @donorData[1] + ")", size: 15
    end
  end
  
  #################################
  # Output contact information header and content
  #################################  
  def contact_text_content
    y_position = cursor - 10
    
    bounding_box([0, y_position], :width => 658, :height => 25) do  
      text "Contact Information:", size: 15
    end  
    
    table contact_table_content do
      row(0).font_style = :bold
      self.header = true
      style(column(0), align: :center)
      style(column(1), align: :left)
      style(column(2), align: :center)
      self.column_widths = [80,230,230]
    end
  end
  
  #################################
  # Helper method for outputting donor contact information
  #################################  
  def contact_table_content
    donor_id = @donorData[0]
    donor_address = @donorData[1] + " " + @donorData[2] + "\n" + @donorData[3] + "\n" + @donorData[5] + ", " + @donorData[6] + " " +  @donorData[7] 
    donor_contact = @donorData[8] + "\n\n" + @donorData[9]
    
    [["ID", "Name/Address", "Phone/Email"], [donor_id, donor_address, donor_contact]]
  end
  
  #################################
  # Output gift content header
  #################################   
  def gift_text_content
    y_position = cursor - 20
    
    bounding_box([0, y_position], :width => 658, :height => 25) do  
      text "Gift History:", size: 15
    end
    
    table gift_table_content do
      style(row(0).column(2), background_color: "DDDDDD")
      row(0).font_style = :bold
      self.header = true
      style(column(0), align: :center)
      style(column(1), align: :center)
      style(column(2), align: :center)
      style(column(3), align: :right)
      self.column_widths = [80,170,145,145]
    end
  end
  
  #################################
  # Helper method for outputting gifts
  #################################  
  def gift_table_content
    [['ID', 'Activity Name', 'Gift Date', 'Gift Amount']] +
    @gifts.map do |gift|
      giftAmount = number_to_currency(gift.amount, precision: 0)
      ["GFT" + gift.id.to_s, Activity.find(gift.activity).name, gift.donation_date.strftime("%b %d, %Y"), giftAmount]
    end
  end
  
    #################################
  # Output gift sum
  #################################  
  def gift_sum_content
    table gift_sum_table_content do
      row(0).font_style = :bold
      self.row_colors = ['DDDDDD']
      self.column_widths = [80,170,145,145]
      style(column(2), align: :center)
      style(column(3), align: :right)
    end
  end
  
  #################################
  # Helper method for outputting sum
  #################################  
  def gift_sum_table_content
    giftAmount = number_to_currency(@sumGifts, precision: 0)
    [['', '', @countGifts + " gifts", giftAmount]]
  end
end