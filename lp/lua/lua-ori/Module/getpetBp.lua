
Delegate.RegInit("getpetBp_Init");

function initgetpetBpNpc_Init(index)
	print("宠物算档大师npc_index = " .. index);
	return 1;
end


function initGetPetBpNpc()
	if (GetPetBps == nil) then
		GetPetBps = NL.CreateNpc("lua/Module/getpetBp.lua", "initgetpetBpNpc_Init");
		Char.SetData(GetPetBps,%对象_形象%,231088);
		Char.SetData(GetPetBps,%对象_原形%,231088);
		Char.SetData(GetPetBps,%对象_X%,228);
		Char.SetData(GetPetBps,%对象_Y%,83);
		Char.SetData(GetPetBps,%对象_地图%,1000);
		Char.SetData(GetPetBps,%对象_方向%,4);
		Char.SetData(GetPetBps,%对象_原名%,"宠物算档大师");
		NLG.UpChar(GetPetBps);
		--含义:创建一个Npc,与其说话所触发的事件为Changepass
		Char.SetWindowTalkedEvent("lua/Module/getpetBp.lua","GetPetBpsA",GetPetBps);
		--这里是与Npc说话的时候,调用ChangePassMsg函数
		Char.SetTalkedEvent("lua/Module/getpetBp.lua","GetPetBpMsg", GetPetBps);
	end
end

function GetPetBpMsg(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		str_ChangeWindow = "4|\\n\\n 			你好!我是阿凯鲁法村的宠物鉴定大师希伯来.\\n	 			我可以帮你计算你所选择的宠物的档数哦!...\\n\\n";
		for i=0,4 do
			local pet = Char.GetPet(_tome,i);

			if(VaildChar(pet)==false)then
				str_ChangeWindow = str_ChangeWindow .. " 			 			空\\n";
			else
				str_ChangeWindow = str_ChangeWindow .. " 			 			"..Char.GetData(pet,%对象_原名%).."\\n";
			end
		end
		NLG.ShowWindowTalked(_tome,_me,%窗口_选择框%,%按钮_关闭%,1,str_ChangeWindow);
		return;
	end
end
function GetPetBpsA(_MeIndex,_PlayerIndex,_seqno,_select,_data)
	if ((_select == 0 or _select == "0") and (_data ~= "")) then
		local selectitem = tonumber(_data) - 1;
		if (selectitem==nil or (selectitem~=nil and (selectitem > 4 or selectitem < 0))) then
				NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n您所选择的位置不正常!");
				return;
		end
		local pet_indexA = Char.GetPet(_PlayerIndex,selectitem);
		if (VaildChar(pet_indexA) == false) then
			NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%窗口_信息框%,%按钮_关闭%,1,"\\n\\n\\n请确定您对应的宠物栏有宠物!");
			return;
		end
		local petIndex = Char.GetData(pet_indexA,1);
		local arr_rank1 = Pet.GetArtRank(pet_indexA,%宠档_体成%);
		local arr_rank11 = Pet.FullArtRank(pet_indexA,%宠档_体成%);
		local arr_rank2 = Pet.GetArtRank(pet_indexA,%宠档_力成%);
		local arr_rank21 = Pet.FullArtRank(pet_indexA,%宠档_力成%);
		local arr_rank3 = Pet.GetArtRank(pet_indexA,%宠档_强成%);
		local arr_rank31 = Pet.FullArtRank(pet_indexA,%宠档_强成%);
		local arr_rank4 = Pet.GetArtRank(pet_indexA,%宠档_敏成%);
		local arr_rank41 = Pet.FullArtRank(pet_indexA,%宠档_敏成%);
		local arr_rank5 = Pet.GetArtRank(pet_indexA,%宠档_魔成%);
		local arr_rank51 = Pet.FullArtRank(pet_indexA,%宠档_魔成%);
		local a1 = math.abs(arr_rank1 - arr_rank11);
		local a2 = math.abs(arr_rank2 - arr_rank21);
		local a3 = math.abs(arr_rank3 - arr_rank31);
		local a4 = math.abs(arr_rank4 - arr_rank41);
		local a5 = math.abs(arr_rank5 - arr_rank51);
		local a6 = a1 + a2+ a3+ a4+ a5;
		local writestr = "";
		if(a6==0)then
			writestr = "宠物名:"..Char.GetData(pet_indexA,%对象_名字%).."\\n"
					.."\\n\\n恭喜你!!!\\n\\n该宠物总掉档数: 掉["..a6.."]档\\n";
		else
			writestr = "宠物名:"..Char.GetData(pet_indexA,%对象_名字%).."\\n"
					.."体力掉档数:掉［"..a1.."］档\\n"
					.."力量掉档数:掉［"..a2.."］档\\n"
					.."防御掉档数:掉［"..a3.."］档\\n"
					.."敏捷掉档数:掉［"..a4.."］档\\n"
					.."魔法掉档数:掉［"..a5.."］档\\n"
					.."该宠物总掉档数: 掉["..a6.."]档\\n";
		end
		NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%窗口_信息框%,%按钮_关闭%,10,writestr);
	end
end




function getpetBp_Init()
	initGetPetBpNpc();
	
end