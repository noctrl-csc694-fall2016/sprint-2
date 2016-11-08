class Donor < ApplicationRecord
  #----------------------------------#
  # Donors Model Definition
  # original written by: Andy W, Oct 13 2016
  # major contributions by:
  #             Wei H, Oct 15 2016
  #             Pat M, Oct 17 2016
  #----------------------------------#
  
  has_many :gifts, dependent: :destroy
  default_scope -> {order(id: :desc)}
  validates :first_name, presence: true, length: {maximum:50}
  validates :last_name, presence: true, length: {maximum:50}
  validates :address, presence: true
  validates :city, presence: true, length: {maximum:30}
  validates :state, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  enum donor_type: [:Individual, :Corporation, :Foundation]  
                  
  require 'csv'
  
  TIMES = [ 'All', 'This Year', 'This Quarter', 'This Month', 
    'Last Year', 'Last Quarter', 'Last Month', 'Past 2 Years', 'Past 5 Years',
    'Past 2 Quarters', 'Past 3 Months', 'Past 6 Months']
    
  SORTS = [ 'Last Name', 'First Name', 'Email', 'State']
  
  TOPN = [ 'All', '10', '20', '50', '100' ]
  
  # Export Donors
  # outputs all donors as a csv file(all attributes included).
  def self.as_csv
    CSV.generate do |csv|
    csv << column_names
    all.each do |item|
      csv << item.attributes.values_at(*column_names)
      end
    end
  end
  
  # Import Donors
  # Takes csv file and by row seeks to update or add in donor(s).
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      donor_hash = row.to_hash # exclude the price field
      donor = Donor.where(id: donor_hash["id"])

      if donor.count == 1
        donor.first.update_attributes(donor_hash)
      else
        Donor.create!(donor_hash)
      end # end if else
    end # end foreach
  end
  
  def self.search(search)
    if search
      #HypersurfDonor....
      #use lower to make searh case insensitive
      where('lower(first_name) LIKE lower(?) OR lower(last_name) LIKE lower(?) OR lower(email) LIKE lower(?) OR lower(address) LIKE lower(?)  OR lower(address2) LIKE lower(?)  OR lower(city) LIKE lower(?)  OR lower(state) LIKE lower(?) ', "%#{search}%","%#{search}%", "%#{search}%", "%#{search}%","%#{search}%", "%#{search}%","%#{search}%")
    else
      all
      #Donor.all.scoped
    end
  end

  def self.to_pdf(day)
    
  end
  
  #returns the total dollar amount a donor has donated
  def gift_total_amount_per_donor()
    selected_gifts = Gift.where(:donor_id => self.id)
    sum = 0
    selected_gifts.each do |g|
      sum+=g.amount
    end
    return sum
  end
  
  #sorts donor list by computed total gift amount
  #portions taken from http://awaxman11.github.io/blog/2013/10/11/sorting-a-rails-resource-based-on-a-calculated-value/
  def self.sorted_by_total_gift_amount
    Donor.all.sort_by(&:gift_total_amount_per_donor)
  end
  
end
