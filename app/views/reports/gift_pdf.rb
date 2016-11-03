class GiftPdf < Prawn::Document
  def initialize(gift)
    super()
    @gifts = gift
    table_content
  end

  # Source: https://www.sitepoint.com/pdf-generation-rails/
  # under the first section for prawn.

  def table_content
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