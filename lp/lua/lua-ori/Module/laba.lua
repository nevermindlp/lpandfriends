--  ***************************************************************************************************** --
--  code by http://www.Cgdev.me
--  ����ģ��
--                   #������־#
--  TYPE ***** TIME ***** Editor ***** Text 
--  CREATE  2013/01/16     blue

--                   #��������#
local limit_time = 10; --���η����ȼ��ʱ�䣬��λ��
local laba_itemid = 520046; --С���ȵĵ��߱��
local turn_on_key = "/��������"; --��ҿ������ȿ��ص�����
local turn_off_key = "/�ر�����"; --��ҹر����ȿ��ص�����
--  ***************************************************************************************************** --

tbl_labaPlayer = {};
Delegate.RegDelLoginEvent("labaLoginEvent");
Delegate.RegDelAllOutEvent("labaOutEvent");
Delegate.RegDelTalkEvent("labaTalkEvent");
function new_labaplayerobject(player)
	local labaplayer =
	{
		index = player;
		isopen = true;
		limit_time = 0;
	};
	return labaplayer;
end

function labaLoginEvent(player)
	tbl_labaPlayer[Playerkey(player)] = new_labaplayerobject(player);
end

function labaOutEvent(player)
	tbl_labaPlayer[Playerkey(player)] = nil;
end


function labaTalkEvent(player,msg,color,range,size)
	

	if(msg==turn_on_key) then 
		tbl_labaPlayer[Playerkey(player)].isopen = false;
		NLG.SystemMessage(player,"С�����Ѿ�������");
	end
	
	if(msg==turn_off_key) then 
		tbl_labaPlayer[Playerkey(player)].isopen = true;
		NLG.SystemMessage(player,"С�����Ѿ��رա�");
	end	
	
	
	if( check_msg(msg,">") ) then	
	
		local litime = tbl_labaPlayer[Playerkey(player)].limit_time;	
		if (os.time() - litime < limit_time )then
			NLG.SystemMessage(player,limit_time.."���ڽ�ֹ�ظ������ȡ�");
			return;
		end
	
		if(Char.ItemNum(player,laba_itemid) > 0)then
			
			for _,v in pairs (tbl_labaPlayer) do
				if(v.isopen == true)then
					NLG.SystemMessage(v.index,"[С����]"..Char.GetData(player,%����_����%)..": "..string.sub(msg,2));
				end
			end		
			Char.DelItem(player,laba_itemid,1);
			tbl_labaPlayer[Playerkey(player)].limit_time = os.time();
		else
			NLG.SystemMessage(player,"�Բ�������С���Ȳ���!");	
		end
	end
		
end
