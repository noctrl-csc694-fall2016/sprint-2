module GiftsHelper
  #returns the public/visible id for the gift
  def get_gift_id(gift)
    return "GFT" + gift.id.to_s
  end
  
end
