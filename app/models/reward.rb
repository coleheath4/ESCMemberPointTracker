# frozen_string_literal: true

class Reward < ApplicationRecord
  scope :sorted, -> { order('"when" ASC') }

  def short_description(max_chars = 30)
    return '' if description.nil?
    return description if description.length <= max_chars

    "#{description[0..max_chars - 3]}..."
  end

  def percent(user, dec_digits = 0, symbol = false)
    return '-' if user.points.nil? || points_required.nil?

    val = (1.0 * user.points / points_required) * 100
    val = val.nan? || val.infinite? ? 0 : val.truncate(dec_digits)
    val = 100 if val > 100

    val = "#{String(val)} %" if symbol

    val
  end

  def has_all_required_fields?
    !name.nil? && !points_required.nil? && !self.when.nil?
  end

  # Returns two objects, the first an array of future rewards and
  # the second an array of past rewards
  def self.all_split(rewards = nil)
    rewards = Rewards.all if rewards.nil?
    future_rewards = []
    past_rewards = []
    today = Time.now

    rewards.each do |r|
      if r.when > today
        future_rewards << r
      else
        past_rewards << r
      end
    end

    [future_rewards, past_rewards]
  end

  def self.eligible_list(rewards = nil, user)
    rewards = Rewards.all if rewards.nil?
    eligible_rewards = []
    rewards.each do |r|
      eligible_rewards << r if r.points_required <= user.points
    end
    eligible_rewards
  end

  def self.stringify_date(r)
    # String(I18n.t("date.abbr_month_names")[r.month]) + ' ' + String(r.day) + ', ' + String(r.year)
    r.strftime('%b %-d, %Y')
  end

  def self.stringify_datetime(r)
    "#{stringify_date(r)} - #{r.strftime('%I:%M %p')}"
  end
end
