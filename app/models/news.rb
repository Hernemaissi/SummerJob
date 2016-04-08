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
# Table name: news
#
#  id             :integer          not null, primary key
#  headline       :string(255)
#  picture_url    :string(255)
#  content        :text
#  market_content :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  risk_content   :text
#  image          :string(255)
#

class News < ActiveRecord::Base
  attr_accessible :content, :headline, :market_content, :picture_url, :risk_content, :image

  mount_uploader :image, ImageUploader

  def self.find_next(id, direction)
    highest_news_id = News.order("id ASC").last.id
    direction_mod = (direction == "right") ? -1 : 1
    current = id
    while News.find_by_id(current) == nil
      current = current + direction_mod
      if current < 0 || current > highest_news_id
        return nil
      end
    end
    return News.find_by_id(current)
  end

  

end
