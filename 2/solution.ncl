let input = import "input.txt" in
let util = import "../util.ncl" in
let cubes = {
  "red" = 12,
  "green" = 13,
  "blue" = 14
}
in
std.string.split "\n" input
|> std.array.filter
  (
    fun line =>
      line
      |> std.string.split ": "
      |> std.array.last
      |> std.string.split "; "
      |> std.array.map
        (
          fun part =>
            part
            |> std.string.split ", "
            |> std.array.fold_left
              (
                fun record next =>
                  record
                  |> std.record.update
                    (
                      next
                      |> std.string.split " "
                      |> std.array.last
                    )
                    (
                      next
                      |> std.string.split " "
                      |> std.array.first
                      |> std.string.to_number
                    )
              )
              {}
        )
      |> std.array.all
        (
          fun record =>
            record
            |> std.record.to_array
            |> std.array.any (fun entry => entry.value > cubes."%{entry.field}")
            |> (!)
        )
  )
|> std.array.fold_left
  (
    fun total line =>
      line
      |> std.string.split ":"
      |> std.array.first
      |> std.string.characters
      |> std.array.filter util.string.is_digit
      |> std.array.reduce_left (++)
      |> std.string.to_number
      |> (+) total
  )
  0
