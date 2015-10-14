
local allTargetGoods = {};

function initdata()
	local targetGoods = {};
	local playerAndPay = {["player1"] = 20};
	local choseGoodsId = "10000";
	if targetGoods[choseGoodsId] then
		local oriPlayOfPay = targetGoods[choseGoodsId]["winner"];
		targetGoods[choseGoodsId]['winner'] = playerAndPay;
		local failureTable;
		if targetGoods[choseGoodsId]['failure'] then
			local failureTable = targetGoods[choseGoodsId]["failure"];
			--table.insert(failureList,oriPlayOfPay);
		else
			local failureTable = {};
		end
		failureTable[#failureTable + 1] = oriPlayOfPay;
		targetGoods[choseGoodsId]["failure"] = failureTable;
	else
		targetGoods[choseGoodsId] = {};
		targetGoods[choseGoodsId]['winner'] = playerAndPay;
		print("choseGoodsId = " .. choseGoodsId);
		print("tg size   " .. #targetGoods);
		print("enddddd");
	end


	local playerAndPay = {["player2"] = 30};
	local choseGoodsId = "10000";
	if targetGoods[choseGoodsId] then
		local oriPlayOfPay = targetGoods[choseGoodsId]["winner"];
		targetGoods[choseGoodsId]['winner'] = playerAndPay;
		if targetGoods[choseGoodsId]['failure'] then
			local failureTable = targetGoods[choseGoodsId]["failure"];
			failureTable[#failureTable + 1] = oriPlayOfPay;
			targetGoods[choseGoodsId]["failure"] = failureTable;
			--table.insert(failureList,oriPlayOfPay);
		else
			local failureTable = {};
			failureTable[#failureTable + 1] = oriPlayOfPay;
			targetGoods[choseGoodsId]['failure'] = failureTable;
		end
	else
		targetGoods[choseGoodsId] = {};
		targetGoods[choseGoodsId]['winner'] = playerAndPay;
		print("choseGoodsId = " .. choseGoodsId);
		print("tg size   " .. #targetGoods);
		print("enddddd");
	end

	local playerAndPay = {["player3"] = 40};
	local choseGoodsId = "10000";
	if targetGoods[choseGoodsId] then
		local oriPlayOfPay = targetGoods[choseGoodsId]["winner"];
		targetGoods[choseGoodsId]['winner'] = playerAndPay;
		if targetGoods[choseGoodsId]['failure'] then
			local failureTable = targetGoods[choseGoodsId]["failure"];
			failureTable[#failureTable + 1] = oriPlayOfPay;
			targetGoods[choseGoodsId]["failure"] = failureTable;
			--table.insert(failureList,oriPlayOfPay);
		else
			local failureTable = {};
			failureTable[#failureTable + 1] = oriPlayOfPay;
			targetGoods[choseGoodsId]['failure'] = failureTable;
		end
	else
		targetGoods[choseGoodsId] = {};
		targetGoods[choseGoodsId]['winner'] = playerAndPay;
		print("choseGoodsId = " .. choseGoodsId);
		print("tg size   " .. #targetGoods);
		print("enddddd");
	end
	return targetGoods;
end

function calculate(player)
	local moneyCount = 0;
	for k,v in pairs(allTargetGoods) do
		local tgoods = v;
		for m,n in pairs(tgoods) do
			local goodsId = m;
			if n["winner"][player] then
			--æ∫ §’ﬂ
				print("winner = " .. player)
				allTargetGoods[k][m]["winner"] = {};
			end
			--æ∫∞‹’ﬂ
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
	print("moneyCount =" .. moneyCount);
end


allTargetGoods[#allTargetGoods + 1] = initdata();
allTargetGoods[#allTargetGoods + 1] = initdata();

calculate("player1");
calculate("player1");
calculate("player2");

print("end!");
