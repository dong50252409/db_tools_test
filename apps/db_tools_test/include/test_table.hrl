%%%----------------------------------------------------
%%% AUTOMATIC GENERATION PLEASE DO NOT MODIFY
%%% 自动生成，请勿修改
%%% 测试表1
%%%----------------------------------------------------
-ifndef(TEST_TABLE_HRL).
-define(TEST_TABLE_HRL, true).

-define(TEST_TABLE, test_table).

-export_type([test_table/0]).

-type test_table() :: #{
        field_1 := integer(),                               % 字段1
        field_2 := integer(),                               % 字段2
        field_3 := unicode:chardata(),                      % 字段3
        field_4 := integer(),                               % 字段4
        field_5 := jsx:json_term(),                         % 字段5
        field_6 := unicode:chardata(),                      % 字段6
        field_7 := binary(),                                % 字段6
        ext_field_1 := integer(),                           % 扩展字段1
        ext_field_2 := list(),                              % 扩展字段2
        ext_field_3 := tuple(),                             % 扩展字段3
        ext_field_4 := binary()                             % 扩展字段4
}.

-record(test_table, {
        field_1 :: integer(),                               % 字段1
        field_2 :: integer(),                               % 字段2
        field_3 = [] :: unicode:chardata(),                 % 字段3
        field_4 = 0 :: integer(),                           % 字段4
        field_5 :: jsx:json_term(),                         % 字段5
        field_6 :: unicode:chardata(),                      % 字段6
        field_7 :: binary(),                                % 字段6
        ext_field_1 = 0 :: integer(),                       % 扩展字段1
        ext_field_2 = [] :: list(),                         % 扩展字段2
        ext_field_3 = {} :: tuple(),                        % 扩展字段3
        ext_field_4 = <<>> :: binary()                      % 扩展字段4
}).

-endif.

