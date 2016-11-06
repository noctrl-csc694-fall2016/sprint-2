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
  
  # https://richonrails.com/articles/importing-csv-files
  def import_gifts_validate
    @activity = params[:activity]
    @file = params[:file]
    if @file.nil?
      flash[:error] = "Please choose a file."
      redirect_to import_gifts_begin_url
      return
    end
    # CSV.generate(:headers => true) do |output|
    #   CSV.foreach(@file.path, :headers => true, :return_headers => true) do |row|
    #     if row.header_row?
    #       output << (row << "testID")
    #     else
    #       output << (row << "1")
    #     end 
    #   end
    # end
    @result = []
    @warning_msg = []
    row_count = 0
    CSV.foreach(@file.path, :headers => true) do |row|
      row_count +=1
      data_hash = row.to_hash
      # real search:
      # found_donor = Donor.where("first_name = ? AND last_name = ? AND email = ?", 
      #                           data_hash["first_name"], data_hash["last_name"], data_hash["email"])
      # test search:
      found_donor = Donor.where("first_name = ? AND last_name = ?", 
                                data_hash["first_name"], data_hash["last_name"])
      found_donor_number = found_donor.count
      if found_donor_number == 0
        @result << (row << "new")
        @warning_msg << "Row #{row_count} : no donor found."
      elsif found_donor_number == 1
        @result << (row << data_hash["id"])
      else
        @result << (row << "conflict")
        @warning_msg << "Row #{row_count} : more than one donor found."
      end
    end
    filename = File.join Rails.root, "newtestgifts.csv"
    CSV.open(filename, 'w') do |csv|
      csv << ["donor_id",	"first_name",	"last_name", "address",	"address2",	"city",	"state",	"zip",	"phone",	"email",	"notes",	"title",	"nickname",	"country",	"donor_type",	"gift_type",	"amount",	"donation_date",	"check_number",	"gift_user",	"gift_source"]
      @result.each do |r|
        csv.add_row r
      end
    end
    # CSV.generate(headers: true) do |csv|
    #   @result.each do |r|
    #     csv.add_row r
    #   end
    # end
  end
  
  def import_gifts_success
  end
end
