--ս����ʼȫ���¼�
function All_BattleStartEvent(battle)
	-- BattleStart delegate begin
	for _,Func in ipairs(tbl_delegate_BattleStartEvent) do
    local f = loadstring(Func.."("..battle..")");	
	if(f~=nil)then
		f();
	end
    end
	-- end
	return;
end


 --ս������ȫ���¼�
function All_BattleOverEvent(battle)
	-- BattleOver delegate begin
	for _,Func in ipairs(tbl_delegate_BattleOverEvent) do
    local f = loadstring(Func.."("..battle..")");	
	if(f~=nil)then
		f();
	end
    end
	-- end
	return;
end

