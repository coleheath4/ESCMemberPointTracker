class Reward < ApplicationRecord
  scope :sorted, lambda { order('"when" ASC') }

  def short_description(max_chars=30)
    return '' if description.nil?
    return description if description.length <= max_chars
    return description[0..max_chars-3] + '...'
  end

    
  def percent(user, dec_digits=0, symbol=false)
    return '-' if user.points.nil? || points_required.nil?

    val = (1.0 * user.points / points_required ) * 100
    val = val.truncate(dec_digits)
    
    if symbol
      val = String(val) + ' %'
    end
    
    return val
  end
  
  def self.stringify_date(r)
    return String(I18n.t("date.abbr_month_names")[r.month]) + ' ' + String(r.day) + ', ' + String(r.year)
  end
  
end
