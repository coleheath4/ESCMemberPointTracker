class Event < ApplicationRecord
    scope :sorted, lambda { order('"event_date" ASC') }

    def has_all_required_fields?
        !name.nil? && !point_amount.nil? && !event_date.nil?
    end

    def short_description(max_chars=30)
        return '' if description.nil?
        return description if description.length <= max_chars
        return description[0..max_chars-3] + '...'
    end
      
      # Returns two objects, the first an array of future rewards and
      # the second an array of past rewards
    def self.all_split(events=nil)
        if events.nil?
          events = Events.all     
        end
        future_events = []
        past_events = []
        today = Time.now
        
        events.each do |e|
          if (e.event_date > today)
            future_events << e
          else
            past_events << e
          end
        end
        
        return future_events, past_events
    end

    def self.get_my_events(events=nil, user)
        if events.nil?
            events = Events.all
        end
        my_events = []
        events.each do |e|
            user.id do |i|
                if (e.id = i)
                    my_events << e
                end
            end
        end

    end
    
      
      def self.stringify_date(e)
        e.strftime("%b %-d, %Y")
      end
      
      def self.stringify_datetime(e)
        self.stringify_date(e) + ' - ' + e.strftime("%I:%M %p")
      end
      
    
end
