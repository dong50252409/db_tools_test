%%%-------------------------------------------------------------------
%%% @author gz1417
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 30. 9月 2021 9:51
%%%-------------------------------------------------------------------
-module(db_ets_reg_list).
-include("test_table.hrl").

%% API
-export([reg_list/0]).

reg_list() ->
    ModeName = test_table,
    Conditions = [],
    Options = [{mode, auto}, {flush_interval, 5000}],
    [
        {test_table, test_db, ModeName, Conditions, Options}
    ].
