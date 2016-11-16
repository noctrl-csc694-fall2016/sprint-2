module GiftsHelper
   #----------------------------------#
  # Gifts Controller Helper
  # original written by: Andy W Nov 14 2016
  # major contributions by:
  #             
  #----------------------------------#
  
  #returns the public/visible id for the gift
  def get_gift_id(gift)
    return "GFT" + gift.id.to_s
  end
  
  #returns the full donor name for a gift
  def get_donor_full_name(gift)
    @donor = Donor.find(gift.donor_id)
    return @donor.first_name + " " + @donor.last_name
  end
  
  def get_activity_name(gift)
    @activity = Activity.find(gift.activity_id)
    return @activity.name
  end
  
end
