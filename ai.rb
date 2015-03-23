require_relative 'solver.rb'
require_relative 'move_picker.rb'

class AI
  attr_reader :team

  def initialize(team, size, difficulty)
    @difficulty = difficulty
    @team = team
    @solver = Solver.new(size)
    @move_picker = MovePicker.new(size)
    @moves = []
  end

  def make_move(board)
    case @difficulty
    when 1
      random_move(board)
    when 2
      chance_move(board, @moves)
    when 3
      smart_move(board, @moves)
    end
  end

  def chance_move(board, moves)
    option = rand(2)
    option == 0 ? random_move(board) : smart_move(board, moves)
  end

  def random_move(board)
    row = 0
    col = 0
    loop do
      row = rand(board.size)
      col = rand(board.size)
      break if board.cell_available?(row, col)
    end
    board.change_cell(row, col, team)
    @moves << [row, col]
  end

  def smart_move(board, moves)
    moves = @move_picker.pick_moves(board, moves, team)
    move = ''
    loop do
      break if moves.length == 0
      move = moves.shift[1]
      break if board.cell_available?(move[0], move[1])
    end
    if move != ''
      board.change_cell(move[0], move[1], team)
      @moves << move
    else
      random_move(board)
    end
  end

  def win?
    @solver.gameover?(@moves)
  end
end
