class ImportExportController < ApplicationController
  #----------------------------------#
  # GiftGarden Import/Export Controller
  # original written by:Pat M, Oct 25 2016
  # major contributions by:
  #                     Wei H Oct 26 2016
  #----------------------------------#
  
  
  require 'csv'
  require 'date'
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

  # validate data in the csv file, not importing anything yet
  def import_gifts_validate
    @file = params[:file]
    if @file.nil?
      flash[:error] = "Please choose a file."
      redirect_to import_gifts_step_two_url
      return
    end
    csv_string = CSV.generate(:headers => true) do |output|
      CSV.foreach(@file.path, :headers => true, :return_headers => true, :col_sep => ',') do |row|
        if row.header_row?
          output << (row << "validation notes")
        else
          warning_msg = ""
          data_hash = row.to_hash
          if (!data_hash["donor_id"].to_s.empty?) # donor_id not blank
            if Donor.exists?(data_hash["donor_id"].to_i) # donor exists in db
              warning_msg += validate_gift(data_hash) # validate required gift fields for import
              if warning_msg == "" 
                output << (row << "ready for import")
              else
                output << (row << warning_msg)
              end
            else # donor_id do not exist in db
              warning_msg += "donor_id not exist in data base"
              output << (row << warning_msg)
            end
          else # donor_id is blank in csv file
            found_donor = Donor.where("first_name = ? AND last_name = ?", 
                                      data_hash["first_name"], data_hash["last_name"])
            found_donor_number = found_donor.count
            if found_donor_number == 0  # no matching donor, check if all the required fields for this gift and this donor are properly filled in
              warning_msg += validate_donor(data_hash)
              warning_msg += validate_gift(data_hash)
              if warning_msg == "" # all required fields of gift and donnor are present
                output << (row << "New Donor; ready for import")
              else
                output << (row << ("new donor; " + warning_msg))
              end
            elsif found_donor_number == 1 # one matching donor, check if all the required fields for this gift are properly filled in
              warning_msg = validate_gift(data_hash)
              if warning_msg == ""
                output << (row << ("donor_id = " + found_donor.first.id.to_s + ", ready for import"))
              else
                output << (row << warning_msg)
              end
            else # more than one matching donor
              output << (row << "conflict")
            end
          end 
        end
      end
    end
    # create csv file for review
    send_data csv_string, 
    :type => 'text/csv; charset=iso-8859-1; header=present', 
    :disposition => "attachment; filename=validated_gifts_#{Date.today}.csv"
  end
    
  # reference https://richonrails.com/articles/importing-csv-files
  # import gifts from csv files
  def import_gifts_import
    @activity = params[:activity]
    if @activity.blank?
      flash[:error] = "Please choose an activity."
      redirect_to import_gifts_step_three_url
      return
    end
      
    @file = params[:file]
    if @file.nil?
      flash[:error] = "Please choose a file."
      redirect_to import_gifts_step_three_url
      return
    end
    
    error = false
    csv_string = CSV.generate(:headers => true) do |output|
      CSV.foreach(@file.path, :headers => true, :return_headers => true, :col_sep => ',') do |row| #@file.path
        if row.header_row?
          output << (row << "import notes")
        else
          warning_msg = ""
          data_hash = row.to_hash
          if (!data_hash["donor_id"].to_s.empty?) # donor_id not blank
            if Donor.exists?(data_hash["donor_id"].to_i) # donor exists in db
              warning_msg += validate_gift(data_hash) # validate required gift fields for import
              if warning_msg == "" # one donor found, all reqired data present, import gift
                Gift.create!(:activity_id => @activity, :donor_id =>data_hash["donor_id"], :donation_date => Date.parse(data_hash['donation_date']),
                          :amount => data_hash['amount'].to_f, :gift_type => data_hash['gift_type'], :solicited_by => data_hash['solicited_by'],
                          :check_number => data_hash['check_number'], :check_date => DateTime.parse(data_hash['check_date']), :pledge => data_hash['pledge'].to_f, :anonymous => data_hash['anonymous'], 
                          :gift_user => current_user.username, :gift_source => @file.original_filename, :memorial_note => data_hash['memorial_note'], 
                          :notes => data_hash['gift_notes'])
              else
                error = true
                output << (row << warning_msg)
              end
            else # donor_id do not exist in db
              error= true
              warning_msg += "donor_id not exist in data base"
              output << (row << warning_msg)
            end
          else # donor_id is blank, need to search for donor
            found_donor = Donor.where("first_name = ? AND last_name = ?", 
                                      data_hash["first_name"], data_hash["last_name"])
            found_donor_number = found_donor.count
            if found_donor_number == 0  # no matching donor -- create donor and create gift
              warning_msg += validate_donor(data_hash) # check if all the required fields for this donor are properly filled in
              warning_msg += validate_gift(data_hash) # check if all the required fields for this gift are properly filled in
              if warning_msg == ""
                new_donor = Donor.create!(:donor_type => data_hash['donor_type'], :first_name => data_hash['first_name'], 
                            :last_name => data_hash['last_name'], :address => data_hash ['address'], 
                            :city => data_hash['city'], :state => data_hash['state'], :zip => data_hash['zip'], :email => data_hash['email'], 
                            :title => data_hash['title'], :nickname => data_hash['nickname'], :address2 => data_hash['address2'], 
                            :country => data_hash[:country], :phone => data_hash['phone'], :notes => data_hash['donor_notes'])
                Gift.create!(:activity_id => @activity, :donor_id =>new_donor.id, :donation_date => Date.parse(data_hash['donation_date']),
                          :amount => data_hash['amount'].to_f, :gift_type => data_hash['gift_type'], :solicited_by => data_hash['solicited_by'],
                          :check_number => data_hash['check_number'], :check_date => DateTime.parse(data_hash['check_date']), :pledge => data_hash['pledge'].to_f, :anonymous => data_hash['anonymous'], 
                          :gift_user => current_user.username, :gift_source => @file.original_filename, :memorial_note => data_hash['memorial_note'], 
                          :notes => data_hash['gift_notes'])
              else
                error = true
                output << (row << warning_msg)
              end
            elsif found_donor_number == 1  # one matching donor
              warning_msg = validate_gift(data_hash)
              if warning_msg == ""
                # Gift.create!(:activity_id => @activity, :donor_id =>found_donor.first.id, :donation_date => Date.parse(data_hash['donation_date']),
                #           :amount => data_hash['amount'], :gift_type => data_hash['gift_type'], :solicited_by => data_hash['solicited_by'],
                #           :check_number => data_hash['check_number'], :pledge => data_hash['pledge'].to_f, :anonymous => data_hash['anonymous'], 
                #           :gift_user => current_user.username, :gift_source => @file.original_filename, :memorial_note => data_hash['memorial_note'], 
                #           :notes => data_hash['gift_notes'])
                Gift.create!(new_gift_hash(data_hash, @activity, found_donor.first.id, @file.original_filename))
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
    end
    if error == false  # all donors and gifts are added
      flash[:success] = "Gifts imported successfully."
      redirect_to gifts_path
    else  # some donors or gifts can not be added, export csv file for review
      send_data csv_string, 
      :type => 'text/csv; charset=iso-8859-1; header=present', 
      :disposition => "attachment; filename=not_imported_gifts_#{Date.today}.csv"
    end
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
      if (new_donor['zip'].nil?)
        msg += "zip cannot be blank,"
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
      if(new_gift['amount'].nil?)
        msg += "gift amount cannot be blank,"
      end
      if (!new_gift['amount'].nil? && !(new_gift['amount'].to_f > 0))
        msg += "gift amount not valid,"
      end
      if (!new_gift['pledge'].nil? && !(new_gift['pledge'].to_f > 0))
        msg += "pledge amount not valid,"
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
      return msg
    end
    
    # check if a string is int
    def integer?(str)
      /\A[+-]?\d+\z/ === str
    end
    
    def new_gift_hash(data, activity, donor, file)
      g = {}
      g["donor_id"] = donor
      g["activity_id"] = activity
      g["donation_date"] = Date.parse(data['donation_date'])
      g["amount"] = data['amount'].to_f
      g["gift_type"] = data['gift_type']
      g["gift_user"] = current_user.username
      g["gift_source"] = file
      g["solicited_by"] =data['solicited_by'] unless data['solicited_by'].nil?
      g["check_number"] = data['check_number'] unless data['check_date'].nil?
      g["check_date"] = DateTime.parse(data['check_date']) unless data['check_date'].nil?
      g["pledge"] = data['pledge'] unless data['pledge'].nil?
      g["memorial_note"] = data['memorial_note'] unless data['memorial_note'].nil?
      g["notes"] = data['gift_notes'] unless data['gift_notes'].nil?
      return g
    end
end

# Gift.create!(:activity_id => @activity, :donor_id =>found_donor.first.id, :donation_date => Date.parse(data_hash['donation_date']),
                #           :amount => data_hash['amount'], :gift_type => data_hash['gift_type'], :solicited_by => data_hash['solicited_by'],
                #           :check_number => data_hash['check_number'], :pledge => data_hash['pledge'].to_f, :anonymous => data_hash['anonymous'], 
                #           :gift_user => current_user.username, :gift_source => @file.original_filename, :memorial_note => data_hash['memorial_note'], 
                #           :notes => data_hash['notes'])