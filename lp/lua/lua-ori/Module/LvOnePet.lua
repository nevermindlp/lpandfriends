Delegate.RegDelBattleStartEvent("LvOnePet_Event");

function LvOnePet_Event(battle)
	for BWhile=10,19 do
		local PlayerIndex = Battle.GetPlayer(battle,BWhile);
		if(VaildChar(PlayerIndex)==true) then
			if(Char.GetData(PlayerIndex,%对象_等级%) == 1 and Char.GetData(PlayerIndex,%对象_名字%) ~= "哥布林" and Char.GetData(PlayerIndex,%对象_名字%) ~= "迷你蝙蝠") then
				for BPWhile=0,4 do
					local BPlayerIndex = Battle.GetPlayer(battle,BPWhile);
					if(BPlayerIndex >= 0) then
						NLG.TalkToCli(BPlayerIndex,-1,"[★☆★一级宠物★☆★]发现一级宠物「"..Char.GetData(PlayerIndex,%对象_名字%).."」出现！",%颜色_红色%,%字体_中%);
					end
				end
			end
		end
	end
end
