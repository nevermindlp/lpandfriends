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
		Char.SetData(PetFusionNPC,%对象_形象%,100500);
		Char.SetData(PetFusionNPC,%对象_原形%,100500);
		Char.SetData(PetFusionNPC,%对象_地图%,778);
		Char.SetData(PetFusionNPC,%对象_X%,7);
		Char.SetData(PetFusionNPC,%对象_Y%,0);
		Char.SetData(PetFusionNPC,%对象_方向%,4);
		Char.SetData(PetFusionNPC,%对象_原名%,"宠物融合npc");
		Char.SetWindowTalkedEvent("lua/Module/petfusion.lua","PetFusionNPCWindowTalk",PetFusionNPC);
		Char.SetTalkedEvent("lua/Module/petfusion.lua","PetFusionNPCTalk",PetFusionNPC);
		NLG.UpChar(PetFusionNPC);
	end
end

function CreateFeedEggNPC()
	if FeedEggNPC == nil then
		FeedEggNPC = NL.CreateNpc(nil,"PetFusionNPCCharInit");
		Char.SetData(FeedEggNPC,%对象_形象%,100500);
		Char.SetData(FeedEggNPC,%对象_原形%,100500);
		Char.SetData(FeedEggNPC,%对象_地图%,778);
		Char.SetData(FeedEggNPC,%对象_X%,8);
		Char.SetData(FeedEggNPC,%对象_Y%,0);
		Char.SetData(FeedEggNPC,%对象_方向%,4);
		Char.SetData(FeedEggNPC,%对象_原名%,"喂蛋npc");
		Char.SetWindowTalkedEvent("lua/Module/petfusion.lua","FeedEggNPCWindowTalk",FeedEggNPC);
		Char.SetTalkedEvent("lua/Module/petfusion.lua","FeedEggNPCTalk",FeedEggNPC);
		NLG.UpChar(FeedEggNPC);
	end
end

function FeedEggNPCTalk(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local msg = "\n请将需要喂食的蛋放在物品栏的第一位！" ..
		"\n确保你有足够喂食的饼干。。。" ..
		"\n嗯。。。让我们开始吧！看看能喂成什么。。。"
		NLG.ShowWindowTalked(_tome,_me,%窗口_信息框%,%按钮_确定%+%按钮_否%,720,msg);
	end
end

function FeedEggNPCWindowTalk(npc,player,Seqno,Select,Data)
	if Select == 8 then
		return;
	end
	if Select ~= 2 then
		--获取第一栏道具
		if Seqno == 720 then
			local item = Char.GetItemIndex(player,8);
			--判断道具是否为蛋可以通过名称或ID区间
			local eggIdCheck = Item.GetData(item,%道具_序%);
			print("eggIdCheck=" .. eggIdCheck);
			if eggIdCheck < 100236 or eggIdCheck > 100436 then\
				NLG.TalkToCli(player,-1,"请将宠物蛋放在物品栏的第一位！",%颜色_红色%);
				return;
			end
			local eggCreateTime = Item.GetData(item,%道具_自用参数%);
			print("eggCreateTime=" .. eggCreateTime);
			if not eggCreateTime then
				--应该是因为重复蛋的问题导致蛋没有被加入自定义参数即生成时间
				--需要重新设置时间，小概率事件
				Item.SetData(item,%道具_自用参数%,os.time());
				NLG.TalkToCli(player,-1,"每8个小时才可以喂一次蛋哦！",%颜色_红色%);
				return;
			end
			local findSecondFlag = string.find(eggCreateTime, secondEggFlag);
			local findFinalFlag = string.find(eggCreateTime, finalEggFlag);

			if findSecondFlag or findFinalFlag then
				--非第一次喂食
				local pos = findSecondFlag or findFinalFlag;
				eggCreateTime = string.sub(eggCreateTime, 1, pos - 1);
			end
			--判断饼干
			local haveFoodNum = Char.ItemNum(player,feedFoodId);
			local needFoodNum;
			if findSecondFlag then
				if haveFoodNum < needFoodNumLvTwo then
					NLG.TalkToCli(player,-1,"你的宠物蛋需要更多的食材！",%颜色_红色%);
					return;
				end
				needFoodNum = needFoodNumLvTwo;
			elseif findFinalFlag then
				if haveFoodNum < needFoodNumLvThree then
					NLG.TalkToCli(player,-1,"你的宠物蛋需要更多的食材！",%颜色_红色%);
					return;
				end
				needFoodNum = needFoodNumLvThree;
			else
				if haveFoodNum < needFoodNumLvOne then
					NLG.TalkToCli(player,-1,"你的宠物蛋需要更多的食材！",%颜色_红色%);
					return;
				end
				needFoodNum = needFoodNumLvOne;
			end


			if os.time() - eggCreateTime > feedEggInterval then
				local oriItemId = Item.GetData(item,%道具_序%);
				print("oriItemId=" .. oriItemId);
				if findSecondFlag then
					--第二次喂蛋
					local newItemId = oriItemId + 1;
					--删除原来的道具，将新道具（蛋）给玩家,并设置新蛋的时间和等级

					Item.Kill(player, item, 8);
					Char.GiveItem(player,newItemId,1);
					local eggObj = Char.HaveItem(player,newItemId);
					Item.SetData(eggObj, %道具_自用参数%, os.time() .. finalEggFlag);
					NLG.TalkToCli(player,-1,"宠物蛋好像更加更加。。呃。。大了。。",%颜色_红色%);
				elseif findFinalFlag then
					--第三次喂蛋
					--首先判断是否有空的宠物栏位置
					local havePets = Char.PetNum(player);
					if  havePets == 5 then
						NLG.TalkToCli(player,-1,"请保证有足够的宠物栏位！",%颜色_红色%);
						return;
					end
					local targetEggId = oriItemId -2;
					for k,v in pairs(petFusionData) do
						if v.eggId == targetEggId then
							--获得蛋对应的宠物ID
							local targetPetId = k;
							print("targetPetId = " .. targetPetId);
							--给玩家指定宠物,需要在data中加入宠物id的数据，现在只有图档ID
							Char.AddPet(player,petFusionData[targetPetId].eggPetId);  --eggPetId
						end
					end
					--删除原来的道具，将新道具（蛋）给玩家,并设置新蛋的时间和等级
					Item.Kill(player, item, 8);
					NLG.TalkToCli(player,-1,"有一个大家伙从你的蛋里钻了出来！",%颜色_红色%);
				else
					--第一次喂蛋
					local newItemId = oriItemId + 1;
					--删除原来的道具，将新道具（蛋）给玩家,并设置新蛋的时间和等级
					Item.Kill(player, item, 8);
					Char.GiveItem(player,newItemId,1);
					local eggObj = Char.HaveItem(player,newItemId);
					Item.SetData(eggObj, %道具_自用参数%, os.time() .. secondEggFlag);
					NLG.TalkToCli(player,-1,"宠物蛋好像更加。。呃。。大了。。",%颜色_红色%);
				end
				--删除食物
				Char.DelItem(player,feedFoodId,needFoodNum);
			else
				NLG.TalkToCli(player,-1,"每8个小时才可以喂一次蛋哦！",%颜色_红色%);
			end
		end

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
			--首先判断玩家是否有空道具栏
			local haveItems = Char.ItemSlot(player);
			if haveItems == 20 then
				NLG.TalkToCli(player,-1,"宠物融合前请保证至少有一个空道具栏位！",%颜色_红色%);
				return;
			end
			pet1 = Char.GetPet(player,0);
			pet2 = Char.GetPet(player,1);
			--获取宠物的id的数组位置需要测试，api中没有
			pet1id = Char.GetData(pet1,1);
			pet2id = Char.GetData(pet2,1);
			--限制融合最低等级30
			local pet1Lve = Char.GetData(pet1,%对象_等级%);
			local pet2Lve = Char.GetData(pet2,%对象_等级%);
			print("pet1Lve " .. pet1Lve  .. "pet2Lve " .. pet2Lve );
			if pet1Lve == 0 or pet2Lve == 0 then
				NLG.TalkToCli(player,-1,"融合宠物必须放在宠物栏第一位和第二位！",%颜色_红色%);
				return;
			end
			if pet1Lve < petFusionLowestLv or pet2Lve < petFusionLowestLv then
				NLG.TalkToCli(player,-1,"融合宠物最低等级为30级！",%颜色_红色%);
				return;
			end

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
					if (petFusionData[pet1id].part == 1 and petFusionData[pet2id].part == 2) or  (petFusionData[pet1id].part == 2 and petFusionData[pet2id].part == 1) then
						print("canFusion");
						canFusion = true;
					else
						--提示宠物必须是两种类型的（人龙+灵巧）
						NLG.TalkToCli(player,-1,"融合宠物必须分别来自大号大师球和小号大师球！",%颜色_红色%);
					end
				else
					--非一阶宠物，需要处于同阶段才可融合
					if petFusionData[pet1id].lv == petFusionData[pet2id].lv then
						if petFusionData[pet1id].lv == 4 then
							--四阶宠物目前为最高阶段，不可继续融合
							canFusion = false;
							--提示最高阶宠物不可融合
							NLG.TalkToCli(player,-1,"最高阶宠物不可融合！",%颜色_红色%);
						else
							canFusion = true;
						end
					else
						--提示同阶宠物才可融合
						NLG.TalkToCli(player,-1,"同阶宠物才可融合！",%颜色_红色%);
						canFusion = false;
					end
				end
			else
				--提示宠物为不可融合宠
				canFusion = false;
				NLG.TalkToCli(player,-1,"该宠物不可融合！",%颜色_红色%);
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
						table.insert(targetPetTable ,fusionPetId);
					end
				end
				if targetPetTable then
					--如果targetPetTable不是nil
					math.randomseed(tostring(os.time()));
					local targetPetNum = math.random(#targetPetTable);
					local targetPetId = targetPetTable[targetPetNum];
					-- 删除两个融合宠物
					Char.DelSlotPet(player,0);
					Char.DelSlotPet(player,1);
					-- 给玩家蛋
					math.randomseed(tostring(os.time()));
					local luckyRandomNum = math.random(1000);
					if luckyRandomNum == luckyNum then
						local playerName = Char.GetData(player,%对象_名字%);
						if petLv == 1 then
							--两个1阶宠物融合
							Char.GiveItem(player,100284,1);
						end
						if petLv == 2 then
							--两个2阶宠物融合
							Char.GiveItem(player,100323,1);
						end
						if petLv == 3 then
							--两个3阶宠物融合
							Char.GiveItem(player,100431,1);
						end
						NLG.TalkToCli(-1,-1,"OMG！" .. playerName.."竟然获得了传说中的宠物蛋！这是神马狗屎运！！！",%颜色_红色%);
					else
						print("eggId = " .. petFusionData[targetPetId].eggId);
						local eggId = petFusionData[targetPetId].eggId;
						Char.GiveItem(player,eggId,1);
						NLG.TalkToCli(player,-1,"融合成功！",%颜色_红色%);
						--给玩家蛋后，重新获取指定蛋ID的数量
						local eggCount = Char.ItemNum(player,eggId);
						if eggCount > 1 then
							--玩家有两个相同的egg。。
							print("bad luck。。。。");
						else
							--设置蛋的自定义属性
							local eggObj = Char.HaveItem(player,eggId);
							Item.SetData(eggObj, %道具_自用参数%, os.time());
							print("eggCreateTime 1111=" .. Item.GetData(eggObj, %道具_自用参数%));
						end
					end
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
	对于2阶到3阶宠物，如果两只宠物的特征相同，则会少一个特征
	需要从额外的特征中随机选一个添加到新特征中
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
	lua中没有分割字符串的方法，自己实现的split方法
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
	通过size和lv
	返回该lv下随机的技能序号
	如：size=6，lv=4 说明共有6个技能，返回随机四个技能对应的table序号。
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
