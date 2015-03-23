require_relative 'game.rb'

game = Game.new
loop do
  break unless game.play
end
puts 'Thanks for playing!'
