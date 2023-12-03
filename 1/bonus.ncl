let util = import "../util.ncl" in
let input = import "input.txt" in
let words = {
  "one" = "1",
  "two" = "2",
  "three" = "3",
  "four" = "4",
  "five" = "5",
  "six" = "6",
  "seven" = "7",
  "eight" = "8",
  "nine" = "9",
}
in
[
  {
    fold = std.array.fold_left,
    index = util.string.index_of
  },
  {
    fold = fun f a b => std.array.fold_right (fun a b => f b a) a b,
    index = util.string.last_index_of
  }
]
|> std.array.map (
    fun function =>
      std.string.split "\n" input
      |> std.array.map
        (
          fun line =>
            std.string.length line
            |> std.array.generate std.function.id
            |> function.fold
              (
                fun result index =>
                  if result > 0 then
                    result
                  else
                    let found =
                      words
                      |> std.record.map (fun word digit => function.index word line)
                      |> std.record.filter (fun word word_index => word_index == index)
                      |> std.record.to_array
                    in
                    if std.string.characters line |> std.array.at index |> util.string.is_digit then
                      std.string.characters line |> std.array.at index |> std.string.to_number
                    else if std.array.length found > 0 then
                      std.array.first found |> (.) "field" |> (fun word => (.) word words) |> std.string.to_number
                    else
                      0
              )
              0
            |> std.to_string
        )
)
|> util.array.transpose
|> std.array.map (std.array.reduce_left (++))
|> std.array.map std.string.to_number
|> std.array.reduce_left (+)
