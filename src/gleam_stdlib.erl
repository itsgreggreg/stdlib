-module(gleam_stdlib).
-include_lib("eunit/include/eunit.hrl").

-export([should_equal/2, should_not_equal/2, should_be_true/1, should_be_false/1,
         should_be_ok/1, should_be_error/1, atom_from_string/1,
         atom_create_from_string/1, atom_to_string/1, map_get/2,
         iodata_append/2, iodata_prepend/2, identity/1, decode_int/1,
         decode_string/1, decode_bool/1, decode_float/1, decode_thunk/1, decode_atom/1,
         decode_list/1, decode_field/2, decode_element/2, parse_int/1, parse_float/1, compare_strings/2]).

should_equal(Actual, Expected) -> ?assertEqual(Expected, Actual).
should_not_equal(Actual, Expected) -> ?assertNotEqual(Expected, Actual).
should_be_true(A) -> ?assert(A).
should_be_false(A) -> ?assertNot(A).
should_be_ok(A) -> ?assertMatch({ok, _}, A).
should_be_error(A) -> ?assertMatch({error, _}, A).

map_get(Map, Key) ->
  case maps:find(Key, Map) of
    error -> {error, nil};
    OkFound -> OkFound
  end.

atom_create_from_string(S) ->
  binary_to_atom(S, utf8).

atom_to_string(S) ->
  atom_to_binary(S, utf8).

atom_from_string(S) ->
  try {ok, binary_to_existing_atom(S, utf8)} catch
    error:badarg -> {error, atom_not_loaded}
  end.

iodata_append(Iodata, String) -> [Iodata, String].
iodata_prepend(Iodata, String) -> [String, Iodata].

identity(X) -> X.

decode_error_msg(Type, Data) ->
  {error, iolist_to_binary(io_lib:format("Expected ~s, got `~p`", [Type, Data]))}.

decode_atom(Data) when is_atom(Data) -> {ok, Data};
decode_atom(Data) -> decode_error_msg("an Atom", Data).

decode_string(Data) when is_binary(Data) -> {ok, Data};
decode_string(Data) -> decode_error_msg("a String", Data).

decode_int(Data) when is_integer(Data) -> {ok, Data};
decode_int(Data) -> decode_error_msg("an Int", Data).

decode_float(Data) when is_float(Data) -> {ok, Data};
decode_float(Data) -> decode_error_msg("a Float", Data).

decode_bool(Data) when is_boolean(Data) -> {ok, Data};
decode_bool(Data) -> decode_error_msg("a Bool", Data).

decode_thunk(Data) when is_function(Data, 0) -> {ok, Data};
decode_thunk(Data) -> decode_error_msg("a zero arity function", Data).

decode_list(Data) when is_list(Data) -> {ok, Data};
decode_list(Data) -> decode_error_msg("a List", Data).

decode_field(Data, Key) ->
  case Data of
    #{Key := Value} ->
      {ok, Value};

    _ ->
      decode_error_msg(io_lib:format("a map with key `~p`", [Key]), Data)
  end.

decode_element(Data, Position) when is_tuple(Data) ->
  case catch element(Position + 1, Data) of
    {'EXIT', _Reason} ->
      {error, "Element position is out-of-bounds"};

    Value ->
      {ok, Value}
  end;
decode_element(Data, _Position) -> decode_error_msg("a Tuple", Data).

parse_int(String) ->
  case string:to_integer(binary:bin_to_list(String)) of
    {Integer, []} ->
      {ok, Integer};

    _ ->
      {error, nil}
  end.

parse_float(String) ->
  case string:to_float(binary:bin_to_list(String)) of
    {Float, []} ->
      {ok, Float};

    _ ->
      {error, nil}
  end.

compare_strings(Lhs, Rhs) ->
  if
    Lhs == Rhs ->
      eq;
    Lhs < Rhs ->
      lt;
    true ->
     gt
  end.
