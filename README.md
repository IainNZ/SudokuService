SudokuService
=============

Sudoku-as-a-service!

Made from:

* [Julia](http://julialang.org), a fantastic up-and-coming language,
* [JuMP](https://github.com/IainNZ/JuMP.jl), an algebraic modelling language for (integer) linear programming,
* [HttpServer.jl](https://github.com/hackerschool/HttpServer.jl), an HTTP server package for Julia made at Hacker School,
* [COIN-OR CBC](https://projects.coin-or.org/Cbc), an open-source integer programming solver.

This project is mainly for demonstration purposes. While you could probably solve sudoku problems faster with a dedicated solver, I wanted to show that it was
 
* Easy to get a server up in Julia, without much web development knowledge, and
* You can solve complex optimization problems using external solvers behind a web interface.

To run it for yourself:
* As far as I know, Windows isn't supported yet by HttpParser, so you need to be on OSX or Linux.
* Clone the repository
* Install Julia 0.2 (see site for instructions)
* Add the required packages:
 * ``julia -e 'Pkg.add("HttpServer")'``
 * ``julia -e 'Pkg.add("JuMP")'``
 * ``julia -e 'Pkg.add("Cbc")'``
* Launch the server: ``julia server.jl``
* Navigate to the server in your browser:
 * Requests should be of the form ``/sudoku/123...123`` or ``/sudoku/123...123/pretty`` for human-readable response
 * There should be 81 numbers, one for each cell of the 9x9 sudoku board, row-wise. A zero indicates a blank.
 * Examples:
  * [http://localhost:8000/sudoku/31005800400.../pretty](http://localhost:8000/sudoku/310058004009320000025104090000000389008000500546000000080203650000071400700480021/pretty) will return a human readable HTML table
  * [http://localhost:8000/sudoku/31005800400...](http://localhost:8000/sudoku/310058004009320000025104090000000389008000500546000000080203650000071400700480021) will return a string of 81 numbers representing the solution
