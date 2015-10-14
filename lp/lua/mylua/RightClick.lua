local FontColor = %颜色_红色% --私聊颜色
local WaitTime =  60 --迎战等待时间 秒
local DuleGroup = 1 --是否允许组队挑战 1为允许 否则为不允许
local DuleGroupMsg = "当前为组队挑战模式，双方都可以自由寻找队友加入自己。"
local jstzTalk = "/接受挑战" --接受挑战时输入的指令
local jjtzTalk = "/拒绝挑战" --拒绝挑战时输入的指令
local lqjjTalk = "/领取奖金" --领取奖金时输入的指令
local MaxGold = 10000000 --玩家魔币上限

--[[ 常用颜色列表
	%颜色_白色%
	%颜色_青色%
	%颜色_紫色%
	%颜色_蓝色%
	%颜色_黄色%
	%颜色_绿色%
	%颜色_红色%
	%颜色_灰色%
	%颜色_灰蓝色%
	%颜色_灰绿色%
]]

--服务器重启后，所有未领取的奖金和下注魔币都会清空。
-------------------------------------------------------------
NL.RegRightClickEvent(nil,"RightClickValue1")
Delegate.RegDelLoginEvent("RightClickValue2")
Delegate.RegDelTalkEvent("RightClickValue3")

RightClickValue4 = RightClickValue4 or {}
RightClickValue5 = RightClickValue5 or {} 
RightClickValue6 = RightClickValue6 or {}
RightClickValue7 = RightClickValue7 or {}
function RightClickValue2(player)
	RightClickValue4[player] = nil
end

function RightClickValue8(RightClickValue15)
	local RightClickValue9 = Battle.GetWinSide(RightClickValue15)
	if RightClickValue6[RightClickValue7[RightClickValue15][RightClickValue9+1]] == nil then
		RightClickValue6[RightClickValue7[RightClickValue15][RightClickValue9+1]] = 2 * RightClickValue7[RightClickValue15][3]
	else
		RightClickValue6[RightClickValue7[RightClickValue15][RightClickValue9+1]] = RightClickValue6[RightClickValue7[RightClickValue15][RightClickValue9+1]] + 2 * RightClickValue7[RightClickValue15][3]
	end
	for i = 0,9 do
		local RightClickValue10 = Battle.GetPlayer(RightClickValue15,(i+10*RightClickValue9))
		if RightClickValue10 >= 0 then
			if Char.GetData(RightClickValue10,(%对象_序%)) == (%对象类型_人%) then
				NLG.SystemMessage(RightClickValue10,"你所在的队伍胜利了！队长请尽快输入 "..lqjjTalk.." 以领取奖金。未被领取的奖金会在服务器重启后消失。")
			end
		end
	end
end


function RightClickValue3(player,RightClickValue17,color,range,size)
	local RightClickValue11 = Char.GetData(player,%对象_CDK%)
	if RightClickValue17 == jstzTalk then
		if RightClickValue5[player] ~= nil then
			local RightClickValue12 = RightClickValue5[player][1]
			local RightClickValue13 = Char.GetData(RightClickValue12,%对象_CDK%)
			local RightClickValue14 = Char.GetData(player,%对象_金币%)
			if RightClickValue14 >= RightClickValue5[player][4] then
				if DuleGroup ~= 1 then
					Char.DischargeParty(player)
					Char.DischargeParty(RightClickValue12)
				end
				local RightClickValue15 = Battle.PVP(player,RightClickValue12)
				if RightClickValue15 >= 0 then
					Char.SetData(player,%对象_金币%,RightClickValue14-RightClickValue5[player][4])
					NLG.UpChar(player)
					Battle.SetWinEvent(nil,"RightClickValue8",RightClickValue15)
					RightClickValue7[RightClickValue15] = {RightClickValue11,RightClickValue13,RightClickValue5[player][4]}
					RightClickValue5[player] = nil
				else
					NLG.SystemMessage(player,"创建战斗失败。")
				end
			else
				NLG.SystemMessage(player,"你的魔币不足以接受此次挑战。")
			end
		else
			NLG.SystemMessage(player,"没有针对于您的挑战或挑战已超时。")
		end
		return 0
	elseif RightClickValue17 == jjtzTalk then
		if RightClickValue5[player] ~= nil then
			local RightClickValue16 = RightClickValue6[RightClickValue5[player][3]]
			if RightClickValue16 == nil then
				RightClickValue16 = 0
			end
			RightClickValue16 = RightClickValue16 + RightClickValue5[player][4]
			RightClickValue6[RightClickValue5[player][3]] = RightClickValue16
			NLG.SystemMessage(RightClickValue5[player][1],"对方已拒绝您发起的挑战，您已下注的魔币已转为奖金。您可以输入 "..lqjjTalk.." 来提领。")
			NLG.SystemMessage(player,"您已拒绝此挑战。")
			RightClickValue5[player] = nil
		else
			NLG.SystemMessage(player,"没有针对于您的挑战或挑战已超时。")
		end
		return 0
	elseif RightClickValue17 == lqjjTalk then
		local RightClickValue16 = RightClickValue6[RightClickValue11]
		if RightClickValue16 == nil then
			RightClickValue16 = 0
		end
		if RightClickValue16 > 0 then
			local RightClickValue14 = Char.GetData(player,%对象_金币%)
			if RightClickValue14 < MaxGold then
				if RightClickValue14 + RightClickValue16 <= MaxGold then
					RightClickValue6[RightClickValue11] = nil
					Char.SetData(player,%对象_金币%,(RightClickValue14 + RightClickValue16))
					NLG.UpChar(player)
					NLG.SystemMessage(player,"奖金领取成功。")
				else
					RightClickValue6[RightClickValue11] = (RightClickValue16 + RightClickValue14 - MaxGold)
					Char.SetData(player,%对象_金币%,MaxGold)
					NLG.UpChar(player)
					NLG.SystemMessage(player,"您的魔币太多了，只能部分领取。存好身上的魔币后可继续领取剩余的奖金。")
				end
			else
				NLG.SystemMessage(player,"您的魔币已满。无法领取奖金。")
			end
		else
			NLG.SystemMessage(player,"您没有尚未领取的奖金。")
		end
		return 0
	end
end

function RightClickValue1(player,RightClickValue12)
	RightClickValue4[player] = RightClickValue12
	local RightClickValue17 = "2\n你点击了玩家："..(Char.GetData(RightClickValue12,%对象_原名%)).."\n\n1.对他私聊\n2.发起挑战"
	NLG.ShowWindowTalked(player,RightClickValue21,2,2,0,RightClickValue17)
end

function RightClickValue18(npc,player,Seqno,Select,Data)
	if Select ~= 2 then
		local RightClickValue12 = RightClickValue4[player]
		if RightClickValue12 ~= nil and RightClickValue12 >= 0 then
			local RightClickValue11 = Char.GetData(player,%对象_CDK%)
			local RightClickValue13 = Char.GetData(RightClickValue12,%对象_CDK%)
			if Seqno == 0 then
				if tonumber(Data) == 1 then
					local RightClickValue17 = "\n请输入你要对"..(Char.GetData(RightClickValue12,%对象_原名%)).."说的话后点击确定："
					NLG.ShowWindowTalked(player,npc,1,3,11,RightClickValue17)
				elseif tonumber(Data) == 2 then
					local RightClickValue17 = "\n请输入你要对"..(Char.GetData(RightClickValue12,%对象_原名%)).."发起挑战的下注金额后点击确定："
					NLG.ShowWindowTalked(player,npc,1,3,21,RightClickValue17)
				end
			elseif Seqno == 11 then
				if Select == 1 then
					NLG.TalkToCli(RightClickValue12,player,Data,FontColor)
					RightClickValue4[player] = nil
				end
			elseif Seqno == 21 then
				if Select == 1 then
					if RightClickValue5[RightClickValue12] == nil then
						if tonumber(Data) ~= nil and tonumber(Data) > 0 and tonumber(Data) <= MaxGold then
							local RightClickValue14 = Char.GetData(player,%对象_金币%)
							if RightClickValue14 >= tonumber(Data) then
								Char.SetData(player,%对象_金币%,RightClickValue14-tonumber(Data))
								NLG.UpChar(player)
								local RightClickValue17 = "Lv"..(Char.GetData(player,%对象_等级%)).."的"..(Char.GetData(player,%对象_原名%)).."下注"..Data.."魔币对你发起了挑战！"..WaitTime.."秒内输入 "..jstzTalk.." 或 "..jjtzTalk.." 应对此次挑战，否则默认为拒绝。"
								if DuleGroup == 1 then
									RightClickValue17 = RightClickValue17..DuleGroupMsg
								end
								NLG.SystemMessage(RightClickValue12,RightClickValue17)
								RightClickValue17 = "挑战已经发出，请等待对方的回应。"
								if DuleGroup == 1 then
									RightClickValue17 = RightClickValue17..DuleGroupMsg
								end
								NLG.SystemMessage(player,RightClickValue17)
								RightClickValue5[RightClickValue12] = {player,(os.time()+WaitTime),RightClickValue11,tonumber(Data)}
								RightClickValue4[player] = nil
							else
								NLG.SystemMessage(player,"你的魔币不足。")
								RightClickValue4[player] = nil
							end
						else
							NLG.SystemMessage(player,"请输入合理的下注金额。")
							RightClickValue4[player] = nil
						end
					else
						NLG.SystemMessage(player,"对方正在处理挑战中。无法接受您的挑战。")
					end
				end
			end
		end
	end
end

function RightClickValue19(npc)
	for k,v in pairs(RightClickValue5) do
		if os.time() > v[2] then
			local RightClickValue16 = RightClickValue6[v[3]]
			if RightClickValue16 == nil then
				RightClickValue16 = 0
			end
			RightClickValue16 = RightClickValue16 + v[4]
			RightClickValue6[v[3]] = RightClickValue16
			RightClickValue5[k] = nil
			NLG.SystemMessage(v[1],"您发起的挑战已过期，您已下注的魔币已转为奖金。您可以输入 "..lqjjTalk.." 来提领。")
		end
	end
end

function RightClickValue20(npc)
	Char.SetData(npc,%对象_形象%,100500)
	Char.SetData(npc,%对象_原形%,100500)
	Char.SetData(npc,%对象_地图%,777)
	Char.SetData(npc,%对象_X%,1)
	Char.SetData(npc,%对象_Y%,0)
	Char.SetData(npc,%对象_方向%,4)
	Char.SetData(npc,%对象_原名%,"右键功能")
	Char.SetWindowTalkedEvent(nil,"RightClickValue18",npc)
	Char.SetLoopEvent(nil,"RightClickValue19",npc,1000)
	NLG.UpChar(npc)
	return true
end

if RightClickValue21 == nil or RightClickValue21 < 0 then
	RightClickValue21 = NL.CreateNpc(nil,"RightClickValue20")
end