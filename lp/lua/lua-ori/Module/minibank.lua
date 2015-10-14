Delegate.RegInit("minibank_Init");

function minibankNpc_Init(index)
	print("��������npc_index = " .. index);
	return 1;
end

function minibank_create() --������ѯ
	tbl_minibankNpc = {};
	if (minibank_index == nil) then
		minibank_index = NL.CreateNpc("lua/Module/minibank.lua", "minibankNpc_Init");
		Char.SetData(minibank_index,%����_����%,10414);
		Char.SetData(minibank_index,%����_ԭ��%,10414);
		Char.SetData(minibank_index,%����_X%,17);
		Char.SetData(minibank_index,%����_Y%,28);
		Char.SetData(minibank_index,%����_��ͼ%,777);
		Char.SetData(minibank_index,%����_����%,4);
		Char.SetData(minibank_index,%����_����%,"bank");
		NLG.UpChar(minibank_index);
		--Char.SetTalkedEvent("lua/Module/minibank.lua", "BankAsYouGo_Talked", minibank_index);
		Char.SetWindowTalkedEvent("lua/Module/minibank.lua", "BankAsYouGo_WinTalked", minibank_index);
		tbl_minibankNpc["minibankNpc"] = tonumber(minibank_index);
	end
end


function minibank_Init()
	minibank_create();
	NL.RegItemString("lua/Module/minibank.lua","minibankcard_Event","LUA_useB1");
end


--function BankAsYouGo_Talked(me, tome)
--	NLG.Talked(0, me, tome);
--	return;
--end

function BankAsYouGo_WinTalked(me, tome, seq, select, data)
	NLG.WindowTalked(0, me, tome, seq, select, data);
	return;
end

function minibankcard_Event(charPointer,toPlayerPointer,slot)
	NLG.Talked(0, tonumber(tbl_minibankNpc["minibankNpc"]), charPointer);
	local _itemindex = Char.GetItemIndex(charPointer,slot);
	local lsnj = tonumber(Item.GetData(_itemindex,%����_�;�%)) - 1;
	if(lsnj <= 0)then
		Item.Kill(charPointer, _itemindex, slot);
	else
		Item.SetData(_itemindex,%����_�;�%,lsnj);
		Item.UpItem(charPointer, slot);
	end
	
	
	
	
	
	
end


