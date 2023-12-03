let util = import "util.ncl" in
[{ hello = 1 }, { bar = 2 }]
|> std.array.map (util.record.get "hello" 0)
