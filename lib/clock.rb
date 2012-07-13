require 'rubygems'
require 'clockwork'
include Clockwork

require File.expand_path('../config/boot', File.dirname(__FILE__))
require File.expand_path('../config/environment', File.dirname(__FILE__))

handler do |job|
  puts "Running #{job}"
end

every(2.minutes, 'marketpoint.fetch') { Game.get_game.delay.end_sub_round }