db_tools_test
=====

测试 [`db`](https://github.com/dong50252409/db) [`db_tools`](https://github.com/dong50252409/db_tools)

1. 修改`config/sys.config`中的数据库信息
2. 创建数据库，数据库格式 `apps/db_tools_test/priv/db.config`，或调用（windows）`scripts/update_db.bat`、（linux）`scripts/update_db.sh`，需要修改脚本中数据库相关信息
3. 生成数据库model文件，调用（windows）`scripts/gen_model.bat` （linux）`scripts/gen_model.sh` 

Build & Run
-----

    $ rebar3 release
    
    _build/default/rel/db_tools_test/bin/db_tools_test.cmd console

    % 或

    _build/default/rel/db_tools_test/bin/db_tools_test.sh console


APIs
----
    测试db_ets模块
    test_db_ets:test/0
    
    测试db_state模块
    test_db_state:test/0
