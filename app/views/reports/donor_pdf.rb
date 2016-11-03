class DonorPdf < Prawn::Document
  def initialize(donor, timeframe, sortby, topn)
    super()
    @donors = donor
    @timeframe = timeframe
    @sortby = sortby
    @topn = topn
    header
    text_content
    table_content
  end

  # Source: https://www.sitepoint.com/pdf-generation-rails/
  # under the first section for prawn.

  def header
    text "Donors Report", size: 24, style: :bold, :align => :center
  end
  
  def text_content
    y_position = cursor - 20

    bounding_box([0, y_position], :width => 658, :height => 50) do
      text "This GiftGarden report created " + Time.zone.now.to_date.to_s + 
      " by John Smith.", size: 15
      text "Report options: Timeframe " + @timeframe + ", Sorted by " + @sortby.to_s + 
      ", Top N " + @topn + ".", size: 15
    end
  end

  def table_content
    table donor_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [40, 175, 90, 80, 65]
      end
  end

  def donor_rows
    [['ID', 'Donor Name', 'City, State', 'Date of Last Gift', 'Gift Total']] +
      @donors.map do |donor|
      [donor.id.to_s, donor.first_name.to_s + " " + donor.last_name.to_s, 
      donor.city.to_s + " " + donor.state, donor.updated_at.to_date.to_s, ""]
    end
  end
end
