class DonorPdf < Prawn::Document
  def initialize(donor)
    super()
    @donors = donor
    header
    text_content
    table_content
  end

  # Source: https://www.sitepoint.com/pdf-generation-rails/
  # under the first section for puma.

  def header
    #This inserts an image in the pdf file and sets the size of the image
    #image "#{Rails.root}/app/assets/images/header.png", width: 530, height: 150
  end

  def text_content
    # The cursor for inserting content starts on the top left of the page. 
    # Here we move it down a little to create more space between the text and the 
    # image inserted above
  end

  def table_content
    # This makes a call to donor_rows and gets back an array of data that will 
    # populate the columns and rows of a table I then included some styling to 
    # include a header and make its text bold. I made the row background colors 
    # alternate between grey and white Then I set the table column widths
    table donor_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [200, 200]
    end
  end

  def donor_rows
    [['Last Name', 'First Name']] +
      @donors.map do |donor|
      [donor.last_name, donor.first_name]
    end
  end
end