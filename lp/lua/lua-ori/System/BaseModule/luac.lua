tbl_daily = {};



function ScriptCall(npc, player, s)
	if(string.find(s,"getbanklimit"))then
		return tonumber(Char.GetData(player, %����_�����������%));
    end
	
	
	if(string.find(s,"setbanklimit40"))then
		Char.SetData(player, %����_�����������%,40);

		return 0;
    end

	if(string.find(s,"setbanklimit60"))then
		Char.SetData(player, %����_�����������%,60);

		return 0;
    end

	if(string.find(s,"setbanklimit80"))then
		Char.SetData(player, %����_�����������%,80);

		return 0;
    end

	if(string.find(s,"getdefcount"))then
		if(tbl_dropinfo[Playerkey(player)].leftCount == nil)then
			return 0;
		end
		return tbl_dropinfo[Playerkey(player)].leftCount;
	end

	if(string.find(s,"adddefcount"))then	
		
		if(tbl_dropinfo[Playerkey(player)] == nil)then
			tbl_dropinfo[Playerkey(player)].leftCount = 0;
		else
			tbl_dropinfo[Playerkey(player)].leftCount = tonumber(tbl_dropinfo[Playerkey(player)].leftCount) + 1;
		end
		return 1;
	end
	
	if(string.find(s,"addfame"))then
		local sv = string.gsub(s, "addfame", "");
		local tfame = tonumber(Char.GetData(player,%����_����%));
		Char.SetData(player,%����_����%,tfame + tonumber(sv));
		NLG.TalkToCli(player,-1,"����������:"..sv.."��.",%��ɫ_��ɫ%,%����_��%);
	end
	
	if(string.find(s,"enstart"))then
		
		local sv = string.gsub(s, "enstart", "");
		local _itemindex = Char.HaveItem(player,tonumber(sv));
		local wz = 0;
		for i=8,27 do
			local ls_itemindex = Char.GetItemIndex(player,i);
			if(_itemindex == ls_itemindex)then
				wz = i;
				break;
				
			end
		end
		if(wz == 0)then
			return;
		end
		local _zc1 = Item.GetData(_itemindex,%����_�Ӳ�һ%);
		local _zc2 = Item.GetData(_itemindex,%����_�Ӳζ�%);
--	    NLG.TalkToCli(player,-1,"��һ:".._zc1.."�ζ�:".._zc2.."λ��:"..wz.."index:".._itemindex,%��ɫ_��ɫ%,%����_��%);
		ItemFarm_func(player, wz,_zc1,_zc2);
	end
	
	if(string.find(s,"daily"))then
		local sv = string.gsub(s, "daily", "");	
		local playerkeyname = Playerkey(player)..sv;
		if(tbl_daily[playerkeyname] == nil)then
			tbl_daily[playerkeyname] = os.time();
			return 1;
		end
						
		if (os.date("%d",tbl_daily[playerkeyname]) ~= os.date("%d",os.time())) then 
			tbl_daily[playerkeyname] = os.time();
			return 1;
		end
		
		return 0;
	end
	
	if(string.find(s,"setnpass"))then
		kickbot_NpassTime[player] = os.time();
	end
	
	if(string.find(s,"getswjjczt"))then
		return tonumber(tbl_swjjc_setting.zt);
		
	end
	
	if(string.find(s,"diywarp"))then
		return rb_checkuser(player);
		
	end
	
	
end




