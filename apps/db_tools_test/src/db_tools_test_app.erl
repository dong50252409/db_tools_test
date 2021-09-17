%%%-------------------------------------------------------------------
%% @doc db_tools_test public API
%% @end
%%%-------------------------------------------------------------------

-module(db_tools_test_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    db_tools_test_util:init_id_mgr(),
    db_tools_test_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
