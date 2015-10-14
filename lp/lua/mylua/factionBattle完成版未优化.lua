
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
NL.RegRightClickEvent(nil,"factionBattleRightClickEvent");
Delegate.RegInit("FactionBattle_Init");

local factionBattleSleepTime = 30; --阵营战间隔时间
local battleBeginWeekday = "3";
local battleBeginTimeH = "22";
local battleBeginTimeM = "47";
local battleBeginTimeS = "00";
local battleLastTime = 1*60; --阵营战持续时间s
local battleOverFlag = false;
local transferFlag = true;
local battleBeginTime = os.date("%H%M", os.time());
local factionBattleTransferTime = 20*60*1000 --从阵营战开始到指定时间可以通过npc传送至阵营战战场
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
		Char.SetData(FactionBattleNPC,%对象_形象%,105000);
		Char.SetData(FactionBattleNPC,%对象_原形%,105000);
		Char.SetData(FactionBattleNPC,%对象_地图%,778);
		Char.SetData(FactionBattleNPC,%对象_X%,1);
		Char.SetData(FactionBattleNPC,%对象_Y%,0);
		Char.SetData(FactionBattleNPC,%对象_方向%,4);
		Char.SetData(FactionBattleNPC,%对象_原名%,"阵营战npc");
		Char.SetWindowTalkedEvent("lua/Module/factionBattle.lua","JoinFactionWindowTalk",FactionBattleNPC);
		Char.SetTalkedEvent("lua/Module/factionBattle.lua","JoinFactionTalk",FactionBattleNPC);
		--Char.SetLoopEvent(nil,"RightClickValue19",npc,1000);
		NLG.UpChar(FactionBattleNPC);
	end
end

function CreateFactionBattleClearNPC()
	if FactionBattleClearNPC == nil then
		FactionBattleClearNPC= NL.CreateNpc(nil,"FactionBattleNPCCharInit");
		Char.SetData(FactionBattleClearNPC,%对象_形象%,105000);
		Char.SetData(FactionBattleClearNPC,%对象_原形%,105000);
		Char.SetData(FactionBattleClearNPC,%对象_地图%,778);
		Char.SetData(FactionBattleClearNPC,%对象_X%,4);
		Char.SetData(FactionBattleClearNPC,%对象_Y%,0);
		Char.SetData(FactionBattleClearNPC,%对象_方向%,4);
		Char.SetData(FactionBattleClearNPC,%对象_原名%,"清空阵营战");
		Char.SetWindowTalkedEvent("lua/Module/factionBattle.lua","ClearFactionWindowTalk",FactionBattleClearNPC);
		Char.SetTalkedEvent("lua/Module/factionBattle.lua","ClearFactionTalk",FactionBattleClearNPC);
		NLG.UpChar(FactionBattleClearNPC);
	end
end

function ClearFactionTalk(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local fbmsg = "\n确认要恢复自由身么亲？".. "" .."\n\n1.确定\n2.还是算了";
		NLG.ShowWindowTalked(_tome,_me,2,2,120,fbmsg);
	end
end

function ClearFactionWindowTalk(npc,player,Seqno,Select,Data)
	print("Data=" .. Data);
	if Select ~= 2 then
		if Seqno == 120 then
		--首次进入对话事件
			local nameColor = Char.GetData(player,%对象_名色%);
			print("nameColor = " .. nameColor );
			if nameColor ~= 0 then
				if tonumber(Data) == 1 then
				--清空玩家颜色
					local nameColor = Char.GetData(player,%对象_名色%);
					Char.SetData(player,%对象_名色%,0);
					NLG.UpChar(player);
					local factionMsg1 = "\n恭喜你自由之身！";
					NLG.ShowWindowTalked(player,npc,1,2,1,factionMsg1);
				elseif tonumber(Data) == 2 then
				--取消
					local faction1Msg2 = "\n还是再想想清楚吧骚年！";
					NLG.ShowWindowTalked(player,npc,1,2,2,faction1Msg2);
				end
			else
				NLG.TalkToCli(player,-1,"您当前没有对应阵营！",%颜色_红色%);
			end
		elseif Seqno == 1 then
			--预留
		elseif Seqno == 2 then
			--预留
		end
	end
end

function JoinFactionTalk(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local fbmsg = "\n恭喜你完成了阵营战的系列任务，请选择要加入的阵营：".. "" .."\n\n1.红方\n2.蓝方";
		NLG.ShowWindowTalked(_tome,_me,2,2,110,fbmsg);
	end
end

function JoinFactionWindowTalk(npc,player,Seqno,Select,Data)

	print("Data=" .. Data);
	if Select ~= 2 then
		if Seqno == 110 then
		--首次进入对话事件
			local nameColor = Char.GetData(player,%对象_名色%);
			print("nameColor = " .. nameColor );
			if nameColor == 0 then
				if tonumber(Data) == 2 then
				--红方
				--改变玩家名称颜色  %对象_名色%
					local nameColor = Char.GetData(player,%对象_名色%);
					Char.SetData(payer,%对象_名色%,1);
					NLG.UpChar(payer);
					local factionMsg1 = "\n恭喜你成为红方大家庭中的一员，努力前进吧！";
					NLG.ShowWindowTalked(player,npc,1,2,1,factionMsg1);
				elseif tonumber(Data) == 3 then
				--蓝方
					local nameColor = Char.GetData(player,%对象_名色%);
					Char.SetData(player,%对象_名色%,2);
					NLG.UpChar(payer);
					local faction1Msg2 = "\n恭喜你成为蓝方大家庭中的一员，努力前进吧！";
					NLG.ShowWindowTalked(player,npc,1,2,2,faction1Msg2);
				end
			elseif nameColor == 1 then
				NLG.TalkToCli(player,-1,"您已经处于红方阵营。",%颜色_红色%);
			elseif nameColor == 2 then
				NLG.TalkToCli(player,-1,"您已经处于蓝方阵营",%颜色_红色%);
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
		FactionBattleTransferNPC = NL.CreateNpc(nil,"FactionBattleNPCCharInit");
		Char.SetData(FactionBattleTransferNPC,%对象_形象%,105000);
		Char.SetData(FactionBattleTransferNPC,%对象_原形%,105000);
		Char.SetData(FactionBattleTransferNPC,%对象_地图%,778);
		Char.SetData(FactionBattleTransferNPC,%对象_X%,2);
		Char.SetData(FactionBattleTransferNPC,%对象_Y%,0);
		Char.SetData(FactionBattleTransferNPC,%对象_方向%,4);
		Char.SetData(FactionBattleTransferNPC,%对象_原名%,"阵营战传送官");
		Char.SetWindowTalkedEvent("lua/Module/factionBattle.lua","EnterBattleMapWindowTalk",FactionBattleTransferNPC);
		Char.SetTalkedEvent("lua/Module/factionBattle.lua","EnterBattleMapTalk",FactionBattleTransferNPC);
		--loop用于控制npc的有效时间，以及设置
		--Char.SetLoopEvent("lua/Module/factionBattle.lua","LoopFactionBattleTransferTime",npc,1000);
		NLG.UpChar(FactionBattleTransferNPC);
	end
end

function EnterBattleMapTalk(_me,_tome)
	print("battleBeginTime = " .. battleBeginTime);
	print("remaining time = " .. (os.time() - battleBeginTime));
	if not transferFlag  then
		-- 传送时间已过
		if (NLG.CanTalk(_me,_tome) == true) then
			local entermsg = "\n骚年传送时间已经过了，下次早点来哦！";
			NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_关闭%,11,entermsg);
		end
	else
		if (NLG.CanTalk(_me,_tome) == true) then
			local entermsg = "\n骚年你真的要进入这个残酷的PK场么？很危险的哦";
			NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定关闭%,11,entermsg);
		end
	end
end

function EnterBattleMapWindowTalk(npc,player,Seqno,Select,Data)
	if Select ~= 2 then
		--组队玩家传送至指定地图
		local playerStatus = Char.GetPartyMode(player);
		if(playerStatus == 0) then
		--0独自一人、1队长只有这两种状态可以传送
			Char.Warp(player,0,60006,15,38);
		elseif(playerStatus == 1) then
			local partyNum = Char.PartyNum(player);
			for i=1,partyNum do
				local p = Char.GetPartyMember(player,i);
				Char.Warp(p,0,60006,15,38);
			end
		else
			NLG.TalkToCli(player,-1,"让你们老大跟我说话！",%颜色_红色%);
		end
	end
end

--做个NPC来loop战斗时间
function CreateFactionBattleTimeNPC()
	if FactionBattleTimeNPC == nil then
		FactionBattleTimeNPC = NL.CreateNpc(nil,"FactionBattleNPCCharInit");
		Char.SetData(FactionBattleTimeNPC,%对象_形象%,105000);
		Char.SetData(FactionBattleTimeNPC,%对象_原形%,105000);
		Char.SetData(FactionBattleTimeNPC,%对象_地图%,778);
		Char.SetData(FactionBattleTimeNPC,%对象_X%,3);
		Char.SetData(FactionBattleTimeNPC,%对象_Y%,0);
		Char.SetData(FactionBattleTimeNPC,%对象_方向%,4);
		Char.SetData(FactionBattleTimeNPC,%对象_原名%,"阵营战计时npc");
		Char.SetLoopEvent(nil,"FactionBattleTimeNPCLoop",FactionBattleTimeNPC,1000);
		NLG.UpChar(FactionBattleTimeNPC);
	end
end

function FactionBattleTimeNPCLoop(_MePtr)
	--2hours
	print("now date" .. os.time());

	if os.date("%w",os.time()) == battleBeginWeekday then

		local currentYear = os.date("%Y");
		local currentMonth = os.date("%m");
		local currentDay = os.date("%d");
		local targetBattleBeginTime = os.time({
		year = currentYear,
		month = currentMonth,
		day = currentDay,
		hour = battleBeginTimeH,
		min = battleBeginTimeM,
		sec = battleBeginTimeS
		});

		print("last time = " .. os.time() - targetBattleBeginTime);

		if (os.time() - targetBattleBeginTime) < 0 then
			return;
		end
		if  (os.time() - targetBattleBeginTime) < battleLastTime then
			print("crazy time!!");
			battleOverFlag = true;
			transferFlag = false;
		else
			if not battleOverFlag then
				return;
			end
			print("battle over!!");
			local winnerFaction;
			local players = NLG.GetMapPlayer(0,60006);
			local redNum = 0;
			local blueNum = 0;
			local redPlayers = {};
			local bluePlayers = {};
			for k,v in pairs(players) do
				local player = v;
				local playerColor = Char.GetData(player,%对象_名色%);
				if playerColor == 1 then 
					redNum = redNum + 1;
					table.insert(redPlayers,player);
				elseif playerColor == 2 then 
					blueNum = blueNum + 1;
					table.insert(bluePlayers,player);
				end
				--将所有玩家移出阵营战战场
				Char.Warp(player,0,778,0,0);
			end
			if redNum > blueNum then 
				--红方阵营获胜
				winnerFaction = "红方阵营胜利！";
				for k,v in pairs(redPlayers) do
					local player = v;
					--获胜者奖励
					NLG.TalkToCli(player,-1,"恭喜您获得了xxx奖励！。",%颜色_红色%);
				end
			elseif redNum == blueNum then
				--平局
				winnerFaction = "平局！";
				for k,v in pairs(redPlayers) do
					local player = v;
					--获胜者奖励
					NLG.TalkToCli(player,-1,"恭喜您获得了xxx奖励！。",%颜色_红色%);
				end
				for k,v in pairs(bluePlayers) do
					local player = v;
					--获胜者奖励
				end
			elseif redNum < blueNum then
				--蓝方阵营获胜
				winnerFaction = "蓝方阵营胜利！";
				for k,v in pairs(bluePlayers) do
					local player = v;
					--获胜者奖励
					NLG.TalkToCli(player,-1,"恭喜您获得了xxx奖励！。",%颜色_红色%);
				end
			end
			--全服通报胜利结果
			NLG.SystemMessage(-1,"阵营PK大战已经结束，最终结果为：" .. winnerFaction);
			battleOverFlag = false;
			transferFlag = true;
		end
	end
end

--重新设计战斗控制逻辑
--首先注册右键事件和对话事件，并设置中间隐藏npc来完成对话及设置战斗的实现。
function factionBattleRightClickEvent(player1,player2)
	RightClickValue4[player1] = player2;
	local rightClickInfo = "2\n你点击了玩家："..(Char.GetData(player2,%对象_原名%)).."\n\n1.发起挑战";
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
			local playerSleepTime1 = 0;
			local playerSleepTime2 = 0;
			if next(battleSleep) == nil then
				-- battleSleep没有被初始化过
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
			if playerSleepTime < factionBattleSleepTime then
				--自己的战斗间隔不足指定时间
				NLG.SystemMessage(player,"休息。。休息一下。。。" .. (factionBattleSleepTime-playerSleepTime) .. "秒后可继续战斗！")
				return;
			end
			if player2SleepTime < factionBattleSleepTime then 
				--对方的战斗间隔不足指定时间
				NLG.SystemMessage(player,"让你的对手休息一下。。" .. (factionBattleSleepTime-player2SleepTime).. "秒后可继续战斗！")
				return;
			end
			
			if Seqno == 100 then
				if tonumber(Data) == 1 then
					--貌似可以直接创建战斗
					local p1mapNum = Char.GetData(player,%对象_地图%);
					local p2mapNum = Char.GetData(player2,%对象_地图%);
					
					local p1health = Char.GetData(player,(%对象_血%));
					local p2health = Char.GetData(player2,(%对象_血%));
					local p1magic = Char.GetData(player,(%对象_魔%));
					local p2magic = Char.GetData(player2,(%对象_魔%));
					if p1mapNum == 60006 and p2mapNum == 60006 then
						--在指定的阵营战地图
						local factionBattle = Battle.PVP(player,player2);	
						Battle.SetType(factionBattle, %战斗_普通%); --期望将战斗设置为普通战斗，可受伤
						--进入pvp战斗后，将玩家的血量和魔法设置为当前值，而非满血满魔
						Char.SetData(player,%对象_血%,p1health);
						Char.SetData(player2,%对象_血%,p2health);
						Char.SetData(player,%对象_魔%,p1magic);
						Char.SetData(player2,%对象_魔%,p2magic);
						NLG.UpChar(player);
						NLG.UpChar(player2);
						if factionBattle >= 0 then 
							--战斗创建成功
							Battle.SetWinEvent(nil,"factionBattleWinEvent",factionBattle);
						else
							--战斗创建失败
							NLG.SystemMessage(player,"创建战斗失败。");
						end   
					end

				elseif tonumber(Data) == 2 then
					--预留
				end
			elseif Seqno == 11 then
				--预留
			end
		end
	end
end

--做个NPC来loop战斗时间
function CreateFactionBattleRightClickNPC()
	if FactionBattleRightClickNPC == nil then
		FactionBattleRightClickNPC = NL.CreateNpc(nil,"FactionBattleNPCCharInit");
		Char.SetData(FactionBattleRightClickNPC,%对象_形象%,105000);
		Char.SetData(FactionBattleRightClickNPC,%对象_原形%,105000);
		Char.SetData(FactionBattleRightClickNPC,%对象_地图%,778);
		Char.SetData(FactionBattleRightClickNPC,%对象_X%,5);
		Char.SetData(FactionBattleRightClickNPC,%对象_Y%,0);
		Char.SetData(FactionBattleRightClickNPC,%对象_方向%,4);
		Char.SetData(FactionBattleRightClickNPC,%对象_原名%,"阵营战右键功能");
		Char.SetWindowTalkedEvent(nil,"factionBattleRightClickEventNpc",FactionBattleRightClickNPC)
		--Char.SetLoopEvent(nil,"FactionBattleTimeNPCLoop",npc,1000);
		NLG.UpChar(FactionBattleRightClickNPC);
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
					print(Char.GetData(battleObj,(%对象_血%)));
					print(Char.GetData(battleObj,(%对象_魔%)));
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
					print(Char.GetData(battleObj,(%对象_血%)));
					print(Char.GetData(battleObj,(%对象_魔%)));
					NLG.SystemMessage(battleObj,"你所在的队伍胜利了！")
				end
			end
		end
	end

	--将所有玩家的阵营战结束时间记录下来
	for i = 0,19 do
		local battleObj = Battle.GetPlayer(factionBattle,i);
		if battleObj >= 0 then
			if Char.GetData(battleObj,(%对象_序%)) == (%对象类型_人%) then
				-- 使用lua控制是否可战斗状态，不使用原魔力实现
				battleSleep[battleObj] = os.time();
			end
		end
	end
end
