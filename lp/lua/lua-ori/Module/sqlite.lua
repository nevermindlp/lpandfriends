--  ***************************************************************************************************** --
--  code by http://www.Cgdev.me
--  SQLiteģ��
--                   #������־#
--  TYPE ***** TIME ***** Editor ***** Text 
--  CREATE  2013/07/21     Free
--  ADD     2013/07/22     Free        ����SQLite Object

--                   #��������#
sql = require "lua.lib.ljsqlite3._ljsqlite3"
conn = sql.open("lua/store/store.db")

--[[

������Module��ֱ�ӵ���conn�Ϳ��Զ�sqlite���и��ֲ�ѯ
��������ʹ����ljsqlite3�ĵ���������ж�sqlite��mapping������ljsqlite3�ṩ��API����ص���������ƥ����ο�
http://scilua.org/ljsqlite3.html

]]--

function CloseSQLiteConn()
	conn:close()
end
