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
  enum gift_type: [:Cash, :Check, :'Credit Card', :Stock, :'In Kind']
  
  TIMES = [ 'All', 'This Year', 'This Quarter', 'This Month', 
    'Last Year', 'Last Quarter', 'Last Month', 'Past 2 Years', 'Past 5 Years',
    'Past 2 Quarters', 'Past 3 Months', 'Past 6 Months']
    
  SORTS = [ 'ID', 'Date', 'Amount']
  
  TOPN = [ 'All', '10', '20', '50', '100' ]
  
  PAGEBY = ['10', '20', '50', '100']
  
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
  
end
