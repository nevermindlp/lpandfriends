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
function Entry (b)
		petFusionData[b.id] = {lv = b.lv , name = b.name , feature = b.feature , part = b.part};
end
dofile("/gmsv/lua/Module/data.lua")



function PetFusion_Init()
	CreatePetFusionNPC();
end

function PetFusionNPCCharInit(_myIndex)
  return true;
end

function CreatePetFusionNPC()
	if PetFusionNPC == nil then
		PetFusionNPC = NL.CreateNpc(nil,"PetFusionNPCCharInit")
		Char.SetData(PetFusionNPC,%����_����%,100500)
		Char.SetData(PetFusionNPC,%����_ԭ��%,100500)
		Char.SetData(PetFusionNPC,%����_��ͼ%,778)
		Char.SetData(PetFusionNPC,%����_X%,7)
		Char.SetData(PetFusionNPC,%����_Y%,0)
		Char.SetData(PetFusionNPC,%����_����%,4)
		Char.SetData(PetFusionNPC,%����_ԭ��%,"�����ں�npc")
		Char.SetWindowTalkedEvent("lua/Module/petfusion.lua","PetFusionNPCWindowTalk",PetFusionNPC)
		Char.SetTalkedEvent("lua/Module/petfusion.lua","PetFusionNPCTalk",PetFusionNPC)
		NLG.UpChar(PetFusionNPC)
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
			pet1 = Char.GetPet(player,0);
			pet2 = Char.GetPet(player,1);
			--��ȡ�����id������λ����Ҫ���ԣ�api��û��
			pet1id = Char.GetData(pet1,1);
			pet2id = Char.GetData(pet2,1);
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
					if petFusionData[pet1id].part == 1 and petFusionData[pet2id].part == 2 then
						print("canFusion");
						canFusion = true;
					else
						--��ʾ����������������͵ģ�����+���ɣ�
					end

					if petFusionData[pet1id].part == 2 and petFusionData[pet2id].part == 1 then
						canFusion = true;
					else
						--��ʾ����������������͵ģ�����+���ɣ�
					end

				else
					--��һ�׳����Ҫ����ͬ�׶βſ��ں�
					if petFusionData[pet1id].lv == petFusionData[pet2id].lv then
						if petFusionData[pet1id].lv == 4 then
							--�Ľ׳���ĿǰΪ��߽׶Σ����ɼ����ں�
							canFusion = false;
							--��ʾ��߽׳��ﲻ���ں�
						else
							canFusion = true;
						end
					else
						--��ʾͬ�׳���ſ��ں�
						canFusion = false;
					end
				end
			else
				--��ʾ����Ϊ�����ںϳ�
				canFusion = false;
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
						table.insert(tarPetTable,fusionPetId);
					end
				end
				if targetPetTable then
					--���targetPetTable����nil
					math.randomseed(tostring(os.time()));
					local targetPetNum = math.random(#tarPetTable);
					local targetPetId = targetPetTable[targetPetNum];
					-- ɾ�������ںϳ���
					Char.DelSlotPet(player,0);
					Char.DelSlotPet(player,1);
					-- ����ҵ�
					Char.GiveItem(player,petFusionData[targetPetId].eggId,1);
					NLG.TalkToCli(player,-1,"�ںϳɹ���",%��ɫ_��ɫ%);
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
	local newfeature = "";
	local flag = false;
	math.randomseed(tostring(os.time()));
	math.random();
	if fsize == 2 and petLv == 3 then
		while(true) do
			local rf = math.random(6);
			for i = 1 , fsize , 1 do
				local f = petfTable[i];
				if f == rf then
					flag = true;
				end
			end
			if not flag then
				table.insert(petfTable, '' .. rf);
				break;
			end
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
		if (pos) then
			local size_t = #sub_str_tab;
			table.insert(sub_str_tab,size_t+1,str);
			break;
		else
			table.insert(sub_str_tab,str);
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
