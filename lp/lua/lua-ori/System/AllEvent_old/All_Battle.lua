--战斗开始全局事件
function All_BattleStartEvent(battle)
	-- BattleStart delegate begin
	for _,Func in ipairs(tbl_delegate_BattleStartEvent) do
    local f = loadstring(Func.."("..battle..")");	
	f();
    end
	-- end
	return;
end


 --战斗结束全局事件
function All_BattleOverEvent(battle)
	-- BattleOver delegate begin
	for _,Func in ipairs(tbl_delegate_BattleOverEvent) do
    local f = loadstring(Func.."("..battle..")");	
	f();
    end
	-- end
	return;
end

