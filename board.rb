class Board
  attr_reader :size

  def initialize(size)
    make_board(size)
    @size = size
  end

  def make_board(size)
    @board = []
    size.times do
      row = []
      size.times do
        row << ' '
      end
      @board << row
    end
  end

  def print_board
    max_char_size = [0, @board.size-1].max.to_s.size
    header = (0...@board.size).to_a
    row_size = (max_char_size+1)*@board.size + max_char_size
    header_separator = ' '*max_char_size

    puts header.join(header_separator).rjust(row_size, ' ')

    separator = [' '*max_char_size].join('')
    separator[separator.size/2] = '|'

    @board.each_with_index do |row, row_number|
      print row_number.to_s.ljust(max_char_size + 1, ' ')
      puts row.join(separator)
    end
  end

  def change_cell(row, col, value)
    @board[row][col] = value
  end

  def get_cell(row, col)
    @board[row][col]
  end

  def cell_available?(row, col)
    @board[row][col] == ' '
  end

  def full?
    @board.all? do |row|
      row.all? do |cell|
        cell != ' '
      end
    end
  end
end
