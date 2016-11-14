class DonorsController < ApplicationController
 #----------------------------------#
  # GiftGarden Donors Controller
  # original written by: Andy W, Oct 17 2016
  # major contributions by:
  #         
  #----------------------------------#
 include DonorsHelper
 
 
 # creates new donor object for New Donor screen
  def new
    @donor = Donor.new
  end
  
  # populates Edit Donor screen with data for the correct donor id
  def edit
    @donor = Donor.find(params[:id])
  end
  
  # creates new donor with permitted donor params defined below in private section
  # or renders for again with error messages
  def create
    @donor = Donor.new(donor_params)
    if @donor.save
      flash[:success] = "Donor added successfully!"
      redirect_to donors_url
    else
      render 'new'
    end
  end
  
  # updates donor information or renders update form again with error messages
  def update
    @donor = Donor.find(params[:id])
    if @donor.update(donor_params)
       redirect_to donors_url
      flash[:success] = "Donor updated successfully!"
    else
      render 'edit'
    end
  end
  
  # Import Donors: calls import method from the Donor model
  def import
    Donor.import(params[:file])
    redirect_to import_export_url, notice: "Donors imported."
  end
  
  # list all donors on index page
  def index
    
    #add all donors to selected_donors
    @selected_donors = Donor.all
    
    #check for all parameters in page call
    if (params.has_key?(:timeframe) && params.has_key?(:sortby) && params.has_key?(:pageby) && params.has_key?(:commit)) == false
      redirect_to donors_url + "?utf8=%E2%9C%93&timeframe=All&sortby=&pageby=&commit=GO"
    end
     
    #TIMEFRAME filtering
    @timeframe_donors = [] #initialize array to store ids of donors making donations within timeframe
    case params[:timeframe]
          when 'All'
          when 'This Year'
            @selected_donors.each do |donor|
              if last_gift_by_donation_date(donor)
                if last_gift_by_donation_date(donor).donation_date.year == Time.current.year
                  @timeframe_donors.push(donor.id)
                end
              end
            end
            @selected_donors = @selected_donors.where(id: @timeframe_donors)
          when 'This Quarter'
            @selected_donors.each do |donor|
              if last_gift_by_donation_date(donor)
                @donation_date = last_gift_by_donation_date(donor).donation_date
                if (@donation_date >= Time.current.beginning_of_quarter) && (@donation_date <= Time.current.end_of_quarter)
                  @timeframe_donors.push(donor.id)
                end
              end
            end
            @selected_donors = @selected_donors.where(id: @timeframe_donors)
          when 'This Month'
            @selected_donors.each do |donor|
              if last_gift_by_donation_date(donor)
                if last_gift_by_donation_date(donor).donation_date.month == Time.current.month
                @timeframe_donors.push(donor.id)
                end
              end
            end
            @selected_donors = @selected_donors.where(id: @timeframe_donors)
         when 'Last Year'
            @selected_donors.each do |donor|
              if last_gift_by_donation_date(donor)
                @donation_date = last_gift_by_donation_date(donor).donation_date
                @start_year = 1.year.ago.beginning_of_year - 1.day
                @end_year = 1.year.ago.end_of_year - 1.day
                if (@donation_date >= @start_year) && (@donation_date <= @end_year)
                  @timeframe_donors.push(donor.id)
                end
              end
            end
            @selected_donors = @selected_donors.where(id: @timeframe_donors)
          when 'Last Quarter'
            @selected_donors.each do |donor|
              if last_gift_by_donation_date(donor)
                @donation_date = last_gift_by_donation_date(donor).donation_date
                @start_quarter = Time.current.beginning_of_quarter - 3.months - 1.day
                @end_quarter = Time.current.end_of_quarter - 3.months
                if (@donation_date >= @start_quarter) && (@donation_date <= @end_quarter)
                  @timeframe_donors.push(donor.id)
                end
              end
            end
            @selected_donors = @selected_donors.where(id: @timeframe_donors)
          when 'Last Month'
            @selected_donors.each do |donor|
              if last_gift_by_donation_date(donor)
                @donation_date = last_gift_by_donation_date(donor).donation_date
                @start_month = 1.month.ago.beginning_of_month - 1.day
                @end_month = 1.month.ago.end_of_month
                if (@donation_date >= @start_month) && (@donation_date <= @end_month)
                  @timeframe_donors.push(donor.id)
                end
              end
            end
            @selected_donors = @selected_donors.where(id: @timeframe_donors)
          when 'Past 2 Years'
            @selected_donors.each do |donor|
              if last_gift_by_donation_date(donor)
                @donation_date = last_gift_by_donation_date(donor).donation_date
                if (@donation_date >= 2.years.ago.to_date)
                  @timeframe_donors.push(donor.id)
                end
              end
            end
            @selected_donors = @selected_donors.where(id: @timeframe_donors)
          when 'Past 5 Years'
            @selected_donors.each do |donor|
              if last_gift_by_donation_date(donor)
                @donation_date = last_gift_by_donation_date(donor).donation_date
                if (@donation_date >= 5.years.ago.to_date)
                  @timeframe_donors.push(donor.id)
                end
              end
            end
            @selected_donors = @selected_donors.where(id: @timeframe_donors)
          when 'Past 2 Quarters'
            @past_2_quarters_begin = Time.current.beginning_of_quarter - 3.months
            @selected_donors.each do |donor|
              if last_gift_by_donation_date(donor)
                @donation_date = last_gift_by_donation_date(donor).donation_date
                if (@donation_date >= @past_2_quarters_begin)
                  @timeframe_donors.push(donor.id)
                end
              end
            end
            @selected_donors = @selected_donors.where(id: @timeframe_donors)
          when 'Past 3 Months'
            @selected_donors.each do |donor|
              if last_gift_by_donation_date(donor)
                @donation_date = last_gift_by_donation_date(donor).donation_date
                if (@donation_date >= 3.months.ago.to_date)
                  @timeframe_donors.push(donor.id)
                end
              end
            end
            @selected_donors = @selected_donors.where(id: @timeframe_donors)
          when 'Past 6 Months'
            @selected_donors.each do |donor|
              if last_gift_by_donation_date(donor)
                @donation_date = last_gift_by_donation_date(donor).donation_date
                if (@donation_date >= 6.months.ago.to_date)
                  @timeframe_donors.push(donor.id)
                end
              end
            end
            @selected_donors = @selected_donors.where(id: @timeframe_donors)
    end
    
    #select the TOP N donors, by total gift amount
    #if(params[:topn] != "" && params[:topn] != "All")
    #  @selected_donors = @selected_donors.sorted_by_total_gift_amount.take(params[:topn].to_i)
    #end
    
    #sort results (reorder objects in table)
    if(params[:topn] && params[:sortby])
      @selected_donors = Donor.where(id: @selected_donors)
    end
    case params[:sortby]
      when 'Last Name'
        @selected_donors = @selected_donors.reorder("last_name")
      when 'Email'
        @selected_donors = @selected_donors.reorder("email")
      when 'State'
        @selected_donors = @selected_donors.reorder("state")
    end
    
    #paginate selected donors list after sorting & filtering
    #use selected amount per page
    if(params[:pageby] != "")
      @selected_donors = @selected_donors.paginate(page: params[:page], per_page: params[:pageby])
    else
      @selected_donors = @selected_donors.paginate(page: params[:page], per_page: 10)
    end	
    
    respond_to do |format|
      format.html
        format.pdf do
          pdf = DonorPdf.new(@donors)
          send_data pdf.render, filename: 'Donors.pdf', type: 'application/pdf'
        end
      end
  end
  
  # delete donor
  def destroy
    Trash.create!(trash_type: "donor", content: Donor.find(params[:id]).inspect)
    Donor.find(params[:id]).destroy
    flash[:success] = "Donor deleted."
    redirect_to donors_path
  end
  
  private
    # defines permitted and required parameters for create and update methods
    def donor_params
      params.required(:donor).permit(:first_name, :last_name, :address, :address2, :city,
                                    :state, :zip, :country, :phone, :email, :title, :nickname, 
                                    :notes, :donor_type)
    end
end
