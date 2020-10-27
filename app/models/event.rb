# frozen_string_literal: true

class Event < ApplicationRecord
  scope :sorted, -> { order('"event_date" ASC') }

  def has_all_required_fields?
    !name.nil? && !point_amount.nil? && !event_date.nil?
  end

  def short_description(max_chars = 30)
    return '' if description.nil?
    return description if description.length <= max_chars

    "#{description[0..max_chars - 3]}..."
  end

  # Returns two objects, the first an array of future rewards and
  # the second an array of past rewards
  def self.all_split(events = nil)
    events = Events.all if events.nil?
    future_events = []
    past_events = []
    today = Time.now

    events.each do |e|
      if e.event_date > today
        future_events << e
      else
        past_events << e
      end
    end

    [future_events, past_events]
  end

  def self.get_my_events(events = nil, user)
    events = Events.all if events.nil?
    my_events = []
    events.each do |e|
      user.id do |i|
        my_events << e if (e.id = i)
      end
    end
  end

  def self.stringify_date(e)
    e.strftime('%b %-d, %Y')
  end

  def self.stringify_datetime(e)
    "#{stringify_date(e)} - #{e.strftime('%I:%M %p')}"
  end
end
