--  ***************************************************************************************************** --
--  code by http://www.Cgdev.me
--  ��ͼ��Mapʾ���ű�
--                   #������־#
--  TYPE ***** TIME ***** Editor ***** Text 
--  CREATE  2013/01/19     Free
--  ADD     2013/01/20     Free        ���Map��ĺ�������ʾ������ʾ��ȫ��ʹ��ȫ�ֵ�Talk�¼�����
--  FIX     2013/01/27     Free        �޸����ֺ���/�﷨����

--                   #��������#
--	����Lua��ͼ��MAPID�������޸�
local LUAMAPID = %��ͼ����_LUAMAP%;
--					 #ʹ��˵��#
--	����Ϸ����������������������ɴ���

--	copymap,��ͼ����,��ͼID						--> ����ָ����ͼ
--	mazemap,x���귶Χ,y���귶Χ,��ͼ��			--> ����ָ����С�����ͼ
--	delmap,��ͼID								--> ɾ��ָ��Lua��ͼ
--	getpos,��ͼID								--> ��ȡָ��Lua���ɵ������ͼ�е�������õ������
--	getimage									--> ��ȡ��ǰ��������ĵذ�ͼ���ź����ͼ����
--	setimage									--> ���õ�ǰ��������ĵذ�/���ͼ����
--	dumpmap,·��,��ͼID,д��ID					--> ��ָ��Lua��ͼ���ɳɵ�ͼ�ļ�������ָ��·����

--					 #ע������#
--	���������ͼʱ�򣬻���ͣ��Ϸ�б��������ͼ�����ɣ���������ͼ���ù��󣬿�����Ҫ�ܳ�ʱ��������ɺõ�ͼ�������в��ԡ�
--	makeMazeMap�����е��õ�Map.MakeMazeMap�ĸ���������������ĵ����в鿴��Ҳ������̳/QQȺ�н�������
--	�ýű���δ������ȫ�Ĳ��ԣ��������⣬���Բ�ϡ�档
--  ***************************************************************************************************** --

--ע���¼�ί��
Delegate.RegDelTalkEvent("MapProc_TalkEvent");

--	�������Ƶ�ͼ
--	��������	index: ��Ҷ���
--				c_mapid: Ҫ���Ƶĵ�ͼ��Map ID
--				c_floor: Ҫ���Ƶĵ�ͼ��Floor ID
function makeCopyMap(index, c_mapid, c_floor)
	local newFloorID = Map.MakeCopyMap(c_mapid, c_floor);
	if(newFloorID == -1)then
		NLG.SystemMessage(index, "��ͼ����ʧ�ܡ�");
	else
		NLG.SystemMessage(index, "��ͼ"..c_mapid..","..c_floor.."�Ѿ��ɹ����Ƶ�"..LUAMAPID..","..newFloorID);
		NLG.SystemMessage(index, "ʹ��GM����[warp "..LUAMAPID.." "..newFloorID.." x���� y����] �����ƶ���ȥ����Ŷ");
	end
	return;
end

--	���������ͼ
--	��������	index: ��Ҷ���
--				xsiz: Ҫ���ɵĵ�ͼ��x���귶Χ
--				ysiz: Ҫ���ɵĵ�ͼ��y���귶Χ
--				mapName: ��ͼ��
--	����˵����MakeMazeMap����Ҫ����ص������ģ���������Ϻ󣬻ᴥ������Ļص��������������ɵĵ�ͼ�Ƿ����
function makeMazeMap(index, xsiz, ysiz, mapName)
	local newFloorID = Map.MakeMazeMap(nil,"mazeMapDoneCall",xsiz,ysiz,mapName,2,30,30,30,30,30,9491,100,0,0,0,0,0,0);
	if(newFloorID == -1)then
		NLG.SystemMessage(index, "��ͼ����ʧ�ܡ�");
	else
		NLG.SystemMessage(index, "��ͼ"..LUAMAPID..","..newFloorID.."�Ѿ���ʼ������...���Ժ�");
	end
	return;
end

--	���������ͼ�Ļص�����
--	��������	floorID: ���ɵĵ�ͼ��Floor ID
--				doneflg: ���ɽ��
function mazeMapDoneCall(floorID, doneflg)
	if(doneflg == 1)then
		NLG.SystemMessage(-1,"���ɵ�ͼ"..LUAMAPID..","..floorID.."�ɹ���");
		NLG.SystemMessage(index, "����ͨ��ʹ��getpos,"..floorID.."����ȡһ���Ϸ��������");
	else
		NLG.SystemMessage(-1,"���ɵ�ͼ"..LUAMAPID..","..floorID.."ʧ�ܣ�");
	end
end

--	��ȡ�����ͼ���õ�����
--	��������	index: ��Ҷ���
--				floorID: �����ͼ��Floor ID
function getPosition(index, floorID)
	local mapx, mapy = Map.GetAvailablePos(floorID);
	if(mapx == 0 and mapy == 0)then
		NLG.SystemMessage(index,"��ȡ��ͼ��������ʧ�ܣ�������");
	else
		NLG.SystemMessage(index,"��ȡ��ͼ"..LUAMAPID..","..floorID.."��������"..mapx..","..mapy);
		NLG.SystemMessage(index, "ʹ��GM����[warp "..LUAMAPID.." "..floorID.." "..mapx.." "..mapy.."] �����ƶ���ȥ����Ŷ");
	end
	return;
end

--	��ȡ��ǰ�������ĵذ�ͼ�����������obj��ͼ����
--	��������	index: ��Ҷ���
function getTileandObj(index)
	local nowMap = Char.GetData(index, %����_MAP%);
	local nowFloor = Char.GetData(index, %����_��ͼ%);
	local nowXpos = Char.GetData(index, %����_X%);
	local nowYpos = Char.GetData(index, %����_Y%);
	local tile, obj = Map.GetImage(nowMap,nowFloor,nowXpos,nowYpos);
	NLG.SystemMessage(index,"��ȡ��ͼ"..nowMap..","..nowFloor..","..nowXpos..","..nowYpos.."�ĵ�ͼԪ��[�ذ�:"..tile.."],[���:"..obj.."]");
	return;
end

--	���õ�ǰ�������ĵذ�ͼ�����������obj��ͼ���ţ��������Զ��ж�ͼ�����ڵذ廹�����
--	��������	index: ��Ҷ���
--				image: ͼ����
function setTileandObj(index, image)
	local nowMap = Char.GetData(index, %����_MAP%);
	local nowFloor = Char.GetData(index, %����_��ͼ%);
	local nowXpos = Char.GetData(index, %����_X%);
	local nowYpos = Char.GetData(index, %����_Y%);
	local ori_tile, ori_obj = Map.GetImage(nowMap,nowFloor,nowXpos,nowYpos);
	Map.SetImage(nowMap,nowFloor,nowXpos,nowYpos, image);
	local now_tile, now_obj = Map.GetImage(nowMap,nowFloor,nowXpos,nowYpos);
	NLG.SystemMessage(index,"��ͼ"..nowMap..","..nowFloor..","..nowXpos..","..nowYpos.."�ĵ�ͼԪ�ر��[�ذ�:"..ori_tile.."->"..now_tile.."],[���:"..ori_obj.."->"..now_obj.."]");
	return;
end

--	�����ͼ�ļ�������·����
--	��������	index: ��Ҷ���
--				path: ����·�����������ļ������ļ�����"\"��β
--				floorID: Lua��ͼ�ĵ�ͼFloor��
--				writeAsFloor: д���ļ��ж���ĵ�ͼ���
function dumpMapFile(index, path, floorID, writeAsFloor)
	local ret = Map.DumpLuaMap(path, floorID, writeAsFloor);
	if (ret == 0) then
		NLG.SystemMessage(index,"��ͼ"..LUAMAPID..","..floorID.."������ļ�ʧ�ܣ�");
	else
		NLG.SystemMessage(index,"��ͼ"..LUAMAPID..","..floorID.."�Ѿ�������ļ�:["..path..LUAMAPID.."_"..floorID.."]");
	end
	return;
end

--	ɾ��Lua���ɵĵ�ͼ���ͷŵ�ͼ���
--	��������	floorID: Lua��ͼ�ĵ�ͼFloor���
function deleteLuaMap(index, floorID)
	local ret = Map.DelLuaMap(floorID);
	if (ret == 0) then
		NLG.SystemMessage(index,"��ͼ"..LUAMAPID..","..floorID.."ɾ��ʧ�ܣ�");
	else
		NLG.SystemMessage(index,"��ͼ"..LUAMAPID..","..floorID.."�Ѿ��ɹ�ɾ����");
	end
	return;
end

--	NL.AllTaklEventCallBack��ί�е���
--	��������	http://lua.cgdev.me/doku.php?id=lua:nl:callback:talkcallback
function MapProc_TalkEvent(index, msg, col, range, size)
	if(string.find(msg,","))then
		local token = Split(msg,",")
	end
	if(string.find(msg,"copymap"))then
		local m = tonumber(token[2]);
		local f = tonumber(token[3]);
		makeCopyMap(index, m ,f);
		return 1;
	end
	if(string.find(msg,"mazemap"))then
		local xsiz = tonumber(token[2]);
		local ysiz = tonumber(token[3]);
		local MapName = token[4];
		makeMazeMap(index, xsiz, ysiz, MapName);
		return 1;
	end
	if(string.find(msg,"delmap"))then
		local f = tonumber(token[2]);
		deleteLuaMap(index, f);
		return 1;
	end
	if(string.find(msg,"getpos"))then
		local f = tonumber(token[2]);
		getPosition(index, f);
		return 1;
	end
	if(msg=="getimage")then
		getTileandObj(index);
		return 1;
	end
	if(string.find(msg,"setimage"))then
		image = tonumber(token[2]);
		setTileandObj(index, image);
		return 1;
	end
	if(string.find(msg,"dumpmap"))then
		path = token[2];
		floorID = tonumber(token[3]);
		writeAsFloor = tonumber(token[4]);
		dumpMapFile(index, path, floorID, writeAsFloor);
		return 1;
	end
end
