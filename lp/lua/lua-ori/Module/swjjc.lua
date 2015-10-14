Delegate.RegInit("swjjc_Init");
Delegate.RegDelTalkEvent("swjjc_TalkEvent");


tbl_swjjc_goinfo = {};
tbl_win_user = {};			--��ǰ����ʤ����ҵ��б�
tbl_swjjc_begin = {};
tbl_swjjc_time ={};


tbl_swjjc_setting =
{
	zt = 0;
	first_round_user_max = 40; 	--��һ������ѡ��������
	this_user_WinFunc = nil;
	WinFunc = nil;				--��ǰ�����������ս��������Ļص�����
};

function swjjc_Init()
	inittable_swjjcStartNpc();
end

function inityddltable_swjjcStartNpc_Init(index)
	return 1;
end


function inittable_swjjcStartNpc()
	if (swjjcStartNpc == nil) then
		swjjcStartNpc = NL.CreateNpc("lua/Module/swjjc.lua", "inityddltable_swjjcStartNpc_Init");
		Char.SetData(swjjcStartNpc,%����_����%,231088);
		Char.SetData(swjjcStartNpc,%����_ԭ��%,231088);
		Char.SetData(swjjcStartNpc,%����_X%,47);
		Char.SetData(swjjcStartNpc,%����_Y%,49);
		Char.SetData(swjjcStartNpc,%����_��ͼ%,777);
		Char.SetData(swjjcStartNpc,%����_����%,4);
		Char.SetData(swjjcStartNpc,%����_ԭ��%,"����������Ա");
		NLG.UpChar(swjjcStartNpc);
		
		--��������Npc˵����ʱ��,����ChangePassMsg����
		Char.SetLoopEvent("lua/Module/swjjc.lua","swjjcStartNpcLoopEvent", swjjcStartNpc,10); 
	end
	 
end


function swjjcStartNpcLoopEvent(index)
	
	if(tbl_swjjc_begin["Loopbegin"] == true)then
		return;
	end
	tbl_swjjc_begin["Loopbegin"] = true;
	if(tbl_swjjc_begin["begin"]  == false)then
		tbl_swjjc_begin["Loopbegin"] = false;
		return;
	end

   
   for i,v in ipairs(tbl_win_user) do
      if(Char.GetData(v,%����_ս��״̬%) ~= 0)then
		tbl_swjjc_begin["Loopbegin"] = false;
        return;   
      end
   
   end
  
   tbl_swjjc_begin["begin"] = false;
   --local timec = os.time() - tbl_swjjc_time["time"];
   --if(timec <= 10)then
	--	NLG.SystemMessage(-1,"������������һ�غϼ�����ʼ��ʣ�� "..tostring(10 - timec).."�롣");
	--	tbl_swjjc_begin["Loopbegin"] = false;
	--	return;
   --end

   def_round_start(tbl_win_user,"wincallbackfunc");
   tbl_swjjc_begin["Loopbegin"] = false;
   return;
end




--test
function swjjc_TalkEvent(player,msg,color,range,size)
	
	
	if(msg=="[bm]") then
		tbl_swjjc_setting.zt = 1;
	end
	if(msg=="[start]") then 
		tbl_swjjc_setting.zt = 2;
		NLG.MapEffect(25290, 4, 0);

		local MapUser = NLG.GetMapPlayer(0,25290);
		
		for i,v in ipairs(MapUser)do
		--	NLG.SystemMessage(-1,Char.GetData(v,%����_����%));
		end
		--ȡ����ս�������������ˣ�������Ϊһ������
		tbl_swjjc_goinfo["round_count"] = 1;
		tbl_swjjc_goinfo["create_battle_count"] = 0;
		tbl_swjjc_goinfo["create_battle_count_bak"] = 0;
		
		setUser_WinFunc("user_WinFunc");
		tbl_swjjc_begin["begin"] = false;
		tbl_swjjc_begin["Loopbegin"] = false;
		--tbl_swjjc_time["time"] = os.time();
		def_round_start(MapUser,"wincallbackfunc");
		
	end
	
	if(msg=="[zt]") then 
		local MapUser = NLG.GetMapPlayer(0,25290);
		for i,v in ipairs(MapUser)do
		--	NLG.SystemMessage(-1,Char.GetData(v,%����_����%).." ս��״̬:"..Char.GetData(v,%����_ս��״̬%));
		end
	end
	
	if(msg=="[initnpc]") then 
		inittable_swjjcStartNpc();
	end
end



function wincallbackfunc(winuser)
	
	-- ���û�����ھ�
	
	--if(tonumber(#winuser) == 3)then
	--	NLG.SystemMessage(-1,"������������ǿ������������ʼ����ǿ����:");
	--	for i,v in ipairs(winuser)do
	--		NLG.SystemMessage(-1,Char.GetData(v,%����_����%));	
	--	end
	--	NLG.SystemMessage(-1,"=======================================");
	--end
	
	if(tonumber(#winuser) > 1)then
		
		
		for i,v in ipairs(winuser)do
			if(VaildChar(v) == false)then
				table.remove(winuser,i);
			end
		end
		
		
		--��������ʧ�ܵ���ң�����ѽ-----------------------------
		local MapUser = NLG.GetMapPlayer(0,25290);
		warpfailuser(MapUser,winuser,0,1000,93,102);
		-------------------------------------------------------
		--�����ֻؿ�
		tbl_win_user = {};
		tbl_win_user = winuser;
		tbl_swjjc_begin["begin"] = true;
		tbl_swjjc_begin["Loopbegin"] = false;
		--tbl_swjjc_time["time"] = os.time();
		--def_round_start(winuser,"wincallbackfunc");
		return;
	end
	
	-- ֱ��n���ֻع�������ʤ��һ�����
	if(tonumber(#winuser) <= 1)then
		
		--���ߵڶ�����ң�����ѽ-----------------------------
		local MapUser = NLG.GetMapPlayer(0,25290);
		warpfailuser(MapUser,winuser,0,1000,162,130);
		-----------------------------------------------------
		
		NLG.MapEffect(25290, 4, 2);
		for _,v in pairs(winuser) do
			
			Char.GiveItem(v,520090,1);
			NLG.SystemMessage(-1,"��ϲ���:"..Char.GetData(v,%����_����%).."��ñ��������������ھ���");
			Char.Warp(v,0,1000,162,130);
		end
		tbl_swjjc_setting.zt = 0;
	end
end

function user_WinFunc(player,mc)
	NLG.SystemMessage(player,"��ϲ����ʤ�������ĵȴ�������ҽ���ս����");

end


function setUser_WinFunc(winfuncname)
	tbl_swjjc_setting.this_user_WinFunc = winfuncname;
end


--	�������ܣ�����ʧ�ܵ����
function warpfailuser(MapUser,winuser,floor,mapid,x,y)
	
	local failuser = delfailuser(MapUser,winuser);
	for _,tuser in pairs(failuser) do
		Battle.ExitBattle(tuser);
		Char.Warp(tuser,floor,mapid,x,y);
		NLG.SystemMessage(tuser,"�����ˣ���л���룡");
	end
	
end


--	�������ܣ���ȡս��ʧ�ܵ����
function delfailuser(MapUser,winuser)
	for _,v in pairs(winuser)do
		for i,w in pairs(MapUser)do
			if(v == w)then
				MapUser[i] = nil;
			end
		end
	end
	
	return MapUser;
end


--	�������ܣ���������б�(δ���)
function tablereset(_table)
	return  _table;
end



--[[ def_round_start
	�������ܣ� ÿһ�غϵĿ�ʼ����һ�غϲ����Ʊ���������ǰfirst_round_user_max��ʤ���߽���������غϾ�����ս�������������
	������䵥�ߣ���ֱ�ӽ���
	����1)usertable:��ʾ������ҵ��б�
	    2)funcallback:������������ִ�еĻص�������������xǿ֮�󴥷�
	    **funtcion callback(
		 ����һ:table ��������
		)
]]
function def_round_start(usertable,callback)
	
	NLG.SystemMessage(-1,"���������� �ڣ�"..tbl_swjjc_goinfo["round_count"].."����ʼ��");
	-- Ŀǰս�������Լ�
	tbl_swjjc_goinfo["round_count"] = tbl_swjjc_goinfo["round_count"] + 1;

	-- �����������
	usertable = tablereset(usertable); 
	-- ����xǿ������Ļص�����
	tbl_swjjc_setting.WinFunc = callback;
	-- ��ʼΪ������ս��
	
	--NLG.SystemMessage(-1,"====�������====");
	--for i,v in ipairs(usertable)do
	--	NLG.SystemMessage(-1,Char.GetData(v,%����_����%));	
	--end
	
	--NLG.SystemMessage(-1,"================");
	
	
	local tbl_UpIndex = {};
	local tbl_DownIndex = {};
	-- �ֳ�������
	for i = 1,tonumber(#usertable),2 do
	--	NLG.SystemMessage(-1,"i:"..i);
		table.insert(tbl_UpIndex,usertable[i]);
		if(i + 1 > tonumber(#usertable))then
			table.insert(tbl_DownIndex,-1);
		else
			table.insert(tbl_DownIndex,usertable[i + 1]);
		end
	--	NLG.SystemMessage(-1,"xxxxx=======");
	--	NLG.SystemMessage(-1,Char.GetData(usertable[i],%����_����%));
	--	NLG.SystemMessage(-1,Char.GetData(usertable[i+1],%����_����%));
	end
	-- ���ʤ������б�	
	tbl_win_user = {};
	
	--��ʼս��
	for j = 1,tonumber(#tbl_UpIndex) + 1,1 do
		--���˫�������ߣ���ʲô��������ֱ������
		if(VaildChar(tbl_UpIndex[j]) == false and VaildChar(tbl_DownIndex[j]) == false)then
		   --do nothing		
		--����Ϸ��䵥��Ա��������ֱ�Ӹ����·���Ա����
		elseif(VaildChar(tbl_UpIndex[j]) == false)then
			table.insert(tbl_win_user,tbl_DownIndex[j]);
			NLG.SystemMessage(tbl_DownIndex[j],"���˺�����ԣ��㽫ֱ�ӽ�������ȴ�����ս��������");
		--����·��䵥��Ա��������ֱ�Ӹ����Ϸ���Ա����
		elseif(VaildChar(tbl_DownIndex[j]) == false)then
			table.insert(tbl_win_user,tbl_UpIndex[j]);
			NLG.SystemMessage(tbl_UpIndex[j],"���˺�����ԣ��㽫ֱ�ӽ�������ȴ�����ս��������");
		--��ս
		else
			--NLG.SystemMessage(-1,"pk:"..Char.GetData(tbl_UpIndex[j],%����_����%).." VS "..Char.GetData(tbl_DownIndex[j],%����_����%));
		
		
			local battleindex = Battle.PVP(tbl_UpIndex[j], tbl_DownIndex[j]);
			
		
			-- ��ǰ���δ���ս���ܼƴΣ������ж��Ƿ��Ѿ��ﵽ������׼
			tbl_swjjc_goinfo["create_battle_count"] = tbl_swjjc_goinfo["create_battle_count"] + 1;
			Battle.SetWinEvent("lua/Module/swjjccback.lua", "def_round_wincallback", battleindex);


		end
		
		
	end
	tbl_swjjc_goinfo["create_battle_count_bak"] = tbl_swjjc_goinfo["create_battle_count"];
end




