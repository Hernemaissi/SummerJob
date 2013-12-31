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
#

class News < ActiveRecord::Base
  attr_accessible :content, :headline, :market_content, :picture_url, :risk_content

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
