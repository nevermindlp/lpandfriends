--[[
异族入侵设计
1、设置NPC每晚8点触发(指定职业带队)
2、创建20个npc （2bos、6中、12小）
3、设置NPC对话。
4、进入战斗设置标记
5、结束战斗设置标记（获胜）
6、设置遇敌（贼拉长的字符串）
7、定时清场
]]--

Delegate.RegInit("invade_init");

local minEnterLv = 20;
local preShowProfessionInfoTime = 5*60;
local wholLeaderInfo = {1 = '弓箭手' , 2 = '战斧' , 3 = '魔道士' , 4 = '剑士'};
local professionId;
local professionName;
local canEnterFlag = false;
local playerAndBoss = playerAndBoss or {};


local bossSet ={
['传说级入侵者1号'] = {'deadFlag' = false , 'canBattleFlag' = true , 'info' = '3|0,20003,43,7||0|||||0|10007|||||||||'} ,
['传说级入侵者2号'] = {'deadFlag' = false , 'canBattleFlag' = true , 'info' = '3|0,20003,43,7||0|||||0|10007|||||||||'} ,
['精英入侵者1号'] = {'deadFlag' = false , 'canBattleFlag' = true , 'info' = '3|0,20003,43,7||0|||||0|10007|||||||||'} ,
['精英入侵者2号'] = {'deadFlag' = false , 'canBattleFlag' = true , 'info' = '3|0,20003,43,7||0|||||0|10007|||||||||'} ,
['入侵者1号'] = {'deadFlag' = false , 'canBattleFlag' = true , 'info' = '3|0,20003,43,7||0|||||0|10007|||||||||'} ,
['入侵者2号'] = {'deadFlag' = false , 'canBattleFlag' = true , 'info' = '3|0,20003,43,7||0|||||0|10007|||||||||'}};

--触发时间设置
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
		Char.SetData(invadeGateNPC,%对象_形象%,100500);
		Char.SetData(invadeGateNPC,%对象_原形%,100500);
		Char.SetData(invadeGateNPC,%对象_地图%,778);
		Char.SetData(invadeGateNPC,%对象_X%,1);
		Char.SetData(invadeGateNPC,%对象_Y%,5);
		Char.SetData(invadeGateNPC,%对象_方向%,4);
		Char.SetData(invadeGateNPC,%对象_原名%,"异族入侵门卫");
		Char.SetWindowTalkedEvent("lua/Module/invade.lua","invadeGateNPCWindowTalk",invadeGateNPC);
		Char.SetTalkedEvent("lua/Module/invade.lua","invadeGateNPCTalk",invadeGateNPC);
		Char.SetLoopEvent("lua/Module/invade.lua","invadeTimeNPCLoop",invadeGateNPC,1000);
		NLG.UpChar(invadeGateNPC);
	end
end

function invadeTimeNPCLoop(_MePtr)
--循环中需要：1、判断玩家可以进入的时间。2、判断传出玩家时间。3、提前5分钟提示需要领队的职业

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
		--5分钟提示，并且随机生成领队职业
		if targetInvadeBeginTime - os.time() = preShowProfessionInfoTime then
			math.randomseed(tostring(os.time()));
			professionId = math.random(4);
			professionName = wholLeaderInfo[randomNum];
			NLG.SystemMessage(-1,"外族入侵需要的领队职业为：" .. professionName);
		end
	--判断进场标识
		if os.time() - targetInvadeBeginTime < invadeBattleLastTime  and os.time() - invadeBeginTime > 0 then
			canEnterFlag = true;
		end
	--清除玩家
		if os.time() - targetInvadeBeginTime == invadeBattleLastTime then
			local players = NLG.GetMapPlayer(0,60006);
			for k,v in pairs(players) do
				--将所有玩家移出阵营战战场
				Char.Warp(player,0,778,0,0);
			end
			canEnterFlag = false;
			NLG.SystemMessage(-1,"外族入侵战斗结束。" );
		end
	end

end

function invadeGateNPCTalk(_me,_tome)
	if canEnterFlag then
		local msg = "本次入侵战的领队职业为：" .. professionName .. "你已经做好准备了么？！";
		NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定%+%按钮_否%,820,msg);
	else
		local msg = "时候未到。。"
		NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_关闭%,830,msg);
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
		local playerLv = Char.GetData(_me,%对象_等级%);
		if playerLv < minEnterLv then
			NLG.TalkToCli(player,-1,"入侵任务的最低等级要求是" .. minEnterLv .. "级", %颜色_黄色%);
		else
			--组队玩家传送至指定地图
			local playerStatus = Char.GetPartyMode(player);
			if(playerStatus == 0) then
			--0独自一人、1队长只有这两种状态可以传送
				local tmpprofession = Char.GetData(player,%对象_职业%);
				if tmpprofession == professionName then
					Char.Warp(player,0,60006,15,38);
				else
					NLG.TalkToCli(player,-1,"本次入侵任务的领队职业是：" .. professionName, %颜色_黄色%);
				end
			elseif(playerStatus == 1) then
				local tmpprofession = Char.GetData(player,%对象_职业%);
				if tmpprofession == professionName then
					local partyNum = Char.PartyNum(player);
					for i=1,partyNum do
						local p = Char.GetPartyMember(player,i);
						Char.Warp(p,0,60006,15,38);
					end
				else
					NLG.TalkToCli(player,-1,"本次入侵任务的领队职业是：" .. professionName, %颜色_黄色%);
				end
			else
				NLG.TalkToCli(player,-1,"让你们老大跟我说话！",%颜色_红色%);
			end
		end
	end
end


----------------创建大量NPC-----------------
local boss1CanBattleFlag = true;
local boss1DeadFlag = false;
function createInvadeBoss1()
	if invadeBossNPC1 == nil then
		invadeBossNPC1 = NL.CreateNpc(nil,true);
		Char.SetData(invadeBossNPC1,%对象_形象%,105000);
		Char.SetData(invadeBossNPC1,%对象_原形%,105000);
		Char.SetData(invadeBossNPC1,%对象_地图%,778);
		Char.SetData(invadeBossNPC1,%对象_X%,3);
		Char.SetData(invadeBossNPC1,%对象_Y%,5);
		Char.SetData(invadeBossNPC1,%对象_方向%,4);
		Char.SetData(invadeBossNPC1,%对象_原名%,"传说级入侵者");
		Char.SetWindowTalkedEvent("lua/Module/invade..lua","invadeBossNPCWindowTalk",invadeBossNPC1);
		Char.SetTalkedEvent("lua/Module/invade..lua","invadeBossNPCTalk",invadeBossNPC1);
		NLG.UpChar(invadeBossNPC1);
	end
end
function invadeBossNPCTalk(_me,_tome)
	local bossName = Char.GetData(_tome,%对象_原名%);
	local bossDeadFlag = bossSet[bossName][deadFlag];
	local bossCanBattleFlag = bossSet[bossName][canBattleFlag];
	if not bossDeadFlag then
		if bossCanBattleFlag then
			local msg = "来战吧！不怕死的虫子！";
			NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定%+%按钮_否%,1000,msg);
		else
			local msg = "我正忙着对付别人呢！"
			NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_关闭%,1001,msg);
		end
	else
		local msg = "我还会回来的！"
		NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_关闭%,1002,msg);
	end
end

function invadeBossNPCWindowTalk(npc,player,Seqno,Select,Data)
	if Select == 8 then
		return;
	end
	if Select ~= 2 then
		if Seqno == 1000 then
			boss1CanBattleFlag = false;
			local npcName = Char.GetData(npc,%对象_原名%);
			local bossInfo = bossSet[npcName][info];
			local battle = Battle.Encount(player,npc,bossInfo);
			if battle >= 0 then
				--战斗创建成功
				bossSet[npcName][canBattleFlag] = false;
				Battle.SetWinEvent(nil,"battleWinEvent",battle);
			else
				--战斗创建失败
				NLG.SystemMessage(player,"创建战斗失败。");
			end
		end
	end
end
function battleWinEvent(_battlePtr,_chrPtr)
	print("name=" .. Char.GetData(_chrPtr,%对象_原名%));
	--如果name为玩家：那就废了。。只能通过bos战中有特殊名字的标识来进行控制。或者！：通过玩家与npc对话将玩家和bos对应起来。playerAndBoss[_chrPtr]= bos
	--如果name为npc：可以通过此指针来进行单例控制。 _chrPtr = bos
	local bossPtr;
	local bossName = Char.GetData(bossPtr,%对象_原名%);
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
