
function All_BattleSkillExpEvent(Object, skill, exp)
	
	local expcount = 0;
	for _,Func in ipairs(tbl_delegate_BattleSkillExpEvent) do
    local f = loadstring("return "..Func.."("..Object..","..skill..","..exp..")");	
	local total = 0;
	if(f~=nil)then
		total = f();
	end
	expcount = expcount + total;
    end
		
	if (expcount == 0) then
		return expcount;
	end
	
	return expcount;
end


function All_ProductSkillExpEvent(Object, skill, exp)
	
	local expcount = 0;
	for _,Func in ipairs(tbl_delegate_ProductSkillExpEvent) do
    local f = loadstring("return "..Func.."("..Object..","..skill..","..exp..")");	
	local total = 0;
	if(f~=nil)then
		total = f();
	end
	expcount = expcount + total;
    end
	
	if (expcount == 0) then
		return expcount;
	end
	
	return expcount;
end


function All_GetExpEvent(Object, exp)
	
	local expcount = 0;
	for _,Func in ipairs(tbl_delegate_GetExpEvent) do
    local f = loadstring("return "..Func.."("..Object..","..exp..")");	
	local total = 0;
	if(f~=nil)then
		total = f();
	end
	expcount = expcount + total;
    end
	
	if (expcount == 0) then
		return expcount;
	end
	
	return expcount;
	
end