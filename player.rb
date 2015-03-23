require_relative 'solver.rb'

class Player
  attr_reader :team

  def initialize(team, n)
    @team = team
    @solver = Solver.new(n)
    @moves = []
  end

  def choose_move(board)
    move = ''
    loop do
      print('player:> ')
      move = gets.chomp.strip
      next unless move =~ /\d,\d/
      move = move.split(',').map(&:to_i)
      next if move.length != 2
      break if move.min >= 0 && move.max < board.size
    end
    make_move(move[0].to_i, move[1].to_i, board)
    @moves << [move[0].to_i, move[1].to_i]
  end

  def make_move(row, col, board)
    board.change_cell(row, col, team)
  end

  def win?
    @solver.gameover?(@moves)
  end
end
