 #----------------------------------#
  # Donors Controller Helper
  # original written by: Wei H, Oct 20 2016
  # major contributions by:
  #             Andy W, Oct 22 2016
  #----------------------------------#


module DonorsHelper
  
  # most methods below used on Surf Donors screens
  
  #returns the quantity of times a donor has made a donation
  def gift_count_per_donor(donor)
    selected_gifts = Gift.where(:donor_id => donor)
    selected_gifts.count
  end
  
  #returns the total dollar amount a donor has donated
  def gift_total_amount_per_donor(donor)
    selected_gifts = Gift.where(:donor_id => donor)
    sum = 0
    selected_gifts.each do |g|
      sum+=g.amount
    end
    return sum
  end
  
  #returns the last gift that a donor made, by created_at date
  def find_last_gift(donor)
    selected_gifts = Gift.where(:donor_id => donor)
    last_gift = nil
    selected_gifts.each do |g|
      if last_gift.nil?
        last_gift = g
      else
        if g.created_at > last_gift.created_at
          last_gift = g
        end
      end
    end 
    return last_gift
  end
  
  #returns the last gift $ amount a donor has given, or 0 if no 
  #gifts have been made
  def last_gift_amount(donor)
    last_gift = find_last_gift(donor)
    if last_gift.nil?
      return 0
    else
      return last_gift.amount
    end
  end
  
  #returns the last activity a donor gave for
  def last_activity(donor)
    last_gift = find_last_gift(donor)
    if last_gift.nil?
      return "--No gifts yet--"
    else
      return Activity.find(last_gift.activity_id).name
    end
  end
  
  #returns the public/visible id for the donor
  def get_donor_id(donor)
    return "don" + donor.id.to_s
  end
  
end