# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  def self.find_or_create_from_auth(auth)
    # where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
    where(email: auth.info.email).first_or_initialize.tap do |user|
      @user = user
      user.provider = auth.provider
      user.uid = auth.uid
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.email = auth.info.email
      # user.save!
    end
  end

  def list_events
    Event.where(id: events).order('event_date ASC')
  end

  def self.to_csv
    attributes = %w[id email username is_admin first_name last_name points events]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  scope :sorted, -> { order('points DESC') }

  def self.non_admin_list(users = nil)
    users = Users.all if users.nil?
    non_admin_users = []
    users.each do |u|
      non_admin_users << u if u.is_admin == false
    end
    non_admin_users
  end
end
