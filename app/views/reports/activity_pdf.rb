class ActivityPdf < Prawn::Document
  def initialize(activity)
    super()
    @activities = activity
    table_content
  end

  # Source: https://www.sitepoint.com/pdf-generation-rails/
  # under the first section for puma.

  def table_content
    table activity_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [110, 175, 175, 80]
      end
  end

  def activity_rows
    [['Name', 'Start Date', 'End Date', 'Goal']] +
      @activities.map do |activity|
      [activity.name.to_s, activity.start_date.to_s, activity.end_date.to_s, 
        activity.goal.to_s]
    end
  end
end