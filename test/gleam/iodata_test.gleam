import gleam/should
import gleam/iodata

pub fn iodata_test() {
  let data = iodata.new("ello")
    |> iodata.append(_, ",")
    |> iodata.append(_, " world!")
    |> iodata.prepend(_, "H")

  data
  |> iodata.to_string
  |> should.equal(_, "Hello, world!")

  data
  |> iodata.byte_size
  |> should.equal(_, 13)

  let data = iodata.new("ello")
    |> iodata.append_iodata(_, iodata.new(","))
    |> iodata.append_iodata(_, iodata.concat([iodata.new(" wo"), iodata.new("rld!")]))
    |> iodata.prepend_iodata(_, iodata.new("H"))

  data
  |> iodata.to_string
  |> should.equal(_, "Hello, world!")

  data
  |> iodata.byte_size
  |> should.equal(_, 13)
}

pub fn lowercase_test() {
  ["Gleam", "Gleam"]
  |> iodata.from_strings
  |> iodata.lowercase
  |> iodata.to_string
  |> should.equal(_, "gleamgleam")
}

pub fn uppercase_test() {
  ["Gleam", "Gleam"]
  |> iodata.from_strings
  |> iodata.uppercase
  |> iodata.to_string
  |> should.equal(_, "GLEAMGLEAM")
}

pub fn split_test() {
  "Gleam,Erlang,Elixir"
  |> iodata.new
  |> iodata.split(_, ",")
  |> should.equal(_, [iodata.new("Gleam"), iodata.new("Erlang"), iodata.new("Elixir")])

  ["Gleam, Erl", "ang,Elixir"]
  |> iodata.from_strings
  |> iodata.split(_, ", ")
  |> should.equal(_, [iodata.new("Gleam"), iodata.from_strings(["Erl", "ang,Elixir"])])
}

pub fn is_equal_test() {
  iodata.new("12")
  |> iodata.is_equal(_, iodata.from_strings(["1", "2"]))
  |> should.be_true

  iodata.new("12")
  |> iodata.is_equal(_, iodata.new("12"))
  |> should.be_true

  iodata.new("12")
  |> iodata.is_equal(_, iodata.new("2"))
  |> should.be_false
}

pub fn is_empty_test() {
  iodata.new("")
  |> iodata.is_empty
  |> should.be_true

  iodata.new("12")
  |> iodata.is_empty
  |> should.be_false

  iodata.from_strings([])
  |> iodata.is_empty
  |> should.be_true

  iodata.from_strings(["", ""])
  |> iodata.is_empty
  |> should.be_true
}
