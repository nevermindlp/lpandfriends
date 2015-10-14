--[[
黑市
data列表，每日更新其中的十项进入黑市。
形成竞价，每次提高10%，并显示当前最高者的名称在物品后面。
每日结算，给上一日竞拍胜利者物品，给失败者竞拍金钱。
需玩家第二日询问npc触发。
data列表中需要区分宠物or道具
]]--
--goodsType: 1-item,2-pet
Delegate.RegInit("BlackMarket_Init");


local showGoodsNum = 5;  --黑市每天po出的物品数量
local marketList = {};
local showGoodsList = {};
local targetGoods = {};
local increaseRate = 0.2;
local currencyItemId = 100203;
local canUseTargetGoods = {};
local allTargetGoods = {};


local initNum = 1;
function Entry (b)
	local tempTable = {id = b.id, name = b.name, price = b.price,  goodsType = b.goodsType};
	table.insert(marketList,tempTable);
	marketList[initNum] = tempTable;
	initNum = initNum + 1;
	print("1hao " ..  marketList[1]["id"]);
	--marketList[b.sid] = {id = b.id, name = b.name, price = b.price,  goodsType = b.goodsType};
	--print("1hao " .. marketList[1]["id"]);
end
dofile("/gmsv/lua/Module/blackMarketData.lua");


function BlackMarket_Init()
	CreateBlackMarketNPC();
	CreateGoodCollectionDepartmentNPC();
end

function BlackMarketNPCCharInit(_myIndex)
  return true;
end

function CreateBlackMarketNPC()
	if BlackMarketNPC == nil then
		BlackMarketNPC = NL.CreateNpc(nil,"BlackMarketNPCCharInit");
		Char.SetData(BlackMarketNPC,%对象_形象%,100500);
		Char.SetData(BlackMarketNPC,%对象_原形%,100500);
		Char.SetData(BlackMarketNPC,%对象_地图%,778);
		Char.SetData(BlackMarketNPC,%对象_X%,0);
		Char.SetData(BlackMarketNPC,%对象_Y%,3);
		Char.SetData(BlackMarketNPC,%对象_方向%,4);
		Char.SetData(BlackMarketNPC,%对象_原名%,"黑市");
		Char.SetWindowTalkedEvent("lua/Module/blackMarket.lua","BlackMarketNPCWindowTalk",BlackMarketNPC);
		Char.SetTalkedEvent("lua/Module/blackMarket.lua","BlackMarketNPCTalk",BlackMarketNPC);
		Char.SetLoopEvent("lua/Module/blackMarket.lua","BlackMarketNPCLoop",BlackMarketNPC,1000);
		NLG.UpChar(BlackMarketNPC);
	end
end

function CreateGoodCollectionDepartmentNPC()
	if GoodCollectionDepartmentNPC == nil then
		GoodCollectionDepartmentNPC = NL.CreateNpc(nil,"BlackMarketNPCCharInit");
		Char.SetData(GoodCollectionDepartmentNPC,%对象_形象%,100500);
		Char.SetData(GoodCollectionDepartmentNPC,%对象_原形%,100500);
		Char.SetData(GoodCollectionDepartmentNPC,%对象_地图%,778);
		Char.SetData(GoodCollectionDepartmentNPC,%对象_X%,1);
		Char.SetData(GoodCollectionDepartmentNPC,%对象_Y%,3);
		Char.SetData(GoodCollectionDepartmentNPC,%对象_方向%,4);
		Char.SetData(GoodCollectionDepartmentNPC,%对象_原名%,"黑市物品领取处");
		Char.SetWindowTalkedEvent("lua/Module/blackMarket.lua","GoodCollectionDepartmentWindowTalk",GoodCollectionDepartmentNPC);
		Char.SetTalkedEvent("lua/Module/blackMarket.lua","GoodCollectionDepartmentNPCTalk",GoodCollectionDepartmentNPC);
		NLG.UpChar(GoodCollectionDepartmentNPC);
	end
end

function GoodCollectionDepartmentNPCTalk(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local msg = "1\n\n1. ★领取竞拍物品&未竞拍成功金额★";
		NLG.ShowWindowTalked(_tome,_me,2,2,1200,msg);
	end
end

function GoodCollectionDepartmentWindowTalk(npc,player,Seqno,Select,Data)
	print("Data=" .. Data);
	local moneyCount = 0;
	if Select ~= 2 then
		if Seqno == 1200 then
			if tonumber(Data) == 1 then
				for k,v in pairs(allTargetGoods) do
					local tgoods = v;
					for m,n in pairs(tgoods) do
						local goodsId = m;
						local goods = getGoodsById(goodsId);
						local goodsType = goods[goodsType];
						if n["winner"][player] then
						--竞胜者
							if goodsType == 1 then
							--道具
								if Char.ItemSlot(player) == 20 then
									--物品栏已满
									NLG.TalkToCli(player,-1,"你的物品栏好像满了，先清理下吧！",%颜色_红色%);
									return
								end
								Char.GiveItem(player,k,1);
							end
							if goodsType == 2 then
							--宠物
								if Char.PetNum(player) == 5 then
									--宠物栏已满
									NLG.TalkToCli(player,-1,"你的宠物栏好像满了，先清理下吧！",%颜色_红色%);
									return
								end
								Char.AddPet(player,k);
							end
							allTargetGoods[k][m]["winner"] = {};
						end
						--竞败者
						local failureList = n["failure"];
						for i,j in pairs(failureList) do
							if j[player] then
								local tempPrice = j[player];
								allTargetGoods[k][m]["failure"][i] = {};
								moneyCount = moneyCount + tempPrice;
							end
						end
					end
				end
				if moneyCount ~= 0 then
					--将总竞败物品给玩家
					Char.GiveItem(player,currencyItemId,moneyCount);
				end
			end
		end
	end
end

function getGoodsById(goodsId)
	for k,v in pairs(marketList) do
		if v.id == goodsId then
			return v;
		end
	end
end

function BlackMarketNPCTalk(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local msg = 1 .. "|\\n哈哈！欢迎光临！\\n";
		if #showGoodsList == 0 then
			changeMarketList();
		end
		print("size =" .. #showGoodsList );
		for k,v in pairs(showGoodsList) do
			print("k=" .. k );
			local goods = v;
			local goodsName = goods["name"];
			print("name == " ..  goodsName );
			local goodPrice = goods["price"];
			msg = msg .. "" .. k .. ".★" .. goodsName .. "********" .. goodPrice .. "\\n";
		end
		--local msg = "\n哈哈！欢迎光临！".. "" .."\n\n1.确定\n2.还是算了";
		NLG.ShowWindowTalked(_tome,_me,2,2,1100,msg);
	end
end

function BlackMarketNPCWindowTalk(npc,player,Seqno,Select,Data)
	print("Data=" .. Data);
	if Select ~= 2 then
		if Seqno == 1100 then
			local test = tonumber(Data);
			print("-----" .. showGoodsList[test]["name"]);
			local choseGoods = showGoodsList[tonumber(Data)];
			local choseGoodsId = choseGoods["id"];
			local choseGoodsPrice = choseGoods["price"];
			--判定并扣除玩家货币
			local playerCurrencyNum = Char.ItemNum(player,currencyItemId);
			if playerCurrencyNum < tonumber(choseGoodsPrice) then
				--骚年，充点软妹币呗
				NLG.TalkToCli(player,-1,"哦，你好像买不起这个，看看别的吧！",%颜色_红色%);
				return;
			else
				--款爷
				Char.DelItem(player,currencyItemId,choseGoodsPrice);
			end

			local newPrice = generateNewPrice(tonumber(choseGoodsPrice));
			--加价
			choseGoods['price'] = newPrice;
			local playerAndPay = {};
			playerAndPay[player] = choseGoodsPrice;
			print("playerAndPay " .. playerAndPay[player]);
			if targetGoods[choseGoodsId] then
				local oriPlayOfPay = targetGoods[choseGoodsId]["winner"];
				targetGoods[choseGoodsId]['winner'] = playerAndPay;
				local failureTable;
				if targetGoods[choseGoodsId]['failure'] then
					failureTable = targetGoods[choseGoodsId]["failure"];
				else
					failureTable = {};
				end
				failureTable[#failureTable + 1] = oriPlayOfPay;
				targetGoods[choseGoodsId]['failure'] = failureTable;
			else
				targetGoods[choseGoodsId] = {};
				targetGoods[choseGoodsId]['winner'] = playerAndPay;
				print("choseGoodsId = " .. choseGoodsId);
				print("tg size" .. #targetGoods);
				print("enddddd");
			end
		end
	end
end

function generateNewPrice(price)
	local newPrice = math.ceil(price + price * increaseRate);
	return newPrice;
end

function BlackMarketNPCLoop(_MePtr)
	if os.date("%X",os.time()) == '00:00:00' then
		showGoodsList = changeMarketList();
		local tempTargetGoods = targetGoods;
		allTargetGoods[#allTargetGoods + 1] = tempTargetGoods;
		targetGoods = {};
		local marketInfo = "啊哈哈，黑市里又到了一批新货，快来看看吧！";
		print(marketInfo);
		NLG.TalkToCli(-1,-1,marketInfo,%颜色_红色%);
	end
end

function changeMarketList()

	math.randomseed(tostring(os.time()));
	math.random();
	local randomNumList = {};
	local repeatFlag = false;
	local goodsList = {};

	while(true) do
		print("------------");
		local randomNum = math.random(#marketList);
		for k,v in pairs(randomNumList) do
			if v == randomNum then
				repeatFlag = true;
			end
		end
		if not repeatFlag then
			if #randomNumList < showGoodsNum then
				table.insert(randomNumList,randomNum);
				--[[
				if  #randomNumList == showGoodsNum then
					return randomNumList;
				end
				]]--
			end
			if #randomNumList == showGoodsNum then
				for k,v in pairs(randomNumList) do
					local goodsOrder = v;
					local goods = marketList[goodsOrder];
					print("goodsOrder" .. goodsOrder);
					print("marketList size =" .. #marketList );
					print("goods name =" .. goods["name"]);
					--table.insert(goodsList,goods);
					local curGoodsListSize = #goodsList;
					goodsList[curGoodsListSize + 1] = goods
				end
				showGoodsList = goodsList;
				return goodsList;
			end
		end
		repeatFlag = false;
	end
end
