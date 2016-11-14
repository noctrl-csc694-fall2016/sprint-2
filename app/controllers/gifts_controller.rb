class GiftsController < ApplicationController
  #----------------------------------#
  # GiftGarden Gifts (Donations) Controller
  # original written by: Andy W, Oct 17 2016
  # major contributions by:
  #         Wei H, Oct 18 2016
  #----------------------------------#
  
  # define new gift object, also define maps to list donors/ids and activities/ids for select
  # boxes on New Gift screen
  def new
    @gift = Gift.new
    if current_user
      @gift.gift_user = current_user.username
    else
      flash[:warning] =  "You are not logged in."
      redirect_to login_path and return
    end
    @gift.gift_source = "Online"
    map_activities_n_donors()
  end

  # populates edit/update gift screens with db info, also define maps to list 
  # donors/ids and activities/ids for select boxes on Edit Gift screen
  def edit
    @gift = Gift.find(params[:id])
    map_activities_n_donors()
  end
  
  # Import Gifts: calls import method from the Gift model
  def import
    Gift.import(params[:file], params[:activity])
    redirect_to import_export_url, notice: "Gifts imported."
  end
  
  # Import in kind Gifts: calls inkind method from the Gift model
  def inkind
    Gift.inkind(params[:file], params[:activity])
    redirect_to import_export_url, notice: "In Kind Gifts imported."
  end

  
  # create new gift using gift_params permitted below in private section
  # or renders form again with error messages
  # [map] code defines donors/ids and activities/ids for select boxes on New Gift screen
  def create
    @gift = Gift.new(gift_params)
    map_activities_n_donors()
    if @gift.save
      flash[:success] = "Gift added successfully!"
      redirect_to gifts_url(:donor_id => @gift.donor_id, :activity_id => @gift.activity_id)
    else
      render 'new'
    end
  end
  
  # update gift using gift_params permitted below in private section
  # or renders form again with error messages
  # [map] code defines donors/ids and activities/ids for select boxes on Edit Gift screen
  def update
    @gift = Gift.find(params[:id])
    map_activities_n_donors()
    if @gift.update(gift_params)
       flash[:success] = "Gift updated successfully!"
       redirect_to gifts_path(:donor_id => @gift.donor_id, :activity_id => @gift.activity_id)
    else
      render 'edit'
    end
  end
  
  #list all gifts on index page
  def index
    #add all gifts selected_gifts
    @selected_gifts = Gift.all
    
    #check for all parameters in page call
    if (params.has_key?(:activity_id) && params.has_key?(:donor_id) && params.has_key?(:timeframe) && params.has_key?(:sortby) && params.has_key?(:pageby) && params.has_key?(:commit)) == false
      redirect_to gifts_url + "?utf8=%E2%9C%93&activity_id=&donor_id=&timeframe=All&sortby=&pageby=&commit=GO"
    end
    
    #pull only those gifts with selected activity
    if(params[:activity_id] != "")
      @selected_gifts = @selected_gifts.where(:activity_id => params[:activity_id])
    end
    #pull only those gifts with selected donor
    if(params[:donor_id] != "")
      @selected_gifts = @selected_gifts.where(:donor_id => params[:donor_id])
    end
    
    #TIMEFRAME filtering
    case params[:timeframe]
          when 'All'
          when 'This Year'
            @selected_gifts = @selected_gifts.where(donation_date: Time.current.beginning_of_year..Time.current.end_of_year)
          when 'This Quarter'
            @selected_gifts = @selected_gifts.where(donation_date: Time.current.beginning_of_quarter..Time.current.end_of_quarter)
          when 'This Month'
            @selected_gifts = @selected_gifts.where(donation_date: Time.current.beginning_of_month..Time.current.end_of_month)
          when 'Last Year'
            @start_year = 1.year.ago.beginning_of_year - 1.day
            @end_year = 1.year.ago.end_of_year
            @selected_gifts = @selected_gifts.where(donation_date: @start_year..@end_year)
          when 'Last Quarter'
            @start_quarter = Time.current.beginning_of_quarter - 3.months - 1.day
            @end_quarter = Time.current.end_of_quarter - 3.months
            @selected_gifts = @selected_gifts.where(donation_date: @start_quarter..@end_quarter)
          when 'Last Month'
            @start_month = 1.month.ago.beginning_of_month - 1.day
            @end_month = 1.month.ago.end_of_month
            @selected_gifts = @selected_gifts.where(donation_date: @start_month..@end_month)
          when 'Past 2 Years'
            @selected_gifts = @selected_gifts.where("donation_date >= ?", 2.years.ago.to_date)
          when 'Past 5 Years'
            @selected_gifts = @selected_gifts.where("donation_date >= ?", 5.years.ago.to_date)
          when 'Past 2 Quarters'
            @past_2_quarters_begin = Time.current.beginning_of_quarter - 3.months
            @selected_gifts = @selected_gifts.where("donation_date >= ?", @past_2_quarters_begin)
          when 'Past 3 Months'
            @selected_gifts = @selected_gifts.where("donation_date >= ?", 3.months.ago.to_date)
          when 'Past 6 Months'
            @selected_gifts = @selected_gifts.where("donation_date >= ?", 6.months.ago.to_date)
    end
    
    #sort results (reorder objects in table)
    case params[:sortby]
      when 'Donor ID'
        @selected_gifts = @selected_gifts.reorder("donor_id DESC")
      when 'Amount'
        @selected_gifts = @selected_gifts.reorder("amount DESC")
      when 'Donation Date'
        @selected_gifts = @selected_gifts.reorder("donation_date DESC")
      when 'Gift Type'
        @selected_gifts = @selected_gifts.reorder("gift_type DESC")
    end
    
    #paginate selected gifts list after sorting & filtering
    #use selected amount per page
    if(params[:pageby] != "")
      @selected_gifts = @selected_gifts.paginate(page: params[:page], per_page: params[:pageby])
    else
      @selected_gifts = @selected_gifts.paginate(page: params[:page], per_page: 10)
    end	

    map_activities_n_donors()
    # for reports
    respond_to do |format|
      format.html
      format.pdf do
        pdf = GiftPdf.new(@gifts)
        send_data pdf.render, filename: 'Gifts.pdf', type: 'application/pdf'
      end
    end
  end
  
  #delete gift
  def destroy
    Trash.create!(:trash_type => "gift", :content => Gift.find(params[:id]).inspect)
    Gift.find(params[:id]).destroy
    flash[:success] = "Gift deleted."
    redirect_to gifts_path(activity_id: "", donor_id: "")
  end
  
  private
    #define permitted and required parameters for create and update methods
    def gift_params
      params.required(:gift).permit(:activity_id, :donor_id, :donation_date, :amount, :gift_type,  
                                    :solicited_by, :check_date, :check_number, :pledge, :anonymous, 
                                    :gift_user, :gift_source, :memorial_note, :notes)
    end
    
    #defines activities and donors lists to populate stop-down selections on index page
    def map_activities_n_donors()
      @donors = Donor.all.map { |donor| [ "#{donor.first_name} #{donor.last_name}", donor.id ] }
      @activities = Activity.all.map { |activity| [ activity.name, activity.id ] }
    end
    
end