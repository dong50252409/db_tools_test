%%%-------------------------------------------------------------------
%%% @author gz1417
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. 9月 2021 14:42
%%%-------------------------------------------------------------------
-module(db_tools_test_util).

%% API
-export([init_id_mgr/0, gen_id/0, rand/2]).

init_id_mgr() ->
    Ref = atomics:new(1, {signed, true}),
    persistent_term:put(id, Ref),
    ok.

gen_id() ->
    Ref = persistent_term:get(id),
    atomics:add_get(Ref, 1, 1).


rand(Min, Max) ->
    M = Min - 1,
    rand:uniform(Max - M) + M.
