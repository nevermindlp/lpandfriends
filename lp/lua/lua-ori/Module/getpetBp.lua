
Delegate.RegInit("getpetBp_Init");

function initgetpetBpNpc_Init(index)
	print("�����㵵��ʦnpc_index = " .. index);
	return 1;
end


function initGetPetBpNpc()
	if (GetPetBps == nil) then
		GetPetBps = NL.CreateNpc("lua/Module/getpetBp.lua", "initgetpetBpNpc_Init");
		Char.SetData(GetPetBps,%����_����%,231088);
		Char.SetData(GetPetBps,%����_ԭ��%,231088);
		Char.SetData(GetPetBps,%����_X%,228);
		Char.SetData(GetPetBps,%����_Y%,83);
		Char.SetData(GetPetBps,%����_��ͼ%,1000);
		Char.SetData(GetPetBps,%����_����%,4);
		Char.SetData(GetPetBps,%����_ԭ��%,"�����㵵��ʦ");
		NLG.UpChar(GetPetBps);
		--����:����һ��Npc,����˵�����������¼�ΪChangepass
		Char.SetWindowTalkedEvent("lua/Module/getpetBp.lua","GetPetBpsA",GetPetBps);
		--��������Npc˵����ʱ��,����ChangePassMsg����
		Char.SetTalkedEvent("lua/Module/getpetBp.lua","GetPetBpMsg", GetPetBps);
	end
end

function GetPetBpMsg(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		str_ChangeWindow = "4|\\n\\n 			���!���ǰ���³����ĳ��������ʦϣ����.\\n	 			�ҿ��԰����������ѡ��ĳ���ĵ���Ŷ!...\\n\\n";
		for i=0,4 do
			local pet = Char.GetPet(_tome,i);

			if(VaildChar(pet)==false)then
				str_ChangeWindow = str_ChangeWindow .. " 			 			��\\n";
			else
				str_ChangeWindow = str_ChangeWindow .. " 			 			"..Char.GetData(pet,%����_ԭ��%).."\\n";
			end
		end
		NLG.ShowWindowTalked(_tome,_me,%����_ѡ���%,%��ť_�ر�%,1,str_ChangeWindow);
		return;
	end
end
function GetPetBpsA(_MeIndex,_PlayerIndex,_seqno,_select,_data)
	if ((_select == 0 or _select == "0") and (_data ~= "")) then
		local selectitem = tonumber(_data) - 1;
		if (selectitem==nil or (selectitem~=nil and (selectitem > 4 or selectitem < 0))) then
				NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n����ѡ���λ�ò�����!");
				return;
		end
		local pet_indexA = Char.GetPet(_PlayerIndex,selectitem);
		if (VaildChar(pet_indexA) == false) then
			NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n\\n��ȷ������Ӧ�ĳ������г���!");
			return;
		end
		local petIndex = Char.GetData(pet_indexA,1);
		local arr_rank1 = Pet.GetArtRank(pet_indexA,%�赵_���%);
		local arr_rank11 = Pet.FullArtRank(pet_indexA,%�赵_���%);
		local arr_rank2 = Pet.GetArtRank(pet_indexA,%�赵_����%);
		local arr_rank21 = Pet.FullArtRank(pet_indexA,%�赵_����%);
		local arr_rank3 = Pet.GetArtRank(pet_indexA,%�赵_ǿ��%);
		local arr_rank31 = Pet.FullArtRank(pet_indexA,%�赵_ǿ��%);
		local arr_rank4 = Pet.GetArtRank(pet_indexA,%�赵_����%);
		local arr_rank41 = Pet.FullArtRank(pet_indexA,%�赵_����%);
		local arr_rank5 = Pet.GetArtRank(pet_indexA,%�赵_ħ��%);
		local arr_rank51 = Pet.FullArtRank(pet_indexA,%�赵_ħ��%);
		local a1 = math.abs(arr_rank1 - arr_rank11);
		local a2 = math.abs(arr_rank2 - arr_rank21);
		local a3 = math.abs(arr_rank3 - arr_rank31);
		local a4 = math.abs(arr_rank4 - arr_rank41);
		local a5 = math.abs(arr_rank5 - arr_rank51);
		local a6 = a1 + a2+ a3+ a4+ a5;
		local writestr = "";
		if(a6==0)then
			writestr = "������:"..Char.GetData(pet_indexA,%����_����%).."\\n"
					.."\\n\\n��ϲ��!!!\\n\\n�ó����ܵ�����: ��["..a6.."]��\\n";
		else
			writestr = "������:"..Char.GetData(pet_indexA,%����_����%).."\\n"
					.."����������:����"..a1.."�ݵ�\\n"
					.."����������:����"..a2.."�ݵ�\\n"
					.."����������:����"..a3.."�ݵ�\\n"
					.."���ݵ�����:����"..a4.."�ݵ�\\n"
					.."ħ��������:����"..a5.."�ݵ�\\n"
					.."�ó����ܵ�����: ��["..a6.."]��\\n";
		end
		NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%����_��Ϣ��%,%��ť_�ر�%,10,writestr);
	end
end




function getpetBp_Init()
	initGetPetBpNpc();
	
end