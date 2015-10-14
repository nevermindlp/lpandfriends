
tbl_MateChage_select = {};
Delegate.RegInit("MateChage_Init");
Delegate.RegDelAllOutEvent("MateChage_Out");

function MateChageNpc_Init(index)
	print("�����޸�Ա���ɳɹ���");
	return 1;
end

function initMateChageNpc()
	tbl_MateChageNpc = {};
	if (MateChageNpc == nil) then
		MateChageNpc = NL.CreateNpc("lua/Module/MateChage.lua", "MateChageNpc_Init");
		Char.SetData(MateChageNpc,%����_����%,231088);
		Char.SetData(MateChageNpc,%����_ԭ��%,231088);
		Char.SetData(MateChageNpc,%����_X%,48);
		Char.SetData(MateChageNpc,%����_Y%,48);
		Char.SetData(MateChageNpc,%����_��ͼ%,777);
		Char.SetData(MateChageNpc,%����_����%,4);
		Char.SetData(MateChageNpc,%����_ԭ��%,"MateChageNpc");
		NLG.UpChar(MateChageNpc);
		--Char.SetTalkedEvent("lua/Module/MateChage.lua","MateChageNpcTalk_Event", MateChageNpc);
		Char.SetWindowTalkedEvent("lua/Module/MateChage.lua","MateChageNpcWinTalk_Event",MateChageNpc);
		tbl_MateChageNpc["MateChageNpc"] = tonumber(MateChageNpc);
	end
	
end


function MateChage_Init()
	initMateChageNpc();
	NL.RegItemString("lua/Module/MateChage.lua","MateChage_Event","LUA_useM1");
end

function MateChage_Out(player)
	tbl_MateChage_select[Playerkey(player)] = nil;
	
end

function MateChage_Event(charPointer,toPlayerPointer,slot)
	
    local _itemindex = Char.GetItemIndex(charPointer,slot);
	local _zc1 = Item.GetData(_itemindex,%����_�Ӳ�һ%);
	tbl_MateChage_select[Playerkey(charPointer)] = slot;
	
	if(_zc1 == 1)then --�������
		str_ChangeWindow = ""..tonumber(Item.GetData(_itemindex,%����_�Ӳζ�%)).."|�뿴���ҵ�����Ŀô�������֮��Ϳ����Լ�����������\\n\\nȷ��������������Ϊ������ô��\\n\\n";
		NLG.ShowWindowTalked(charPointer,tonumber(tbl_MateChageNpc["MateChageNpc"]),37,%��ť_ȷ��% + %��ť_�ر�%,10,str_ChangeWindow);
		return;
	end
	
	if(_zc1 == 2)then --�������
		str_ChangeWindow = "4|\\n\\n 			 \\n	 			������Ҫ���������������ֻ�����ϣ�\\n\\n";
			for i=0,4 do
				local pet = Char.GetPet(charPointer,i);
				if(VaildChar(pet))then
					str_ChangeWindow = str_ChangeWindow .. " 			 			"..Char.GetData(pet,%����_����%).."\\n";

				else
					str_ChangeWindow = str_ChangeWindow .. " 			 			��\\n";
				end
			end
		NLG.ShowWindowTalked(charPointer,tonumber(tbl_MateChageNpc["MateChageNpc"]),%����_ѡ���%,%��ť_�ر�%,20,str_ChangeWindow);
		return;
	end
	
	tbl_MateChage_select[Playerkey(charPointer)] = nil;
	
end


function MateChageNpcWinTalk_Event(_MeIndex,_PlayerIndex,_seqno,_select,_data)
	
	if(tonumber(_select)==%��ť_�ر�%)then
		return;
	end
	
	
	if(tonumber(_seqno)==10 and tonumber(_select)==%��ť_ȷ��%)then
		
		if(tbl_MateChage_select[Playerkey(_PlayerIndex)]~=nil)then
			local s = tonumber(tbl_MateChage_select[Playerkey(_PlayerIndex)]);
			local _itemindex = Char.GetItemIndex(_PlayerIndex,s);
			local _zc2 = tonumber(Item.GetData(_itemindex,%����_�Ӳζ�%));
			Char.SetData(_PlayerIndex,%����_����%,_zc2);
			Char.SetData(_PlayerIndex,%����_ԭ��%,_zc2);
			Char.SetData(_PlayerIndex,%����_ԭʼͼ��%,_zc2);
			NLG.UpChar(_PlayerIndex);
			NLG.SystemMessage(_PlayerIndex,"��ϲ�㣬����ɹ�����");
			Item.Kill(_PlayerIndex, _itemindex, s);
		
		else
			NLG.SystemMessage(_PlayerIndex,"δ֪����������ʹ�ã�");
			
		end
		tbl_MateChage_select[Playerkey(_PlayerIndex)] = nil;
		
	end


	if (tonumber(_seqno)==20 and (_data ~= "")) then
		local selectitem = tonumber(_data) - 1;
		if (selectitem==nil or (selectitem~=nil and (selectitem > 4 or selectitem < 0))) then
				NLG.ShowWindowTalked(_PlayerIndex,_PlayerIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n����ѡ���λ�ò�����!");
				return;
		end
		local pet_indexA = Char.GetPet(_PlayerIndex,selectitem);
		if (pet_indexA == 0) then
			NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n��ȷ������Ӧ�ĳ������г���!");
			return;
		end
		
		if(tbl_MateChage_select[Playerkey(_PlayerIndex)]~=nil)then
			local s = tonumber(tbl_MateChage_select[Playerkey(_PlayerIndex)]);
			local _itemindex = Char.GetItemIndex(_PlayerIndex,s);
			local _zc2 = tonumber(Item.GetData(_itemindex,%����_�Ӳζ�%));
			--NLG.SystemMessage(_PlayerIndex,Char.GetData(pet_indexA,%����_����%).." "..Char.GetData(pet_indexA,%����_ԭ��%).." "..Char.GetData(pet_indexA,%����_ԭʼͼ��%));
			
			
			
			if(_zc2 == 0)then
				_zc2 = Char.GetData(pet_indexA,%����_ԭʼͼ��%);
				if(_zc2 ~= 0 )then
					Char.SetData(pet_indexA,%����_����%,_zc2);
					Char.SetData(pet_indexA,%����_ԭ��%,_zc2);			
					Pet.UpPet(_PlayerIndex,pet_indexA);
					Item.Kill(_PlayerIndex, _itemindex, s);
					Char.SetData(pet_indexA,%����_ԭʼͼ��%,0);
					NLG.SystemMessage(_PlayerIndex,"��ϲ�㣬���ﻹԭ�ɹ���");
					return;
				else
					NLG.SystemMessage(_PlayerIndex,"�Ѿ���ԭ������ò�ˣ��޷���ԭ��");
					return;
				
				end		
				return;
			end
			
			if(Char.GetData(pet_indexA,%����_ԭʼͼ��%) == 0)then
				Char.SetData(pet_indexA,%����_ԭʼͼ��%,Char.GetData(pet_indexA,%����_����%));
			end
			
			Char.SetData(pet_indexA,%����_����%,_zc2);
			Char.SetData(pet_indexA,%����_ԭ��%,_zc2);	
			--NLG.SystemMessage(_PlayerIndex,Char.GetData(pet_indexA,%����_����%).." "..Char.GetData(pet_indexA,%����_ԭ��%).." "..Char.GetData(pet_indexA,%����_ԭʼͼ��%));
						
					
			Pet.UpPet(_PlayerIndex,pet_indexA);			
			Item.Kill(_PlayerIndex, _itemindex, s);
			
			NLG.SystemMessage(_PlayerIndex,"��ϲ�㣬�������ɹ���");
			
		else
			NLG.SystemMessage(_PlayerIndex,"δ֪����������ʹ�ã�");
			
		end
		tbl_MateChage_select[Playerkey(_PlayerIndex)] = nil;
		
		
		
	end
end