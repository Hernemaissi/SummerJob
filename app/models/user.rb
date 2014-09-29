# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  student_number         :string(255)
#  department             :string(255)
#  teacher                :boolean          default(FALSE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  password_digest        :string(255)
#  remember_token         :string(255)
#  group_id               :integer
#  position               :string(255)
#  description            :text
#  registration_token     :string(255)
#  registered             :boolean          default(FALSE)
#  group_token            :string(255)
#  group_registered       :boolean          default(FALSE)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  image                  :string(255)
#  show_read_events       :boolean          default(TRUE)
#  process_action_year    :integer
#

#User model models users in the game.
#Users can be students or teachers
#Teachers possess rights to change all kinds of settings in the game

class User < ActiveRecord::Base
  attr_accessible :name, :email, :student_number, :department, :password, :password_confirmation, :position, :qualityvalue_ids, :image, :show_read_events
  mount_uploader :image, ImageUploader
  has_secure_password
  
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token
  before_create { generate_token(:registration_token) }
  before_create { generate_token(:group_token) }

  validate :valid_position

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i #Regex for email address
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
                    
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  validates :department, presence: true

  validates :student_number, presence: true, uniqueness: { case_sensitive: false }
  validate :answered_all_qualities, :on => :create
  
  belongs_to :group
  has_and_belongs_to_many :qualityvalues
   has_many :initiator_roles, foreign_key: "initiator_id",
                                   class_name: "ContractProcess",
                                   :dependent => :destroy

  has_many :receiver_roles, foreign_key: "receiver_id",
                                class_name: "ContractProcess",
                                :dependent => :destroy

  has_many :events

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
    if teacher? || !self.group
      return nil
    else
      self.group.company
    end
  end

  #Returns the different positions user can have in a group
  def self.positions
    ['CEO', 'CFO', 'VP (Marketing)', 'COO', "VP (Sales)"]
  end

  def self.position_resp_areas
    Hash['CEO', ['Value Proposition'], 'CFO',['Revenue Streams', 'Cost Structure'], 'COO', ['Key Resources', 'Key Activities'], 'VP (Marketing)', ['Customer Segments', 'Key Partners'], 'VP (Sales)' , ['Channels', 'Customer Relationships']]
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


  def send_mail
    UserMailer.confirm_email(self).deliver
  end

  def send_group_confirm
    UserMailer.confirm_group_email(self).deliver
  end

  def send_broken_contract_mail(breaking_party, broken_party)
    UserMailer.contract_broken_email(self, breaking_party, broken_party).deliver
  end

  #Test method
  def self.populate_values
    users = User.all
    qualities = Quality.all
    users.each do |u|
      u.qualityvalues.clear
      qualities.each do |q|
        u.qualityvalues.push(q.qualityvalues.sample)
      end
      u.save(validate: false)
    end
  end

  def self.get_with_qualities(quality_array, user_group)
    users = Array.new
    user_group.each do |u|
      user_qualities = u.qualityvalue_ids.collect{|i| i.to_s}
      if (quality_array - user_qualities).empty?
        users << u
      end
    end
    return users
  end


def send_password_reset
  generate_token(:password_reset_token)
  self.password_reset_sent_at = Time.zone.now
  save(validate: false)
  UserMailer.password_reset(self).deliver
end

def self.user_data_txt
  data = ""
  User.where("group_id IS NOT NULL").order("group_id ASC").all.each do |u|
    line = ""
    company = u.company
    line += (company) ? company.name : "No company assigned"
    line += ", "
    line += u.group.id.to_s + ", "
    line += u.name +  ", "
    line += u.student_number + ", "
    line += u.email + "<br/>"
    data += line
  end
  return data
end

def can_take_process?
  size = self.contract_processes.size
  self.group.users.each do |u|
    if u != self
      return false if size - u.contract_processes.size > 0
    end
  end
  return true
end

def contract_processes
  self.initiator_roles.all.concat(self.receiver_roles.all)
end

def remove_from_process
  self.initiator_roles.all.each do |p|
    p.update_attribute(:initiator_id, nil)
  end
  self.receiver_roles.all.each do |p|
    p.update_attribute(:receiver_id, nil)
  end
end

def process_requirement_done?
  if !self.initiator_roles.all.empty?
    return true
  else
    self.receiver_roles.all.each do |p|
        return true if !p.bids.empty?
    end
    return false
  end
end

def plan_requirement_done?
  return false if !self.position || !self.company
  self.company.business_plan.plan_parts.where("position = ?", self.position).all.each do |p|
    return false if !p.isReady?
  end
  return true
end

def readable_events
    if self.show_read_events
      return self.events.order('id DESC').all
    else
      return self.events.where(:read => false).order('id DESC').all
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

  def answered_all_qualities
    if self.qualityvalues.size != Quality.all.size
      errors.add(:base, "You must answer all questions")
    end
  end


end
