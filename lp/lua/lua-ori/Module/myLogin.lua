--  ***************************************************************************************************** --
--  code by http://www.Cgdev.me
--  �Զ����¼ģ��
--                   #������־#
--  TYPE ***** TIME ***** Editor ***** Text 
--  CREATE  2013/01/16     blue
--  ADD     2013/01/16     blue        �ṩ��¼��ӭ�ʺ�ԭ�ص�¼���ܣ�ԭ�ص�¼�����趨��
--									   select1:����ڳ����ͼ���ܹ�ֱ��ԭ�ص�¼��ʣ������� 1
--									   select2:������Թ���ͼ���Թ�δ���飬�ܹ�ֱ��ԭ�ص�¼��ʣ������� 1
--									   select3:����ڳ����ͼ���Թ������ˣ��ص��Թ���ڵ㣬ʣ������� 1
--  UPD     2013/01/26     blue        108������ tbl_dropinfo[_playerkey].time = os.time(); 207�� --inittable_cleanNpc();


--                   #��������#


local In_situ_login_on_off = "on" ; --�Ƿ񿪷�ԭ�ص�¼ on--����  off--������
local In_situ_login_Count = 2; --Ĭ�ϵ�ԭ�ص�¼��������npc��ȡ����
local In_situ_login_TimeOut =3600; --ԭ�ص�¼��ʱʱ�䣬��λΪ��
local In_situ_login_Limit = false; --�Ƿ񿪷����޴�ԭ�ص�¼
local Is_use_Field = false; --�Ƿ�ʹ��field�⣨δ��ɣ�

local NPCName = "ԭ�ص�¼��ȡԱ"; --������ȡԭ�ص�¼��NPC����
local NPCPoint = {14633,1000,242,104,6}; --ԭ�ص�¼��ȡԱ��ԭ�ͣ���ͼ��X���꣬Y���꣬����
--  ***************************************************************************************************** --



--ע���¼�ί��
Delegate.RegDelLoginEvent("MyLogin_LoginEvent");
Delegate.RegDelAllOutEvent("MyLogin_OutEvent");
Delegate.RegDelWarpEvent("MyLogin_WarpEvent");
Delegate.RegInit("MyLogin_Init");


--�洢������Ϣ
tbl_dropinfo = {};

tbl_In_situsetting =
{
    defcount = In_situ_login_Count;
    timeout = In_situ_login_TimeOut; 
    limit = In_situ_login_Limit; 
};

function new_tbl_dropinfoobject(player) 
	
	local lef = 0;
	if(tbl_dropinfo[Playerkey(player)] ~= nil)then
		lef = tbl_dropinfo[Playerkey(player)].leftCount;
	end
	
	
	local _tbl_dropinfo =
	{
		leftCount = lef;
		LoginCount = Char.GetData(player,%����_��½����%);
		
		MapType = Char.GetData(player,%����_MAP%);  
		MapId = Char.GetData(player,%����_��ͼ%);	
		X = Char.GetData(player,%����_X%);
		Y = Char.GetData(player,%����_Y%);
		
		DengonMapId = 0;
		DengonName = "";
		DengonX = 0;
		DengonY = 0;
		time = os.time();
	};
	return _tbl_dropinfo;
end

function new_tbl_dropinfoobject_without_setting(player)
	

	
	local _tbl_dropinfo =
	{
		leftCount = 0;
		LoginCount = Char.GetData(player,%����_��½����%);
		
		MapType = tbl_dropinfo[Playerkey(player)].MapType;        
		MapId = tbl_dropinfo[Playerkey(player)].MapId;	
		X = tbl_dropinfo[Playerkey(player)].X;
		Y = tbl_dropinfo[Playerkey(player)].Y;
		
		DengonMapId = 0;
		DengonName = "";
		DengonX = 0;
		DengonY = 0;
		time = os.time();
	};
	return _tbl_dropinfo;
end

function MyLogin_LoginEvent(player)
	

	if(Char.GetData(player,%����_��½����%) == 999)then
		Char.SetData(player, %����_��½����% , 1);
	end
	

	local suss_link = false; --�Ƿ�ɹ�ԭ�ص�¼
	local suss_Message = "";
	local _playerkey = Playerkey(player);
	local Drop_list;
	if(tbl_dropinfo[_playerkey] ~= nil ) then
		Drop_list = tbl_dropinfo[_playerkey]; --��ȡ����ǰ����Ϣ
		tbl_dropinfo[_playerkey].time = os.time();
	else
		local PlayerInfo = new_tbl_dropinfoobject(player);  --������״ε�¼�����Ŀǰ�����Ϣ��ֱ�ӷ���
		tbl_dropinfo[_playerkey] = PlayerInfo;
		return;
	end
	
	if(tbl_In_situsetting.limit == true) then --����������޴�ԭ�ص�¼
		suss_Message = "Ŀǰ�������������޴�ԭ�ص�¼�����������Ѿ��ָ���";
		suss_link = true;
	end
	
	
	if (os.time() - Drop_list.time <= tonumber(tbl_In_situsetting.timeout) and tonumber(Char.GetData(player,%����_��½����%)) - Drop_list.LoginCount <= 1 and Drop_list.leftCount > 0)then --�Ƿ�ʱ���Ƿ񻻹��ߣ�ԭ�ص�¼�����Ƿ����
	    tbl_dropinfo[_playerkey].leftCount = tbl_dropinfo[_playerkey].leftCount - 1; --����һ��
		--print("in is"..tbl_dropinfo[_playerkey].leftCount);
		suss_link = true;
	end
	
	--NLG.SystemMessage(player,(os.time() - Drop_list.time).." "..tbl_In_situsetting.timeout.." "..tonumber(Char.GetData(player,%����_��½����%)) - Drop_list.LoginCount.." "..Drop_list.leftCount);
	if(Drop_list.MapType ~= 0) then --��������Թ��ڵ���
		local Walkable = NLG.Walkable(1,Drop_list.DengonMapId,Drop_list.DengonX,Drop_list.DengonY);
		if (NLG.GetMapName(1,Drop_list.DengonMapId) == Drop_list.DengonName and Walkable == 1) then --����Թ���δ��ʧ�����ͻ��Թ�
			Drop_list.MapType = 1;
			Drop_list.MapId = Drop_list.DengonMapId;
			Drop_list.X = Drop_list.DengonX;
			Drop_list.Y = Drop_list.DengonY;
			
			suss_Message = "�Թ���δ��ʧ�����������Ѿ��ָ���";
		else --���ͻ��Թ���
			Drop_list.MapType = 0;
			suss_Message = "�Թ���ʧ�ˣ������͵��Թ���ڣ�";
		end
	
	else --����ڳ����ͼ�ڵ��߻��ߵǳ�
			suss_Message = "���������Ѿ��ָ���";
	end
	suss_Message = suss_Message.."ԭ�ص�¼����ʣ��:"..tbl_dropinfo[_playerkey].leftCount.."�Ρ�";
	if(In_situ_login_on_off == "on" and suss_link == true ) then
		--NLG.SystemMessage(player,Drop_list.MapType.." "..Drop_list.MapId.." "..Drop_list.X.." "..Drop_list.Y.." "..Drop_list.DengonName);
		Char.Warp(player,Drop_list.MapType,Drop_list.MapId,Drop_list.X,Drop_list.Y);
		NLG.SystemMessage(player,suss_Message);
	end
	--NLG.SystemMessage(player,Drop_list.MapType.." "..Drop_list.MapId.." "..Drop_list.X.." "..Drop_list.Y.." "..Drop_list.DengonName);
end



function MyLogin_OutEvent(player)
	
	local Playerinfo = new_tbl_dropinfoobject(player);
	if(Playerinfo.MapType == 0) then  --��������Թ��ڣ��򱣴泣���ͼ��Ϣ��
		Playerinfo.leftCount = tonumber(tbl_dropinfo[Playerkey(player)].leftCount); --���浱ǰԭ�ص�¼����
		--print("key is "..Playerkey(player));
		--print("value is "..tbl_dropinfo[Playerkey(player)].leftCount);		
		tbl_dropinfo[Playerkey(player)] = Playerinfo; 
		return;
	end
	
	
	if(Playerinfo.MapType == 1) then --������Թ��ڣ��򱣴��Թ�����Ϣ
		local dropinfo = new_tbl_dropinfoobject_without_setting(player); 
		local MapName = NLG.GetMapName(1,Playerinfo.MapId); --��ȡ�Թ����֣�����Թ���ʧ��ص��Թ���
		dropinfo.MapType = 1;
		dropinfo.DengonMapId = Playerinfo.MapId;
		dropinfo.DengonName = MapName;
		dropinfo.DengonX = Playerinfo.X;
		dropinfo.DengonY = Playerinfo.Y;
		dropinfo.leftCount = tonumber(tbl_dropinfo[Playerkey(player)].leftCount); --���浱ǰԭ�ص�¼����
		tbl_dropinfo[Playerkey(player)] = dropinfo; 
		
	end
	
	
	
	
end


function MyLogin_WarpEvent(player)
	--[[
	local dropinfo = new_tbl_dropinfoobject(player);  
	if(dropinfo.MapType == 0) then 
		dropinfo.leftCount = tonumber(tbl_dropinfo[Playerkey(player)].leftCount); 
		tbl_dropinfo[Playerkey(player)] = dropinfo; 
		
	end--]]
	local partyNum = Char.PartyNum(player); --�������ж�Ա�����Թ�ǰ��λ����Ϣ
		for i=0,partyNum do
			local this_player = Char.GetPartyMember(player,i);
			if(VaildChar(this_player))then
			   local dropinfo = new_tbl_dropinfoobject(this_player);  
				if(dropinfo.MapType == 0) then 
					tbl_dropinfo[Playerkey(this_player)] = dropinfo; 
					--NLG.SystemMessage(this_player,dropinfo.X);
				end
			end
		end
	
end


function inityddlNpc_Init(index)
	print("ԭ�ص�¼npc_index = " .. index);
	return 1;
end

function inityddlNpc()
	if (yddlnpc == nil) then
		yddlnpc = NL.CreateNpc("lua/Module/myLogin.lua", "inityddlNpc_Init");
		Char.SetData(yddlnpc,%����_����%,NPCPoint[1]);
		Char.SetData(yddlnpc,%����_ԭ��%,NPCPoint[1]);
		Char.SetData(yddlnpc,%����_X%,NPCPoint[3]);
		Char.SetData(yddlnpc,%����_Y%,NPCPoint[4]);
		Char.SetData(yddlnpc,%����_��ͼ%,NPCPoint[2]);
		Char.SetData(yddlnpc,%����_����%,NPCPoint[5]);
		Char.SetData(yddlnpc,%����_ԭ��%,NPCName);
		NLG.UpChar(yddlnpc);
		
		--��������Npc˵����ʱ��,����ChangePassMsg����
		Char.SetTalkedEvent("lua/Module/myLogin.lua","yddlnpcMsg", yddlnpc);
	end
end

function yddlnpcMsg(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		str_ChangeWindow = "\\n\\n ���ߣ�����ԭ�صǳ�����������Ϊ"..tbl_In_situsetting.defcount.."�Σ�\\n\\n �ǳ�����30���ӽ����ؼ�¼�㡣";
	    tbl_dropinfo[Playerkey(_tome)].leftCount = tbl_In_situsetting.defcount; 
		NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_�ر�%,1,str_ChangeWindow);
		return;
	end
end

function inityddltable_cleanNpc_Init(index)
	print("ԭ�ص�¼�ڴ����Աnpc_index = " .. index);
	return 1;
end

function inittable_cleanNpc()
	if (table_cleanNpc == nil) then
		table_cleanNpc = NL.CreateNpc("lua/Module/myLogin.lua", "inityddltable_cleanNpc_Init");
		Char.SetData(table_cleanNpc,%����_����%,231088);
		Char.SetData(table_cleanNpc,%����_ԭ��%,231088);
		Char.SetData(table_cleanNpc,%����_X%,47);
		Char.SetData(table_cleanNpc,%����_Y%,47);
		Char.SetData(table_cleanNpc,%����_��ͼ%,777);
		Char.SetData(table_cleanNpc,%����_����%,4);
		Char.SetData(table_cleanNpc,%����_ԭ��%,"�ڴ����Ա");
		NLG.UpChar(table_cleanNpc);
		
		--��������Npc˵����ʱ��,����ChangePassMsg����
		Char.SetLoopEvent("lua/Module/myLogin.lua","table_cleanNpcLoopEvent", table_cleanNpc,1800); --30����ִ��һ��table����
	end
end

function table_cleanNpcLoopEvent(index)
   
   --ԭ�ص�¼table�������
   --���ͣ������ʱ����ôֱ���������ش����drop��Ϣ��
   
   for i,v in pairs(tbl_dropinfo) do
      if(os.time() - v.time > tbl_In_situsetting.timeout )then
         tbl_dropinfo[i] = nil;
      
      end
   
   end
   
   --����
  
  
end



function MyLogin_Init()
	
	inityddlNpc();
	--inittable_cleanNpc();

end
