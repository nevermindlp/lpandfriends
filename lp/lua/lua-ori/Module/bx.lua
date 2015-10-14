function str_format(str,str_len,str_type)
	if(str_type == 1) then
		str_tmp=string.format("%"..str_len.."s", str);
	elseif(str_type == 2) then
		str_tmp=string.format("%-"..str_len.."s", str);
	elseif(str_type == 3) then
		local tmp_splace=math.floor((str_len-string.len(str))/2)+string.len(str);
		str_tmp=string.format("%"..tmp_splace.."s", str);
		str_tmp=string.format("%-"..str_len.."s", str_tmp);
	end
	return str_tmp;
end

function ItemFarm_func(_PlayerIndex, _ItemPos,yudilv,yudibushu)
	if Char.PartyNum(_PlayerIndex) ~=1 then
		if Char.GetPartyMember(_PlayerIndex,0) ~= _PlayerIndex then
			NLG.SystemMessage(_PlayerIndex,"���״̬�±����ɶӳ�ʹ��ม�");
			return
		end
	end
	local getXiangVar1 = Char.GetData(_PlayerIndex,%����_�㲽��%);
	local getXiangVar2 = Char.GetData(_PlayerIndex,%����_������%);
	if getXiangVar1 ~=0 then
		NLG.SystemMessage(_PlayerIndex,"���Ѿ�ʹ������ħ�㣬�޷�����ʹ���ˡ�");
		return;
	end
	local ItemIndex_tmp=Char.GetItemIndex(_PlayerIndex, _ItemPos);
	--[[for i=0,100 do
		print( i..":"..Item.GetData(ItemIndex_tmp,i));
	end
	if(1)then
		return;
	end--]]
	local duidie = Item.GetData(ItemIndex_tmp,%����_�ѵ���%);
	if duidie == 1 then 
		Item.Kill(_PlayerIndex, ItemIndex_tmp, _ItemPos);
		Item.UpItem(_PlayerIndex, _ItemPos);
	else
		Item.SetData(ItemIndex_tmp,%����_�ѵ���%,duidie-1);
		Item.UpItem(_PlayerIndex, _ItemPos);
	end
	--local getXiangVar1 = Char.GetData(_PlayerIndex,%����_�㲽��%);
	--local getXiangVar2 = Char.GetData(_PlayerIndex,%����_������%);
	if getXiangVar1 ~=0 then
		NLG.SystemMessage(_PlayerIndex,"����ϵͳ�Ѿ��������״̬���ӡ�");
	end
	if (getXiangVar1 == nil) then
		getXiangVar1 = 0;
	end
	
	Char.SetData(_PlayerIndex,%����_�㲽��%,getXiangVar1 + yudibushu);
	Char.SetData(_PlayerIndex,%����_������%,yudilv);
	--Char.SetData(_PlayerIndex,%����_������%,yudilv);
	--NLG.TalkToCli(_PlayerIndex,-1,"��:"..Char.GetData(_PlayerIndex,%����_�㲽��%).."��:"..Char.GetData(_PlayerIndex,%����_������%).."��2:"..Char.GetData(_PlayerIndex,%����_������%),%��ɫ_��ɫ%,%����_��%);
	
	
	getXiangVar1 = Char.GetData(_PlayerIndex,%����_�㲽��%);
	getXiangVar2 = Char.GetData(_PlayerIndex,%����_������%);
		if(getXiangVar1~=nil and getXiangVar2~=nil)then
			if(getXiangVar1==0)then
				Field.Set(_PlayerIndex, "xiang_use", 0);
				Field.Set(_PlayerIndex, "xiang_foot", 0);
				Field.Set(_PlayerIndex, "xiang_max", 0);
			else
				Field.Set(_PlayerIndex, "xiang_use", 1);
				Field.Set(_PlayerIndex, "xiang_foot", getXiangVar1);
				Field.Set(_PlayerIndex, "xiang_max", getXiangVar2);
			end
		end
		NLG.SystemMessage(_PlayerIndex,"�������Ѿ���¼��������ħ�㲽����");
		NLG.SystemMessage(_PlayerIndex,"��ħ���Ѿ���ʼ��Ч��");
end

Delegate.RegDelLoginEvent("bx_LoginEvent");

function bx_LoginEvent(player)
	
	local xiang_use=tonumber(Field.Get(player, "xiang_use"));
	local xiang_foot=tonumber(Field.Get(player, "xiang_foot"));
	local xiang_max=tonumber(Field.Get(player, "xiang_max"));
	if 	(xiang_use == 1 and xiang_foot > 0) then
		Char.SetData(player,%����_�㲽��%,xiang_foot);
		Char.SetData(player,%����_������%,xiang_max);
		NLG.SystemMessage(player,"���ϴ�����ʱ��ħ����ʣ�ಽ����ϵͳ�Զ�Ϊ���ָ�ʹ�á�");
	end


end

Delegate.RegDelBattleStartEvent("bx_BattleStart_Event");

function bx_BattleStart_Event(battle)
	
	local _PlayerIndex = Battle.GetPlayer(battle,0);
	if(VaildChar(_PlayerIndex)==true) then
		local getXiangVar1 = Char.GetData(_PlayerIndex,%����_�㲽��%);
	    local getXiangVar2 = Char.GetData(_PlayerIndex,%����_������%);
		if(getXiangVar1~=nil and getXiangVar2~=nil)then
			if(getXiangVar1 <= 10)then
				Field.Set(_PlayerIndex, "xiang_use", 0);
				Field.Set(_PlayerIndex, "xiang_foot", 0);
				Field.Set(_PlayerIndex, "xiang_max", 0);
			else
				Field.Set(_PlayerIndex, "xiang_use", 1);
				Field.Set(_PlayerIndex, "xiang_foot", getXiangVar1);
				Field.Set(_PlayerIndex, "xiang_max", getXiangVar2);
			end
		end
		
			
	end
	
end

Delegate.RegDelAllOutEvent("bx_OutEvent");

function bx_OutEvent(player)
	
		local getXiangVar1 = Char.GetData(player,%����_�㲽��%);
	    local getXiangVar2 = Char.GetData(player,%����_������%);
		if(getXiangVar1~=nil and getXiangVar2~=nil)then
			if(getXiangVar1 <= 10)then
				Field.Set(player, "xiang_use", 0);
				Field.Set(player, "xiang_foot", 0);
				Field.Set(player, "xiang_max", 0);
			else
				Field.Set(player, "xiang_use", 1);
				Field.Set(player, "xiang_foot", getXiangVar1);
				Field.Set(player, "xiang_max", getXiangVar2);
			end
		end		
	
end
