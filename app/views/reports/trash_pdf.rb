class TrashPdf < Prawn::Document
  def initialize(trash)
    super()
    @trashes = trash
    header
    table_content
  end
  
  def header
    text "Trash Report", size: 24, style: :bold, :align => :center
  end
  
  def table_content
    table trash_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [40, 400]
      end
  end
  
  def trash_rows
    [['Type', 'Content']] +
      @trashes.map do |t|
        [t.category, t.content]
    end
  end
  
end