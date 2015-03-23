class Solver
  def initialize(size)
    @size = size
  end

  def gameover?(moves)
    check1 = check_vertical(moves)
    check2 = check_horizontal(moves)
    check3 = check_diagonal(moves)
    check1 || check2 || check3
  end

  def check_vertical(moves)
    col_sorted = moves.sort { |x, y| x[1] <=> y[1] }
    straight_solution?(col_sorted, 1)
  end

  def check_horizontal(moves)
    row_sorted = moves.sort { |x, y| x[0] <=> y[0] }
    straight_solution?(row_sorted, 0)
  end

  def check_diagonal(moves)
    diagonal_solution?(moves)
  end

  def straight_solution?(moves, position)
    current = 0
    runner = 0
    streak = 0
    while current < moves.length
      if moves[current][position] == moves[runner][position]
        streak += 1
      else
        current = runner
        streak = 1
      end
      runner += 1
      return true if streak == @size
      break if runner == moves.length
    end
    false
  end

  def diagonal_solution?(moves)
    forward = true
    backward = true
    curr = @size - 1
    @size.times do |num|
      if !moves.include?([num, num])
        forward = false
      end
      if !moves.include?([num, curr - num])
        backward = false
      end
    end
    forward || backward
  end
end
