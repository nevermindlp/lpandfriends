--������ѯ

Delegate.RegInit("fram_Init");

function initframNpc_Init(index)
	print("������ѯnpc_index = " .. index);
	return 1;
end


function fram_create() --������ѯ
	if (fram_index == nil) then
		fram_index = NL.CreateNpc("lua/Module/fram.lua", "initframNpc_Init");
		Char.SetData(fram_index,%����_����%,10414);
		Char.SetData(fram_index,%����_ԭ��%,10414);
		Char.SetData(fram_index,%����_X%,231);
		Char.SetData(fram_index,%����_Y%,83);
		Char.SetData(fram_index,%����_��ͼ%,1000);
		Char.SetData(fram_index,%����_����%,4);
		Char.SetData(fram_index,%����_����%,"���ɵ�������ѯ��");
		NLG.UpChar(fram_index);
		Char.SetTalkedEvent("lua/Module/fram.lua", "FramTalk", fram_index);
		Char.SetWindowTalkedEvent("lua/Module/fram.lua", "FramEvent", fram_index);
	end
end


function FramTalk(_NpcIndex,_PlayerIndex)
	if (NLG.CanTalk(_NpcIndex,_PlayerIndex) == true) then
		WindowMsg = "3\\n\\n 			����������ʲô������\\n\\nHi,�������������ж���������!\\n\\n(��o��)������ˡ���";
		NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_ѡ���%,%��ť_�ر�%,1,WindowMsg);
	end
	return;
end

function FramEvent(_NpcIndex,_PlayerIndex,_SqeNo,_select,_data)
	if ((_select == 0 or _select == "0") and (_data ~= "")) then
		local selectitem = tonumber(_data) -1;
		if (selectitem == 0) then
			Msg = "\\n\\n�������Ѿ���"..Char.GetData(_PlayerIndex,%����_����%).."��������!\\n\\nû�ﵽĿ��Ļ���Ҫ����,����Ŭ����";
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,Msg);
		end
		if (selectitem == 2) then
			NLG.ShowWindowTalked(_PlayerIndex,_NpcIndex,%����_��Ϣ��%,%��ť_�ر�%,1,"\\n\\n��Ҫ�ҵ��˼���~�˼ҿ��Ǻ�æ��!");
		end
	end
end


function fram_Init()
	fram_create();
	
end