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
local preShowProfessionInfoTime = 5*60;
local wholLeaderInfo = {1 = '������' , 2 = 'ս��' , 3 = 'ħ��ʿ' , 4 = '��ʿ'};
local professionId;
local professionName;
local canEnterFlag = false;
local playerAndBoss = playerAndBoss or {};


local bossSet ={
['��˵��������1��'] = {'deadFlag' = false , 'canBattleFlag' = true , 'info' = '3|0,20003,43,7||0|||||0|10007|||||||||'} ,
['��˵��������2��'] = {'deadFlag' = false , 'canBattleFlag' = true , 'info' = '3|0,20003,43,7||0|||||0|10007|||||||||'} ,
['��Ӣ������1��'] = {'deadFlag' = false , 'canBattleFlag' = true , 'info' = '3|0,20003,43,7||0|||||0|10007|||||||||'} ,
['��Ӣ������2��'] = {'deadFlag' = false , 'canBattleFlag' = true , 'info' = '3|0,20003,43,7||0|||||0|10007|||||||||'} ,
['������1��'] = {'deadFlag' = false , 'canBattleFlag' = true , 'info' = '3|0,20003,43,7||0|||||0|10007|||||||||'} ,
['������2��'] = {'deadFlag' = false , 'canBattleFlag' = true , 'info' = '3|0,20003,43,7||0|||||0|10007|||||||||'}};

--����ʱ������
local invadeBeginWeekday = "3";
local invadeBeginTimeH = "22";
local invadeBeginTimeM = "47";
local invadeBeginTimeS = "00";


function invade_init()
	createInvadeGateNPC();
	createInvadeBoss1();
	createInvadeBoss2();
	createInvadeMiddle1();
	createInvadeSmall1();
end

function createInvadeGateNPC()
	if invadeGateNPC == nil then
		invadeGateNPC = NL.CreateNpc(nil,true);
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
		--5������ʾ����������������ְҵ
		if targetInvadeBeginTime - os.time() = preShowProfessionInfoTime then
			math.randomseed(tostring(os.time()));
			professionId = math.random(4);
			professionName = wholLeaderInfo[randomNum];
			NLG.SystemMessage(-1,"����������Ҫ�����ְҵΪ��" .. professionName);
		end
	--�жϽ�����ʶ
		if os.time() - targetInvadeBeginTime < invadeBattleLastTime  and os.time() - invadeBeginTime > 0 then
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
		local msg = "��������ս�����ְҵΪ��" .. professionName .. "���Ѿ�����׼����ô����";
		NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_ȷ��%+%��ť_��%,820,msg);
	else
		local msg = "ʱ��δ������"
		NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_�ر�%,830,msg);
	end
end

function invadeGateNPCWindowTalk(npc,player,Seqno,Select,Data)
	if Select == 8 then
		return;
	end
	if Select ~= 2 then
		if Seqno ~= 820 then
			return;
		end
		local playerLv = Char.GetData(_me,%����_�ȼ�%);
		if playerLv < minEnterLv then
			NLG.TalkToCli(player,-1,"�����������͵ȼ�Ҫ����" .. minEnterLv .. "��", %��ɫ_��ɫ%);
		else
			--�����Ҵ�����ָ����ͼ
			local playerStatus = Char.GetPartyMode(player);
			if(playerStatus == 0) then
			--0����һ�ˡ�1�ӳ�ֻ��������״̬���Դ���
				local tmpprofession = Char.GetData(player,%����_ְҵ%);
				if tmpprofession == professionName then
					Char.Warp(player,0,60006,15,38);
				else
					NLG.TalkToCli(player,-1,"����������������ְҵ�ǣ�" .. professionName, %��ɫ_��ɫ%);
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
					NLG.TalkToCli(player,-1,"����������������ְҵ�ǣ�" .. professionName, %��ɫ_��ɫ%);
				end
			else
				NLG.TalkToCli(player,-1,"�������ϴ����˵����",%��ɫ_��ɫ%);
			end
		end
	end
end


----------------��������NPC-----------------
local boss1CanBattleFlag = true;
local boss1DeadFlag = false;
function createInvadeBoss1()
	if invadeBossNPC1 == nil then
		invadeBossNPC1 = NL.CreateNpc(nil,true);
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
function invadeBossNPCTalk(_me,_tome)
	local bossName = Char.GetData(_tome,%����_ԭ��%);
	local bossDeadFlag = bossSet[bossName][deadFlag];
	local bossCanBattleFlag = bossSet[bossName][canBattleFlag];
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
			boss1CanBattleFlag = false;
			local npcName = Char.GetData(npc,%����_ԭ��%);
			local bossInfo = bossSet[npcName][info];
			local battle = Battle.Encount(player,npc,bossInfo);
			if battle >= 0 then
				--ս�������ɹ�
				bossSet[npcName][canBattleFlag] = false;
				Battle.SetWinEvent(nil,"battleWinEvent",battle);
			else
				--ս������ʧ��
				NLG.SystemMessage(player,"����ս��ʧ�ܡ�");
			end
		end
	end
end
function battleWinEvent(_battlePtr,_chrPtr)
	print("name=" .. Char.GetData(_chrPtr,%����_ԭ��%));
	--���nameΪ��ң��Ǿͷ��ˡ���ֻ��ͨ��bosս�����������ֵı�ʶ�����п��ơ����ߣ���ͨ�������npc�Ի�����Һ�bos��Ӧ������playerAndBoss[_chrPtr]= bos
	--���nameΪnpc������ͨ����ָ�������е������ơ� _chrPtr = bos
	local bossPtr;
	local bossName = Char.GetData(bossPtr,%����_ԭ��%);
	local winSide = Battle.GetWinSide(_battlePtr);
	print("winside = " .. winSide);
	if winSide == 0 then
		bossSet[bossName][deadFlag] = true;
		bossSet[bossName][canBattleFlag] = false;
	elseif winSide == 1 then
		bossSet[bossName][deadFlag] = false;
		bossSet[bossName][canBattleFlag] = true;
		playerAndBoss[player] = nil;
	end
end
