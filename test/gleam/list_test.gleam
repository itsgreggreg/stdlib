import gleam/should
import gleam/list
import gleam/int
import gleam/float
import gleam/string
import gleam/pair

pub fn length_test() {
  list.length([])
  |> should.equal(_, 0)

  list.length([1])
  |> should.equal(_, 1)

  list.length([1, 1])
  |> should.equal(_, 2)

  list.length([1, 1, 1])
  |> should.equal(_, 3)
}

pub fn reverse_test() {
  list.reverse([]) |> should.equal(_, [])
  list.reverse([1, 2, 3, 4, 5]) |> should.equal(_, [5, 4, 3, 2, 1])
}

pub fn is_empty_test() {
  list.is_empty([]) |> should.be_true
  list.is_empty([1]) |> should.be_false
}

pub fn contains_test() {
  list.contains([0, 4, 5, 1], 1) |> should.be_true
  list.contains([0, 4, 5, 7], 1) |> should.be_false
  list.contains([], 1) |> should.be_false
}

pub fn head_test() {
  list.head([0, 4, 5, 7])
    |> should.equal(_, Ok(0))

  list.head([])
    |> should.equal(_, Error(Nil))
}

pub fn tail_test() {
  list.tail([0, 4, 5, 7])
    |> should.equal(_, Ok([4, 5, 7]))

  list.tail([0])
    |> should.equal(_, Ok([]))

  list.tail([])
    |> should.equal(_, Error(Nil))
}

pub fn filter_test() {
  []
    |> list.filter(_, fn(_) { True })
    |> should.equal(_, [])

  [0, 4, 5, 7, 3]
    |> list.filter(_, fn(_) { True })
    |> should.equal(_, [0, 4, 5, 7, 3])

  [0, 4, 5, 7, 3]
    |> list.filter(_, fn(x) { x > 4 })
    |> should.equal(_, [5, 7])

  [0, 4, 5, 7, 3]
    |> list.filter(_, fn(x) { x < 4 })
    |> should.equal(_, [0, 3])
}

pub fn map_test() {
  []
    |> list.map(_, fn(x) { x * 2 })
    |> should.equal(_, [])

  [0, 4, 5, 7, 3]
    |> list.map(_, fn(x) { x * 2 })
    |> should.equal(_, [0, 8, 10, 14, 6])
}

pub fn traverse_test() {
  let fun = fn(x) {
    case x == 6 || x == 5 || x == 4 {
      True -> Ok(x * 2)
      False -> Error(x)
    }
  }

  [5, 6, 5, 6]
    |> list.traverse(_, fun)
    |> should.equal(_, Ok([10, 12, 10, 12]))

  [4, 6, 5, 7, 3]
    |> list.traverse(_, fun)
    |> should.equal(_, Error(7))
}

pub fn drop_test() {
  []
    |> list.drop(_, 5)
    |> should.equal(_, [])

  [1, 2, 3, 4, 5, 6, 7, 8]
    |> list.drop(_, 5)
    |> should.equal(_, [6, 7, 8])
}

pub fn take_test() {
  []
    |> list.take(_, 5)
    |> should.equal(_, [])
  [1, 2, 3, 4, 5, 6, 7, 8]
    |> list.take(_, 5)
    |> should.equal(_, [1, 2, 3, 4, 5])
}

pub fn new_test() {
  list.new() |> should.equal(_, [])
}

pub fn append_test() {
  list.append([1], [2, 3])
    |> should.equal(_, [1, 2, 3])
}

pub fn flatten_test() {
  list.flatten([])
    |> should.equal(_, [])

  list.flatten([[]])
    |> should.equal(_, [])

  list.flatten([[], [], []])
    |> should.equal(_, [])

  list.flatten([[1, 2], [], [3, 4]])
    |> should.equal(_, [1, 2, 3, 4])
}

pub fn fold_test() {
  [1, 2, 3]
    |> list.fold(_, [], fn(x, acc) { [x | acc] })
    |> should.equal(_, [3, 2, 1])
}

pub fn fold_right_test() {
  [1, 2, 3]
  |> list.fold_right(_, from: [], with: fn(x, acc) { [x | acc] })
  |> should.equal(_, [1, 2, 3])
}

pub fn find_map_test() {
  let f = fn(x) {
    case x {
      2 -> Ok(4)
      _ -> Error(Nil)
    }
  }

  [1, 2, 3]
  |> list.find_map(_, with: f)
  |> should.equal(_, Ok(4))

  [1, 3, 2]
  |> list.find_map(_, with: f)
  |> should.equal(_, Ok(4))

  [1, 3]
  |> list.find_map(_, with: f)
  |> should.equal(_, Error(Nil))
}

pub fn find_test() {
  let is_two = fn(x) {
    x == 2
  }

  [1, 2, 3]
  |> list.find(_, one_that: is_two)
  |> should.equal(_, Ok(2))

  [1, 3, 2]
  |> list.find(_, one_that: is_two)
  |> should.equal(_, Ok(2))

  [1, 3]
  |> list.find(_, one_that: is_two)
  |> should.equal(_, Error(Nil))
}

pub fn all_test() {
  list.all([1, 2, 3, 4, 5], fn(x) { x > 0 })
  |> should.equal(_, True)

  list.all([1, 2, 3, 4, 5], fn(x) { x < 0 })
  |> should.equal(_, False)

  list.all([], fn(_) { False })
  |> should.equal(_, True)
}

pub fn any_test() {
  list.any([1, 2, 3, 4, 5], fn(x) { x == 2 })
  |> should.equal(_, True)

  list.any([1, 2, 3, 4, 5], fn(x) { x < 0 })
  |> should.equal(_, False)

  list.any([], fn(_) { False })
  |> should.equal(_, False)
}

pub fn zip_test() {
  list.zip([], [1, 2, 3])
  |> should.equal(_, [])

  list.zip([1, 2], [])
  |> should.equal(_, [])

  list.zip([1, 2, 3], [4, 5, 6])
  |> should.equal(_, [tuple(1, 4), tuple(2, 5), tuple(3, 6)])

  list.zip([5, 6], [1, 2, 3])
  |> should.equal(_, [tuple(5, 1), tuple(6, 2)])

  list.zip([5, 6, 7], [1, 2])
  |> should.equal(_, [tuple(5, 1), tuple(6, 2)])
}

pub fn strict_zip_test() {
  list.strict_zip([], [1, 2, 3])
  |> should.equal(_, Error(list.LengthMismatch))

  list.strict_zip([1, 2], [])
  |> should.equal(_, Error(list.LengthMismatch))

  list.strict_zip([1, 2, 3], [4, 5, 6])
  |> should.equal(_, Ok([
    tuple(1, 4),
    tuple(2, 5),
    tuple(3, 6),
  ]))

  list.strict_zip([5, 6], [1, 2, 3])
  |> should.equal(_, Error(list.LengthMismatch))

  list.strict_zip([5, 6, 7], [1, 2])
  |> should.equal(_, Error(list.LengthMismatch))
}

pub fn intersperse_test() {
  list.intersperse([1, 2, 3], 4)
  |> should.equal(_, [1, 4, 2, 4, 3])

  list.intersperse([], 2)
  |> should.equal(_, [])
}

pub fn at_test() {
  list.at([1, 2, 3], 2)
  |> should.equal(_, Ok(3))

  list.at([1, 2, 3], 5)
  |> should.equal(_, Error(Nil))

  list.at([], 0)
  |> should.equal(_, Error(Nil))

  list.at([1, 2, 3, 4, 5, 6], -1)
  |> should.equal(_, Error(Nil))
}

pub fn unique_test() {
  list.unique([1, 1, 2, 3, 4, 4, 4, 5, 6])
  |> should.equal(_, [1, 2, 3, 4, 5, 6])

  list.unique([7, 1, 45, 6, 2, 47, 2, 7, 5])
  |> should.equal(_, [7, 1, 45, 6, 2, 47, 5])

  list.unique([3, 4, 5])
  |> should.equal(_, [3, 4, 5])

  list.unique([])
  |> should.equal(_, [])
}

pub fn sort_test() {
  [4, 3, 6, 5, 4]
  |> list.sort(_, int.compare)
  |> should.equal(_, [3, 4, 4, 5, 6])

  [4, 3, 6, 5, 4, 1]
  |> list.sort(_, int.compare)
  |> should.equal(_, [1, 3, 4, 4, 5, 6])

  [4.1, 3.1, 6.1, 5.1, 4.1]
  |> list.sort(_, float.compare)
  |> should.equal(_, [3.1, 4.1, 4.1, 5.1, 6.1])

  []
  |> list.sort(_, int.compare)
  |> should.equal(_, [])
}

pub fn index_map_test() {
  list.index_map([3, 4, 5], fn(i, x) { tuple(i, x) })
  |> should.equal(_, [tuple(0, 3), tuple(1, 4), tuple(2, 5)])

  let f = fn(i, x) {
    string.append(x, int.to_string(i))
  }
  list.index_map(["a", "b", "c"], f)
  |> should.equal(_, ["a0", "b1", "c2"])
}

pub fn range_test() {
  list.range(0, 0)
  |> should.equal(_, [])

  list.range(1, 1)
  |> should.equal(_, [])

  list.range(-1, -1)
  |> should.equal(_, [])

  list.range(0, 1)
  |> should.equal(_, [0])

  list.range(0, 5)
  |> should.equal(_, [0, 1, 2, 3, 4])

  list.range(1, -5)
  |> should.equal(_, [1, 0, -1, -2, -3, -4])
}

pub fn repeat_test() {
  list.repeat(1, -10)
  |> should.equal(_, [])

  list.repeat(1, 0)
  |> should.equal(_, [])

  list.repeat(2, 3)
  |> should.equal(_, [2, 2, 2])

  list.repeat("x", 5)
  |> should.equal(_, ["x", "x", "x", "x", "x"])
}

pub fn split_test() {
  []
  |> list.split(_, 0)
  |> should.equal(_, tuple([], []))

  [0, 1, 2, 3, 4]
  |> list.split(_, 0)
  |> should.equal(_, tuple([], [0, 1, 2, 3, 4]))

  [0, 1, 2, 3, 4]
  |> list.split(_, -2)
  |> should.equal(_, tuple([], [0, 1, 2, 3, 4]))

  [0, 1, 2, 3, 4]
  |> list.split(_, 1)
  |> should.equal(_, tuple([0], [1, 2, 3, 4]))

  [0, 1, 2, 3, 4]
  |> list.split(_, 3)
  |> should.equal(_, tuple([0, 1, 2], [3, 4]))

  [0, 1, 2, 3, 4]
  |> list.split(_, 9)
  |> should.equal(_, tuple([0, 1, 2, 3, 4], []))
}

pub fn split_while_test() {
  []
  |> list.split_while(_, fn(x) { x <= 5 })
  |> should.equal(_, tuple([], []))

  [1, 2, 3, 4, 5]
  |> list.split_while(_, fn(x) { x <= 5 })
  |> should.equal(_, tuple([1, 2, 3, 4, 5], []))

  [1, 2, 3, 4, 5]
  |> list.split_while(_, fn(x) { x == 2 })
  |> should.equal(_, tuple([], [1, 2, 3, 4, 5]))

  [1, 2, 3, 4, 5]
  |> list.split_while(_, fn(x) { x <= 3 })
  |> should.equal(_, tuple([1, 2, 3], [4, 5]))

  [1, 2, 3, 4, 5]
  |> list.split_while(_, fn(x) { x <= -3 })
  |> should.equal(_, tuple([], [1, 2, 3, 4, 5]))
}


pub fn key_find_test() {
  let proplist = [tuple(0, "1"), tuple(1, "2")]

  proplist
  |> list.key_find(_, 0)
  |> should.equal(_, Ok("1"))

  proplist
  |> list.key_find(_, 1)
  |> should.equal(_, Ok("2"))

  proplist
  |> list.key_find(_, 2)
  |> should.equal(_, Error(Nil))
}
