require_relative 'board.rb'
require_relative 'player.rb'
require_relative 'ai.rb'

class Game
  def play
    introduction()
    setup()
    start()
    finish()
  end

  def introduction
    puts '||      Welcome to Tic-Tac-Toe!     ||'
    puts '======================================'
    puts 'What size grid do you want to play on?'
    puts '(entering 3 will start a 3x3 game)'
    size = 0
    loop do
      print '> '
      size = gets.to_i
      break if size > 0
    end
    @board = Board.new(size)
  end

  def setup
    puts 'Do you want to play as "x" or "o"?'
    player_team = ''
    loop do
      print '> '
      player_team = gets.chomp
      break if player_team == 'x' || player_team == 'o'
    end
    puts 'What difficulty do you want to play on?'
    puts '(1: easy, 2: intermediate, 3: hard)'
    difficulty = ''
    loop do
      print '> '
      difficulty = gets.chomp.to_i
      break if [1, 2, 3,].include?(difficulty)
    end
    @player = Player.new(player_team, @board.size)
    @ai = (player_team == 'o') ? AI.new('x', @board.size, difficulty) : AI.new('o', @board.size, difficulty)
  end

  def start
    gameover = false
    teams = ['x','o']
    turn = teams.shuffle.pop
    loop do
      @board.print_board
      if @board.full?
        puts 'Draw!'
        break
      end
      if turn == @player.team
        puts 'What is your move? ("row,col")'
        @player.choose_move(@board)
        gameover = true if @player.win?
      else
        @ai.make_move(@board)
        gameover = true if @ai.win?
      end
      if gameover
        @board.print_board
        if @player.team == turn
          puts 'The Player wins!'
        else
          puts 'The Computer wins'
        end
        break
      end
      turn = (turn == 'x') ? 'o' : 'x'
    end
  end

  def finish
    puts 'Would you like to play again? (y/n)'
    response = ''
    loop do
      print '> '
      response = gets.chomp
      break if response == 'y' || response == 'n'
    end
    response == 'y'
  end
end
