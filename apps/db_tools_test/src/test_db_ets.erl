%%%-------------------------------------------------------------------
%%% @author gz1417
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(test_db_ets).

-behaviour(gen_server).

-include("test_table.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-export([start_link/0, do_delete_all_objects/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).

-export([test/0, test_1/0, test_2/0, func/1, flush/0]).

-export([
    do_insert/1, do_insert_new/1, do_insert_update/1,
    do_update_counter/1, do_update_element/1, do_select_replace/1,
    do_delete/1, do_delete_object/1, do_select_delete/1, do_take/1, do_delete_table/1]).


-define(ETS_TEST_TABLE, test_table).
%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

test() ->
    test_1(),

    test_2().

test_1() ->
    %% [{mode, auto}, {flush_interval, 1 * 60 * 1000}]
    start_link(),
    func(do_insert),
    ok = db_ets:flush(?ETS_TEST_TABLE),
    timer:sleep(3000),

    func(do_insert_new),
    ok = db_ets:flush(?ETS_TEST_TABLE),
    timer:sleep(3000),

    func(do_insert_update),
    ok = db_ets:flush(?ETS_TEST_TABLE),
    timer:sleep(3000),

    func(do_update_counter),
    ok = db_ets:flush(?ETS_TEST_TABLE),
    timer:sleep(3000),

    func(do_update_element),
    ok = db_ets:flush(?ETS_TEST_TABLE),
    timer:sleep(3000),

    func(do_delete),
    ok = db_ets:flush(?ETS_TEST_TABLE),
    timer:sleep(3000),

    func(do_delete_object),
    ok = db_ets:flush(?ETS_TEST_TABLE),
    timer:sleep(3000),

    func(do_take),
    ok = db_ets:flush(?ETS_TEST_TABLE),
    timer:sleep(3000),

    func(do_select_delete),
    ok = db_ets:flush(?ETS_TEST_TABLE),
    timer:sleep(3000),

    func(do_delete_all_objects),
    ok = db_ets:flush(?ETS_TEST_TABLE),
    timer:sleep(3000),

    func(do_delete_table),
    timer:sleep(3000),

    gen_server:stop(?MODULE).

%%    func(do_select_replace),
%%    db_ets:flush(?ETS_TEST_TABLE),
%%    timer:sleep(3000).


test_2() ->
    %% [{mode, {callback, ?MODULE}}, {flush_interval, 1 * 60 * 1000}]
    start_link(),
    func(do_insert),
    {_, _, _} = db_ets:pull(?ETS_TEST_TABLE),
    timer:sleep(3000),

    func(do_insert_new),
    {_, _, _} = db_ets:pull(?ETS_TEST_TABLE),
    timer:sleep(3000),

    func(do_insert_update),
    {_, _, _} = db_ets:pull(?ETS_TEST_TABLE),
    timer:sleep(3000),

    func(do_update_counter),
    {_, _, _} = db_ets:pull(?ETS_TEST_TABLE),
    timer:sleep(3000),

    func(do_update_element),
    {_, _, _} = db_ets:pull(?ETS_TEST_TABLE),
    timer:sleep(3000),

    func(do_delete),
    {_, _, _} = db_ets:pull(?ETS_TEST_TABLE),
    timer:sleep(3000),

    func(do_delete_object),
    {_, _, _} = db_ets:pull(?ETS_TEST_TABLE),
    timer:sleep(3000),

    func(do_take),
    {_, _, _} = db_ets:pull(?ETS_TEST_TABLE),
    timer:sleep(3000),

    func(do_select_delete),
    {_, _, _} = db_ets:pull(?ETS_TEST_TABLE),
    timer:sleep(3000),

    func(do_delete_all_objects),
    {_, _, _} = db_ets:pull(?ETS_TEST_TABLE),
    timer:sleep(3000),

    func(do_delete_table),
    timer:sleep(3000),

    gen_server:stop(?MODULE).

%%    func(do_select_replace),
%%    db_ets:flush(?ETS_TEST_TABLE),
%%    timer:sleep(3000).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

func(Fun) ->
    gen_server:call(?MODULE, {func, Fun}, infinity).

flush() ->
    gen_server:call(?MODULE, flush, infinity).

init([]) ->
    _Tab = ets:new(?ETS_TEST_TABLE, [named_table, set, {keypos, #test_table.field_1}]),
    {ok, #{}}.

handle_call({func, Fun}, _From, State) ->
    io:format("func:~w~n", [Fun]),
    State1 = ?MODULE:Fun(State),
    {reply, ok, State1};

handle_call(flush, _From, State) ->
    io:format("flush ~n", []),
    db_ets:flush(?ETS_TEST_TABLE),
    {reply, ok, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    io:format("INFOL:~w~n", [_Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================

do_insert(State) ->
    RecordList = [db_tools_test_util:new_record() || _ <- lists:seq(1, 10)],
    ets:insert(?ETS_TEST_TABLE, RecordList),
    State#{keys => [Record#test_table.field_1 || Record <- RecordList]}.

do_insert_new(#{keys := Keys} = State) ->
    Record = db_tools_test_util:new_record(),
    ets:insert_new(?ETS_TEST_TABLE, Record),
    State#{keys := [Record#test_table.field_1 | Keys]}.

do_insert_update(State) ->
    lists:foreach(
        fun(Record) ->
            NewRecord = db_tools_test_util:rand_change(Record),
            ets:insert(?ETS_TEST_TABLE, NewRecord)
        end,
        ets:tab2list(?ETS_TEST_TABLE)),
    State.

do_update_counter(#{keys := Keys} = State) ->
    [ets:update_counter(?ETS_TEST_TABLE, Key, {#test_table.field_2, 1}) || Key <- Keys],
    State.

do_update_element(#{keys := Keys} = State) ->
    [ets:update_element(?ETS_TEST_TABLE, Key, {#test_table.field_2, 1}) || Key <- Keys],
    State.

do_select_replace(State) ->
    MS = ets:fun2ms(fun(Record) when Record#test_table.field_1 rem 3 =:= 0 -> Record#test_table{field_3 = <<>>} end),
    ets:select_replace(?ETS_TEST_TABLE, MS),
    State.

do_delete(#{keys := [Key | T]} = State) ->
    ets:delete(?ETS_TEST_TABLE, Key),
    State#{keys := T}.

do_delete_object(#{keys := [Key | T]} = State) ->
    [Record] = ets:lookup(?ETS_TEST_TABLE, Key),
    ets:delete_object(?ETS_TEST_TABLE, Record),
    State#{keys := T}.

do_select_delete(#{keys := Keys} = State) ->
    MS = ets:fun2ms(fun(#test_table{field_1 = Field1}) when Field1 rem 2 =:= 0 -> true end),
    ets:select_delete(?ETS_TEST_TABLE, MS),
    State#{keys := [Key || Key <- Keys, Key rem 2 =/= 0]}.

do_take(#{keys := [Key | T]} = State) ->
    [_Record] = ets:take(?ETS_TEST_TABLE, Key),
    State#{keys := T}.

do_delete_all_objects(State) ->
    ets:delete_all_objects(?ETS_TEST_TABLE),
    State#{keys := []}.

do_delete_table(State) ->
    ets:delete(?ETS_TEST_TABLE),
    State#{keys := []}.
