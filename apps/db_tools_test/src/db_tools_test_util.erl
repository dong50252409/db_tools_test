%%%-------------------------------------------------------------------
%%% @author gz1417
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 9月 2021 14:42
%%%-------------------------------------------------------------------
-module(db_tools_test_util).

-include("test_table.hrl").

%% API
-export([init_id_mgr/0, gen_id/0, rand/2, new_map/0, new_record/0, rand_change/1]).

init_id_mgr() ->
    Ref = atomics:new(1, [{signed, true}]),
    persistent_term:put(id, Ref),
    ok.

gen_id() ->
    Ref = persistent_term:get(id),
    atomics:add_get(Ref, 1, 1).


rand(Min, Max) ->
    M = Min - 1,
    rand:uniform(Max - M) + M.

new_map() ->
    Map = test_table:new_map(),
    Map1 = rand_change(Map),
    Map1#{field_1 := db_tools_test_util:gen_id()}.

new_record() ->
    Record = test_table:new_record(),
    Record1 = rand_change(Record),
    Record1#test_table{field_1 = db_tools_test_util:gen_id()}.

rand_change(Map) when is_map(Map) ->
    Map#{
        field_2 => db_tools_test_util:rand(0, 255),
        field_3 => unicode:characters_to_binary([[db_tools_test_util:rand(65, 122)] || _ <- lists:seq(1, 50)]),
        field_4 => db_tools_test_util:rand(-16#80000000, 16#7FFFFFFF),
        field_5 => rand_json(),
        field_6 => lists:duplicate(10, lists:seq(1, 10)),
        field_7 => lists:duplicate(10, lists:seq(1, 10)),
        ext_field_1 => 0,
        ext_field_2 => [],
        ext_field_3 => {},
        ext_field_4 => <<>>
    };
rand_change(Record) when is_record(Record, ?TEST_TABLE) ->
    Record#test_table{
        field_2 = db_tools_test_util:rand(0, 255),
        field_3 = unicode:characters_to_binary([[db_tools_test_util:rand(65, 122)] || _ <- lists:seq(1, 50)]),
        field_4 = db_tools_test_util:rand(-16#80000000, 16#7FFFFFFF),
        field_5 = rand_json(),
        field_6 = lists:duplicate(10, lists:seq(1, 10)),
        field_7 = lists:duplicate(10, lists:seq(1, 10)),
        ext_field_1 = 0,
        ext_field_2 = [],
        ext_field_3 = {},
        ext_field_4 = <<>>
    }.

rand_json() ->
    L = [
        #{<<"awesome">> => true, <<"library">> => <<"jsx">>},
        [<<"a">>, <<"list">>, <<"of">>, <<"words">>],
        [{<<"library">>, <<"jsx">>}, {<<"awesome">>, true}]
    ],
    N = rand:uniform(length(L)),
    lists:nth(N, L).
