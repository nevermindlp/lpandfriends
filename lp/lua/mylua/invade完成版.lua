--[[
�����������
1������NPCÿ��8�㴥��(ָ��ְҵ����)
2������20��npc ��2bos��6�С�12С��
3������NPC�Ի���
4������ս�����ñ��
5������ս�����ñ�ǣ���ʤ��
6���������У����������ַ�����
7����ʱ�峡
]]--

Delegate.RegInit("invade_init");

local minEnterLv = 20;
local preShowProfessionInfoTime = 1*60;
local wholLeaderInfo = {};
local professionId;
local professionName;
local canEnterFlag = false;
local minProLv = 0;
local playerAndBoss = playerAndBoss or {};

local boSet = {aa = {d = true, c = false}, bb = {d = true, c = false}};

local bossSet ={
��˵�������� = {deadFlag = false , canBattleFlag = true , info = "3|0,20003,43,7||0|||||0|10007|||||||||"} ,
��˵��������1 = {deadFlag = false , canBattleFlag = true , info = "3|0,20003,43,7||0|||||0|10007|||||||||"} ,
��Ӣ������1�� = {deadFlag = false , canBattleFlag = true , info = "3|0,20003,43,7||0|||||0|10007|||||||||"} ,
��Ӣ������2�� = {deadFlag = false , canBattleFlag = true , info = '3|0,20003,43,7||0|||||0|10007|||||||||'} ,
������1�� = {deadFlag = false , canBattleFlag = true , info = '3|0,20003,43,7||0|||||0|10007|||||||||'} ,
������2�� = {deadFlag = false , canBattleFlag = true , info = '3|0,20003,43,7||0|||||0|10007|||||||||'}};

--����ʱ������
local invadeBeginWeekday = "1";
local invadeBeginTimeH = "23";
local invadeBeginTimeM = "01";
local invadeBeginTimeS = "00";
local invadeBattleLastTime  = 2*60;

function Entry (b)
	local temp = {id = b.id,name = b.name};
	table.insert(wholLeaderInfo,temp);
end
dofile("/gmsv/lua/Module/invadeData.lua")

function invade_init()
	createInvadeGateNPC();
	createInvadeBoss1();
	createInvadeBoss2();
	--createInvadeBoss2();
	--createInvadeMiddle1();
	--createInvadeSmall1();
end

function InvadeNPCCharInit(_myIndex)
  return true;
end

function createInvadeGateNPC()
	if invadeGateNPC == nil then
		invadeGateNPC = NL.CreateNpc(nil,"InvadeNPCCharInit");
		Char.SetData(invadeGateNPC,%����_����%,100500);
		Char.SetData(invadeGateNPC,%����_ԭ��%,100500);
		Char.SetData(invadeGateNPC,%����_��ͼ%,778);
		Char.SetData(invadeGateNPC,%����_X%,1);
		Char.SetData(invadeGateNPC,%����_Y%,5);
		Char.SetData(invadeGateNPC,%����_����%,4);
		Char.SetData(invadeGateNPC,%����_ԭ��%,"������������");
		Char.SetWindowTalkedEvent("lua/Module/invade.lua","invadeGateNPCWindowTalk",invadeGateNPC);
		Char.SetTalkedEvent("lua/Module/invade.lua","invadeGateNPCTalk",invadeGateNPC);
		Char.SetLoopEvent("lua/Module/invade.lua","invadeTimeNPCLoop",invadeGateNPC,1000);
		NLG.UpChar(invadeGateNPC);
	end
end

function invadeTimeNPCLoop(_MePtr)
--ѭ������Ҫ��1���ж���ҿ��Խ����ʱ�䡣2���жϴ������ʱ�䡣3����ǰ5������ʾ��Ҫ��ӵ�ְҵ
	if os.date("%w",os.time()) == invadeBeginWeekday then

		local currentYear = os.date("%Y");
		local currentMonth = os.date("%m");
		local currentDay = os.date("%d");
		local targetInvadeBeginTime = os.time({
		year = currentYear,
		month = currentMonth,
		day = currentDay,
		hour = invadeBeginTimeH,
		min = invadeBeginTimeM,
		sec = invadeBeginTimeS
		});
		print("time = " .. targetInvadeBeginTime - os.time());
		--5������ʾ����������������ְҵ
		if targetInvadeBeginTime - os.time() == preShowProfessionInfoTime then
			math.randomseed(tostring(os.time()));
			local randomNum = math.random(#wholLeaderInfo);
			print("professionId " .. randomNum );
			professionId = wholLeaderInfo[randomNum]["id"];
			professionName = wholLeaderInfo[randomNum]["name"];
			NLG.SystemMessage(-1,"����������Ҫ�����ְҵΪ��" .. professionName);
		end
	--�жϽ�����ʶ
		if os.time() - targetInvadeBeginTime < invadeBattleLastTime  and os.time() - targetInvadeBeginTime > 0 then
			canEnterFlag = true;
		end
	--������
		if os.time() - targetInvadeBeginTime == invadeBattleLastTime then
			local players = NLG.GetMapPlayer(0,60006);
			for k,v in pairs(players) do
				--����������Ƴ���Ӫսս��
				Char.Warp(player,0,778,0,0);
			end
			canEnterFlag = false;
			NLG.SystemMessage(-1,"��������ս��������" );
		end
	end

end

function invadeGateNPCTalk(_me,_tome)
	if canEnterFlag then
		local msg = "��������ս�����ְҵΪ����" .. professionName .. "��!���Ѿ�����׼����ô����";
		NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_ȷ��%+%��ť_��%,820,msg);
	else
		local msg = "ʱ��δ������"
		NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_�ر�%,830,msg);
	end
end

function invadeGateNPCWindowTalk(npc,player,Seqno,Select,Data)
	print(Char.GetData(player,%����_ְҵ%));
	print(Char.GetData(player,%����_ְ��%));
	print(Char.GetData(player,%����_ְ��ID%));
	if Select == 8 then
		return;
	end
	if Select ~= 2 then
		if Seqno ~= 820 then
			return;
		end
		local playerLv = Char.GetData(player,%����_�ȼ�%);
		if playerLv < minEnterLv then
			NLG.TalkToCli(player,-1,"�����������͵ȼ�Ҫ����" .. minEnterLv .. "��", %��ɫ_��ɫ%);
		else
			--�����Ҵ�����ָ����ͼ
			local playerStatus = Char.GetPartyMode(player);
			if(playerStatus == 0) then
			--0����һ�ˡ�1�ӳ�ֻ��������״̬���Դ���
				local tmpprofession = Char.GetData(player,%����_ְ��ID%);
				local tempproLv = Char.GetData(player,%����_ְ��%);

				if tmpprofession == professionId and tempproLv >minProLv  then
					--�������NPC��Ӧ
					playerAndBoss[player] = Char.GetData(npc,%����_ԭ��%);
					Char.Warp(player,0,60006,15,38);
				else
					NLG.TalkToCli(player,-1,"����������������ְҵ�ǣ�" .. professionName .. "��ֻ�зǼ�ϰְ�ײ��л������Ŀ��ܡ�����ֻ��Ҫ��ƽ�������ڿ�����ս���Ѿ�������Ψһ��ѡ���ˡ�", %��ɫ_��ɫ%);
				end
			elseif(playerStatus == 1) then
				local tmpprofession = Char.GetData(player,%����_ְҵ%);
				if tmpprofession == professionName then
					local partyNum = Char.PartyNum(player);
					for i=1,partyNum do
						local p = Char.GetPartyMember(player,i);
						Char.Warp(p,0,60006,15,38);
					end
				else
					NLG.TalkToCli(player,-1,"����������������ְҵ�ǣ�" .. professionName .. "��ֻ�зǼ�ϰְ�ײ��л������Ŀ��ܡ�����ֻ��Ҫ��ƽ�������ڿ�����ս���Ѿ�������Ψһ��ѡ���ˡ�", %��ɫ_��ɫ%);
				end
			else
				NLG.TalkToCli(player,-1,"�������ϴ����˵����",%��ɫ_��ɫ%);
			end
		end
	end
end


----------------��������NPC-----------------
function createInvadeBoss1()
	if invadeBossNPC1 == nil then
		invadeBossNPC1 = NL.CreateNpc(nil,"InvadeNPCCharInit");
		Char.SetData(invadeBossNPC1,%����_����%,105000);
		Char.SetData(invadeBossNPC1,%����_ԭ��%,105000);
		Char.SetData(invadeBossNPC1,%����_��ͼ%,778);
		Char.SetData(invadeBossNPC1,%����_X%,3);
		Char.SetData(invadeBossNPC1,%����_Y%,5);
		Char.SetData(invadeBossNPC1,%����_����%,4);
		Char.SetData(invadeBossNPC1,%����_ԭ��%,"��˵��������");
		Char.SetWindowTalkedEvent("lua/Module/invade..lua","invadeBossNPCWindowTalk",invadeBossNPC1);
		Char.SetTalkedEvent("lua/Module/invade..lua","invadeBossNPCTalk",invadeBossNPC1);
		NLG.UpChar(invadeBossNPC1);
	end
end

function createInvadeBoss2()
	if invadeBossNPC2 == nil then
		invadeBossNPC2 = NL.CreateNpc(nil,"InvadeNPCCharInit");
		Char.SetData(invadeBossNPC2,%����_����%,105000);
		Char.SetData(invadeBossNPC2,%����_ԭ��%,105000);
		Char.SetData(invadeBossNPC2,%����_��ͼ%,778);
		Char.SetData(invadeBossNPC2,%����_X%,3);
		Char.SetData(invadeBossNPC2,%����_Y%,5);
		Char.SetData(invadeBossNPC2,%����_����%,4);
		Char.SetData(invadeBossNPC2,%����_ԭ��%,"��˵��������2");
		Char.SetWindowTalkedEvent("lua/Module/invade..lua","invadeBossNPCWindowTalk",invadeBossNPC2);
		Char.SetTalkedEvent("lua/Module/invade..lua","invadeBossNPCTalk",invadeBossNPC2);
		NLG.UpChar(invadeBossNPC2);
	end
end

function invadeBossNPCTalk(_me,_tome)
	local bossName = Char.GetData(_me,%����_ԭ��%);
	local bossDeadFlag = bossSet[bossName]["deadFlag"];
	local bossCanBattleFlag = bossSet[bossName]["canBattleFlag"];
	if not bossDeadFlag then
		if bossCanBattleFlag then
			local msg = "��ս�ɣ��������ĳ��ӣ�";
			NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_ȷ��%+%��ť_��%,1000,msg);
		else
			local msg = "����æ�ŶԸ������أ�"
			NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_�ر�%,1001,msg);
		end
	else
		local msg = "�һ�������ģ�"
		NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_�ر�%,1002,msg);
	end
end

function invadeBossNPCWindowTalk(npc,player,Seqno,Select,Data)
	if Select == 8 then
		return;
	end
	if Select ~= 2 then
		if Seqno == 1000 then
			local npcName = Char.GetData(npc,%����_ԭ��%);
			local bossInfo = bossSet[npcName]["info"];
			local battle = Battle.Encount(npc,player,bossInfo);
			if battle >= 0 then
				--ս�������ɹ�
				bossSet[npcName]["canBattleFlag"] = false;
				Battle.SetWinEvent(nil,"battleWinEvent",battle);
			else
				--ս������ʧ��
				NLG.SystemMessage(player,"����ս��ʧ�ܡ�");
			end
		end
	end
end
function battleWinEvent(_battlePtr,_chrPtr)
	--0-9Ϊ���
	local captain;
	for i=0,9 do
		local tempPlayer = Battle.GetPlayer(_battlePtr, i);
		if (Char.GetPartyMode(tempPlayer) == 0 or Char.GetPartyMode(tempPlayer) == 1) then
			--���˻�ӳ�
			captain = tempPlayer;
			break;
		end
	end
	local bossName = playerAndBoss[captain];
	local winSide = Battle.GetWinSide(_battlePtr);
	print("winside = " .. winSide);
	if winSide == 0 then
		bossSet[bossName]["deadFlag"] = true;
		bossSet[bossName]["canBattleFlag"] = false;
	elseif winSide == 1 then
		bossSet[bossName]["deadFlag"] = false;
		bossSet[bossName]["canBattleFlag"] = true;
	end
	playerAndBoss[captain] = nil;
end
