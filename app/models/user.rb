# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  email              :string(255)
#  student_number     :string(255)
#  department         :string(255)
#  teacher            :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  password_digest    :string(255)
#  remember_token     :string(255)
#  group_id           :integer
#  position           :string(255)
#  description        :text
#  registration_token :string(255)
#  registered         :boolean          default(FALSE)
#

#User model models users in the game.
#Users can be students or teachers
#Teachers possess rights to change all kinds of settings in the game

class User < ActiveRecord::Base
  attr_accessible :name, :email, :student_number, :department, :password, :password_confirmation, :position
  has_secure_password
  
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  before_create { generate_token(:registration_token) }

  validate :valid_position

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i #Regex for email address
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
                    
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  validates :department, presence: true

  validates :student_number, presence: true, uniqueness: { case_sensitive: false }
  
  belongs_to :group

  #Checks if the user belongs to group that has a company
  def has_company?
    if self.group && self.group.company
      true
    else
      false
    end
  end

  #Returns true if user belongs to a group that owns the company given as a parameter
  def isOwner?(company)
    if (self.group && self.group.company && (self.group.company.id == company.id)) || self.teacher?
      true
    else
      false
    end
  end

  #Returns the company of the group the user belongs to, or nil in case the user is a teacher
  def company
    if teacher?
      return nil
    else
      self.group.company
    end
  end

  #Returns the different positions user can have in a group
  def self.positions
    ['CEO', 'CFO', 'VP(Marketing)', 'COO', "VP(Sales)"]
  end

  def self.position_resp_areas
    Hash['CEO', ['Value Proposition'], 'CFO',['Revenue Streams', 'Cost Structure'], 'COO', ['Key Resources', 'Key Activities'], 'VP(Marketing)', ['Customer Segments', 'Key Partners'], 'VP(Sales)' , ['Channels', 'Customer Relationships']]
  end

  #Returns the search fields that can be chosen when searching users
  def self.search_fields
    ['Name', 'Student Number', "Department", "Company"]
  end

  #Validates that the position is included in the User.positions list
  def self.validate_proper_position(position)
    self.positions.include?(position)
  end

  #Returns an array of users matching the query for a given field
  def self.search(field, query)
    name = 0
    student_number = 1
    department = 2
    company = 3
    if field == User.search_fields[name]
      return User.where('name LIKE ?', "%#{query}%")
    elsif field == User.search_fields[student_number]
      return User.where('student_number LIKE ?', "%#{query}%")
    elsif field == User.search_fields[department]
      return User.where('department LIKE ?',  "%#{query}%")
    elsif field == User.search_fields[company]
      users = []
      companies = Company.where('name LIKE ?', "%#{query}%")
      companies.each do |c|
        users += c.group.users
      end
      return users
    else
      return []
    end
  end
  
  private
  
  #Creates a remember token so that user can be remembered between sessions
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  #Creates a general token
  def generate_token(column)
  begin
    self[column] = SecureRandom.urlsafe_base64
  end while User.exists?(column => self[column])
end

  #Validates position before save
  def valid_position
    if self.position != nil && !User.positions.include?(self.position)
         errors.add(:position, "Invalid position")
    end
  end
end
