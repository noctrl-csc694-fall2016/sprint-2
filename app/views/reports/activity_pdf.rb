class ActivityPdf < Prawn::Document
  def initialize(activity, timeframe, sortby)
    super()
    @activities = activity
    @timeframe = timeframe
    @sortby = sortby
    header
    text_content
    table_content
  end

  # Source: https://www.sitepoint.com/pdf-generation-rails/
  # under the first section for puma.
  
  def header
    text "Activities Report", size: 24, style: :bold, :align => :center
  end
  
  def text_content
    y_position = cursor - 20

    bounding_box([0, y_position], :width => 658, :height => 50) do
      text "This GiftGarden report created " + Time.zone.now.to_date.to_s + " by Jane Doe.", size: 15
      text "Report options: Timeframe " + @timeframe + ", Sorted by " + @sortby + ".", size: 15
    end

  end

  def table_content
    table activity_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['DDDDDD', 'FFFFFF']
      self.column_widths = [40, 175, 90, 80, 65, 65]
      end
  end
  
  def activity_rows
    [['ID', 'Activity Name', 'End Date', 'Goal', 'Gift total', 'Progress']] +
      @activities.map do |activity|
      [activity.id.to_s, activity.name.to_s, activity.end_date.to_s, 
        activity.goal.to_s, "", ""] #add in gift total and progress later on
    end
  end
end