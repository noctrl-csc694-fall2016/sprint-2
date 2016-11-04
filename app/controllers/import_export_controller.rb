class ImportExportController < ApplicationController
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
    if params[:file_name].nil?
      flash[:error] = "Please choose a file."
      redirect_to import_export_url
    end
  end
  
  def import_gifts_success
  end
end
