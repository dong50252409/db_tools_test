#!/bash/bin

chmod + X ./db_tools
rm -fr ../apps/db_tools_test/src/model/*
rm -fr ../apps/db_tools_test/include/*

./db_tools --verbose -f ../apps/db_tools_test/priv/db.config -m gen_model --out_hrl ../apps/db_tools_test/include/ --out_erl ../apps/db_tools_test/src/model/
