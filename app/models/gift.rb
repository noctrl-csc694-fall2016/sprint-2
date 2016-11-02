class Gift < ApplicationRecord
  #----------------------------------#
  # Gifts Model Definition
  # original written by: Andy W, Oct 13 2016
  # major contributions by:
  #             Wei H, Oct 15 2016
  #             Pat M, Oct 17 2016
  #----------------------------------#
  
  belongs_to :donor
  belongs_to :activity
  default_scope -> {order(id: :desc)}
  validates :donation_date, presence: true
  validates :amount, presence: true, :numericality => {:greater_than_or_equal_to => 0}
  validates :gift_type, presence: true
  validates :notes, presence: false, length: { maximum: 2500 }
  
  TIMES = [ 'All', 'This Year', 'This Quarter', 'This Month', 
    'Last Year', 'Last Quarter', 'Last Month', 'Past 2 Years', 'Past 5 Years',
    'Past 2 Quarters', 'Past 3 Months', 'Past 6 Months']
    
  SORTS = [ 'Donor', 'Amount', 'Donation Date', 'Gift Type']
  
  TOPN = [ '10', '20', '50', '100', 'all']
  
  # Import Gifts
  def self.import(file, activity)
    
    CSV.foreach(file.path, headers: true) do |row|
      gift_hash = row.to_hash 
      # imported gifts are assigned an activity at import time
      gift_hash["activity_id"] = activity
      
      gift = Gift.where(id: gift_hash["id"])

      if gift.count == 1
        gift.first.update_attributes(gift_hash)
      else
        Gift.create!(gift_hash)
      end # end if else
    end # end foreach
  end
  
  # Import in Kind Gifts
  def self.inkind(file, activity)
    
    CSV.foreach(file.path, headers: true) do |row|
      gift_hash = row.to_hash 
      # imported in kind gifts are assigned an activity at import time
      gift_hash["activity_id"] = activity
      gift_hash["gift_type"] = "in Kind"
      
      gift = Gift.where(id: gift_hash["id"])

      if gift.count == 1
        gift.first.update_attributes(gift_hash)
      else
        Gift.create!(gift_hash)
      end # end if else
    end # end foreach
  end

      t.float :amount
      t.text :notes
    add_column :gifts, :pledge, :float
    add_column :gifts, :check_number, :integer
    add_column :gifts, :memorial_note, :text
    add_column :gifts, :solicited_by, :string

  def self.search(search)
    if search
      #HypersurfActivity....
      #use lower to make searh case insensitive
      where('lower(amount) LIKE lower(?) OR lower(notes) LIKE lower(?) OR lower(pledge) LIKE lower(?) OR lower(check_number) LIKE lower(?)OR lower(memorial_note) LIKE lower(?) OR lower(solicited_by) LIKE lower(?)', "%#{search}%","%#{search}%", "%#{search}%","%#{search}%","%#{search}%","%#{search}%")
    else
      all
      #Donor.all.scoped
    end
  end
  
end
