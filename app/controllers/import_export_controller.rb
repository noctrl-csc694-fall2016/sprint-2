class ImportExportController < ApplicationController
  require 'csv'
  
  def import
     @activities = Activity.all
  end
  
  def importDonors
  end

  def inkind
    @activities = Activity.all
  end

  def export
    @donor = Donor.order(:created_at)
    respond_to do |format|
    format.html
    format.csv { send_data @donor.as_csv, filename: "Donors Export #{Date.today}.csv" }
    end
  end
  
  def import_gifts_begin
    @activities = Activity.all
  end
  
  def import_gifts_validate
    @activity = params[:activity]
    @file = params[:file]
    if @file.nil?
      flash[:error] = "Please choose a file."
      redirect_to import_gifts_begin_url
    end
    CSV.open('/tmp/newtestgifts.csv', "w", :headers => true) do |output|
      CSV.foreach(@file.path, :headers => true, :return_headers => true) do |row|
        if row.header_row?
          output << (row << "testID")
        else
          output << (row << "1")
        end 
      end
    end
    # @result = []
    # CSV.foreach(@file.path, :headers => true) do |row|
    #   @result << (row << "1")
    # end
  end
  
  def import_gifts_success
  end
end
