let input = import "input.txt" in
let util = import "../util.ncl" in
let lines = std.string.split "\n" input in
lines
|> std.array.map
  (
    fun line =>
      let numbers =
        line
        |> std.string.split " | "
        |> std.array.last
        |> std.string.split " "
        |> std.array.filter util.string.is_not_empty
        |> std.array.map std.string.to_number
      in
      line
      |> std.string.split " | "
      |> std.array.first
      |> std.string.split ": "
      |> std.array.last
      |> std.string.split " "
      |> std.array.filter util.string.is_not_empty
      |> std.array.map std.string.to_number
      |> std.array.filter (fun n => std.array.elem n numbers)
      |> std.array.fold_left (fun total number => total * 2 |> std.number.max (total + 1)) 0
  )
|> util.array.sum
