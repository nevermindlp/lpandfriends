Delegate.RegDelBattleOverEvent("NewbieBless_BattleOver");

--ս������ȫ���¼�
function NewbieBless_BattleOver(_battle)

	for i=0,9 do
		local player = Battle.GetPlayer(_battle,i);
		if(player>-1 and Char.GetData(player,%����_�ȼ�%)<=30 and Char.GetData(player,%����_Ѫ%)<Char.GetData(player,%����_���Ѫ%))then
			Char.SetData(player,%����_Ѫ%,Char.GetData(player,%����_���Ѫ%));
			Char.SetData(player,%����_ħ%,Char.GetData(player,%����_���ħ%));
			NLG.UpChar(player);
			NLG.SystemMessage(player,"[��ʹ�ӻ�]"..Char.GetData(player,%����_����%).."�ܵ�����ʹ��ף��,����ֵ�ָ�ȫ��.");
		end
		if(player>-1 and Char.GetData(player,%����_ս��%)==0 and Char.GetData(player,%����_��þ���%)>1 and Battle.GetGainMode(_battle)==%ս��_��ͨ% and Battle.GetType(_battle)==%ս��_��ͨ%)then
			local battlePrize = math.random(1,100);
			if(battlePrize >=80 and battlePrize<=82 )then
				Char.SetData(player,%����_��þ���%,Char.GetData(player,%����_��þ���%)*103/100);
				NLG.UpChar(player);
				NLG.SystemMessage(player,"[ս��ӻ�]"..Char.GetData(player,%����_����%).."�ܵ���ս���ף��,����ս������ֵ����3%.");
			elseif(battlePrize >=97 and battlePrize<=99 )then
				Char.SetData(player,%����_��þ���%,Char.GetData(player,%����_��þ���%)*106/100);
				NLG.UpChar(player);
				NLG.SystemMessage(player,"[ս��ӻ�]"..Char.GetData(player,%����_����%).."�ܵ���ս���ף��,����ս������ֵ����6%.");
			elseif(battlePrize >=1 and battlePrize<=2 )then
				local battlePrizeGold = math.random(50,500);
				Char.AddGold(player,battlePrizeGold);
				NLG.SystemMessage(player,"[����ӻ�]"..Char.GetData(player,%����_����%).."�ܵ��˲����ף��,ս�����"..battlePrizeGold.."��Ǯ����.");
			elseif(battlePrize >=9 and battlePrize<=12 )then
				Char.SetData(player,%����_��þ���%,Char.GetData(player,%����_��þ���%)*97/100);
				NLG.UpChar(player);
				NLG.SystemMessage(player,"[˥��ӻ�]"..Char.GetData(player,%����_����%).."�ܵ���˥�������,����ս�����þ��齵��3%.");
			end
		end
	end

	return 1;
end
