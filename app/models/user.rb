# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  login               :string(255)      not null
#  first_name          :string(255)      not null
#  last_name           :string(255)
#  crypted_password    :string(255)      not null
#  password_salt       :string(255)      not null
#  email               :string(255)      not null
#  last_login          :datetime
#  about               :text
#  created_at          :datetime
#  updated_at          :datetime
#  remember_hash       :string(255)
#  persistence_token   :string(255)      not null
#  single_access_token :string(255)      not null
#  perishable_token    :string(255)      not null
#  login_count         :integer          default(0), not null
#  failed_login_count  :integer          default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#

class User < ActiveRecord::Base
  acts_as_authentic do |config|
    config.login_field = :email
    config.perishable_token_valid_for = 1.week
    config.logged_in_timeout = 1.week
    config.merge_validates_length_of_login_field_options :within => 6..50
    config.merge_validates_length_of_password_field_options :within => 6..50
  end

  strip_attributes :only => [:email, :first_name, :last_name]

  has_many :language_users, dependent: :destroy
  has_and_belongs_to_many :languages, join_table: :language_users

  validates :email, presence: true, uniqueness: {case_sensitive: false}

  def name
    "#{first_name} #{last_name}"
  end
end
