Delegate.RegInit("announce_Init");

function announce_initialize(_MeIndex)
	return true;
end

function announce_create() --宣传大使
	if (announce_index == nil) then
		announce_index = NL.CreateNpc("lua/Module/announce.lua", "announce_initialize");
		Char.SetData(announce_index,%对象_形象%,106602);
		Char.SetData(announce_index,%对象_原形%,106602);
		Char.SetData(announce_index,%对象_X%,242);
		Char.SetData(announce_index,%对象_Y%,88);
		Char.SetData(announce_index,%对象_地图%,1000);
		Char.SetData(announce_index,%对象_方向%,4);
		Char.SetData(announce_index,%对象_名字%,"宣传大使");
		NLG.UpChar(announce_index);
		Char.SetTalkedEvent("lua/Module/announce.lua", "Server_AnMsg", announce_index);
		Char.SetWindowTalkedEvent("lua/Module/announce.lua", "Server_AnTalk", announce_index);
	end
	--注册事件
	Char.SetLoopEvent("lua/Module/announce.lua", "serverLoop", announce_index, 10000);
end

--定义一个随机数种子,这样取的随机数每次都会不一样
math.randomseed(os.time());
local LastAnTime = 0;
local Anon1 = {"通知：服务器的摆摊功能与官方一样，看不到摆摊按钮的玩家请到主页或者群下载我们的BIN补丁！"};
local Anon2 = {"小窍门：如果您怕没人带您过海的话，游民练到20级可以直接偷渡哦！"};
local Anon3 = {"通知：本服提供了聊天频道，按TAB可切换频道，新手频道支援30级以前玩家！"};
local Anon4 = {"通知：各老玩家请记得要多多帮助新手哦！这样我们的魔力才会热闹起来！"};
local Anon5 = {"小窍门：25级可以走到莎莲娜海底隧道，36级就可以开通雪山传送了！"};
local Anon6 = {"通知：服务器开放新手群：72616191，美女管理为各新手排忧解难，禁止商人加入，禁止发布交易信息！"};
local Server_Anon = {Anon1,Anon2,Anon3,Anon4,Anon5,Anon6};
local An_State = 1;

function StartAtAnnounce()
	An_State = 1;
end

function StopAtAnnounce()
	An_State = 0;
end

function serverLoop(_MeIndex)
	--取一个0-7的随机数,代表NPC移动的方向
	local dir= math.random(0, 7);
	--设置NPC状态为走路
	local walk = 1;
	NLG.SetAction(_MeIndex,walk);
	--让NPC走一步
	NLG.WalkMove(_MeIndex,dir);
	if(Char.GetData(_MeIndex,%对象_X%) < 225 or Char.GetData(_MeIndex,%对象_X%) > 249) then
		Char.SetData(_MeIndex,%对象_X%,242);
		NLG.UpChar(_MeIndex);
	end
	if(Char.GetData(_MeIndex,%对象_Y%) < 80 or Char.GetData(_MeIndex,%对象_Y%) > 99) then
		Char.SetData(_MeIndex,%对象_Y%,88);
		NLG.UpChar(_MeIndex);
	end
	if(os.time() - LastAnTime >= 2700 and An_State == 1) then
		LastAnTime = os.time();
		--NLG.TalkToCli(-1,-1,""..Server_Anon[math.random(1,5)][1].."",math.random(0,9),%字体_中%);
		--NLG.SystemMessage(_MeIndex,""..Server_Anon[math.random(1,4)][1].."");
		NLG.SystemMessage(-1,"[GM]"..Server_Anon[math.random(1,6)][1].."");
	end
end

function Server_AnMsg(_me,_tome)
	if (NLG.CanTalk(_me,_tome) == true) then
		local str_caller = "3\\n\\n请选择你想要咨询的问题...\\n\\n1.如何防止帐号被盗\\n2.如何联系客服\\n3.如何赞助就上魔力";
		NLG.ShowWindowTalked(_tome,_me,%窗口_选择框%,%按钮_关闭%,1,str_caller);
	end
end

function Server_AnTalk(_MeIndex,_PlayerIndex,_seqno,_select,_data)
	if (_seqno == 1) then
		if ((_select == 0 or _select == "0") and (_data ~= "")) then
			local selectitem = tonumber(_data);
			if (selectitem == 1) then
				local Server_str = "\\n\\n1、请不要随意将帐号等信息与其他玩家分享..\\n2、请安装正版杀毒软件,以保障您的帐号以及信息安全\\n3、注意每隔一段时间进行一次密码修改哦\\n4、建议您密码不要使用纯数字组合\\n5、当发现帐号被盗时,请第一时间联系客服进行";
				NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%窗口_信息框%,%按钮_关闭%,10,Server_str);
			end
			if (selectitem == 2) then
				local Server_str = "\\n\\n客服QQ:9769763\\n\\n客服电话:4006-933-818\\n\\n官方网站:www.9smoli.com\\n\\n官方论坛:bbs.93moli.com";
				NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%窗口_信息框%,%按钮_关闭%,10,Server_str);
			end
			if (selectitem == 3) then
				local Server_str = "\\n1、银行汇款转帐，请客服QQ:9769763索取银行帐号\\n\\n2、淘宝或者支付宝，请联系客服QQ索取购买地址或者支付宝帐号\\n\\n3、网站自助充值，请到网站选择在线充值(支持银行在线支付、手机卡、游戏点卡)\\n\\n官方网站:www.9smoli.com";
				NLG.ShowWindowTalked(_PlayerIndex,_MeIndex,%窗口_信息框%,%按钮_关闭%,10,Server_str);
			end
		end
	end
end

function announce_Init()
	announce_create();
end