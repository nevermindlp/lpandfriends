local WelcomeMessage = {};--��ӭ��
table.insert(WelcomeMessage,"��ӭ��������ħ��3.0��ͳ��");
table.insert(WelcomeMessage,"�ͷ��绰:4006-933-818���ͷ�QQ:9769763��ǧ��Ⱥ:237377357");
table.insert(WelcomeMessage,"����BUG�뵽��̳��������ҳ��ַ: http://www.9smoli.com");

Delegate.RegDelLoginEvent("Welcome_LoginEvent");

function Welcome_LoginEvent(player)
	if (WelcomeMessage ~= nil) then --��ӭ��
		for _,text in ipairs(WelcomeMessage) do
		      NLG.TalkToCli(player,-1,text,%��ɫ_��ɫ%,%����_С%);
		end
		NLG.TalkToCli(player,-1,"���������ϧĿǰ����Ϸƽ̨������ħ��3.0�����������Ϸ�ڻ���ΪĿ�꿪�裬������ɫ��Ϸƽ̨��",%��ɫ_��ɫ%,%����_С%);
		NLG.TalkToCli(player,-1,"��������·�ֲ���1-2��Ϊ˫��·��3��Ϊ���ţ�4��ΪBGP���ߣ�����Ϸʱ�о����粻���뻻�ߵ�½��",%��ɫ_����ɫ%,%����_С%);
		--NLG.TalkToCli(player,-1,"����������6��7������10:30����ͣ��ά��,�Ż���ӡ��������",%��ɫ_��ɫ%,%����_С%);
		NLG.SystemMessage(player,"6��11�ո�������:���Ŷ��������<������>���޸ı��⸱������,������鿴��½�����档");
		NLG.TalkToCli(player,-1,"���⸱��Ŀǰ�Ѿ��޸��������Ϊ3�Σ�����ʱ�������޸�Ϊ40�����Լ�ս����ʱ�䵽�˲��Ῠסս����",%��ɫ_��ɫ%,%����_��%);
	end
	
end