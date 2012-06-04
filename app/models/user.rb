class User < ActiveRecord::Base
  attr_accessible :name, :email, :studentNumber, :department, :password, :password_confirmation
  has_secure_password
  
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
                    
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  
  belongs_to :group
  
  def isOwner?(company)
    if (self.group && self.group.company && (self.group.company.id == company.id)) || self.isTeacher?
      true
    else
      false
    end
  end
  
  private
  
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  studentNumber   :string(255)
#  department      :string(255)
#  role            :string(255)
#  isTeacher       :boolean         default(FALSE)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  group_id        :integer
#

