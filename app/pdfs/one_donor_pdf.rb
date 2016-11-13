class OneDonorPdf < Prawn::Document
  def initialize(one_donor_data)
    super()
    @donor_data = one_donor_data
    header
    text_content
    table_content
  end
  
  def header
    text "One Donor Report", size: 24, style: :bold, :align => :center
  end
  
  def text_content
    y_position = cursor - 20

    bounding_box([0, y_position], :width => 658, :height => 25) do
      text "This Gift Garden report created " + Time.zone.now.to_date.to_s + " by " + @donor_data[0][0], size: 15
    end
  end
  
  def table_content
  
  end
    
end