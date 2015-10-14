 --说话全局事件
function All_TalkEvent(player,msg,color,range,size)
    -- TalkEvent delegate begin
	for _,Func in pairs(tbl_delegate_TalkEvent) do	
    local f =loadstring(Func.."("..player..",\""..msg.."\","..color..","..range..","..size..")");	
	f();
    end
	-- end
	return;
end
