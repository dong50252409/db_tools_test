%%%-------------------------------------------------------------------
%%% @author gz1417
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(agent_process_test).

-behaviour(gen_server).

-include("test_table.hrl").

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link() ->
    gen_server:start_link(?MODULE, [], []).

init([]) ->
    ok = db_agent_process:reg(test_db, test_table, [{struct_type, map}]),
    ok = db_agent_process:reg(test_db, test_table, [{struct_type, maps}]),
    ok = db_agent_process:reg(test_db, test_table, [{struct_type, record}]),
    ok = db_agent_process:reg(test_db, test_table, [{struct_type, record_list}]),
    State = #{
        map => new_map(),
        maps => maps:from_list([begin Map = test_table:new_map(), {maps:get(field_1, Map), Map} end || _ <- lists:seq(1, 10)]),
        record => new_record(),
        record_list => [new_record() || _ <- lists:seq(1, 10)]
    },
    erlang:send_after(1000 * 1, self(), flush_state),
    erlang:send_after(1000 * 5, self(), change_something),
    erlang:send_after(1000 * 60, self(), shutdown),
    {ok, State}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(change_something, State) ->
    State1 = do_change_something(State),
    {noreply, State1};

handle_info(flush_state, State) ->
    Fun = fun(_K, V, _) -> db_agent_process:flush(test_table, V) end,
    maps:fold(Fun, ok, State),
    erlang:send_after(1000 * 20, self(), flush_state),
    {noreply, State};

handle_info(shutdown, State) ->
    {stop, normal, State};

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, State) ->
    Fun = fun(_K, V, _) -> db_agent_process:flush(test_table, V) end,
    maps:fold(Fun, ok, State),
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================

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

do_change_something(#{map := Map, maps := Maps, record := Record, record_list := RecordList} = State) ->
    State#{
        map := rand_change(Map),
        maps := maps:from_list([{K, rand_change(V)} || {K, V} <- maps:to_list(Maps)]),
        record := rand_change(Record),
        record_list := [rand_change(R) || R <- RecordList]
    }.
