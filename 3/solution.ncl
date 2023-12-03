let input = import "input.txt" in
let util = import "../util.ncl" in
let lines = std.string.split "\n" input in
lines
|> std.array.length
|> std.array.generate std.function.id
|> std.array.map
  (
    fun index =>
      let parts =
        [
          std.array.at index lines,
          util.array.get (index - 1) null lines,
          util.array.get (index + 1) null lines
        ]
        |> std.array.filter (fun x => x != null)
        |> std.array.map std.string.characters
      in
      parts
      |> std.array.first
      |> std.array.length
      |> std.array.generate std.function.id
      |> std.array.fold_left
        (
          fun results index =>
            let character =
              parts
              |> std.array.first
              |> std.array.at index
            in
            if util.string.is_digit character then
              let record =
                if std.array.length results == 0 then
                  { digits = "", symbol = false }
                else
                  std.array.last results
              in
              let symbol = fun character => !util.string.is_digit character && character != "." in
              let last =
                record
                |> std.record.update "digits" (record.digits ++ character)
                |> std.record.update
                  "symbol"
                  (
                    [ -1, 0, 1]
                    |> std.array.map (fun offset => index + offset)
                    |> std.array.map
                      (
                        fun offset =>
                          parts
                          |> std.array.first
                          |> util.array.get offset "."
                          |> symbol
                          || parts
                          |> std.array.drop_first
                          |> std.array.any (fun line => line |> util.array.get offset "." |> symbol)
                      )
                    |> (@) [record.symbol]
                    |> std.array.any std.function.id
                  )
              in
              if std.array.length results == 0 then
                [last]
              else
                std.array.drop_last results @ [last]
            else
              results @ [{ digits = "", symbol = false }]
        )
        []
      |> std.array.filter (fun record => record.symbol)
      |> std.array.map (fun record => record.digits |> std.string.to_number)
  )
|> std.array.flatten
|> std.array.fold_left (+) 0
