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


namespace :game_tasks do
  desc "Checks if deadline passed"
  task :deadline => :environment do
    Time.zone = "Helsinki"
    deadline = Game.get_game.deadline
    month = deadline.month
    day = deadline.day
    hour = deadline.hour
    current_month = Time.zone.now.month
    puts "Month: #{current_month}"
    current_day = Time.zone.now.day
    puts "day: #{current_day}"
    current_hour = Time.zone.now.hour
    puts "hour: #{current_hour}"
    if current_month >= month && !Game.get_game.read_only
      if current_day >= day
        if current_hour >= hour
          Game.get_game.update_attribute(:read_only, true)
          puts "Deadline reached. Switching to read_only"
        end
      end
    end
    puts "Ending task"
  end

end
