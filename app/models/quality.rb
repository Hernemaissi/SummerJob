=begin
This file is part of Network Service Business Game.

    Network Service Business Game is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    Network Service Business Game is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Network Service Business Game.  If not, see <http://www.gnu.org/licenses/>
=end

# == Schema Information
#
# Table name: qualities
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  description  :text
#  used         :boolean          default(TRUE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  order_number :integer          default(1)
#

class Quality < ActiveRecord::Base
  attr_accessible :description, :title, :used, :qualityvalues_attributes, :amount, :order_number

  validates :order_number, :numericality => { :only_integer => true }

  has_many :qualityvalues, :dependent => :destroy

  attr_accessor :amount

  accepts_nested_attributes_for :qualityvalues, :reject_if => lambda { |a| a["value"].blank? }, :allow_destroy => true
end
