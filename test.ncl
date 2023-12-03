let util = import "util.ncl" in
{
  hello = util.array.transpose [[2, 8, 1], [9, 3, 3]]
}
