%%%-------------------------------------------------------------------
%%% @author gz1417
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(test_db_state).

-behaviour(gen_server).

-include("test_table.hrl").

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).

-export([test/0, test/1, change_something/0, drop_data/0, flush_state/0]).
%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

test() ->
    ModeList = [map, maps, record, record_list],
    lists:foreach(fun(Mode) -> test(Mode) end, ModeList).

test(Mod) ->
    {ok, Pid} = start_link(Mod),
    ok = flush_state(),
    timer:sleep(3000),

    create_something(),
    ok = flush_state(),
    timer:sleep(3000),

    change_something(),
    ok = flush_state(),
    timer:sleep(3000),

    drop_data(),
    ok = flush_state(),
    timer:sleep(3000),

    create_something(),
    ok = flush_state(),
    timer:sleep(3000),

    drop_data(),
    ok = flush_state(),
    timer:sleep(3000),

    gen_server:stop(Pid).

start_link(Mod) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [Mod], []).

create_something() ->
    gen_server:call(?MODULE, create_something, infinity).

change_something() ->
    gen_server:call(?MODULE, change_something, infinity).

drop_data() ->
    gen_server:call(?MODULE, drop_data, infinity).

flush_state() ->
    gen_server:call(?MODULE, flush_state, infinity).

init([Mod]) ->
    {ok, #{mod => Mod}}.

handle_call(create_something, _From, State) ->
    io:format("create_something ~n", []),
    State1 = do_create(State),
    {reply, State1, State1};

handle_call(change_something, _From, State) ->
    io:format("change_something ~n", []),
    State1 = do_change(State),
    {reply, State1, State1};

handle_call(drop_data, _From, #{mod := Mod} = State) ->
    io:format("drop_data ~n", []),
    {reply, ok, maps:remove(Mod, State)};

handle_call(flush_state, _From, State) ->
    io:format("flush_state ~n", []),
    Value = do_get_value(State),
    Ret = db_state:flush(test_table, Value),
    {reply, Ret, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================

do_create(#{mod := Mod} = State) ->
    case Mod of
        map ->
            ok = db_state:reg(test_db, test_table, [{struct_type, map}]),
            State#{map => db_tools_test_util:new_map()};
        maps ->
            ok = db_state:reg(test_db, test_table, [{struct_type, maps}]),
            State#{
                maps => maps:from_list([begin Map = db_tools_test_util:new_map(), {maps:get(field_1, Map), Map} end || _ <- lists:seq(1, 10)])
            };
        record ->
            ok = db_state:reg(test_db, test_table, [{struct_type, record}]),
            State#{record => db_tools_test_util:new_record()};
        record_list ->
            ok = db_state:reg(test_db, test_table, [{struct_type, record_list}]),
            State#{record_list => [db_tools_test_util:new_record() || _ <- lists:seq(1, 10)]}
    end.

do_change(#{mod := map, map := Map} = State) ->
    State#{map := db_tools_test_util:rand_change(Map)};
do_change(#{mod := maps, maps := Maps} = State) ->
    State#{maps := maps:from_list([{K, db_tools_test_util:rand_change(V)} || {K, V} <- maps:to_list(Maps)])};
do_change(#{mod := record, record := Record} = State) ->
    State#{record := db_tools_test_util:rand_change(Record)};
do_change(#{mod := record_list, record_list := RecordList} = State) ->
    State#{record_list := [db_tools_test_util:rand_change(R) || R <- RecordList]}.

do_get_value(#{mod := map} = State) ->
    maps:get(map, State, undefined);
do_get_value(#{mod := maps} = State) ->
    maps:get(maps, State, #{});
do_get_value(#{mod := record} = State) ->
    maps:get(record, State, undefined);
do_get_value(#{mod := record_list} = State) ->
    maps:get(record_list, State, []).


