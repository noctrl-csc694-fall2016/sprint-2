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
  
  # reference https://richonrails.com/articles/importing-csv-files
  # validat gifts from csv files
  # need to add more fields to create gifts and donors
  # need to validate reqired fields for gifts and donors
  # cannot handle conflict donors yet
  def import_gifts_validate
    @activity = params[:activity]
    @file = params[:file]
    testfile = File.join Rails.root, "/tmp/import/import_gifts.csv" # just for testing
    
    # comment out for test
    # if @file.nil?
    #   flash[:error] = "Please choose a file."
    #   redirect_to import_gifts_begin_url
    #   return
    # end
    
    # @warning_msg = [] # can warning message be shown?  If not, delete warning_msg.
    row_count = 0
    error = false
    attributes = ["donor_id",	"first_name",	"last_name", "address",	"address2",	
    "city",	"state",	"zip",	"phone",	"email",	"notes",	"title",	"nickname",	
    "country",	"donor_type",	"gift_type",	"amount",	"donation_date",	
    "check_number",	"gift_user",	"gift_source", "new_id"]
    csv_string = CSV.generate(:headers => true) do |output|
      # CSV.foreach(@file.path, :headers => true, :return_headers => true, :col_sep => ',') do |row| # uncomment this line to replace the following line
      CSV.foreach(testfile, :headers => true, :return_headers => true, :col_sep => ',') do |row| # just for testing
        if row.header_row?
          output << attributes
        else
          row_count += 1
          data_hash = row.to_hash
          # real search:
          # found_donor = Donor.where("first_name = ? AND last_name = ? AND email = ?", 
          #                           data_hash["first_name"], data_hash["last_name"], data_hash["email"])
          # test search:
          found_donor = Donor.where("first_name = ? AND last_name = ?", 
                                    data_hash["first_name"], data_hash["last_name"])
          found_donor_number = found_donor.count
          # no matching donor
          if found_donor_number == 0
            new_donor = Donor.create!(:donor_type => data_hash['donor_type'], :first_name => data_hash['first_name'], 
                          :last_name => data_hash['last_name'], :address => data_hash ['address'], 
                          :city => data_hash['city'], :state => data_hash['state'], :email => data_hash['email'])
            Gift.create!(:activity_id => @activity, :donor_id =>new_donor.id, :donation_date => Date.parse(data_hash['donation_date']),
                        :amount => data_hash['amount'], :gift_type => data_hash['gift_type'])
            # error = true
            # output << (row << "new")
            # @warning_msg << "Row #{row_count} : no donor found."
          # one matching donor
          elsif found_donor_number == 1
            # output << (row << found_donor.first.id)
            Gift.create!(:activity_id => @activity, :donor_id =>found_donor.first.id, :donation_date => Date.parse(data_hash['donation_date']),
                        :amount => data_hash['amount'], :gift_type => data_hash['gift_type'])
          # more than one matching donor
          else
            error = true
            output << (row << "conflict")
            # @warning_msg << "Row #{row_count} : more than one donor found."
          end
        end 
      end
    end
    
    # all donors and gifts are added
    if error == false
      redirect_to root_path
    else  # some donors or gifts can not be added, export csv file for review
      send_data csv_string, 
      :type => 'text/csv; charset=iso-8859-1; header=present', 
      :disposition => "attachment; filename=result.csv"
    end
  end
  
  def import_gifts_success
  end
end
