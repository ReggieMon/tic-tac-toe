class MovePicker
  def initialize(size)
    @size = size
  end

  def pick_moves(board, moves, team)
    @move_queue = []
    check_corner(board, team)
    check_center(board)
    advance(board, moves, team)
    check_player(board, team)
    @move_queue.sort! { |x, y| y[0] <=> x[0] }
  end

  def advance(board, moves, team)
    rows = check_horizontal(board, team)
    cols = check_vertical(board, team)
    diags = check_diagonals(board, team)
    select_from_horizontal(rows, moves)
    select_from_horizontal(cols, moves)
    select_from_horizontal(diags, moves)
  end

  def check_player(board, team)
    other_team = team == 'x' ? 'o' : 'x'
    rows = check_horizontal(board, other_team)
    cols = check_vertical(board, other_team)
    diags = check_diagonals(board, other_team)
    important_row = rows.select { |row| row[1] == 1 }
    important_col = cols.select { |row| row[1] == 1 }
    important_diag = diags.select { |row| row[1] == 1 }
    imperative_rows(important_row, board) unless important_row.empty?
    imperative_cols(important_col, board) unless important_col.empty?
    imperative_diags(important_diag, board) unless important_diag.empty?
  end

  def check_center(board)
    return if @size.even?
    middle = (@size - 1) / 2
    @move_queue << [5, [middle, middle]] if board.cell_available?(middle, middle)
  end

  def check_corner(board, team)
    n = @size - 1
    corners = [[0,0], [0,n], [n,0], [n,n]]
    available_moves = []
    player_corners = []
    corners.each do |cell|
      if board.cell_available?(cell[0], cell[1])
        available_moves << cell
      elsif board.get_cell(cell[0], cell[1]) != team
        player_corners << cell
      end
    end
    opposite = { 0 => n, n => 0}
    available_moves.each do |move|
      if player_corners.include?([opposite[move[0]],opposite[move[1]]])
        @move_queue << [3, move]
      else
        @move_queue << [1, move]
      end
    end
  end

  def check_horizontal(board, team)
    rows = []
    other_team = team == 'x' ? 'o' : 'x'
    @size.times do |row|
      remaining_spaces = @size
      blocked = false
      @size.times do |col|
        remaining_spaces -= 1 if board.get_cell(row, col) == team
        blocked  = true if board.get_cell(row, col) == other_team
      end
      rows << [row, remaining_spaces] unless blocked
    end
    rows.sort! { |x, y| x[1] <=> y[1] }
  end

  def check_vertical(board, team)
    cols = []
    other_team = team == 'x' ? 'o' : 'x'
    @size.times do |col|
      remaining_spaces = @size
      blocked = false
      @size.times do |row|
        remaining_spaces -= 1 if board.get_cell(row, col) == team
        blocked  = true if board.get_cell(row, col) == other_team
      end
      cols << [col, remaining_spaces] unless blocked
    end
    cols.sort! { |x, y| x[1] <=> y[1] }
  end

  def check_diagonals(board, team)
    diags = []
    other_team = team == 'x' ? 'o' : 'x'
    remaining_spaces = @size
    blocked = false
    @size.times do |num|
      remaining_spaces -= 1 if board.get_cell(0 + num, 0 + num) == team
      blocked = true if board.get_cell(0 + num, 0 + num) == other_team
    end
    diags << ['\\', remaining_spaces] unless blocked

    remaining_spaces = @size
    blocked = false
    @size.times do |num|
      curr = @size - 1
      remaining_spaces -= 1 if board.get_cell(0 + num, curr - num) == team
      blocked = true if board.get_cell(0 + num, curr - num) == other_team
    end
    diags << ['/', remaining_spaces] unless blocked
    diags.sort! { |x, y| x[1] <=> y[1] }
  end

  def select_from_horizontal(horizontals, moves)
    horizontals.each do |tuple|
      row = tuple[0]
      free_spaces = tuple[1]
      next if free_spaces == @size
      priority = free_spaces == 1 ? @size * 3 : @size - (free_spaces - 1)
      same_row = moves.select { |move| move[0] == row}
      possible_moves = []
      same_row.each do |cell|
        possible_moves << [row, cell[1] - 1] unless cell[1] == 0
        possible_moves << [row, cell[1] + 1] unless cell[1] == @size - 1
      end
      possible_moves.keep_if { |move| !moves.include?(move) }
      possible_moves.each { |move| @move_queue << [priority, move] }
    end
  end

  def select_from_vertical(verticals, moves)
    verticals.each do |tuple|
      col = tuple[0]
      free_spaces = tuple[1]
      next if free_spaces == @size
      priority = free_spaces == 1 ? @size * 3 : @size - (free_spaces - 1)
      same_col = moves.select { |move| move[1] == col}
      possible_moves = []
      same_col.each do |cell|
        possible_moves << [cell[0] - 1, col] unless cell[0] == 0
        possible_moves << [cell[0] + 1, col] unless cell[0] == @size - 1
      end
      possible_moves.keep_if { |move| !moves.include?(move) }
      possible_moves.each { |move| @move_queue << [priority, move] }
    end
  end

  def select_from_diagonal(diagonals, moves)
    diagonals.each do |tuple|
      direction = tuple[0]
      free_spaces = tuple[1]
      next if free_spaces == @size
      priority = free_spaces == 1 ? @size * 3 : @size - (free_spaces - 1)
      possible_moves = []
      if (direction == '\\')
        same_diag = moves.select { |move| move[0] - move[1] == 0 }
        same_diag.each do |cell|
          possible_moves << [cell[0] - 1, cell[1] - 1] unless cell[0] == 0
          possible_moves << [cell[0] + 1, cell[1] + 1] unless cell[0] == @size - 1
        end
        possible_moves.keep_if { |move| !moves.include?(move) }
        possible_moves.each { |move| @move_queue << [priority, move] }
      else
        same_diag = moves.select { |move| move[0] + move[1] == (@size - 1) }
        same_diag.each do |cell|
          possible_moves << [cell[0] + 1, cell[1] - 1] unless cell[0] == 0
          possible_moves << [cell[0] - 1, cell[1] + 1] unless cell[0] == @size - 1
        end
        possible_moves.keep_if { |move| !moves.include?(move) }
        possible_moves.each { |move| @move_queue << [priority, move] }
      end
    end
  end

  def imperative_rows(rows, board)
    rows.each do |row|
      @size.times do |col|
        next unless board.cell_available?(row[0], col)
        @move_queue << [@size * 2, [row[0], col]]
      end
    end
  end

  def imperative_cols(cols, board)
    cols.each do |col|
      @size.times do |row|
        next unless board.cell_available?(row, col[0])
        @move_queue << [@size * 2, [row, col[0]]]
      end
    end
  end

  def imperative_diags(diags, board)
    diags.each do |diag|
      if diag[0] == '\\'
        @size.times do |num|
          next unless board.cell_available?(num, num)
          @move_queue << [@size * 2, [num, num]]
        end
      else
        @size.times do |num|
          next unless board.cell_available?(num, (@size - 1) - num)
          @move_queue << [@size * 2, [num, (@size - 1) - num]]
        end
      end
    end
  end
end
