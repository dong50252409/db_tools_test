%%%-------------------------------------------------------------------
%%% @author gz1417
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(test_db_ets_1).

-behaviour(gen_server).

-include("test_table.hrl").
-include_lib("stdlib/include/ms_transform.hrl").

-compile({parse_transform, db_ets_parse}).

-export([start_link/1, do_delete_all_objects/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2]).

-export([
    do_insert/1, do_insert_new/1, do_insert_update/1,
    do_update_counter/1, do_update_element/1, do_select_replace/1,
    do_delete/1, do_delete_object/1, do_select_delete/1, do_take/1, do_delete_table/1]).


-define(ETS_TEST_TABLE, test_table).
%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link(Options) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, Options, []).


init(Options) ->
    Tab = ets:new(?ETS_TEST_TABLE, [named_table, set, {keypos, #test_table.field_1}]),
    ok = db_ets:reg_select(?ETS_TEST_TABLE, test_db, ?TEST_TABLE, [], Options),
    {ok, #{tab => Tab}}.

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Request, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    io:format("INFOL:~w~n", [_Info]),
    {noreply, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

do_insert(#{tab := Tab} = State) ->
    RecordList = [db_tools_test_util:new_record() || _ <- lists:seq(1, 10)],
    ets:insert(Tab, RecordList),
    State#{keys => [Record#test_table.field_1 || Record <- RecordList]}.

do_insert_new(#{tab := Tab, keys := Keys} = State) ->
    Record = db_tools_test_util:new_record(),
    ets:insert_new(Tab, Record),
    State#{keys := [Record#test_table.field_1 | Keys]}.

do_insert_update(#{tab := Tab} = State) ->
    RecordList = [db_tools_test_util:rand_change(Record) || Record <- ets:tab2list(Tab)],
    ets:insert(Tab, RecordList),
    State.

do_update_counter(#{tab := Tab, keys := Keys} = State) ->
    [
        begin
            ets:update_counter(Tab, Key, {#test_table.field_2, 1})
        end || Key <- Keys
    ],
    State.

do_update_element(#{tab := Tab, keys := Keys} = State) ->
    [
        begin
            ets:update_element(Tab, Key, {#test_table.field_2, 1})
        end || Key <- Keys
    ],
    State.

do_select_replace(#{tab := Tab} = State) ->
    MS = ets:fun2ms(fun(Record) when Record#test_table.field_1 rem 3 =:= 0 -> Record#test_table{field_3 = <<>>} end),
    ets:select_replace(Tab, MS),
    State.

do_delete(#{tab := Tab, keys := [Key | T]} = State) ->
    ets:delete(Tab, Key),
    State#{keys := T}.

do_delete_object(#{tab := Tab, keys := [Key | T]} = State) ->
    [Record] = ets:lookup(Tab, Key),
    ets:delete_object(Tab, Record),
    State#{keys := T}.

do_select_delete(#{tab := Tab, keys := Keys} = State) ->
    MS = ets:fun2ms(fun(#test_table{field_1 = Field1}) when Field1 rem 2 =:= 0 -> true end),
    ets:select_delete(Tab, MS),
    State#{keys := [Key || Key <- Keys, Key rem 2 =/= 0]}.

do_take(#{tab := Tab, keys := [Key | T]} = State) ->
    [_Record] = ets:take(Tab, Key),
    State#{keys := T}.

do_delete_all_objects(#{tab := Tab} = State) ->
    ets:delete_all_objects(Tab),
    State#{keys := []}.

do_delete_table(#{tab := Tab} = State) ->
    ets:delete(Tab),
    State#{tab := Tab, keys := []}.
