--[[ def_round_wincallback
	�������ܣ� ��ǰ����ս��������ÿ�����ʤ����Ļص�������
	���ﵽ�����ν�����׼ʱ(��һ����Ϊfirst_round_user_max����ʤ�������ೡ��Ϊ�������ս������)������xǿ��������
	
	������1)number battleindex:��ʾս��ָ��
	    
]]
function def_round_wincallback(battleindex)
	
	
	local winside = Battle.GetWinSide(battleindex);

	local sideM;

	tbl_swjjc_goinfo["create_battle_count"] = tbl_swjjc_goinfo["create_battle_count"] - 1;

	--��ȡʤ����
	if(winside == 0)then
		sideM = 0;
	else
		sideM = 10;
	end
	
	--��ȡʤ���������ָ�룬����վ��ǰ���ͺ�
	local w1 = Battle.GetPlayer(battleindex, 0 + sideM); 
	local w2 = Battle.GetPlayer(battleindex, 5 + sideM);
	local ww = nil;

	--��ʤ����Ҽ����б�
	if(VaildChar(w1) == true and Char.GetData(w1,%����_��½����%) >= 1)then
		ww = w1;
	else
		ww = w2;
	end

	table.insert(tbl_win_user,tonumber(ww));
	
	-- ��ʤ����ҽ���ͨ��
	if (tbl_swjjc_setting.this_user_WinFunc ~= nil)then
		local mc = 0;
		--local mc = math.abs(tbl_swjjc_goinfo["create_battle_count_bak"] - tbl_swjjc_goinfo["create_battle_count"]);
		-- this_user_WinFunc(playerindex,����);
		local f1 = loadstring(tbl_swjjc_setting.this_user_WinFunc.."("..ww..","..mc..")");	
		f1();
	end
	
	
	
	--�������ս
	if(tbl_swjjc_setting.round_count == 1)then
		--�ж������Ƿ��Ѵ����ڶ��ֵ�Ҫ��
		if(tonumber(#tbl_win_user) == tbl_swjjc_setting.first_round_user_max)then
			local f2 = loadstring(tbl_swjjc_setting.WinFunc.."(tbl_win_user)");	
			f2();
		end
	else	
		--�ж������Ƿ��Ѵ������һ�ֵ�Ҫ��
		if(tbl_swjjc_goinfo["create_battle_count"] == 0)then
			local f3 = loadstring(tbl_swjjc_setting.WinFunc.."(tbl_win_user)");	
			f3();
		end
	end
end