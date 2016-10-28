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
end
