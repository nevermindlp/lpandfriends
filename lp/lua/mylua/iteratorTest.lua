local bossSet = {
["传说级入侵者"] = {["deadFlag"] = false , ["canBattleFlag"] = false , ["info"] = "3|0,20003,43,7||0|||||0|10007|||||||||"},
["传说级入侵者2"] = {["deadFlag"] = false , ["canBattleFlag"] = false , ["info"] = "3|0,20003,43,7||0|||||0|10007|||||||||"},
["test"] = {["deadFlag"] = false , ["canBattleFlag"] = false , ["info"] = "3|0,20003,43,7||0|||||0|10007|||||||||"}
};

function iteratorTable()
	local name1 = "传说级入侵者";
	local name2 = "test";
	local nameTable = {};
	nameTable[#nameTable + 1] = name1;
	nameTable[#nameTable + 1] = name2;

	local excludeTable = {};
	for k,v in pairs(bossSet) do
		--将所有玩家移出阵营战战场
		print(k);
		print(v);
		local exsit = false;
		for k1,v1 in pairs(nameTable) do
			if k == v1 then
				exsit = true;
			end
		end
		if not exsit then
			v.canBattleFlag = true;
		end
	end
	print(bossSet["test"]["canBattleFlag"]);
end


iteratorTable();
