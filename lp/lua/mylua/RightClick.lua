local FontColor = %��ɫ_��ɫ% --˽����ɫ
local WaitTime =  60 --ӭս�ȴ�ʱ�� ��
local DuleGroup = 1 --�Ƿ����������ս 1Ϊ���� ����Ϊ������
local DuleGroupMsg = "��ǰΪ�����սģʽ��˫������������Ѱ�Ҷ��Ѽ����Լ���"
local jstzTalk = "/������ս" --������սʱ�����ָ��
local jjtzTalk = "/�ܾ���ս" --�ܾ���սʱ�����ָ��
local lqjjTalk = "/��ȡ����" --��ȡ����ʱ�����ָ��
local MaxGold = 10000000 --���ħ������

--[[ ������ɫ�б�
	%��ɫ_��ɫ%
	%��ɫ_��ɫ%
	%��ɫ_��ɫ%
	%��ɫ_��ɫ%
	%��ɫ_��ɫ%
	%��ɫ_��ɫ%
	%��ɫ_��ɫ%
	%��ɫ_��ɫ%
	%��ɫ_����ɫ%
	%��ɫ_����ɫ%
]]

--����������������δ��ȡ�Ľ������עħ�Ҷ�����ա�
-------------------------------------------------------------
NL.RegRightClickEvent(nil,"RightClickValue1")
Delegate.RegDelLoginEvent("RightClickValue2")
Delegate.RegDelTalkEvent("RightClickValue3")

RightClickValue4 = RightClickValue4 or {}
RightClickValue5 = RightClickValue5 or {} 
RightClickValue6 = RightClickValue6 or {}
RightClickValue7 = RightClickValue7 or {}
function RightClickValue2(player)
	RightClickValue4[player] = nil
end

function RightClickValue8(RightClickValue15)
	local RightClickValue9 = Battle.GetWinSide(RightClickValue15)
	if RightClickValue6[RightClickValue7[RightClickValue15][RightClickValue9+1]] == nil then
		RightClickValue6[RightClickValue7[RightClickValue15][RightClickValue9+1]] = 2 * RightClickValue7[RightClickValue15][3]
	else
		RightClickValue6[RightClickValue7[RightClickValue15][RightClickValue9+1]] = RightClickValue6[RightClickValue7[RightClickValue15][RightClickValue9+1]] + 2 * RightClickValue7[RightClickValue15][3]
	end
	for i = 0,9 do
		local RightClickValue10 = Battle.GetPlayer(RightClickValue15,(i+10*RightClickValue9))
		if RightClickValue10 >= 0 then
			if Char.GetData(RightClickValue10,(%����_��%)) == (%��������_��%) then
				NLG.SystemMessage(RightClickValue10,"�����ڵĶ���ʤ���ˣ��ӳ��뾡������ "..lqjjTalk.." ����ȡ����δ����ȡ�Ľ�����ڷ�������������ʧ��")
			end
		end
	end
end


function RightClickValue3(player,RightClickValue17,color,range,size)
	local RightClickValue11 = Char.GetData(player,%����_CDK%)
	if RightClickValue17 == jstzTalk then
		if RightClickValue5[player] ~= nil then
			local RightClickValue12 = RightClickValue5[player][1]
			local RightClickValue13 = Char.GetData(RightClickValue12,%����_CDK%)
			local RightClickValue14 = Char.GetData(player,%����_���%)
			if RightClickValue14 >= RightClickValue5[player][4] then
				if DuleGroup ~= 1 then
					Char.DischargeParty(player)
					Char.DischargeParty(RightClickValue12)
				end
				local RightClickValue15 = Battle.PVP(player,RightClickValue12)
				if RightClickValue15 >= 0 then
					Char.SetData(player,%����_���%,RightClickValue14-RightClickValue5[player][4])
					NLG.UpChar(player)
					Battle.SetWinEvent(nil,"RightClickValue8",RightClickValue15)
					RightClickValue7[RightClickValue15] = {RightClickValue11,RightClickValue13,RightClickValue5[player][4]}
					RightClickValue5[player] = nil
				else
					NLG.SystemMessage(player,"����ս��ʧ�ܡ�")
				end
			else
				NLG.SystemMessage(player,"���ħ�Ҳ����Խ��ܴ˴���ս��")
			end
		else
			NLG.SystemMessage(player,"û�������������ս����ս�ѳ�ʱ��")
		end
		return 0
	elseif RightClickValue17 == jjtzTalk then
		if RightClickValue5[player] ~= nil then
			local RightClickValue16 = RightClickValue6[RightClickValue5[player][3]]
			if RightClickValue16 == nil then
				RightClickValue16 = 0
			end
			RightClickValue16 = RightClickValue16 + RightClickValue5[player][4]
			RightClickValue6[RightClickValue5[player][3]] = RightClickValue16
			NLG.SystemMessage(RightClickValue5[player][1],"�Է��Ѿܾ����������ս��������ע��ħ����תΪ�������������� "..lqjjTalk.." �����졣")
			NLG.SystemMessage(player,"���Ѿܾ�����ս��")
			RightClickValue5[player] = nil
		else
			NLG.SystemMessage(player,"û�������������ս����ս�ѳ�ʱ��")
		end
		return 0
	elseif RightClickValue17 == lqjjTalk then
		local RightClickValue16 = RightClickValue6[RightClickValue11]
		if RightClickValue16 == nil then
			RightClickValue16 = 0
		end
		if RightClickValue16 > 0 then
			local RightClickValue14 = Char.GetData(player,%����_���%)
			if RightClickValue14 < MaxGold then
				if RightClickValue14 + RightClickValue16 <= MaxGold then
					RightClickValue6[RightClickValue11] = nil
					Char.SetData(player,%����_���%,(RightClickValue14 + RightClickValue16))
					NLG.UpChar(player)
					NLG.SystemMessage(player,"������ȡ�ɹ���")
				else
					RightClickValue6[RightClickValue11] = (RightClickValue16 + RightClickValue14 - MaxGold)
					Char.SetData(player,%����_���%,MaxGold)
					NLG.UpChar(player)
					NLG.SystemMessage(player,"����ħ��̫���ˣ�ֻ�ܲ�����ȡ��������ϵ�ħ�Һ�ɼ�����ȡʣ��Ľ���")
				end
			else
				NLG.SystemMessage(player,"����ħ���������޷���ȡ����")
			end
		else
			NLG.SystemMessage(player,"��û����δ��ȡ�Ľ���")
		end
		return 0
	end
end

function RightClickValue1(player,RightClickValue12)
	RightClickValue4[player] = RightClickValue12
	local RightClickValue17 = "2\n��������ң�"..(Char.GetData(RightClickValue12,%����_ԭ��%)).."\n\n1.����˽��\n2.������ս"
	NLG.ShowWindowTalked(player,RightClickValue21,2,2,0,RightClickValue17)
end

function RightClickValue18(npc,player,Seqno,Select,Data)
	if Select ~= 2 then
		local RightClickValue12 = RightClickValue4[player]
		if RightClickValue12 ~= nil and RightClickValue12 >= 0 then
			local RightClickValue11 = Char.GetData(player,%����_CDK%)
			local RightClickValue13 = Char.GetData(RightClickValue12,%����_CDK%)
			if Seqno == 0 then
				if tonumber(Data) == 1 then
					local RightClickValue17 = "\n��������Ҫ��"..(Char.GetData(RightClickValue12,%����_ԭ��%)).."˵�Ļ�����ȷ����"
					NLG.ShowWindowTalked(player,npc,1,3,11,RightClickValue17)
				elseif tonumber(Data) == 2 then
					local RightClickValue17 = "\n��������Ҫ��"..(Char.GetData(RightClickValue12,%����_ԭ��%)).."������ս����ע������ȷ����"
					NLG.ShowWindowTalked(player,npc,1,3,21,RightClickValue17)
				end
			elseif Seqno == 11 then
				if Select == 1 then
					NLG.TalkToCli(RightClickValue12,player,Data,FontColor)
					RightClickValue4[player] = nil
				end
			elseif Seqno == 21 then
				if Select == 1 then
					if RightClickValue5[RightClickValue12] == nil then
						if tonumber(Data) ~= nil and tonumber(Data) > 0 and tonumber(Data) <= MaxGold then
							local RightClickValue14 = Char.GetData(player,%����_���%)
							if RightClickValue14 >= tonumber(Data) then
								Char.SetData(player,%����_���%,RightClickValue14-tonumber(Data))
								NLG.UpChar(player)
								local RightClickValue17 = "Lv"..(Char.GetData(player,%����_�ȼ�%)).."��"..(Char.GetData(player,%����_ԭ��%)).."��ע"..Data.."ħ�Ҷ��㷢������ս��"..WaitTime.."�������� "..jstzTalk.." �� "..jjtzTalk.." Ӧ�Դ˴���ս������Ĭ��Ϊ�ܾ���"
								if DuleGroup == 1 then
									RightClickValue17 = RightClickValue17..DuleGroupMsg
								end
								NLG.SystemMessage(RightClickValue12,RightClickValue17)
								RightClickValue17 = "��ս�Ѿ���������ȴ��Է��Ļ�Ӧ��"
								if DuleGroup == 1 then
									RightClickValue17 = RightClickValue17..DuleGroupMsg
								end
								NLG.SystemMessage(player,RightClickValue17)
								RightClickValue5[RightClickValue12] = {player,(os.time()+WaitTime),RightClickValue11,tonumber(Data)}
								RightClickValue4[player] = nil
							else
								NLG.SystemMessage(player,"���ħ�Ҳ��㡣")
								RightClickValue4[player] = nil
							end
						else
							NLG.SystemMessage(player,"������������ע��")
							RightClickValue4[player] = nil
						end
					else
						NLG.SystemMessage(player,"�Է����ڴ�����ս�С��޷�����������ս��")
					end
				end
			end
		end
	end
end

function RightClickValue19(npc)
	for k,v in pairs(RightClickValue5) do
		if os.time() > v[2] then
			local RightClickValue16 = RightClickValue6[v[3]]
			if RightClickValue16 == nil then
				RightClickValue16 = 0
			end
			RightClickValue16 = RightClickValue16 + v[4]
			RightClickValue6[v[3]] = RightClickValue16
			RightClickValue5[k] = nil
			NLG.SystemMessage(v[1],"���������ս�ѹ��ڣ�������ע��ħ����תΪ�������������� "..lqjjTalk.." �����졣")
		end
	end
end

function RightClickValue20(npc)
	Char.SetData(npc,%����_����%,100500)
	Char.SetData(npc,%����_ԭ��%,100500)
	Char.SetData(npc,%����_��ͼ%,777)
	Char.SetData(npc,%����_X%,1)
	Char.SetData(npc,%����_Y%,0)
	Char.SetData(npc,%����_����%,4)
	Char.SetData(npc,%����_ԭ��%,"�Ҽ�����")
	Char.SetWindowTalkedEvent(nil,"RightClickValue18",npc)
	Char.SetLoopEvent(nil,"RightClickValue19",npc,1000)
	NLG.UpChar(npc)
	return true
end

if RightClickValue21 == nil or RightClickValue21 < 0 then
	RightClickValue21 = NL.CreateNpc(nil,"RightClickValue20")
end