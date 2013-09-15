# SudokuService
# Sudoku-as-a-service
# By Iain Dunning
# https://github.com/IainNZ/SudokuService
# http://iaindunning.com/2013/sudoku-as-a-service.html
# License: MIT

# sudoku.jl
# A sudoku solver that uses a MIP to find solutions

# We have binary variables x[i,j,k] which, if = 1, say that cell (i,j)
# contains the number k
# The constraints are:
# 1 - Each row contains each number exactly once
# 2 - Each column contains each number exactly once
# 3 - Each 3x3 subgrid contains each number exactly once
# and the obvious one that
# 4 - Each cell has one value only
# We take as input a 9x9 matrix, where 0s are "blanks"

using JuMP

function SolveModel(initgrid)
  m = Model(:Max)  # Feasibility problem, so sense not important

  @defVar(m, 0 <= x[1:9, 1:9, 1:9] <= 1, Int)

  for val in 1:9
    for dim1 in 1:9
      # Constraint 1 - Each row...
      @addConstraint(m, sum{x[dim1, dim2, val], dim2=1:9} == 1)
      # Constraint 2 - Each column...
      @addConstraint(m, sum{x[dim2, dim1, val], dim2=1:9} == 1)
    end
  end

  # Constraint 3 - Each sub-grid...
  for i in 0:3:6
    for j in 0:3:6
      for val in 1:9
        @addConstraint(m, sum{x[i+off1, j+off2, val], off1=1:3, off2=1:3} == 1)
      end
    end
  end

  # Constraint 4 - Cells...
  for row in 1:9
    for col in 1:9
      @addConstraint(m, sum{x[row, col, val], val=1:9} == 1)
    end
  end

  # Initial solution
  for row in 1:9
    for col in 1:9
      if initgrid[row,col] != 0
        @addConstraint(m, x[row, col, initgrid[row, col]] == 1)
      end
    end
  end

  # Solve it
  status = solve(m)
  
  # Check solution
  if status == :Infeasible
    error("No solution found!")
  else
    mipSol = getValue(x)
    sol = zeros(Int,9,9)
    for row in 1:9
      for col in 1:9
        for val in 1:9
          if mipSol[row, col, val] >= 0.9
            sol[row, col] = val
          end
        end
      end
    end
    return sol
  end

end

