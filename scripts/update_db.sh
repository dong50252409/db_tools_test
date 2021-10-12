#!/bin/bash

chmod + X ./db_tools
./db_tools --verbose -f ../apps/db_tools_test/priv/db.config -m update_db --character utf8 -h 127.0.0.1 -u test -p passwd -d test_db
