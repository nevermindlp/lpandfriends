--[[
����
data�б�ÿ�ո������е�ʮ�������С�
�γɾ��ۣ�ÿ�����10%������ʾ��ǰ����ߵ���������Ʒ���档
ÿ�ս��㣬����һ�վ���ʤ������Ʒ����ʧ���߾��Ľ�Ǯ��
����ҵڶ���ѯ��npc������
data�б�����Ҫ���ֳ���or����
]]--
--goodsType: 1-item,2-pet
Delegate.RegInit("BlackMarket_Init");


local showGoodsNum = 10;  --����ÿ��po������Ʒ����
local marketList = {};
local showGoodsList = {};
local targetGoods = {};
local increaseRate = 0.2;
local currencyItemId = 1000000;


function Entry (b)
	local tempTable = {id = b.id, name = b.name, price = b.price,  goodsType = b.goodsType};
	table.insert(marketList,tempTable);
end
dofile("/gmsv/lua/Module/marketData.lua");


function BlackMarket_Init()
	CreateBlackMarketNPC();
end

function BlackMarketNPCCharInit(_myIndex)
  return true;
end

function CreateBlackMarketNPC()
	if BlackMarketNPC == nil then
		BlackMarketNPC = NL.CreateNpc(nil,"BlackMarketNPCCharInit");
		Char.SetData(BlackMarketNPC,%����_����%,100500);
		Char.SetData(BlackMarketNPC,%����_ԭ��%,100500);
		Char.SetData(BlackMarketNPC,%����_��ͼ%,778);
		Char.SetData(BlackMarketNPC,%����_X%,0);
		Char.SetData(BlackMarketNPC,%����_Y%,3);
		Char.SetData(BlackMarketNPC,%����_����%,4);
		Char.SetData(BlackMarketNPC,%����_ԭ��%,"����");
		Char.SetWindowTalkedEvent("lua/Module/blackMarket.lua","BlackMarketNPCWindowTalk",BlackMarketNPC);
		Char.SetTalkedEvent("lua/Module/blackMarket.lua","BlackMarketNPCTalk",BlackMarketNPC);
		Char.SetLoopEvent("lua/Module/blackMarket.lua","BlackMarketNPCLoop",BlackMarketNPC,1000);
		NLG.UpChar(BlackMarketNPC);
	end
end

function CreateGoodCollectionDepartmentNPC()
	if GoodCollectionDepartmentNPC == nil then
		GoodCollectionDepartmentNPC = NL.CreateNpc(nil,"BlackMarketNPCCharInit");
		Char.SetData(GoodCollectionDepartmentNPC,%����_����%,100500);
		Char.SetData(GoodCollectionDepartmentNPC,%����_ԭ��%,100500);
		Char.SetData(GoodCollectionDepartmentNPC,%����_��ͼ%,778);
		Char.SetData(GoodCollectionDepartmentNPC,%����_X%,1);
		Char.SetData(GoodCollectionDepartmentNPC,%����_Y%,3);
		Char.SetData(GoodCollectionDepartmentNPC,%����_����%,4);
		Char.SetData(GoodCollectionDepartmentNPC,%����_ԭ��%,"������Ʒ��ȡ��");
		Char.SetWindowTalkedEvent("lua/Module/blackMarket.lua","GoodCollectionDepartmentWindowTalk",GoodCollectionDepartmentNPC);
		Char.SetTalkedEvent("lua/Module/blackMarket.lua","GoodCollectionDepartmentNPCTalk",GoodCollectionDepartmentNPC);
		NLG.UpChar(GoodCollectionDepartmentNPC);
	end
end

function GoodCollectionDepartmentNPCTalk(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local msg = "\n\n1. ����ȡ������Ʒ&δ���ĳɹ�����";
		NLG.ShowWindowTalked(_tome,_me,2,2,1200,msg);
	end
end

function GoodCollectionDepartmentWindowTalk(npc,player,Seqno,Select,Data)
	print("Data=" .. Data);
	local moneyCount = 0;
	if Select ~= 2 then
		if Seqno == 1200 then
			if Data == 1 then
				for k,v in pairs(targetGoods) do
					local goodsId = k;
					local goods = getGoodsById(goodsId);
					local goodsType = goods[goodsType];
					if v["winner"][player] then
					--��ʤ��
						if goodsType == 1 then
						--����
							if Char.ItemSlot(player) == 20 then
								--��Ʒ������
								NLG.TalkToCli(player,-1,"�����Ʒ���������ˣ��������°ɣ�",%��ɫ_��ɫ%);
								return
							end
							Char.GiveItem(player,k,1);
						end
						if goodsType == 2 then
						--����
							if Char.PetNum(player) == 5 then
								--����������
								NLG.TalkToCli(player,-1,"��ĳ������������ˣ��������°ɣ�",%��ɫ_��ɫ%);
								return
							end
							Char.AddPet(player,k);
						end
						targetGoods[k]["winner"] = {};
					else
					--������
						local failureList = v["failure"];
						for k,v in pairs(failureList)
							if v[player] then
								local tempPrice = v[player];
								moneyCount = moneyCount + tempPrice;
							end
						end
					end
				end
				--���ܾ�����Ʒ�����
				Char.GiveItem(player,currencyItemId,moneyCount);
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
		local msg = "\n��������ӭ���٣�\n";
		if #showGoodsList == 0 then
			changeMarketList();
		end
		for k,v in pairs(showGoodsList) do
			local goods = v;
			local goodsName = goods[name];
			local goodPrice = goods[price];
			msg = msg .. k .. ".��" .. goodsName .. "********" .. goodPrice .. "\n";
		end
		--local msg = "\n��������ӭ���٣�".. "" .."\n\n1.ȷ��\n2.��������";
		NLG.ShowWindowTalked(_tome,_me,2,2,1100,msg);
	end
end

function BlackMarketNPCWindowTalk(npc,player,Seqno,Select,Data)
	print("Data=" .. Data);
	if Select ~= 2 then
		if Seqno == 1100 then
			local choseGoods = showGoodsList[Data];
			local choseGoodsId = choseGoods[id];
			local choseGoodsPrice = choseGoods[price];
			--�ж����۳���һ���
			local playerCurrencyNum = Char.ItemNum(player,currencyItemId);
			if playerCurrencyNum < choseGoodsPrice then
				--ɧ�꣬������ñ���
				NLG.TalkToCli(player,-1,"Ŷ����������������������İɣ�",%��ɫ_��ɫ%);
				return;
			else
				--��ү
				Char.DelItem(player,currencyItemId,choseGoodsPrice);
			end

			local newPrice = generateNewPrice(choseGoodsPrice);
			--�Ӽ�
			choseGoods[price] = newPrice;
			local playerAndPay = {player = choseGoodsPrice};
			if targetGoods[choseGoodsId] then
				local oriPlayOfPay = targetGoods[choseGoodsId]["winner"];
				targetGoods[choseGoodsId]["winner"] = playerAndPay;
				if targetGoods[choseGoodsId]["failure"] then
					local failureList = targetGoods[choseGoodsId]["failure"];
					table.insert(failureList,oriPlayOfPay);
				else
					targetGoods[choseGoodsId]["failure"] = {};
				end
			else
				targetGoods[choseGoodsId] = {};
				targetGoods[choseGoodsId]["winner"] = playerAndPay;
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
		local marketInfo = "���������������ֵ���һ���»������������ɣ�";
		print(marketInfo);
		NLG.TalkToCli(-1,-1,marketInfo,%��ɫ_��ɫ%);
	end
end

function changeMarketList()
	math.randomseed(tostring(os.time()));
	math.random(size);
	local randomNumList = {};
	local repeatFlag = false;
	local goodsList = {};

	while(true)
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
					table.insert(goodsList,goods);
				end
				showGoodsList = goodsList;
				return goodsList;
			end
		end
		repeatFlag = false;
	end
end
