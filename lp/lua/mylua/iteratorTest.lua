local bossSet = {
["��˵��������"] = {["deadFlag"] = false , ["canBattleFlag"] = false , ["info"] = "3|0,20003,43,7||0|||||0|10007|||||||||"},
["��˵��������2"] = {["deadFlag"] = false , ["canBattleFlag"] = false , ["info"] = "3|0,20003,43,7||0|||||0|10007|||||||||"},
["test"] = {["deadFlag"] = false , ["canBattleFlag"] = false , ["info"] = "3|0,20003,43,7||0|||||0|10007|||||||||"}
};

function iteratorTable()
	local name1 = "��˵��������";
	local name2 = "test";
	local nameTable = {};
	nameTable[#nameTable + 1] = name1;
	nameTable[#nameTable + 1] = name2;

	local excludeTable = {};
	for k,v in pairs(bossSet) do
		--����������Ƴ���Ӫսս��
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
