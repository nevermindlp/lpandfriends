Delegate.RegDelBattleStartEvent("LvOnePet_Event");

function LvOnePet_Event(battle)
	for BWhile=10,19 do
		local PlayerIndex = Battle.GetPlayer(battle,BWhile);
		if(VaildChar(PlayerIndex)==true) then
			if(Char.GetData(PlayerIndex,%����_�ȼ�%) == 1 and Char.GetData(PlayerIndex,%����_����%) ~= "�粼��" and Char.GetData(PlayerIndex,%����_����%) ~= "��������") then
				for BPWhile=0,4 do
					local BPlayerIndex = Battle.GetPlayer(battle,BPWhile);
					if(BPlayerIndex >= 0) then
						NLG.TalkToCli(BPlayerIndex,-1,"[����һ���������]����һ�����"..Char.GetData(PlayerIndex,%����_����%).."�����֣�",%��ɫ_��ɫ%,%����_��%);
					end
				end
			end
		end
	end
end
