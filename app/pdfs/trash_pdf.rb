class TrashPdf < Prawn::Document
  def initialize(trash)
    super()
    @trashes = trash
    header
    text_content
    table_content
  end
  
  def header
    text "Trash Report", size: 24, style: :bold, :align => :center
  end
  
  def text_content
    y_position = cursor - 20

    bounding_box([0, y_position], :width => 658, :height => 25) do
      text "Trash report created " + Time.zone.now.to_date.to_s, size: 15
    end

  end
  
  def table_content
    table trash_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [80, 460]
      end
  end
  
  def trash_rows
    [['Trash Type', 'Content']] +
      @trashes.map do |t|
        [t.trash_type, t.content]
    end
  end
  
end