
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
NL.RegRightClickEvent(nil,"factionBattleRightClickEvent");
Delegate.RegInit("FactionBattle_Init");

local factionBattleSleepTime = 30; --��Ӫս���ʱ��
local battleBeginTime = os.time();
RightClickValue4 = RightClickValue4 or {};
battleSleep = battleSleep or {};

function FactionBattle_Init()
	CreateFactionBattleNPC();
	CreateFactionBattleTransferNPC();
	CreateFactionBattleTimeNPC();
	CreateFactionBattleClearNPC();
	CreateFactionBattleRightClickNPC();
end

function FactionBattleNPCCharInit(_myIndex)
  return true;
end

function CreateFactionBattleNPC()
	if FactionBattleNPC == nil then
		FactionBattleNPC = NL.CreateNpc(nil,"FactionBattleNPCCharInit");
		Char.SetData(FactionBattleNPC,%����_����%,105000);
		Char.SetData(FactionBattleNPC,%����_ԭ��%,105000);
		Char.SetData(FactionBattleNPC,%����_��ͼ%,778);
		Char.SetData(FactionBattleNPC,%����_X%,1);
		Char.SetData(FactionBattleNPC,%����_Y%,0);
		Char.SetData(FactionBattleNPC,%����_����%,4);
		Char.SetData(FactionBattleNPC,%����_ԭ��%,"��Ӫսnpc");
		Char.SetWindowTalkedEvent("lua/Module/factionBattle.lua","JoinFactionWindowTalk",FactionBattleNPC);
		Char.SetTalkedEvent("lua/Module/factionBattle.lua","JoinFactionTalk",FactionBattleNPC);
		--Char.SetLoopEvent(nil,"RightClickValue19",npc,1000);
		NLG.UpChar(FactionBattleNPC);
	end
end

function CreateFactionBattleClearNPC()
	if FactionBattleClearNPC == nil then
		FactionBattleClearNPC= NL.CreateNpc(nil,"FactionBattleNPCCharInit");
		Char.SetData(FactionBattleClearNPC,%����_����%,105000);
		Char.SetData(FactionBattleClearNPC,%����_ԭ��%,105000);
		Char.SetData(FactionBattleClearNPC,%����_��ͼ%,778);
		Char.SetData(FactionBattleClearNPC,%����_X%,4);
		Char.SetData(FactionBattleClearNPC,%����_Y%,0);
		Char.SetData(FactionBattleClearNPC,%����_����%,4);
		Char.SetData(FactionBattleClearNPC,%����_ԭ��%,"�����Ӫս");
		Char.SetWindowTalkedEvent("lua/Module/factionBattle.lua","ClearFactionWindowTalk",FactionBattleClearNPC);
		Char.SetTalkedEvent("lua/Module/factionBattle.lua","ClearFactionTalk",FactionBattleClearNPC);
		NLG.UpChar(FactionBattleClearNPC);
	end
end

function ClearFactionTalk(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local fbmsg = "2\nȷ��Ҫ�ָ�������ô�ף�".. "" .."\n\n1.ȷ��\n2.��������";
		NLG.ShowWindowTalked(_tome,_me,2,2,120,fbmsg);
	end
end

function ClearFactionWindowTalk(npc,player,Seqno,Select,Data)
	print("Data=" .. Data);
	if Select ~= 2 then
		if Seqno == 120 then
		--�״ν���Ի��¼�
			local nameColor = Char.GetData(player,%����_��ɫ%);
			print("nameColor = " .. nameColor );
			if nameColor ~= 0 then
				if tonumber(Data) == 1 then
				--��������ɫ
					local nameColor = Char.GetData(player,%����_��ɫ%);
					Char.SetData(player,%����_��ɫ%,0);
					NLG.UpChar(player);
					local factionMsg1 = "\n��ϲ������֮��";
					NLG.ShowWindowTalked(player,npc,1,2,1,factionMsg1);
				elseif tonumber(Data) == 2 then
				--ȡ��
					local faction1Msg2 = "\n���������������ɧ�꣡";
					NLG.ShowWindowTalked(player,npc,1,2,2,faction1Msg2);
				end
			else
				NLG.TalkToCli(player,-1,"����ǰû�ж�Ӧ��Ӫ��",%��ɫ_��ɫ%);
			end
		elseif Seqno == 1 then
			--Ԥ��
		elseif Seqno == 2 then
			--Ԥ��
		end
	end
end

function JoinFactionTalk(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local fbmsg = "2\n��ϲ���������Ӫս��ϵ��������ѡ��Ҫ�������Ӫ��".. "" .."\n\n1.�췽\n2.����";
		NLG.ShowWindowTalked(_tome,_me,2,2,110,fbmsg);
	end
end

function JoinFactionWindowTalk(npc,player,Seqno,Select,Data)

	print("Data=" .. Data);
	if Select ~= 2 then
		if Seqno == 110 then
		--�״ν���Ի��¼�
			local nameColor = Char.GetData(player,%����_��ɫ%);
			print("nameColor = " .. nameColor );
			if nameColor == 0 then
				if tonumber(Data) == 2 then
				--�췽
				--�ı����������ɫ  %����_��ɫ%
					local nameColor = Char.GetData(player,%����_��ɫ%);
					Char.SetData(payer,%����_��ɫ%,1);
					NLG.UpChar(payer);
					local factionMsg1 = "\n��ϲ���Ϊ�췽���ͥ�е�һԱ��Ŭ��ǰ���ɣ�";
					NLG.ShowWindowTalked(player,npc,1,2,1,factionMsg1);
				elseif tonumber(Data) == 3 then
				--����
					local nameColor = Char.GetData(player,%����_��ɫ%);
					Char.SetData(player,%����_��ɫ%,2);
					NLG.UpChar(payer);
					local faction1Msg2 = "\n��ϲ���Ϊ�������ͥ�е�һԱ��Ŭ��ǰ���ɣ�";
					NLG.ShowWindowTalked(player,npc,1,2,2,faction1Msg2);
				end
			elseif nameColor == 1 then
				NLG.TalkToCli(player,-1,"���Ѿ����ں췽��Ӫ��",%��ɫ_��ɫ%);
			elseif nameColor == 2 then
				NLG.TalkToCli(player,-1,"���Ѿ�����������Ӫ",%��ɫ_��ɫ%);
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
		FactionBattleTransferNPC = NL.CreateNpc(nil,"FactionBattleNPCCharInit");
		Char.SetData(FactionBattleTransferNPC,%����_����%,105000);
		Char.SetData(FactionBattleTransferNPC,%����_ԭ��%,105000);
		Char.SetData(FactionBattleTransferNPC,%����_��ͼ%,778);
		Char.SetData(FactionBattleTransferNPC,%����_X%,2);
		Char.SetData(FactionBattleTransferNPC,%����_Y%,0);
		Char.SetData(FactionBattleTransferNPC,%����_����%,4);
		Char.SetData(FactionBattleTransferNPC,%����_ԭ��%,"��Ӫս���͹�");
		Char.SetWindowTalkedEvent("lua/Module/factionBattle.lua","EnterBattleMapWindowTalk",FactionBattleTransferNPC);
		Char.SetTalkedEvent("lua/Module/factionBattle.lua","EnterBattleMapTalk",FactionBattleTransferNPC);
		--loop���ڿ���npc����Чʱ�䣬�Լ�����
		Char.SetLoopEvent("lua/Module/factionBattle.lua","RightClickValue19",npc,1000);
		NLG.UpChar(FactionBattleTransferNPC);
	end
end

function EnterBattleMapTalk(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local entermsg = "2\nɧ�������Ҫ��������п��PK��ô����Σ�յ�Ŷ";
		NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_ȷ���ر�%,11,entermsg);
	end
end

function EnterBattleMapWindowTalk(npc,player,Seqno,Select,Data)
	if Select ~= 2 then
		--�����Ҵ�����ָ����ͼ
		local playerStatus = Char.GetPartyMode(player);
		if(playerStatus == 0) then
		--0����һ�ˡ�1�ӳ�ֻ��������״̬���Դ���
			Char.Warp(player,0,60006,15,38);
		elseif(playerStatus == 1) then
			local partyNum = Char.PartyNum(player);
			for i=1,partyNum do
				local p = Char.GetPartyMember(player,i);
				Char.Warp(p,0,60006,15,38);
			end
		else
			NLG.TalkToCli(player,-1,"�������ϴ����˵����",%��ɫ_��ɫ%);
		end
	end
end

--��λ�ȡָ����ͼ�ϵ�����ս��ָ�룿
-- NLG.GetMapPlayer(map,floor) ��ȡĿ���ͼ���е���ң�����table��ʽ���ء�
-- Char.GetBattleIndex(_Ptr) ��ȡ����_Ptr��ս����ţ�ս����ſ���ʹ��Battle��ĺ������в���
-- NL.RegBattleStartEvent(nil, "FactionBattleStart");
-- NL.RegBattleOverEvent(nil, "FactionBattleOver");
function FactionBattleStart(_battlePtr)
	--ͨ��ս����ȡ���
	--local player = Battle.GetPlayer(_battlePtr, 1);
	--��ȡ������ڵ�ͼ
	--local playerMapNum = Char.GetData(player,%����_MAP%);
	print("playerMapNum  = " .. "test" );
	--if playerMapNum == 60006 then
		--��������ָ����ͼ����ս����������ΪPVE
		--����API��û��ս������!
		--Battle.SetType(_battlePtr, 1);
	--end
end
function FactionBattleOver(_battlePtr)
	--ʡ����ָ����ͼ���жϣ��Ժ��ټӡ�
	--������0-19������ָ�룬����˫��������+����
	local overTime = os.time();
	for i=0,19 do
		local player = Battle.GetPlayer(_battlePtr, i);
		--���ö���PK����Ϊ�ر�״̬
		Char.SetData(player,"%����_PK����%",1);
		NLG.UpChar(player);
	end
	--��˻��˷Ѵ�����cpuʱ�䣬��֪��Ч���Ƿ���Ǹ����⡣
	--��û��ǿ��Ի�ȡ��PK�¼�����PK�¼����жϵ�ǰʱ����overTime�Ĳ�ֵ�Ƿ񳬹�ָ��ʱ�䡣
	while os.time() - overTime < 18 do
		--18����ʲô������
	end
	for i=0,19 do
		local player = Battle.GetPlayer(_battlePtr, i);
		--���ö���PK����Ϊ����״̬
		if player ~= nil then
			Char.SetData(player,"%����_PK����%",2);
			NLG.UpChar(player);
		end
	end
end

--����NPC��loopս��ʱ��
function CreateFactionBattleTimeNPC()
	if FactionBattleTimeNPC == nil then
		FactionBattleTimeNPC = NL.CreateNpc(nil,"FactionBattleNPCCharInit");
		Char.SetData(FactionBattleTimeNPC,%����_����%,105000);
		Char.SetData(FactionBattleTimeNPC,%����_ԭ��%,105000);
		Char.SetData(FactionBattleTimeNPC,%����_��ͼ%,778);
		Char.SetData(FactionBattleTimeNPC,%����_X%,3);
		Char.SetData(FactionBattleTimeNPC,%����_Y%,0);
		Char.SetData(FactionBattleTimeNPC,%����_����%,4);
		Char.SetData(FactionBattleTimeNPC,%����_ԭ��%,"��Ӫս��ʱnpc");
		Char.SetLoopEvent(nil,"FactionBattleTimeNPCLoop",npc,1000);
		NLG.UpChar(FactionBattleTimeNPC);
	end
end

function FactionBattleTimeNPCLoop(_MePtr)
	--2hours
	--table.getn(tblTest1) ��ȡtable����
	if os.time() - battleBeginTime == 60*60*2 then
		local players = NLG.GetMapPlayer(0,60006);
		local redNum = 0;
		local blueNum = 0;
		local redPlayers = {};
		local bluePlayers = {};
		for k,v in pairs(players) do
			local player = v;
			local playerColor = Char.GetData(player,%����_��ɫ%);
			if playerColor == 1 then 
				redNum = redNum + 1;
				table.insert(redPlayers,player);
			elseif playerColor == 2 then 
				blueNum = blueNum + 1;
				table.insert(bluePlayers,player);
			end
		end
		if redNum > blueNum then 
			--�췽��Ӫ��ʤ
			local winnerFaction = "�췽��Ӫʤ����";
			for k,v in pairs(redPlayers) do
				local player = v;
				--��ʤ�߽���
			end
		elseif redNum == blueNum then
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
		elseif redNum < blueNum then
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

-- Delegate.RegDelTalkEvent("RightClickValue3")

function factionBattleRightClickEvent(player1,player2)
	print(1111);
	RightClickValue4[player1] = player2;
	local rightClickInfo = "2\n��������ң�"..(Char.GetData(player2,%����_ԭ��%)).."\n\n1.������ս";
	NLG.ShowWindowTalked(player1,FactionBattleRightClickNPC,2,2,100,rightClickInfo);
end

function factionBattleRightClickEventNpc(npc,player,Seqno,Select,Data)
	print("Select  = " .. Select );
	print("Seqno = " .. Seqno);
	print("Data= " .. Data);
	if Select == 0 then
		local player2 = RightClickValue4[player]
		print("player2 = " .. player2);
		if player2 ~= nil and player2 >= 0 then
			print("in ");
			print("player object = " .. player);
			print("player2 object = " .. player2);
			local playerSleepTime1 = 0;
			local playerSleepTime2 = 0;
			if next(battleSleep) == nil then
				-- battleSleepû�б���ʼ����
			else
				if battleSleep[player] ~= nil then
					playerSleepTime1  = battleSleep[player] ;
				end	
				if battleSleep[player2] ~= nil then
					playerSleepTime2 = battleSleep[player2] ;
				end
			end
			local playerSleepTime = os.time() - playerSleepTime1;
			local player2SleepTime = os.time() - playerSleepTime2;
			print("playerSleepTime = " .. playerSleepTime);
			print("player2SleepTime = " .. player2SleepTime);
			if playerSleepTime < factionBattleSleepTime then
				--�Լ���ս���������ָ��ʱ��
				NLG.SystemMessage(player,"��Ϣ������Ϣһ�¡�����" .. (factionBattleSleepTime-playerSleepTime) .. "���ɼ���ս����")
				return;
			end
			if player2SleepTime < factionBattleSleepTime then 
				--�Է���ս���������ָ��ʱ��
				NLG.SystemMessage(player,"����Ķ�����Ϣһ�¡���" .. (factionBattleSleepTime-player2SleepTime).. "���ɼ���ս����")
				return;
			end
			
			if Seqno == 100 then
				if tonumber(Data) == 1 then
					print("in");
					--ò�ƿ���ֱ�Ӵ���ս��
					local p1mapNum = Char.GetData(player,%����_��ͼ%);
					local p2mapNum = Char.GetData(player2,%����_��ͼ%);
					print("p1mapNum  = " .. p1mapNum );
					print("p2mapNum = " .. p1mapNum );
					if p1mapNum == 60006 and p2mapNum == 60006 then
						--��ָ������Ӫս��ͼ
						local factionBattle = Battle.PVP(player,player2);	
						Battle.SetType(factionBattle, %ս��_��ͨ%); --������ս������Ϊ��ͨս����������0
						if factionBattle >= 0 then 
							--ս�������ɹ�
							Battle.SetWinEvent(nil,"factionBattleWinEvent",factionBattle);
						else
							--ս������ʧ��
							NLG.SystemMessage(player,"����ս��ʧ�ܡ�");
						end   
					end

				elseif tonumber(Data) == 2 then
					--Ԥ��
				end
			elseif Seqno == 11 then
				--Ԥ��
			end
		end
	end
end

--����NPC��loopս��ʱ��
function CreateFactionBattleRightClickNPC()
	if FactionBattleRightClickNPC == nil then
		FactionBattleRightClickNPC = NL.CreateNpc(nil,"FactionBattleNPCCharInit");
		Char.SetData(FactionBattleRightClickNPC,%����_����%,105000);
		Char.SetData(FactionBattleRightClickNPC,%����_ԭ��%,105000);
		Char.SetData(FactionBattleRightClickNPC,%����_��ͼ%,778);
		Char.SetData(FactionBattleRightClickNPC,%����_X%,5);
		Char.SetData(FactionBattleRightClickNPC,%����_Y%,0);
		Char.SetData(FactionBattleRightClickNPC,%����_����%,4);
		Char.SetData(FactionBattleRightClickNPC,%����_ԭ��%,"��Ӫս�Ҽ�����");
		Char.SetWindowTalkedEvent(nil,"factionBattleRightClickEventNpc",FactionBattleRightClickNPC)
		--Char.SetLoopEvent(nil,"FactionBattleTimeNPCLoop",npc,1000);
		NLG.UpChar(FactionBattleRightClickNPC);
	end
end

function factionBattleRightClickEvent1(player1,player2)
	--ò�ƿ���ֱ�Ӵ���ս��
	local p1mapNum = Char.GetData(player,%����_MAP%);
	local p2mapNum = Char.GetData(player,%����_MAP%);
	if p1mapNum == 60006 and p2mapNum == 60006 then
		--��ָ������Ӫս��ͼ
		print("+++++++++++++++++++++++++");
		local factionBattle = Battle.PVP(player1,player2,1);
		print("**************************");

		print(Battle.GetType(factionBattle));
		--Battle.SetType(factionBattle, %ս��_��ͨ%); --������ս������Ϊ��ͨս����������0
		if factionBattle >= 0 then 
			--ս�������ɹ�
			print("^^^^^^^^^^^^^^^^^^^^^^^^^");

			Battle.SetWinEvent(nil,"factionBattleWinEvent",factionBattle)
		else
			--ս������ʧ��
			NLG.SystemMessage(player1,"����ս��ʧ�ܡ�")
		end   
	end
end

function factionBattleWinEvent(factionBattle)
	--0����1,0��ʾս���·�����0-9λ�õ���ң�1��ʾ�Ϸ�����10-19λ�õ����
    --local overTime = os.time();
	local winSide = Battle.GetWinSide(factionBattle);
	if winSide == 0 then 
		for i = 0,9 do
			local battleObj = Battle.GetPlayer(factionBattle,i);
			if battleObj >= 0 then
				if Char.GetData(battleObj,(%����_��%)) == (%��������_��%) then
					print(Char.GetData(battleObj,(%����_Ѫ%)));
					print(Char.GetData(battleObj,(%����_ħ%)));
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
					print(Char.GetData(battleObj,(%����_Ѫ%)));
					print(Char.GetData(battleObj,(%����_ħ%)));
					NLG.SystemMessage(battleObj,"�����ڵĶ���ʤ���ˣ�")
				end
			end
		end
	end

	--��������ҵ�ս��״̬��Ϊ����ս��
	--��������ҵ���Ӫս����ʱ���¼����
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
				print("playerName = " .. Char.GetData(battleObj,(%����_����%)));
				battleSleep[battleObj] = os.time();
				print("sleepTime = " .. battleSleep[battleObj]);
				-- NLG.UpChar(battleObj);
			end
		end
	end
	
	--���½����ս��״̬����Ϊ��ս��
	--[[
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
	]]--
end
