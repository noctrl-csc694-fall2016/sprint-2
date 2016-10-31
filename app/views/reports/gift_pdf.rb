class GiftPdf < Prawn::Document
  def initialize(gift)
    super()
    @gifts = gift
    table_content
  end

  # Source: https://www.sitepoint.com/pdf-generation-rails/
  # under the first section for puma.

  def table_content
    # This makes a call to gift_rows and gets back an array of data that will 
    # populate the columns and rows of a table I then included some styling to 
    # include a header and make its text bold. I made the row background colors 
    # alternate between grey and white Then I set the table column widths
    table gift_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [180, 180, 180]
    end
  end

  def gift_rows
    [['Date Received', 'Amount', 'Type of Donation']] +
      @gifts.map do |gift|
      [gift.donation_date, gift.amount, gift.gift_type]
    end
  end    
end