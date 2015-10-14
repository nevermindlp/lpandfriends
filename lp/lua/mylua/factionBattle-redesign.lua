
-- ��Ӫսlua

--[[ 
��ʵ�ֹ��ܣ�
1��������Ӫսnpc��������Ҽ��벻ͬ����Ӫ��
2���ı����������ɫ��������Ӫ��
3��������Ӫս���͹٣��û���׼��������Ҵ�����ָ��PK��ͼ����ͼ�������;ã�����npcֻ��ָ��ʱ����ڿ��Ŵ��͹��ܡ�
4������ӪսPK��ͼ�У���PK����������ΪPEVս���������������˵�ս����ġ�
5������ӪսPK��ͼ�У���������ڽ���PVPս������һ��ʱ���׼��ʱ�䣬�ڴ��ڼ䲻�����ٴα�PK��
6����ӪսPK��ͼ��ָ��ʱ���Ե�ǰ��ͼ����ҽ���ͳ�ƣ��Ծ���ʤ����Ӫ��NLG.GetMapPlayer(map,floor) ��ȡĿ���ͼ���е���ң�����table��ʽ���ء�
7��������Ӫս������ȡnpc�����ڸ�ʤ����Ӫ����ҷ��Ž��������˴�������Ϊֱ�Ӹ���Ұ��﷢�Ž�������ʱ��������Ĵ������û����ã�
8����Ӫƽ����ԡ�������ͨ�����齱��������ƽ�⣩
]]--
Delegate.RegInit("FactionBattle_Init");

local battleBeginTime = os.time();
local battleSleep = battleSleep or {};

function FactionBattle_Init()
	CreateFactionBattleNPC();
	CreateFactionBattleTransferNPC();
	CreateFactionBattleTimeNPC();
end

function FactionBattleNPCCharInit(_myIndex)
  return true;
end

function CreateFactionBattleNPC()
	if FactionBattleNPC == nil then
		FactionBattleNPC = NL.CreateNpc(nil,"FactionBattleNPCCharInit")
		Char.SetData(FactionBattleNPC,%����_����%,100500)
		Char.SetData(FactionBattleNPC,%����_ԭ��%,100500)
		Char.SetData(FactionBattleNPC,%����_��ͼ%,778)
		Char.SetData(FactionBattleNPC,%����_X%,1)
		Char.SetData(FactionBattleNPC,%����_Y%,0)
		Char.SetData(FactionBattleNPC,%����_����%,4)
		Char.SetData(FactionBattleNPC,%����_ԭ��%,"��Ӫսnpc")
		Char.SetWindowTalkedEvent(nil,"JoinFactionWindowTalk",FactionBattleNPC)
		Char.SetTalkedEvent(nil,"JoinFactionTalk",FactionBattleNPC)
		--Char.SetLoopEvent(nil,"RightClickValue19",npc,1000)
		NLG.UpChar(FactionBattleNPC)
	end
end

function JoinFactionTalk(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local fbmsg = "2\n��ϲ���������Ӫս��ϵ��������ѡ��Ҫ�������Ӫ��".. "" .."\n\n1.�췽\n2.����"
		NLG.ShowWindowTalked(_me,_tome,2,2,0,fbmsg)
	end
end

function JoinFactionWindowTalk(npc,player,Seqno,Select,Data)
	if Select ~= 2 then
		if Seqno == 0 then
		--�״ν���Ի��¼�
			local nameColor = Char.GetData(Player,%����_��ɫ%);
			if nameColor == 0 then
				if tonumber(Data) == 1 then
				--�췽
				--�ı����������ɫ  %����_��ɫ%
					local nameColor = Char.GetData(Player,%����_��ɫ%);
					Char.SetData(Player,%����_��ɫ%,1);
					local factionMsg1 = "\n��ϲ���Ϊ�췽���ͥ�е�һԱ��Ŭ��ǰ���ɣ�"
					NLG.ShowWindowTalked(player,npc,1,2,1,factionMsg1)
				elseif tonumber(Data) == 2 then
				--����
					local nameColor = Char.GetData(Player,%����_��ɫ%);
					Char.SetData(Player,%����_��ɫ%,2);
					local faction1Msg2 = "\n��ϲ���Ϊ�������ͥ�е�һԱ��Ŭ��ǰ���ɣ�"
					NLG.ShowWindowTalked(player,npc,1,2,2,faction1Msg2)
				end
			elseif nameColor == 1 then
				NLG.TalkToCli(player,-1,"���Ѿ����ں췽��Ӫ��",%��ɫ_��ɫ%)
			elseif nameColor == 2 then
				NLG.TalkToCli(player,-1,"���Ѿ�����������Ӫ",%��ɫ_��ɫ%)
			end
		elseif Seqno == 1 then
			--Ԥ��
		elseif Seqno == 2 then
			--Ԥ��
		end
		
	end
end

function CreateFactionBattleTransferNPC()
	if FactionBattleTransferNPC == nil then
		FactionBattleTransferNPC = NL.CreateNpc(nil,"CreateFactionBattleNPC")
		Char.SetData(FactionBattleTransferNPC,%����_����%,100500)
		Char.SetData(FactionBattleTransferNPC,%����_ԭ��%,100500)
		Char.SetData(FactionBattleTransferNPC,%����_��ͼ%,778)
		Char.SetData(FactionBattleTransferNPC,%����_X%,1)
		Char.SetData(FactionBattleTransferNPC,%����_Y%,0)
		Char.SetData(FactionBattleTransferNPC,%����_����%,4)
		Char.SetData(FactionBattleTransferNPC,%����_ԭ��%,"��Ӫս���͹�")
		Char.SetWindowTalkedEvent(nil,"EnterBattleMapWindowTalk",FactionBattleTransferNPC)
		Char.SetTalkedEvent(nil,"EnterBattleMapTalk",FactionBattleNPC)
		--loop���ڿ���npc����Чʱ�䣬�Լ�����
		Char.SetLoopEvent(nil,"RightClickValue19",npc,1000)
		NLG.UpChar(FactionBattleTransferNPC)
	end
end

function EnterBattleMapTalk(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local entermsg = "2\nɧ�������Ҫ��������п��PK��ô����Σ�յ�Ŷ"
		NLG.ShowWindowTalked(player,FactionBattleTransferNPC,1,2,11,entermsg)
	end
end

function EnterBattleMapWindowTalk(npc,player,Seqno,Select,Data)
	if Select ~= 2 then
		--�����Ҵ�����ָ����ͼ
		local playerStatus = Char.GetPartyMode(player)
		if(playerStatus == 0) then
		--0����һ�ˡ�1�ӳ�ֻ��������״̬���Դ���
			Char.Warp(player,0,778,0,1)
		elseif(playerStatus == 1) then
			local partyNum = Char.PartyNum(player)
			for i=1,partyNum do
				local p = Char.GetPartyMember(player,i)
				Char.Warp(p,0,778,0,1)
			end
		else
			NLG.TalkToCli(player,-1,"�������ϴ����˵����",%��ɫ_��ɫ%)
		end
	end
end


--��λ�ȡָ����ͼ�ϵ�����ս��ָ�룿
-- NLG.GetMapPlayer(map,floor) ��ȡĿ���ͼ���е���ң�����table��ʽ���ء�
-- Char.GetBattleIndex(_Ptr) ��ȡ����_Ptr��ս����ţ�ս����ſ���ʹ��Battle��ĺ������в���
NL.RegBattleStartEvent(nil, "FactionBattleStart")
NL.RegBattleOverEvent(nil, "FactionBattleOver")
function FactionBattleStart(_battlePtr)
	--ͨ��ս����ȡ���
	local player = Battle.GetPlayer(_battlePtr, 1)
	--��ȡ������ڵ�ͼ
	local playerMapNum = Char.GetData(player,%����_MAP%)
	if playerMapNum == 778 then
		--��������ָ����ͼ����ս����������ΪPVE
		--����API��û��ս������!
		Battle.SetType(_battlePtr, 1)
	end
end
function FactionBattleOver(_battlePtr)
	--ʡ����ָ����ͼ���жϣ��Ժ��ټӡ�
	--������0-19������ָ�룬����˫��������+����
	local overTime = os.time();
	for i=0,19 do
		local player = Battle.GetPlayer(_battlePtr, i)
		--���ö���PK����Ϊ�ر�״̬
		Char.SetData(player,"%����_PK����%",1)
		NLG.UpChar(player)
	end
	--��˻��˷Ѵ�����cpuʱ�䣬��֪��Ч���Ƿ���Ǹ����⡣
	--��û��ǿ��Ի�ȡ��PK�¼�����PK�¼����жϵ�ǰʱ����overTime�Ĳ�ֵ�Ƿ񳬹�ָ��ʱ�䡣
	while os.time() - overTime < 18 do
		--18����ʲô������
	end
	for i=0,19 do
		local player = Battle.GetPlayer(_battlePtr, i)
		--���ö���PK����Ϊ����״̬
		Char.SetData(player,"%����_PK����%",2)
		NLG.UpChar(player)
	end
end

--����NPC��loopս��ʱ��
function CreateFactionBattleTimeNPC()
	if FactionBattleTimeNPC == nil then
		FactionBattleTimeNPC = NL.CreateNpc(nil,"FactionBattleNPCCharInit")
		Char.SetData(FactionBattleTimeNPC,%����_����%,100500)
		Char.SetData(FactionBattleTimeNPC,%����_ԭ��%,100500)
		Char.SetData(FactionBattleTimeNPC,%����_��ͼ%,778)
		Char.SetData(FactionBattleTimeNPC,%����_X%,1)
		Char.SetData(FactionBattleTimeNPC,%����_Y%,0)
		Char.SetData(FactionBattleTimeNPC,%����_����%,4)
		Char.SetData(FactionBattleTimeNPC,%����_ԭ��%,"��Ӫս��ʱnpc")
		Char.SetLoopEvent(nil,"FactionBattleTimeNPCLoop",npc,1000)
		NLG.UpChar(FactionBattleTimeNPC)
	end
end

function FactionBattleTimeNPCLoop(_MePtr)
	--2hours
	--table.getn(tblTest1) ��ȡtable����
	if os.time() - battleBeginTime == 60*60*2 then
		local players = NLG.GetMapPlayer(0,778)
		local redNum = 0;
		local blueNum = 0;
		local redPlayers = {};
		local bluePlayers = {};
		for k,v in pairs(players) do
			local player = v;
			local playerColor = Char.GetData(Player,%����_��ɫ%);
			if playerColor == 1 do 
				redNum = redNum + 1;
				table.insert(redPlayers,player);
			elseif playerColor == 2 do 
				blueNum = blueNum + 1;
				table.insert(bluePlayers,player);
			end
		end
		if redNum > blueNum do 
			--�췽��Ӫ��ʤ
			local winnerFaction = "�췽��Ӫʤ����";
			for k,v in pairs(redPlayers) do
				local player = v;
				--��ʤ�߽���
			end
		elseif redNum == blueNum do
			--ƽ��
			local winnerFaction = "ƽ�֣�";
			for k,v in pairs(redPlayers) do
				local player = v;
				--��ʤ�߽���
			end
			for k,v in pairs(bluePlayers) do
				local player = v;
				--��ʤ�߽���
			end
		elseif redNum < blueNum do
			--������Ӫ��ʤ
			local winnerFaction = "������Ӫʤ����";
			for k,v in pairs(bluePlayers) do
				local player = v;
				--��ʤ�߽���
			end
		end
		--ȫ��ͨ��ʤ�����
		NLG.SystemMessage(-1,"��ӪPK��ս�Ѿ����������ս��Ϊ��" .. winnerFaction);		
	end
end




--�������ս�������߼�
--����ע���Ҽ��¼��ͶԻ��¼����������м�����npc����ɶԻ�������ս����ʵ�֡�
NL.RegRightClickEvent(nil,"factionBattleRightClickEvent")
Delegate.RegDelTalkEvent("RightClickValue3")
function factionBattleRightClickEvent(player1,player2)
	--ò�ƿ���ֱ�Ӵ���ս��
	local p1mapNum = Char.GetData(player,%����_MAP%);
	local p2mapNum = Char.GetData(player,%����_MAP%);
	if p1mapNum == 60006 and p2mapNum == 60006 then
		--��ָ������Ӫս��ͼ
		local factionBattle = Battle.PVE(player1,player2);
		if factionBattle >= 0 then 
			--ս�������ɹ�
			Battle.SetWinEvent(nil,"factionBattleWinEvent",factionBattle)
		else
			--ս������ʧ��
			NLG.SystemMessage(player1,"����ս��ʧ�ܡ�")
		end
	end
end

function factionBattleWinEvent(factionBattle)
	--0����1,0��ʾս���·�����0-9λ�õ���ң�1��ʾ�Ϸ�����10-19λ�õ����
	local winSide = Battle.GetWinSide(factionBattle);
	if winSide == 0 then 
		for i = 0,9 do
			local battleObj = Battle.GetPlayer(factionBattle,i);
			if battleObj >= 0 then
				if Char.GetData(battleObj,(%����_��%)) == (%��������_��%) then
					NLG.SystemMessage(battleObj,"�����ڵĶ���ʤ���ˣ�")
				end
			end
		end
	end
	if winSide == 1 then 
		for i = 10,19 do
			local battleObj = Battle.GetPlayer(factionBattle,i);
			if battleObj >= 0 then
				if Char.GetData(battleObj,(%����_��%)) == (%��������_��%) then
					NLG.SystemMessage(battleObj,"�����ڵĶ���ʤ���ˣ�")
				end
			end
		end
	end

	-- ������ҵ�ս��״̬��Ϊ����ս��
	-- ��������ҵ���Ӫս����ʱ���¼����
	for i = 0,19 do
		local battleObj = Battle.GetPlayer(factionBattle,i);
		if battleObj >= 0 then
			if Char.GetData(battleObj,(%����_��%)) == (%��������_��%) then
				--Char.SetData(battleObj,"%����_PK����%",1);
				--upChar��֪���ܲ����ڷ���δ����ʱ������Ч��
				-- ʹ��lua�����Ƿ��ս��״̬����ʹ��ԭħ��ʵ��
				-- �Ż�ʱ��Ҫ���Ǵ˴���battleObj����ͬһ������Ƿ�һֱ��ͬһ������
				-- �粻�ǵĻ����ܻᵼ��ÿ��ս�����������������Ĵ洢��
				-- %ս��_��ͨ%	Battle.SetType()	��ͨս��ģʽ,������
				battleSleep[battleObj] = os.time();
				--NLG.UpChar(battleObj);
			end
		end
	end
	
	--���½����ս��״̬����Ϊ��ս��
	while os.time() - overTime < 18 do
		--18����ʲô������
	end
	for i = 0,19 do
		local battleObj = Battle.GetPlayer(factionBattle,i);
		if battleObj >= 0 then
			if Char.GetData(battleObj,(%����_��%)) == (%��������_��%) then
				Char.SetData(battleObj,"%����_PK����%",2);
				--upChar��֪���ܲ����ڷ���δ����ʱ������Ч��
				NLG.UpChar(battleObj);
			end
		end
	end
end













