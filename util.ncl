{
  bool = {
    not = fun value => !value,
  },
  string = {
    is_empty = fun string => std.string.length string == 0,
    is_not_empty = fun string => std.string.length string > 0,
    is_digit = fun character =>
      std.string.to_enum character
      |> match {
        '"0" => true,
        '"1" => true,
        '"2" => true,
        '"3" => true,
        '"4" => true,
        '"5" => true,
        '"6" => true,
        '"7" => true,
        '"8" => true,
        '"9" => true,
        _ => false
      },
    index_of = fun target string =>
      std.string.length string
      |> std.array.generate std.function.id
      |> std.array.fold_left
        (
          fun result start =>
            if result >= 0 || std.string.length target + start > std.string.length string then
              result
            else if std.string.substring start (std.string.length target + start) string == target then
              start
            else
              result
        )
        (-1),
    last_index_of = fun target string =>
      std.string.length string
      |> std.array.generate (fun x => x + 1)
      |> std.array.fold_right
        (
          fun end result =>
            if result >= 0 || end - std.string.length target < 0 then
              result
            else if std.string.substring (end - std.string.length target) end string == target then
              end - std.string.length target
            else
              result
        )
        (-1)
  },
  array = {
    sum = fun array =>
      std.array.fold_left
        (
          fun result next =>
            result + next
        )
        0
        array,
    chunked = fun count array =>
      std.array.fold_left
        (
          fun result next =>
            if std.array.length result == 0 then
              [[next]]
            else if std.array.last result |> std.array.length |> (==) count then
              result @ [[next]]
            else
              std.array.drop_last result @ [std.array.last result @ [next]]
        )
        []
        array,
    transpose =
      let rec transpose = fun matrix =>
        if std.array.any (fun array => std.array.length array == 0) matrix then
          []
        else
          [
            std.array.map std.array.first matrix
          ]
          @ (
            std.array.map (fun array => std.array.drop_first array) matrix
            |> transpose
          )
      in transpose,
    get = fun index not_found array =>
      if index < 0 || index >= std.array.length array then
        not_found
      else
        std.array.at index array,
  },
  record = {
    get = (fun key not_found record => if std.record.has_field key record then record."%{key}" else not_found),
  }
}
