class Activity < ApplicationRecord
  #----------------------------------#
  # Activities Model Definition
  # original written by: Andy W, Oct 13 2016
  # major contributions by:
  #             Wei H, Oct 15 2016
  #             Pat M, Oct 17 2016
  #----------------------------------#
  before_create :set_default_dates
  has_many :gifts, dependent: :destroy
  default_scope -> {order(id: :desc)}
  validates :name, presence: true, length: {maximum:255}
  validates :description, presence: true, length: {maximum:255}
  validates :goal, presence: true, :numericality => {:greater_than_or_equal_to => 0}
  enum activity_type: [:General, :Community, :Corporate, :Grants, :Mailer, :'Email Blast', :'Faith-based', :'Fund-raiser']
  
  TIMES = [ 'All', 'This Year', 'This Quarter', 'This Month', 
    'Last Year', 'Last Quarter', 'Last Month', 'Past 2 Years', 'Past 5 Years',
    'Past 2 Quarters', 'Past 3 Months', 'Past 6 Months']
    
  SORTS = [ 'Name', 'End Date', 'Goal $', 'Progress']
  
  TOPN = [ 'All', '10', '20', '50', '100' ]
  
  PAGEBY = ['10', '20', '50', '100']
  
  def set_default_dates
    self.start_date = Time.now.beginning_of_year unless self.start_date.present?
    self.end_date = DateTime.parse("2099-12-31 00:00:00") unless self.end_date.present?
  end
  
  def progress
    selected_gifts = Gift.where(:activity_id => self.id)
    sum = 0.0
    selected_gifts.each do |g|
      sum+=g.amount
    end
    return (sum/self.goal).round(4)*100 unless self.goal == 0
    return "N/A"
  end
  
  def self.import(file)
    #CSV.foreach(file.path, headers: true) do |row|
    #  activity_hash = row.to_hash
    #  activity = Activity.where(id: activity_hash["id"])
    #  if activity.count == 1
    #    activity.first.update_attributes(activity_hash)
    #  else
    #    Activity.create!(activity_hash)
    #  end # end if !activity.nil?
    #end # end CSV.foreach
  end # end self.import(file)
  
  def self.search(search)
    if search
      #HypersurfDonor....
      #use lower to make searh case insensitive
      where('lower(name) LIKE lower(?) OR lower(description) LIKE lower(?) OR lower(notes) LIKE lower(?)', "%#{search}%","%#{search}%", "%#{search}%")
    else
      all
      #Donor.all.scoped
    end
  end
end
