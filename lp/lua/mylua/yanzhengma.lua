local codeTab = {
				["1"] = {
						{0,0,1,0,0},
						{0,1,1,0,0},
						{0,0,1,0,0},
						{0,0,1,0,0},
						{0,0,1,0,0},
						{0,0,1,0,0},
						{1,1,1,1,1}
						},
				["2"] = {
						{0,0,0,0,0},
						{0,1,1,1,0},
						{1,0,0,0,1},
						{0,0,0,1,0},
						{0,0,1,0,0},
						{0,1,0,0,0},
						{1,1,1,1,1}
						},
				["3"] = {
						{1,1,1,1,0},
						{0,0,0,0,1},
						{0,0,0,0,1},
						{1,1,1,1,1},
						{0,0,0,0,1},
						{0,0,0,0,1},
						{1,1,1,1,0}
						},
				["4"]= {
						{1,0,1,0,0},
						{1,0,1,0,0},
						{1,0,1,0,0},
						{1,0,1,0,0},
						{1,1,1,1,1},
						{0,0,1,0,0},
						{0,0,1,0,0}
						},
				["5"] = {
						{1,1,1,1,1},
						{1,0,0,0,0},
						{1,0,0,0,0},
						{1,1,1,1,1},
						{0,0,0,0,1},
						{0,0,0,1,0},
						{0,0,1,0,0}
						},
				["6"] = {
						{1,1,1,1,1},
						{1,0,0,0,0},
						{1,0,0,0,0},
						{1,1,1,1,1},
						{1,0,0,0,1},
						{1,0,0,0,1},
						{0,1,1,1,0}
						},
				["7"] = {
						{1,1,1,1,1},
						{0,0,0,0,1},
						{0,0,0,1,0},
						{0,0,1,0,0},
						{0,0,1,0,0},
						{0,0,1,0,0},
						{0,0,1,0,0}
						},
				["8"] = {
						{1,1,1,1,1},
						{1,0,0,0,1},
						{1,0,0,0,1},
						{1,1,1,1,1},
						{1,0,0,0,1},
						{1,0,0,0,1},
						{1,1,1,1,1}
						},
				["9"] = {
						{0,1,1,1,0},
						{1,0,0,0,1},
						{1,0,0,0,1},
						{0,1,1,1,0},
						{0,0,0,0,1},
						{0,0,0,0,1},
						{0,0,1,1,0}
						},
				["0"] = {
						{0,1,1,1,0},
						{1,0,0,0,1},
						{1,0,0,0,1},
						{1,0,0,0,1},
						{1,0,0,0,1},
						{1,0,0,0,1},
						{0,1,1,1,0}
						},
				};

local codeRandom = {
					"1","2","3","4","5",
					"6","7","8","9","0",
}

local useCode = {"●","◆","■","▲","★"};
local unuseCode = {"　"};

function makeCod()
	math.randomseed(tostring(os.time()));
	math.random(10);
	local strTab = {codeRandom[math.random(1,#(codeRandom))],
					codeRandom[math.random(1,#(codeRandom))],
					codeRandom[math.random(1,#(codeRandom))],
					codeRandom[math.random(1,#(codeRandom))]};
	return strTab;
end

function makeVerifyCod(tab)
	local num = {2};
	local enter = {3};
	local rTab = {};
	local tTab = {codeTab[tab[1]][1],num,codeTab[tab[2]][1],num,codeTab[tab[3]][1],num,codeTab[tab[4]][1],enter,
					codeTab[tab[1]][2],num,codeTab[tab[2]][2],num,codeTab[tab[3]][2],num,codeTab[tab[4]][2],enter,
					codeTab[tab[1]][3],num,codeTab[tab[2]][3],num,codeTab[tab[3]][3],num,codeTab[tab[4]][3],enter,
					codeTab[tab[1]][4],num,codeTab[tab[2]][4],num,codeTab[tab[3]][4],num,codeTab[tab[4]][4],enter,
					codeTab[tab[1]][5],num,codeTab[tab[2]][5],num,codeTab[tab[3]][5],num,codeTab[tab[4]][5],enter,
					codeTab[tab[1]][6],num,codeTab[tab[2]][6],num,codeTab[tab[3]][6],num,codeTab[tab[4]][6],enter,
					codeTab[tab[1]][7],num,codeTab[tab[2]][7],num,codeTab[tab[3]][7],num,codeTab[tab[4]][7],enter};
	rTab = makeTabAdd(tTab);
	--print(TableList(rTab, "rTab"));
	return rTab;
end

function makeStr(stab)
	local str = "";
	for k,v in pairs(stab) do
		if(v == 0)then
			str = str..unuseCode[math.random(1,#(unuseCode))];
		elseif(v == 1) then
			str = str..useCode[math.random(1,#(useCode))];
		elseif(v == 2) then
			str = str.."‖";
		elseif(v == 3) then
			--str = str.."\n";
		end
	end

	return str;
end

function makeTabAdd(tab)
	local rsTab = {} ;
	for k,v in pairs(tab) do
		for _k,_v in pairs(v) do
			table.insert(rsTab,_v);
		end

	end
	return rsTab;
end
--验证码生成部分结束
print("create num = " .. makeStr(makeVerifyCod(makeCod())));
