class ImportExportController < ApplicationController
  #----------------------------------#
  # GiftGarden Import/Export Controller
  # original written by:Pat M, Oct 25 2016
  # major contributions by:
  #                     Wei H Oct 26 2016
  #----------------------------------#
  
  
  require 'csv'
  #users must be logged into access any of this controller's methods/views
  before_action :logged_in
  
  #import gifts from a .csv file
  #this is the 'simple' gift import method
  def import
     @activities = Activity.all.sort{|a,b| a.name.downcase <=> b.name.downcase }
  end
  
  #import donors from a .csv file
  def importDonors
  end

  #import in kind gifts from a .csv file
  def inkind
    @activities = Activity.all.sort{|a,b| a.name.downcase <=> b.name.downcase }
  end

  #export donors to a .csv file
  def export
    @donor = Donor.order(:created_at)
    respond_to do |format|
    format.html
    format.csv { send_data @donor.as_csv, filename: "Donors Export #{Date.today}.csv" }
    end
  end
  
  #smart gifts wizard - instruction
  def import_gifts_inst
  end
  
  #smart gifts import - step one
  def import_gifts_step_one
    @activities = Activity.all.sort{|a,b| a.name.downcase <=> b.name.downcase }
  end
  
  # download csv template
  def import_gifts_download_csv_template
    template_file = Rails.root + 'app/assets/template/gifts_template.csv'
    csv_string = CSV.generate(:headers => true) do |output|
      CSV.foreach(template_file, :headers => true, :return_headers => true, :col_sep => ',') do |row|
        output << row
      end  
    end
    send_data csv_string, 
    :type => 'text/csv; charset=iso-8859-1; header=present', 
    :disposition => "attachment; filename=gifts_template_#{Date.today}.csv"
  end
  
  #smart gifts import - step two
  def import_gifts_step_two
  end
  
  #smart gifts import - step three
  def import_gifts_step_three
    @activities = Activity.all.sort{|a,b| a.name.downcase <=> b.name.downcase }
  end
  
  # reference https://richonrails.com/articles/importing-csv-files
  # import gifts from csv files
  # need to add more fields to create gifts and donors
  def import_gifts_import
    @activity = params[:activity]
    # test_file = Rails.root + 'tmp/import/import_gifts.csv'
    @file = params[:file]  
    if @file.nil?
      flash[:error] = "Please choose a file."
      redirect_to import_gifts_next_url
      return
    end
    
    error = false
    csv_string = CSV.generate(:headers => true) do |output|
      CSV.foreach(@file.path, :headers => true, :return_headers => true, :col_sep => ',') do |row| #@file.path
        if row.header_row?
          output << row
        else
          warning_msg = ""
          data_hash = row.to_hash
          # real search:
          # found_donor = Donor.where("first_name = ? AND last_name = ? AND email = ?", 
          #                           data_hash["first_name"], data_hash["last_name"], data_hash["email"])
          # test search:
          found_donor = Donor.where("first_name = ? AND last_name = ?", 
                                    data_hash["first_name"], data_hash["last_name"])
          found_donor_number = found_donor.count
          if found_donor_number == 0  # no matching donor -- create donor and create gift
            warning_msg += validate_donor(data_hash)
            warning_msg += validate_gift(data_hash)
            if warning_msg == ""
              new_donor = Donor.create!(:donor_type => data_hash['donor_type'], :first_name => data_hash['first_name'], 
                          :last_name => data_hash['last_name'], :address => data_hash ['address'], 
                          :city => data_hash['city'], :state => data_hash['state'], :email => data_hash['email'], 
                          :title => data_hash['title'], :nickname => data_hash['nickname'], :address2 => data_hash['address2'], 
                          :country => data_hash[:country], :phone => data_hash['phone'])
              Gift.create!(:activity_id => @activity, :donor_id => new_donor.id, :donation_date => Date.parse(data_hash['donation_date']),
                        :amount => data_hash['amount'], :gift_type => data_hash['gift_type'], :solicited_by => data_hash['solicited_by'],
                        :check_number => data_hash['check_number'], 
                        :pledge => data_hash['pledge'], :anonymous => data_hash['anonymous'], :gift_user => current_user.username, 
                        :gift_source => @file.original_filename, :memorial_note => data_hash['memorial_note'], :notes => data_hash['notes'])
            else
              error = true
              output << (row << warning_msg)
            end
          elsif found_donor_number == 1  # one matching donor
            warning_msg = validate_gift(data_hash)
            if warning_msg == ""
              Gift.create!(:activity_id => @activity, :donor_id =>found_donor.first.id, :donation_date => Date.parse(data_hash['donation_date']),
                        :amount => data_hash['amount'], :gift_type => data_hash['gift_type'], :solicited_by => data_hash['solicited_by'],
                        :check_number => data_hash['check_number'], 
                        :pledge => data_hash['pledge'], :anonymous => data_hash['anonymous'], :gift_user => data_hash['gift_user'], 
                        :gift_source => data_hash['gift_source'], :memorial_note => data_hash['memorial_note'], :notes => data_hash['notes'])
            else
              error = true
              output << (row << warning_msg)
            end
          else  # more than one matching donor
            error = true
            output << (row << "conflict")
          end
        end 
      end
    end
    
    if error == false  # all donors and gifts are added
      flash[:success] = "Gifts imported successfully."
      redirect_to root_path
    else  # some donors or gifts can not be added, export csv file for review
      send_data csv_string, 
      :type => 'text/csv; charset=iso-8859-1; header=present', 
      :disposition => "attachment; filename=result.csv"
    end
  end
  
  #smart gifts import - next
  def import_gifts_next
    @activities = Activity.all.sort{|a,b| a.name.downcase <=> b.name.downcase }
    @activity = param[:p1]
  end

  def import_gifts_validate
    @file = params[:file]
    if @file.nil?
      flash[:error] = "Please choose a file."
      redirect_to import_gifts_step_two_url
      return
    end
    csv_string = CSV.generate(:headers => true) do |output|
      CSV.foreach(@file.path, :headers => true, :return_headers => true, :col_sep => ',') do |row| # uncomment this line to replace the following line
        if row.header_row?
          output << row
        else
          data_hash = row.to_hash
          # real search:
          # found_donor = Donor.where("first_name = ? AND last_name = ? AND email = ?", 
          #                           data_hash["first_name"], data_hash["last_name"], data_hash["email"])
          # test search:
          found_donor = Donor.where("first_name = ? AND last_name = ?", 
                                    data_hash["first_name"], data_hash["last_name"])
          found_donor_number = found_donor.count
          if found_donor_number == 0  # no matching donor
            output << (row << "new")
          elsif found_donor_number == 1 # one matching donor
            output << (row << found_donor.first.id)
          else # more than one matching donor
            output << (row << "conflict")
          end
        end 
      end
    end
    # create csv file for review
    send_data csv_string, 
    :type => 'text/csv; charset=iso-8859-1; header=present', 
    :disposition => "attachment; filename=validated_gifts_#{Date.today}.csv"
  end
  
  private
    # check whether csv file has all the fields needed to create a donor
    def validate_donor(donor)
      new_donor = donor
      msg = ""
      if (!new_donor['donor_type'].in?(['Individual', 'Corporation', 'Foundation']))
        msg += "donor_type not valid,"
      end
      if (new_donor['first_name'].nil?) 
        msg += "first_name cannot be blank,"
      end
      if (new_donor['last_name'].nil?) 
        msg += "last_name cannot be blank,"
      end
      if (new_donor['address'].nil?) 
        msg += "address cannot be blank,"
      end
      if (new_donor['city'].nil?) 
        msg += "city cannot be blank,"
      end
      if (new_donor['state'].nil?) 
        msg += "state cannot be blank,"
      end
      if (new_donor['email'].nil?) 
        msg += "email cannot be blank,"
      end
      return msg
    end
  
    # check whether csv file has all the fields needed to create gift
    def validate_gift(gift)
      new_gift = gift
      msg = ""
      if (new_gift['donation_date'].nil?)
        msg += "donation_date cannot be blank,"
      end
      if (new_gift['amount'] != "" && !(new_gift['amount'].to_f > 0))
        msg += "gift amount not valid,"
      end
      if (new_gift['gift_type'] == "Check")
        if (new_gift['check_number'].nil? || !integer?(new_gift['check_number']))
          msg += "check_number not valid,"
        end
        if (new_gift['check_date'].nil?)
          msg += "check_date cannot be blank,"
        end
      elsif (!new_gift['gift_type'].in?(['Cash', 'Stock', 'In Kind', 'Credit Card']))
        msg += "gift_type not valid,"
      end
      if (new_gift['gift_user'] == "")
        msg += "gift_user missing,"
      end
      if (new_gift['gift_source'] == "")
        msg += "gift_source missing,"
      end
      return msg
    end
    
    # check if a string is int
    def integer?(str)
      /\A[+-]?\d+\z/ === str
    end
end