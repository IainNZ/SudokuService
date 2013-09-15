# SudokuService
# Sudoku-as-a-service
# By Iain Dunning
# https://github.com/IainNZ/SudokuService
# http://iaindunning.com/2013/sudoku-as-a-service.html
# License: MIT

# server.jl
# A server that accepts and validates sudoku problems

using HttpServer

# Load the Sudoku solver
require("sudoku.jl")

# Build the request handler
http = HttpHandler() do req::Request, res::Response
  if ismatch(r"^/sudoku/", req.resource)
    # Expecting 81 numbers between 0 and 9
    reqsplit = split(req.resource, "/")
    prettyoutput = false
    if length(reqsplit) == 4
      if reqsplit[4] == "pretty"
        prettyoutput = true
      end
    end
    if length(reqsplit) <= 2
      return Response("Error: no numbers")
    end
    probstr = reqsplit[3]
    println(probstr)
    if length(probstr) != 81
      return Response("Error: expected 81 numbers.")
    end
    
    # Convert string into numbers, and place in matrix
    # Return error if any non-numbers or numbers out of range detected
    prob = zeros(Int,9,9)
    pos = 1
    try
      for row = 1:9
        for col = 1:9
          val = int(probstr[pos:pos])
          if val < 0 || val > 10
            return Response("Error: number out of range 0:9.")
          end
          prob[row,col] = val
          pos += 1
        end
      end
    catch
      return Response("Error: couldn't parse numbers.")
    end

    # Attempt to solve the problem using integer programming
    try
      sol = SolveModel(prob)
      if prettyoutput
        # Human readable output
        out = "<table>"
        for row = 1:9
          out = string(out,"<tr>")
          for col = 1:9
            out = string(out,"<td>",sol[row,col],"</td>")
          end
          out = string(out,"</tr>")
        end
        out = string(out,"</table>")
        return Response(out)
      else
        # Return solution like input
        return Response(join(sol,""))
      end
    catch
      return Response("Error: coudn't solve puzzle.")
    end
  else
    return Response(404)
  end
end

# Basic event handlers
http.events["error"]  = ( client, err ) -> println( err )
http.events["listen"] = ( port )        -> println("Listening on $port...")

# Boot up the server
server = Server(http)
run(server, 8000)
