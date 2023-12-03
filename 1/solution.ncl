let util = import "../util.ncl" in
let input = import "input.txt" in
input
|> std.string.split "\n"
|> std.array.map
  (
    fun line =>
      let digits = std.string.characters line |> std.array.filter util.string.is_digit in
      std.array.first digits ++ std.array.last digits |> std.string.to_number
  )
|> std.array.reduce_left (+)
