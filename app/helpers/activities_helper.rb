 #----------------------------------#
  # Activities Controller Helper
  # original written by: Wei H, Oct 20 2016
  # major contributions by:
  #             Andy W, Oct 23 2016
  #----------------------------------#

module ActivitiesHelper
  
  #returns the percent value of the $ given vs the $ goal for an activity
  def progress(activity)
    selected_gifts = Gift.where(:activity_id => activity.id)
    sum = 0.0
    selected_gifts.each do |g|
      sum+=g.amount
    end
    return (sum/activity.goal).round(4)*100 unless activity.goal == 0
    return "N/A"
  end
  
  #returns the quantity of gifts given for an activity
  def gift_count_per_activity(activity)
    selected_gifts = Gift.where(:activity => activity)
    selected_gifts.count
  end 
  
  #returns the quantity of donors that have given $ for an activity
  def donor_count_per_activity(activity)
    selected_gifts = Gift.where(:activity_id => activity.id)
    selected_gifts.distinct.count(:donor_id)
  end 
  
  #returns the public/visible id for the activity
  def get_activity_id(activity)
    return "act" + activity.id.to_s
  end
end