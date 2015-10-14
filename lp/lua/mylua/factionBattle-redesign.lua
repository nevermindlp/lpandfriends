
-- 阵营战lua

--[[ 
待实现功能：
1、创建阵营战npc，用于玩家加入不同的阵营。
2、改变玩家名称颜色以区分阵营。
3、创建阵营战传送官，用户将准备区的玩家传送至指定PK地图（地图不消耗耐久），此npc只在指定时间段内开放传送功能。
4、在阵营战PK地图中，将PK的属性设置为PEV战斗，即包括会受伤等战斗损耗。
5、在阵营战PK地图中，任意玩家在结束PVP战斗后，有一定时间的准备时间，在此期间不允许再次被PK。
6、阵营战PK地图在指定时间后对当前地图的玩家进行统计，以决定胜利阵营。NLG.GetMapPlayer(map,floor) 获取目标地图所有的玩家，并以table形式返回。
7、创建阵营战奖励获取npc，用于给胜利阵营的玩家发放奖励。（此处亦可设计为直接给玩家包里发放奖励，当时如果包满的处理机制没有想好）
8、阵营平衡策略。（可能通过经验奖励来控制平衡）
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
		Char.SetData(FactionBattleNPC,%对象_形象%,100500)
		Char.SetData(FactionBattleNPC,%对象_原形%,100500)
		Char.SetData(FactionBattleNPC,%对象_地图%,778)
		Char.SetData(FactionBattleNPC,%对象_X%,1)
		Char.SetData(FactionBattleNPC,%对象_Y%,0)
		Char.SetData(FactionBattleNPC,%对象_方向%,4)
		Char.SetData(FactionBattleNPC,%对象_原名%,"阵营战npc")
		Char.SetWindowTalkedEvent(nil,"JoinFactionWindowTalk",FactionBattleNPC)
		Char.SetTalkedEvent(nil,"JoinFactionTalk",FactionBattleNPC)
		--Char.SetLoopEvent(nil,"RightClickValue19",npc,1000)
		NLG.UpChar(FactionBattleNPC)
	end
end

function JoinFactionTalk(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local fbmsg = "2\n恭喜你完成了阵营战的系列任务，请选择要加入的阵营：".. "" .."\n\n1.红方\n2.蓝方"
		NLG.ShowWindowTalked(_me,_tome,2,2,0,fbmsg)
	end
end

function JoinFactionWindowTalk(npc,player,Seqno,Select,Data)
	if Select ~= 2 then
		if Seqno == 0 then
		--首次进入对话事件
			local nameColor = Char.GetData(Player,%对象_名色%);
			if nameColor == 0 then
				if tonumber(Data) == 1 then
				--红方
				--改变玩家名称颜色  %对象_名色%
					local nameColor = Char.GetData(Player,%对象_名色%);
					Char.SetData(Player,%对象_名色%,1);
					local factionMsg1 = "\n恭喜你成为红方大家庭中的一员，努力前进吧！"
					NLG.ShowWindowTalked(player,npc,1,2,1,factionMsg1)
				elseif tonumber(Data) == 2 then
				--蓝方
					local nameColor = Char.GetData(Player,%对象_名色%);
					Char.SetData(Player,%对象_名色%,2);
					local faction1Msg2 = "\n恭喜你成为蓝方大家庭中的一员，努力前进吧！"
					NLG.ShowWindowTalked(player,npc,1,2,2,faction1Msg2)
				end
			elseif nameColor == 1 then
				NLG.TalkToCli(player,-1,"您已经处于红方阵营。",%颜色_红色%)
			elseif nameColor == 2 then
				NLG.TalkToCli(player,-1,"您已经处于蓝方阵营",%颜色_红色%)
			end
		elseif Seqno == 1 then
			--预留
		elseif Seqno == 2 then
			--预留
		end
		
	end
end

function CreateFactionBattleTransferNPC()
	if FactionBattleTransferNPC == nil then
		FactionBattleTransferNPC = NL.CreateNpc(nil,"CreateFactionBattleNPC")
		Char.SetData(FactionBattleTransferNPC,%对象_形象%,100500)
		Char.SetData(FactionBattleTransferNPC,%对象_原形%,100500)
		Char.SetData(FactionBattleTransferNPC,%对象_地图%,778)
		Char.SetData(FactionBattleTransferNPC,%对象_X%,1)
		Char.SetData(FactionBattleTransferNPC,%对象_Y%,0)
		Char.SetData(FactionBattleTransferNPC,%对象_方向%,4)
		Char.SetData(FactionBattleTransferNPC,%对象_原名%,"阵营战传送官")
		Char.SetWindowTalkedEvent(nil,"EnterBattleMapWindowTalk",FactionBattleTransferNPC)
		Char.SetTalkedEvent(nil,"EnterBattleMapTalk",FactionBattleNPC)
		--loop用于控制npc的有效时间，以及设置
		Char.SetLoopEvent(nil,"RightClickValue19",npc,1000)
		NLG.UpChar(FactionBattleTransferNPC)
	end
end

function EnterBattleMapTalk(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local entermsg = "2\n骚年你真的要进入这个残酷的PK场么？很危险的哦"
		NLG.ShowWindowTalked(player,FactionBattleTransferNPC,1,2,11,entermsg)
	end
end

function EnterBattleMapWindowTalk(npc,player,Seqno,Select,Data)
	if Select ~= 2 then
		--组队玩家传送至指定地图
		local playerStatus = Char.GetPartyMode(player)
		if(playerStatus == 0) then
		--0独自一人、1队长只有这两种状态可以传送
			Char.Warp(player,0,778,0,1)
		elseif(playerStatus == 1) then
			local partyNum = Char.PartyNum(player)
			for i=1,partyNum do
				local p = Char.GetPartyMember(player,i)
				Char.Warp(p,0,778,0,1)
			end
		else
			NLG.TalkToCli(player,-1,"让你们老大跟我说话！",%颜色_红色%)
		end
	end
end


--如何获取指定地图上的所有战斗指针？
-- NLG.GetMapPlayer(map,floor) 获取目标地图所有的玩家，并以table形式返回。
-- Char.GetBattleIndex(_Ptr) 获取对象_Ptr的战斗序号，战斗序号可以使用Battle库的函数进行操作
NL.RegBattleStartEvent(nil, "FactionBattleStart")
NL.RegBattleOverEvent(nil, "FactionBattleOver")
function FactionBattleStart(_battlePtr)
	--通过战斗获取玩家
	local player = Battle.GetPlayer(_battlePtr, 1)
	--获取玩家所在地图
	local playerMapNum = Char.GetData(player,%对象_MAP%)
	if playerMapNum == 778 then
		--如果玩家在指定地图，则将战斗类型设置为PVE
		--尼玛API里没有战斗类型!
		Battle.SetType(_battlePtr, 1)
	end
end
function FactionBattleOver(_battlePtr)
	--省略了指定地图的判断，以后再加。
	--最多会有0-19个对象指针，包括双方的人物+宠物
	local overTime = os.time();
	for i=0,19 do
		local player = Battle.GetPlayer(_battlePtr, i)
		--设置对象PK开关为关闭状态
		Char.SetData(player,"%对象_PK开关%",1)
		NLG.UpChar(player)
	end
	--如此会浪费大量的cpu时间，不知道效率是否会是个问题。
	--最好还是可以获取到PK事件，在PK事件中判断当前时间与overTime的差值是否超过指定时间。
	while os.time() - overTime < 18 do
		--18秒内什么都不干
	end
	for i=0,19 do
		local player = Battle.GetPlayer(_battlePtr, i)
		--设置对象PK开关为开启状态
		Char.SetData(player,"%对象_PK开关%",2)
		NLG.UpChar(player)
	end
end

--做个NPC来loop战斗时间
function CreateFactionBattleTimeNPC()
	if FactionBattleTimeNPC == nil then
		FactionBattleTimeNPC = NL.CreateNpc(nil,"FactionBattleNPCCharInit")
		Char.SetData(FactionBattleTimeNPC,%对象_形象%,100500)
		Char.SetData(FactionBattleTimeNPC,%对象_原形%,100500)
		Char.SetData(FactionBattleTimeNPC,%对象_地图%,778)
		Char.SetData(FactionBattleTimeNPC,%对象_X%,1)
		Char.SetData(FactionBattleTimeNPC,%对象_Y%,0)
		Char.SetData(FactionBattleTimeNPC,%对象_方向%,4)
		Char.SetData(FactionBattleTimeNPC,%对象_原名%,"阵营战计时npc")
		Char.SetLoopEvent(nil,"FactionBattleTimeNPCLoop",npc,1000)
		NLG.UpChar(FactionBattleTimeNPC)
	end
end

function FactionBattleTimeNPCLoop(_MePtr)
	--2hours
	--table.getn(tblTest1) 获取table长度
	if os.time() - battleBeginTime == 60*60*2 then
		local players = NLG.GetMapPlayer(0,778)
		local redNum = 0;
		local blueNum = 0;
		local redPlayers = {};
		local bluePlayers = {};
		for k,v in pairs(players) do
			local player = v;
			local playerColor = Char.GetData(Player,%对象_名色%);
			if playerColor == 1 do 
				redNum = redNum + 1;
				table.insert(redPlayers,player);
			elseif playerColor == 2 do 
				blueNum = blueNum + 1;
				table.insert(bluePlayers,player);
			end
		end
		if redNum > blueNum do 
			--红方阵营获胜
			local winnerFaction = "红方阵营胜利！";
			for k,v in pairs(redPlayers) do
				local player = v;
				--获胜者奖励
			end
		elseif redNum == blueNum do
			--平局
			local winnerFaction = "平局！";
			for k,v in pairs(redPlayers) do
				local player = v;
				--获胜者奖励
			end
			for k,v in pairs(bluePlayers) do
				local player = v;
				--获胜者奖励
			end
		elseif redNum < blueNum do
			--蓝方阵营获胜
			local winnerFaction = "蓝方阵营胜利！";
			for k,v in pairs(bluePlayers) do
				local player = v;
				--获胜者奖励
			end
		end
		--全服通报胜利结果
		NLG.SystemMessage(-1,"阵营PK大战已经结束，最终结果为：" .. winnerFaction);		
	end
end




--重新设计战斗控制逻辑
--首先注册右键事件和对话事件，并设置中间隐藏npc来完成对话及设置战斗的实现。
NL.RegRightClickEvent(nil,"factionBattleRightClickEvent")
Delegate.RegDelTalkEvent("RightClickValue3")
function factionBattleRightClickEvent(player1,player2)
	--貌似可以直接创建战斗
	local p1mapNum = Char.GetData(player,%对象_MAP%);
	local p2mapNum = Char.GetData(player,%对象_MAP%);
	if p1mapNum == 60006 and p2mapNum == 60006 then
		--在指定的阵营战地图
		local factionBattle = Battle.PVE(player1,player2);
		if factionBattle >= 0 then 
			--战斗创建成功
			Battle.SetWinEvent(nil,"factionBattleWinEvent",factionBattle)
		else
			--战斗创建失败
			NLG.SystemMessage(player1,"创建战斗失败。")
		end
	end
end

function factionBattleWinEvent(factionBattle)
	--0或者1,0表示战斗下方，即0-9位置的玩家；1表示上方，即10-19位置的玩家
	local winSide = Battle.GetWinSide(factionBattle);
	if winSide == 0 then 
		for i = 0,9 do
			local battleObj = Battle.GetPlayer(factionBattle,i);
			if battleObj >= 0 then
				if Char.GetData(battleObj,(%对象_序%)) == (%对象类型_人%) then
					NLG.SystemMessage(battleObj,"你所在的队伍胜利了！")
				end
			end
		end
	end
	if winSide == 1 then 
		for i = 10,19 do
			local battleObj = Battle.GetPlayer(factionBattle,i);
			if battleObj >= 0 then
				if Char.GetData(battleObj,(%对象_序%)) == (%对象类型_人%) then
					NLG.SystemMessage(battleObj,"你所在的队伍胜利了！")
				end
			end
		end
	end

	-- 所有玩家的战斗状态置为不可战斗
	-- 将所有玩家的阵营战结束时间记录下来
	for i = 0,19 do
		local battleObj = Battle.GetPlayer(factionBattle,i);
		if battleObj >= 0 then
			if Char.GetData(battleObj,(%对象_序%)) == (%对象类型_人%) then
				--Char.SetData(battleObj,"%对象_PK开关%",1);
				--upChar不知道能不能在方法未结束时即可生效？
				-- 使用lua控制是否可战斗状态，不使用原魔力实现
				-- 优化时需要考虑此处的battleObj对于同一个玩家是否一直是同一个对象
				-- 如不是的话可能会导致每场战斗都会增加这个数组的存储。
				-- %战斗_普通%	Battle.SetType()	普通战斗模式,会受伤
				battleSleep[battleObj] = os.time();
				--NLG.UpChar(battleObj);
			end
		end
	end
	
	--重新将玩家战斗状态设置为可战斗
	while os.time() - overTime < 18 do
		--18秒内什么都不干
	end
	for i = 0,19 do
		local battleObj = Battle.GetPlayer(factionBattle,i);
		if battleObj >= 0 then
			if Char.GetData(battleObj,(%对象_序%)) == (%对象类型_人%) then
				Char.SetData(battleObj,"%对象_PK开关%",2);
				--upChar不知道能不能在方法未结束时即可生效？
				NLG.UpChar(battleObj);
			end
		end
	end
end













