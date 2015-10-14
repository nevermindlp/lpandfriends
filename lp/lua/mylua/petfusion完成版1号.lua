--[[
宠物融合设计：
1、创建宠物融合NPC。
2、初始化NPC对话内容。
3、获取玩家宠物栏中位置1、2的宠物。
4、判断宠物的id是否为可融合宠物。
5、获取两只宠物的id对应的特征（feature）
	如获取到的特征为：2和1
	对特征进行排序得到：{1、2}
	将特征用”_”连接得到:“1_2“
6、按获取到的特征（1_2）在lv2宠物的集合中寻找符合该特征的数据。
7、将融合后的宠物蛋给玩家并删除用于融合的两只宠物。
8、新增feature宠物2阶到3阶需要从两种宠物中的part1属性、part2属性各取一个
    组成3个特征，如果两只宠物的技能重叠，需要额外随机加入一种特征。OMG。。。
9、需要将data文件中宠物的ID换成真实的ID，并且在每个ENTRY中加入eggId。
]]--

--[[
local petsid = {};
function Entry (b) petsid[b.id] = true end
dofile("/gmsv/lua/Module/data.lua")
for id in pairs(petsid) do print(id) end
]]--

Delegate.RegInit("PetFusion_Init");

--构建宠物数据table
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
		Char.SetData(PetFusionNPC,%对象_形象%,100500)
		Char.SetData(PetFusionNPC,%对象_原形%,100500)
		Char.SetData(PetFusionNPC,%对象_地图%,778)
		Char.SetData(PetFusionNPC,%对象_X%,7)
		Char.SetData(PetFusionNPC,%对象_Y%,0)
		Char.SetData(PetFusionNPC,%对象_方向%,4)
		Char.SetData(PetFusionNPC,%对象_原名%,"宠物融合npc")
		Char.SetWindowTalkedEvent("lua/Module/petfusion.lua","PetFusionNPCWindowTalk",PetFusionNPC)
		Char.SetTalkedEvent("lua/Module/petfusion.lua","PetFusionNPCTalk",PetFusionNPC)
		NLG.UpChar(PetFusionNPC)
	end
end

function PetFusionNPCTalk(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local msg = "\n宠物融合可以使你获得更强大的宠物。" ..
		"\n你需要使用两只可进行融合的宠物作为基础。" .. "\n请将想要进行融合的宠物放在宠物栏的前两位" ..
		"\n融合后你将获得一枚宠物蛋，24小时候后强大的融合宠物将从蛋中孵化而出。" ..
		"\n你将会失去进行融合的两只宠物！" ..
		"\n请确认你的物品栏至少有一个空位来获取宠物蛋！！" ..
		"\n确认进行融合？"
		NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定%+%按钮_否%,710,msg);
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
			--获取宠物的id的数组位置需要测试，api中没有
			pet1id = Char.GetData(pet1,1);
			pet2id = Char.GetData(pet2,1);
			print("pet1id " .. pet1id );
			print("pet2id " .. pet2id );
			if petFusionData[pet1id] and petFusionData[pet2id] then
				--两只宠物可融合
				--需要判断两只宠物是否为一阶宠物，如果是，需要分属为两方的（如：人龙+灵巧）
				print("lv=" .. petFusionData[pet1id].lv);
				if petFusionData[pet1id].lv == 1 and petFusionData[pet2id].lv == 1 then
					--如果是一级融合宠，需要判断part
					print(petFusionData[pet1id].part);
					print(petFusionData[pet2id].part);
					if petFusionData[pet1id].part == 1 and petFusionData[pet2id].part == 2 then
						print("canFusion");
						canFusion = true;
					else
						--提示宠物必须是两种类型的（人龙+灵巧）
					end

					if petFusionData[pet1id].part == 2 and petFusionData[pet2id].part == 1 then
						canFusion = true;
					else
						--提示宠物必须是两种类型的（人龙+灵巧）
					end

				else
					--非一阶宠物，需要处于同阶段才可融合
					if petFusionData[pet1id].lv == petFusionData[pet2id].lv then
						if petFusionData[pet1id].lv == 4 then
							--四阶宠物目前为最高阶段，不可继续融合
							canFusion = false;
							--提示最高阶宠物不可融合
						else
							canFusion = true;
						end
					else
						--提示同阶宠物才可融合
						canFusion = false;
					end
				end
			else
				--提示宠物为不可融合宠
				canFusion = false;
			end
			if canFusion then
				--可融合
				local pet1f = petFusionData[pet1id].feature;
				local pet2f = petFusionData[pet2id].feature;
				print("pet1f = " .. pet1f );
				print("pet2f = " .. pet2f );
				--两个宠物的lv相同
				local petLv = petFusionData[pet1id].lv;
				local petnewfeature = getNewPetFeature(pet1f, pet2f, petLv+1);
				print("petnewfeature =" .. petnewfeature );
				local targetPetTable = {};
				for k,v in pairs(petFusionData) do
					if v.feature == petnewfeature then
						--获得融合宠的集合
						local fusionPetId = k;
						print("fPetId = " .. fusionPetId);
						table.insert(tarPetTable,fusionPetId);
					end
				end
				if targetPetTable then
					--如果targetPetTable不是nil
					math.randomseed(tostring(os.time()));
					local targetPetNum = math.random(#tarPetTable);
					local targetPetId = targetPetTable[targetPetNum];
					-- 删除两个融合宠物
					Char.DelSlotPet(player,0);
					Char.DelSlotPet(player,1);
					-- 给玩家蛋
					Char.GiveItem(player,petFusionData[targetPetId].eggId,1);
					NLG.TalkToCli(player,-1,"融合成功！",%颜色_红色%);
				else
					NLG.TalkToCli(player,-1,"融合失败！",%颜色_红色%);
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
	对于2阶到3阶宠物，如果两只宠物的特征相同，则会少一个特征
	需要从额外的特征中随机选一个添加到新特征中
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
	lua中没有分割字符串的方法，自己实现的split方法
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
	通过size和lv
	返回该lv下随机的技能序号
	如：size=6，lv=4 说明共有6个技能，返回随机四个技能对应的table序号。
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
