class DonorLYBUNTPdf < Prawn::Document
  #----------------------------------#
  # GiftGarden LYBUNT Donor Report
  # original written by: Andy W, Nov 19 2016
  # major sections pulled from:
  #        DonorPDF by Pat M, Nov 5 2016
  #----------------------------------#
  
  def initialize(donor, timeframe, sortby, topn, giftTotal, user)
    super()
    @donors = donor
    @timeframe = timeframe
    @sortby = sortby
    @topn = topn
    @giftTotal = format_currency(giftTotal.to_s, false)
    @user = user
    header
    text_content
    table_content
  end

  # Source: https://www.sitepoint.com/pdf-generation-rails/
  # under the first section for prawn.

  def header
    image "#{Rails.root}/app/assets/images/giftgardensmall.jpg", 
    width: 40, height: 40
    move_up 30
    text "LYBUNT Donors Report", size: 24, style: :bold, :align => :center
  end
  
  def text_content
    y_position = cursor - 20

    bounding_box([0, y_position], :width => 658, :height => 50) do
      text "This Gift Garden report created " + Time.zone.now.to_date.to_s + 
      " by " + @user['username'].to_s + ".", size: 15
      text "Report options: " + timeframe_exalanation(@timeframe) + 
       "," + topn_explanation(@topn) +  "sorted by " + @sortby.to_s + ".", size: 15
    end
  end

  def table_content
    
    table donor_rows do
      row(0).font_style = :bold
      self.header = true
      self.row_colors = ['FFFFFF']
      self.column_widths = [80, 150, 135, 90, 85]
      style(column(4), align: :right)
      end
      
    table total_row do
      row(0).font_style = :bold
      self.row_colors = ['DDDDDD']
      self.column_widths = [80, 150, 135, 90, 85]
      style(column(1), align: :center)
      style(column(4), align: :right)
    end
    
  end

  def donor_rows
    [['ID', 'Donor Name', 'City, State', 'Last Gift Date', 'Gift Total']] +
      @donors.map do |donor|
      [("DON" + donor.id.to_s), donor.last_name.to_s + ", " + donor.first_name.to_s, 
      donor.city.to_s + ", " + donor.state, donor.title, format_currency(donor.nickname, false)]
    end
  end
  
  def total_row
    [['', 'Total', '', '', @giftTotal]]
  end
  
  #custom currency formatting method for reports
  #handles any monetary amounts under $1bn
  def format_currency(amount, chopOff)
    if amount.length > 0
      result = amount.to_s
      if chopOff
        2.times do result.chop! end #takes off the .0
      end
      if result.length <= 3
        result = "$" + result
      elsif result.length >= 4 && result.length <=6
        idx = result.length - 3
        result = "$" + result[0,idx] + "," + result[(idx)..(idx + 2)]
      elsif result.length >= 7 && result.length <=9
        idx = result.length - 6
        result = "$" + result[0,idx] + "," + result[(idx)..(idx + 2)] + "," + 
          result[(idx + 3)..(idx + 5)]
      end
      return result
    else
      return ''
    end
  end
  
  #timeframe 'more-English-like' conversion
  def timeframe_exalanation(range)
    result = ""
    case range
      when "All previous years"
        result += "All Donors who donated previously, but not this year"
      when "Last year"
        result += "Donors who donated last year, but not this year"
      when "Last 2 years"
        result += "Donors who donated in the past 2 years, but not this year"
    end
    result
  end
  
  #topn 'more-English-like' conversion
  def topn_explanation(range)
    result = " "
    case @topn
    when 'all'
      result += ""
    when '10'
      result += "Top 10 Donors "
    when '20'
      result += "Top 20 Donors "
    when '50'
      result += "Top 50 Donors "
    when '100'
      result += "Top 100 Donors "
    end
    result
  end
end
