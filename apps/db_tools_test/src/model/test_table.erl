%%%----------------------------------------------------
%%% AUTOMATIC GENERATION PLEASE DO NOT MODIFY
%%% 自动生成，请勿修改
%%% 测试表1
%%%----------------------------------------------------
-module(test_table).

-include("test_table.hrl").

-compile(export_all).

-spec get_table_name() -> atom().
get_table_name() -> 
    test_table.

-spec new_map() -> test_table().
new_map() -> 
    #{
        field_1 => undefined,                                   % 字段1
        field_2 => undefined,                                   % 字段2
        field_3 => [],                                          % 字段3
        field_4 => 0,                                           % 字段4
        field_5 => undefined,                                   % 字段5
        field_6 => undefined,                                   % 字段6
        field_7 => undefined,                                   % 字段6
        ext_field_1 => 0,                                       % 扩展字段1
        ext_field_2 => [],                                      % 扩展字段2
        ext_field_3 => {},                                      % 扩展字段3
        ext_field_4 => <<>>                                     % 扩展字段4
    }.

-spec new_record() -> #test_table{}.
new_record() -> 
    #test_table{
        field_1 = undefined,                                    % 字段1
        field_2 = undefined,                                    % 字段2
        field_3 = [],                                           % 字段3
        field_4 = 0,                                            % 字段4
        field_5 = undefined,                                    % 字段5
        field_6 = undefined,                                    % 字段6
        field_7 = undefined,                                    % 字段6
        ext_field_1 = 0,                                        % 扩展字段1
        ext_field_2 = [],                                       % 扩展字段2
        ext_field_3 = {},                                       % 扩展字段3
        ext_field_4 = <<>>                                      % 扩展字段4
    }.

-spec as_map(list()) -> test_table().
as_map([V1, V2, V3, V4, V5, V6, V7]) ->
    Map = new_map(),
    Map#{
        field_1 := V1, field_2 := V2, field_3 := V3, field_4 := V4, field_5 := db_util:json_to_term(V5),
        field_6 := db_util:string_to_term(V6), field_7 := db_util:string_to_term(V7)
    }.

-spec as_record(list()) -> #test_table{}.
as_record([V1, V2, V3, V4, V5, V6, V7]) ->
    Record = new_record(),
    Record#test_table{
        field_1 = V1, field_2 = V2, field_3 = V3, field_4 = V4, field_5 = db_util:json_to_term(V5),
        field_6 = db_util:string_to_term(V6), field_7 = db_util:string_to_term(V7)
    }.

-spec get_table_field_list() -> list().
get_table_field_list() ->
    [field_1, field_2, field_3, field_4, field_5, field_6, field_7].

-spec get_table_key_field_list() -> list().
get_table_key_field_list() ->
    [field_1].

-spec get_table_key_values(test_table()|#test_table{}) -> list().
get_table_key_values(#{field_1 := V1}) ->
    [V1];

get_table_key_values(#test_table{field_1 = V1}) ->
    [V1].

-spec get_table_values(test_table()|#test_table{}) -> list().
get_table_values(#{field_1 := V1, field_2 := V2, field_3 := V3,
    field_4 := V4, field_5 := V5, field_6 := V6, field_7 := V7}) ->
    [V1, V2, V3, V4, db_util:term_to_json(V5), db_util:term_to_string(V6),
        db_util:term_to_string(V7)];

get_table_values(#test_table{field_1 = V1, field_2 = V2, field_3 = V3,
    field_4 = V4, field_5 = V5, field_6 = V6, field_7 = V7}) -> 
    [V1, V2, V3, V4, db_util:term_to_json(V5), db_util:term_to_string(V6),
        db_util:term_to_string(V7)].

