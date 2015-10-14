--[[
�����ں���ƣ�
1�����������ں�NPC��
2����ʼ��NPC�Ի����ݡ�
3����ȡ��ҳ�������λ��1��2�ĳ��
4���жϳ����id�Ƿ�Ϊ���ںϳ��
5����ȡ��ֻ�����id��Ӧ��������feature��
	���ȡ��������Ϊ��2��1
	��������������õ���{1��2}
	�������á�_�����ӵõ�:��1_2��
6������ȡ����������1_2����lv2����ļ�����Ѱ�ҷ��ϸ����������ݡ�
7�����ںϺ�ĳ��ﵰ����Ҳ�ɾ�������ںϵ���ֻ���
8������feature����2�׵�3����Ҫ�����ֳ����е�part1���ԡ�part2���Ը�ȡһ��
    ���3�������������ֻ����ļ����ص�����Ҫ�����������һ��������OMG������
9����Ҫ��data�ļ��г����ID������ʵ��ID��������ÿ��ENTRY�м���eggId��
]]--

--[[
local petsid = {};
function Entry (b) petsid[b.id] = true end
dofile("/gmsv/lua/Module/data.lua")
for id in pairs(petsid) do print(id) end
]]--

Delegate.RegInit("PetFusion_Init");

--������������table
local petFusionData = {};
local luckyNum = 930;
--local feedEggInterval = 8*60*60;
local feedEggInterval = 1*60;
local secondEggFlag = "_second";
local finalEggFlag = "_final";
local petFusionLowestLv = 1;
local feedFoodId = 10000;
local needFoodNumLvOne = 10;\
local needFoodNumLvTwo = 20;
local needFoodNumLvThree = 30;


function Entry (b)
		petFusionData[b.id] = {lv = b.lv , name = b.name , feature = b.feature , part = b.part , eggId = b.eggId , eggPetId = b.eggPetId};
end
dofile("/gmsv/lua/Module/data.lua")



function PetFusion_Init()
	CreatePetFusionNPC();
	CreateFeedEggNPC();

end

function PetFusionNPCCharInit(_myIndex)
  return true;
end

function CreatePetFusionNPC()
	if PetFusionNPC == nil then
		PetFusionNPC = NL.CreateNpc(nil,"PetFusionNPCCharInit");
		Char.SetData(PetFusionNPC,%����_����%,100500);
		Char.SetData(PetFusionNPC,%����_ԭ��%,100500);
		Char.SetData(PetFusionNPC,%����_��ͼ%,778);
		Char.SetData(PetFusionNPC,%����_X%,7);
		Char.SetData(PetFusionNPC,%����_Y%,0);
		Char.SetData(PetFusionNPC,%����_����%,4);
		Char.SetData(PetFusionNPC,%����_ԭ��%,"�����ں�npc");
		Char.SetWindowTalkedEvent("lua/Module/petfusion.lua","PetFusionNPCWindowTalk",PetFusionNPC);
		Char.SetTalkedEvent("lua/Module/petfusion.lua","PetFusionNPCTalk",PetFusionNPC);
		NLG.UpChar(PetFusionNPC);
	end
end

function CreateFeedEggNPC()
	if FeedEggNPC == nil then
		FeedEggNPC = NL.CreateNpc(nil,"PetFusionNPCCharInit");
		Char.SetData(FeedEggNPC,%����_����%,100500);
		Char.SetData(FeedEggNPC,%����_ԭ��%,100500);
		Char.SetData(FeedEggNPC,%����_��ͼ%,778);
		Char.SetData(FeedEggNPC,%����_X%,8);
		Char.SetData(FeedEggNPC,%����_Y%,0);
		Char.SetData(FeedEggNPC,%����_����%,4);
		Char.SetData(FeedEggNPC,%����_ԭ��%,"ι��npc");
		Char.SetWindowTalkedEvent("lua/Module/petfusion.lua","FeedEggNPCWindowTalk",FeedEggNPC);
		Char.SetTalkedEvent("lua/Module/petfusion.lua","FeedEggNPCTalk",FeedEggNPC);
		NLG.UpChar(FeedEggNPC);
	end
end

function FeedEggNPCTalk(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local msg = "\n�뽫��Ҫιʳ�ĵ�������Ʒ���ĵ�һλ��" ..
		"\nȷ�������㹻ιʳ�ı��ɡ�����" ..
		"\n�š����������ǿ�ʼ�ɣ�������ι��ʲô������"
		NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_ȷ��%+%��ť_��%,720,msg);
	end
end

function FeedEggNPCWindowTalk(npc,player,Seqno,Select,Data)
	if Select == 8 then
		return;
	end
	if Select ~= 2 then
		--��ȡ��һ������
		if Seqno == 720 then
			local item = Char.GetItemIndex(player,8);
			--�жϵ����Ƿ�Ϊ������ͨ�����ƻ�ID����
			local eggIdCheck = Item.GetData(item,%����_��%);
			print("eggIdCheck=" .. eggIdCheck);
			if eggIdCheck < 100236 or eggIdCheck > 100436 then\
				NLG.TalkToCli(player,-1,"�뽫���ﵰ������Ʒ���ĵ�һλ��",%��ɫ_��ɫ%);
				return;
			end
			local eggCreateTime = Item.GetData(item,%����_���ò���%);
			print("eggCreateTime=" .. eggCreateTime);
			if not eggCreateTime then
				--Ӧ������Ϊ�ظ��������⵼�µ�û�б������Զ������������ʱ��
				--��Ҫ��������ʱ�䣬С�����¼�
				Item.SetData(item,%����_���ò���%,os.time());
				NLG.TalkToCli(player,-1,"ÿ8��Сʱ�ſ���ιһ�ε�Ŷ��",%��ɫ_��ɫ%);
				return;
			end
			local findSecondFlag = string.find(eggCreateTime, secondEggFlag);
			local findFinalFlag = string.find(eggCreateTime, finalEggFlag);

			if findSecondFlag or findFinalFlag then
				--�ǵ�һ��ιʳ
				local pos = findSecondFlag or findFinalFlag;
				eggCreateTime = string.sub(eggCreateTime, 1, pos - 1);
			end
			--�жϱ���
			local haveFoodNum = Char.ItemNum(player,feedFoodId);
			local needFoodNum;
			if findSecondFlag then
				if haveFoodNum < needFoodNumLvTwo then
					NLG.TalkToCli(player,-1,"��ĳ��ﵰ��Ҫ�����ʳ�ģ�",%��ɫ_��ɫ%);
					return;
				end
				needFoodNum = needFoodNumLvTwo;
			elseif findFinalFlag then
				if haveFoodNum < needFoodNumLvThree then
					NLG.TalkToCli(player,-1,"��ĳ��ﵰ��Ҫ�����ʳ�ģ�",%��ɫ_��ɫ%);
					return;
				end
				needFoodNum = needFoodNumLvThree;
			else
				if haveFoodNum < needFoodNumLvOne then
					NLG.TalkToCli(player,-1,"��ĳ��ﵰ��Ҫ�����ʳ�ģ�",%��ɫ_��ɫ%);
					return;
				end
				needFoodNum = needFoodNumLvOne;
			end


			if os.time() - eggCreateTime > feedEggInterval then
				local oriItemId = Item.GetData(item,%����_��%);
				print("oriItemId=" .. oriItemId);
				if findSecondFlag then
					--�ڶ���ι��
					local newItemId = oriItemId + 1;
					--ɾ��ԭ���ĵ��ߣ����µ��ߣ����������,�������µ���ʱ��͵ȼ�

					Item.Kill(player, item, 8);
					Char.GiveItem(player,newItemId,1);
					local eggObj = Char.HaveItem(player,newItemId);
					Item.SetData(eggObj, %����_���ò���%, os.time() .. finalEggFlag);
					NLG.TalkToCli(player,-1,"���ﵰ������Ӹ��ӡ������������ˡ���",%��ɫ_��ɫ%);
				elseif findFinalFlag then
					--������ι��
					--�����ж��Ƿ��пյĳ�����λ��
					local havePets = Char.PetNum(player);
					if  havePets == 5 then
						NLG.TalkToCli(player,-1,"�뱣֤���㹻�ĳ�����λ��",%��ɫ_��ɫ%);
						return;
					end
					local targetEggId = oriItemId -2;
					for k,v in pairs(petFusionData) do
						if v.eggId == targetEggId then
							--��õ���Ӧ�ĳ���ID
							local targetPetId = k;
							print("targetPetId = " .. targetPetId);
							--�����ָ������,��Ҫ��data�м������id�����ݣ�����ֻ��ͼ��ID
							Char.AddPet(player,petFusionData[targetPetId].eggPetId);  --eggPetId
						end
					end
					--ɾ��ԭ���ĵ��ߣ����µ��ߣ����������,�������µ���ʱ��͵ȼ�
					Item.Kill(player, item, 8);
					NLG.TalkToCli(player,-1,"��һ����һ����ĵ������˳�����",%��ɫ_��ɫ%);
				else
					--��һ��ι��
					local newItemId = oriItemId + 1;
					--ɾ��ԭ���ĵ��ߣ����µ��ߣ����������,�������µ���ʱ��͵ȼ�
					Item.Kill(player, item, 8);
					Char.GiveItem(player,newItemId,1);
					local eggObj = Char.HaveItem(player,newItemId);
					Item.SetData(eggObj, %����_���ò���%, os.time() .. secondEggFlag);
					NLG.TalkToCli(player,-1,"���ﵰ������ӡ������������ˡ���",%��ɫ_��ɫ%);
				end
				--ɾ��ʳ��
				Char.DelItem(player,feedFoodId,needFoodNum);
			else
				NLG.TalkToCli(player,-1,"ÿ8��Сʱ�ſ���ιһ�ε�Ŷ��",%��ɫ_��ɫ%);
			end
		end

	end
end


function PetFusionNPCTalk(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local msg = "\n�����ںϿ���ʹ���ø�ǿ��ĳ��" ..
		"\n����Ҫʹ����ֻ�ɽ����ںϵĳ�����Ϊ������" .. "\n�뽫��Ҫ�����ںϵĳ�����ڳ�������ǰ��λ" ..
		"\n�ںϺ��㽫���һö���ﵰ��24Сʱ���ǿ����ںϳ��ｫ�ӵ��з���������" ..
		"\n�㽫��ʧȥ�����ںϵ���ֻ���" ..
		"\n��ȷ�������Ʒ��������һ����λ����ȡ���ﵰ����" ..
		"\nȷ�Ͻ����ںϣ�"
		NLG.ShowWindowTalked(_tome,_me,%����_��Ϣ��%,%��ť_ȷ��%+%��ť_��%,710,msg);
	end
end

function PetFusionNPCWindowTalk(npc,player,Seqno,Select,Data)

	print("Data=" .. Data);
	print("Select=" .. Select);
	local canFusion = false;
	if Select == 8 then
		return;
	end
	if Select ~= 2 then
		if Seqno == 710 then
			--�����ж�����Ƿ��пյ�����
			local haveItems = Char.ItemSlot(player);
			if haveItems == 20 then
				NLG.TalkToCli(player,-1,"�����ں�ǰ�뱣֤������һ���յ�����λ��",%��ɫ_��ɫ%);
				return;
			end
			pet1 = Char.GetPet(player,0);
			pet2 = Char.GetPet(player,1);
			--��ȡ�����id������λ����Ҫ���ԣ�api��û��
			pet1id = Char.GetData(pet1,1);
			pet2id = Char.GetData(pet2,1);
			--�����ں���͵ȼ�30
			local pet1Lve = Char.GetData(pet1,%����_�ȼ�%);
			local pet2Lve = Char.GetData(pet2,%����_�ȼ�%);
			print("pet1Lve " .. pet1Lve  .. "pet2Lve " .. pet2Lve );
			if pet1Lve == 0 or pet2Lve == 0 then
				NLG.TalkToCli(player,-1,"�ںϳ��������ڳ�������һλ�͵ڶ�λ��",%��ɫ_��ɫ%);
				return;
			end
			if pet1Lve < petFusionLowestLv or pet2Lve < petFusionLowestLv then
				NLG.TalkToCli(player,-1,"�ںϳ�����͵ȼ�Ϊ30����",%��ɫ_��ɫ%);
				return;
			end

			print("pet1id " .. pet1id );
			print("pet2id " .. pet2id );
			if petFusionData[pet1id] and petFusionData[pet2id] then
				--��ֻ������ں�
				--��Ҫ�ж���ֻ�����Ƿ�Ϊһ�׳������ǣ���Ҫ����Ϊ�����ģ��磺����+���ɣ�
				print("lv=" .. petFusionData[pet1id].lv);
				if petFusionData[pet1id].lv == 1 and petFusionData[pet2id].lv == 1 then
					--�����һ���ںϳ裬��Ҫ�ж�part
					print(petFusionData[pet1id].part);
					print(petFusionData[pet2id].part);
					if (petFusionData[pet1id].part == 1 and petFusionData[pet2id].part == 2) or  (petFusionData[pet1id].part == 2 and petFusionData[pet2id].part == 1) then
						print("canFusion");
						canFusion = true;
					else
						--��ʾ����������������͵ģ�����+���ɣ�
						NLG.TalkToCli(player,-1,"�ںϳ������ֱ����Դ�Ŵ�ʦ���С�Ŵ�ʦ��",%��ɫ_��ɫ%);
					end
				else
					--��һ�׳����Ҫ����ͬ�׶βſ��ں�
					if petFusionData[pet1id].lv == petFusionData[pet2id].lv then
						if petFusionData[pet1id].lv == 4 then
							--�Ľ׳���ĿǰΪ��߽׶Σ����ɼ����ں�
							canFusion = false;
							--��ʾ��߽׳��ﲻ���ں�
							NLG.TalkToCli(player,-1,"��߽׳��ﲻ���ںϣ�",%��ɫ_��ɫ%);
						else
							canFusion = true;
						end
					else
						--��ʾͬ�׳���ſ��ں�
						NLG.TalkToCli(player,-1,"ͬ�׳���ſ��ںϣ�",%��ɫ_��ɫ%);
						canFusion = false;
					end
				end
			else
				--��ʾ����Ϊ�����ںϳ�
				canFusion = false;
				NLG.TalkToCli(player,-1,"�ó��ﲻ���ںϣ�",%��ɫ_��ɫ%);
			end
			if canFusion then
				--���ں�
				local pet1f = petFusionData[pet1id].feature;
				local pet2f = petFusionData[pet2id].feature;
				print("pet1f = " .. pet1f );
				print("pet2f = " .. pet2f );
				--���������lv��ͬ
				local petLv = petFusionData[pet1id].lv;
				local petnewfeature = getNewPetFeature(pet1f, pet2f, petLv+1);
				print("petnewfeature =" .. petnewfeature );
				local targetPetTable = {};
				for k,v in pairs(petFusionData) do
					if v.feature == petnewfeature then
						--����ںϳ�ļ���
						local fusionPetId = k;
						print("fPetId = " .. fusionPetId);
						table.insert(targetPetTable ,fusionPetId);
					end
				end
				if targetPetTable then
					--���targetPetTable����nil
					math.randomseed(tostring(os.time()));
					local targetPetNum = math.random(#targetPetTable);
					local targetPetId = targetPetTable[targetPetNum];
					-- ɾ�������ںϳ���
					Char.DelSlotPet(player,0);
					Char.DelSlotPet(player,1);
					-- ����ҵ�
					math.randomseed(tostring(os.time()));
					local luckyRandomNum = math.random(1000);
					if luckyRandomNum == luckyNum then
						local playerName = Char.GetData(player,%����_����%);
						if petLv == 1 then
							--����1�׳����ں�
							Char.GiveItem(player,100284,1);
						end
						if petLv == 2 then
							--����2�׳����ں�
							Char.GiveItem(player,100323,1);
						end
						if petLv == 3 then
							--����3�׳����ں�
							Char.GiveItem(player,100431,1);
						end
						NLG.TalkToCli(-1,-1,"OMG��" .. playerName.."��Ȼ����˴�˵�еĳ��ﵰ����������ʺ�ˣ�����",%��ɫ_��ɫ%);
					else
						print("eggId = " .. petFusionData[targetPetId].eggId);
						local eggId = petFusionData[targetPetId].eggId;
						Char.GiveItem(player,eggId,1);
						NLG.TalkToCli(player,-1,"�ںϳɹ���",%��ɫ_��ɫ%);
						--����ҵ������»�ȡָ����ID������
						local eggCount = Char.ItemNum(player,eggId);
						if eggCount > 1 then
							--�����������ͬ��egg����
							print("bad luck��������");
						else
							--���õ����Զ�������
							local eggObj = Char.HaveItem(player,eggId);
							Item.SetData(eggObj, %����_���ò���%, os.time());
							print("eggCreateTime 1111=" .. Item.GetData(eggObj, %����_���ò���%));
						end
					end
				else
					NLG.TalkToCli(player,-1,"�ں�ʧ�ܣ�",%��ɫ_��ɫ%);
				end
			end
		end
	end
end

function getNewPetFeature(pet1f, pet2f, lv)
	print("pet1f = " .. pet1f);
	print("pet2f = " .. pet2f);
	local pet1fTable = lua_string_split(pet1f,"_");
	print(pet1fTable );
	local pet2fTable = lua_string_split(pet2f,"_");
	local size1 = #pet1fTable;
	local size2 = #pet2fTable;
	print("size1=" .. size1 .. "size2=" .. size2);
	local addFlag = false;
	local newfeature = "";
	for i = 1 , size1 , 1 do
		local f1 = pet1fTable[i];
		print("f1 = " .. f1)
		for j = 1 , size2 , 1 do
			local f2 = pet2fTable[j];
			print("f2=" .. f2);
			if f1 == f2 then
				addFlag = true;
			end
		end
		if not addFlag then
			print("addFlag in ");
			print(#pet2fTable);
			table.insert(pet2fTable,f1);
			print(#pet2fTable);
		end
		addFlag = false;
	end
	fullFeature(pet2fTable,lv);
	print(1);
	print("pet2fTable");
	print(pet2fTable);
	table.sort(pet2fTable);
	print("pet2fTable[1]");
	print(pet2fTable[1]);
	local totalFSize = #pet2fTable;
	print("totalFSize ");
	print(totalFSize );
	local randomSeqTable = getRandomNumBySizeAndLv(totalFSize, lv);
	table.sort(randomSeqTable);
	--local randomSeqTable = {};
	for k,v in pairs(randomSeqTable) do
		newfeature = newfeature .. pet2fTable[v] .. "_";
	end
	newfeature = string.sub(newfeature,0,string.len(newfeature)-1);
	print("newfeature " .. newfeature );
	return newfeature;
end

--[[
	����2�׵�3�׳�������ֻ�����������ͬ�������һ������
	��Ҫ�Ӷ�������������ѡһ����ӵ���������
]]--
function fullFeature(petfTable,petLv)
	local fsize = #petfTable;
	print("fsize =============" .. fsize);
	local newfeature = "";
	local flag = false;
	math.randomseed(tostring(os.time()));
	math.random();
	if fsize < petLv then
		while(true) do
			local rf = math.random(6);
			local rfStr = '' .. rf;
			print("rfStr = " .. rfStr );
			for i = 1 , fsize , 1 do
				local f = petfTable[i];
				print("***********i=" .. i .. "************f=" .. f);
				if f == rfStr then
					flag = true;
				end
			end
			if not flag then
				table.insert(petfTable, '' .. rf);
				break;
			end
			flag = false;
		end
	end
end

--[[
	lua��û�зָ��ַ����ķ������Լ�ʵ�ֵ�split����
]]--
function lua_string_split(str, split_char)
	local sub_str_tab = {};

	while (true) do
		local pos = string.find(str, split_char);
		print((not pos));
		if (not pos) then
			local size_t = #sub_str_tab;
			table.insert(sub_str_tab,size_t+1,str);
			return sub_str_tab;
		end

		local sub_str = string.sub(str, 1, pos - 1);
		local size_t = #sub_str_tab;
		table.insert(sub_str_tab,size_t+1,sub_str);
		local t = string.len(str);
		str = string.sub(str, pos + 1, t);
	end
	return sub_str_tab;
end
--[[
	ͨ��size��lv
	���ظ�lv������ļ������
	�磺size=6��lv=4 ˵������6�����ܣ���������ĸ����ܶ�Ӧ��table��š�
]]--
function getRandomNumBySizeAndLv(size,lv)
	print("size=" .. size .. "lv = " .. lv);
	local randomNumTable = {};
	local repeatFlag = false;
	math.randomseed(tostring(os.time()));
	math.random(size);
	while (true) do
		local tempNum = math.random(size);
		print("tempNum");
		print(tempNum)
		for k,v in pairs(randomNumTable) do
			if v == tempNum then
				repeatFlag = true;
			end
		end
		if not repeatFlag then
			local tableSize = #randomNumTable;
			if tableSize < lv then
				table.insert(randomNumTable,tempNum);
				if  #randomNumTable == lv then
					return randomNumTable;
				end
			else
				return randomNumTable;
			end
		end
		repeatFlag = false;
	end
end
