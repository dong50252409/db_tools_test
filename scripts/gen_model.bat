@echo off

del /S/Q ..\apps\db_tools_test\src\model\*
del /S/Q ..\apps\db_tools_test\include\*

.\db_tools --verbose -f ..\apps\db_tools_test\priv\db.config -m gen_model --out_hrl ..\apps\db_tools_test\include\ --out_erl ..\apps\db_tools_test\src\model\

pause