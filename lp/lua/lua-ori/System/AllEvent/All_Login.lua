--��ҵ�¼ȫ���¼�
function All_LoginEvent(player)
	for _,Func in ipairs(tbl_delegate_LoginEvent) do
    local f = loadstring(Func.."("..player..")");	
	if(f~=nil)then
		f();
	end
    end
	
	
	return;
end


--����뿪ȫ���¼�
function All_DropEvent(player)

	for _,Func in ipairs(tbl_delegate_DropEvent) do
    local f = loadstring(Func.."("..player..")");	
	if(f~=nil)then
		f();
	end
    end
	All_AllOutEvent(player);
	return;
end

--��ҵǳ�ȫ���¼�
function All_LogoutEvent(player)

	for _,Func in ipairs(tbl_delegate_LogoutEvent) do
    local f = loadstring(Func.."("..player..")");	
	if(f~=nil)then
		f();
	end
    end
	All_AllOutEvent(player);
	return;
end

--��ҵǻس�ȫ���¼�
function All_LoginGateEvent(player)

	for _,Func in ipairs(tbl_delegate_LoginGateEvent) do
    local f = loadstring(Func.."("..player..")");	
	if(f~=nil)then
		f();
	end
    end
	return;
end

--����뿪�¼�
function All_AllOutEvent(player)

	for _,Func in ipairs(tbl_delegate_AllOutEvent) do
    local f = loadstring(Func.."("..player..")");	
	if(f~=nil)then
		f();
	end
    end
	return;
end

