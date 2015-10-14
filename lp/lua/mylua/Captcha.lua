Delegate.RegInit("Captcha_Init");

function Init_Captcha(_index)
	return 1;
end

function Code_new_tbl()
	local _tbl_Codeinfo =
	{
		Code = "";
		State = 1;
		Time = 0;
	}
	return _tbl_Codeinfo;
end

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

function Captcha_WindowEvent( _index_me, _index_tome, _sequence, _select, _data)
	local _Player = Playerkey(_index_tome);
	if(tbl_Codeinfo[_Player] == nil) then
		tbl_Codeinfo[_Player] = Code_new_tbl();
	end
	if( _sequence == 500 )then
		if(_select == %按钮_确定%) then
			if(_data == tbl_Codeinfo[_Player].Code) then
				tbl_Codeinfo[_Player].Time = os.time();
				tbl_Codeinfo[_Player].State = 0;
				NLG.SystemMessage(_index_tome,"[验证码系统]验证码输入正确!您在未来的60分钟内将不再需要输入验证码。现在请您重新跟NPC对话!")
				--NLG.ShowWindowTalked( _index_tome, _index_me, %窗口_信息框%, %按钮_关闭%, 600, NLG.c("\\n\\n验证码输入正确!\\n\\n您在未来的60分钟内将不再需要输入验证码。\\n\\n现在请您重新跟NPC对话!"));
			else
				NLG.ShowWindowTalked( _index_tome, _index_me, %窗口_信息框%, %按钮_关闭%, 601, NLG.c("\\n\\n验证码输入错误,请重新输入!"));
			end
		end
	end
end

function Captcha_Init()
	if (Captcha_index == nil) then
		Captcha_index = NL.CreateNpc("lua/Module/Captcha.lua", "Init_Captcha");
		Char.SetData(Captcha_index,%对象_形象%,10414);
		Char.SetData(Captcha_index,%对象_原形%,10414);
		Char.SetData(Captcha_index,%对象_X%,78);
		Char.SetData(Captcha_index,%对象_Y%,77);
		Char.SetData(Captcha_index,%对象_地图%,777);
		Char.SetData(Captcha_index,%对象_方向%,4);
		Char.SetData(Captcha_index,%对象_名字%,"验证码");
		NLG.UpChar(Captcha_index);
		--Char.SetTalkedEvent("lua/Module/Captcha.lua", "Captcha_Talk", Captcha_index);
		Char.SetWindowTalkedEvent("lua/Module/Captcha.lua", "Captcha_WindowEvent", Captcha_index);
	end
	Protocol.OnRecv("lua/Module/Captcha.lua", "Captcha_Recv", %RECV_WN%)
end

function Captcha_Recv(fd,head,packet)
	local player = Protocol.GetCharByFd(fd);
	local _Player = Playerkey(player);
	if(tbl_Codeinfo[_Player] == nil) then
		tbl_Codeinfo[_Player] = Code_new_tbl();
	end
	--验证间隔是3600秒,既1小时
	if(os.time() - tbl_Codeinfo[_Player].Time > 3600) then
		tbl_Codeinfo[_Player].State = 1;
		local SplitArray = Split(packet,":");
		if(SplitArray[3] == "5n" or SplitArray[3] == "5i" or SplitArray[3] == "5S") then
			local verifyCode = makeCod();
			tbl_Codeinfo[_Player].Code = verifyCode[1]..verifyCode[2]..verifyCode[3]..verifyCode[4];
			local checkTab = makeVerifyCod(verifyCode);
			local checkStr = "";
			checkStr = makeStr(checkTab);
			local window_info=""..checkStr.."\\n请输入上面显示的验证码(均为数字)："
			NLG.ShowWindowTalked( player, Captcha_index, %窗口_输入框%, %按钮_确定关闭%, 500, window_info);
			return 1;
		end
	end

end