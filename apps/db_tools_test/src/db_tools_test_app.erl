%%%-------------------------------------------------------------------
%% @doc db_tools_test public API
%% @end
%%%-------------------------------------------------------------------

-module(db_tools_test_app).

-behaviour(application).

-export([start/2, stop/1]).
-export([init_start/0]).

start(_StartType, _StartArgs) ->
    db_tools_test_util:init_id_mgr(),
    db_tools_test_sup:start_link().

stop(_State) ->
    ok.

init_start() ->
    application:ensure_all_started(db),
    application:ensure_all_started(db_tools_test).

%% internal functions
