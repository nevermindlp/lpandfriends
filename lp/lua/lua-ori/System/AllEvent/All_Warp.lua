function All_WarpEvent(player,x,y)

	for _,Func in ipairs(tbl_delegate_WarpEvent) do
    local f = loadstring(Func.."("..player..")");		
	if(f~=nil)then
		f();
	end
    end
	return;
end