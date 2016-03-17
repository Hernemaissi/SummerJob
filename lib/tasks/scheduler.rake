namespace :game_tasks do
  desc "Checks if deadline passed"
  task :deadline => :environment do
    deadline = Game.get_game.deadline
    month = deadline.month
    day = deadline.day
    hour = deadline.hour
    current_month = Time.now.month
    puts "Month: #{current_month}"
    current_day = Time.now.day
    puts "day: #{current_day}"
    current_hour = Time.now.hour
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
