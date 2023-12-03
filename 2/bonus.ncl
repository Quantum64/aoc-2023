let input = import "input.txt" in
let util = import "../util.ncl" in
let cubes = ["red", "blue", "green"] in
input
|> std.string.split "\n"
|> std.array.map
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
      |> std.array.fold_left
        (
          fun record next =>
            std.array.fold_left
              (
                fun new cube =>
                  new
                  |> std.record.update
                    cube
                    (
                      [record, next]
                      |> std.array.map (util.record.get cube 0)
                      |> std.array.reduce_left std.number.max
                    )
              )
              {}
              cubes
        )
        {}
        |> std.record.values
        |> std.array.reduce_left (*)
  )
  |> std.array.reduce_left (+)
