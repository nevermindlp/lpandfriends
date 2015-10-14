local WelcomeMessage = {};--欢迎词
table.insert(WelcomeMessage,"欢迎来到就上魔力3.0传统区");
table.insert(WelcomeMessage,"客服电话:4006-933-818，客服QQ:9769763，千人群:237377357");
table.insert(WelcomeMessage,"发现BUG请到论坛发贴，主页地址: http://www.9smoli.com");

Delegate.RegDelLoginEvent("Welcome_LoginEvent");

function Welcome_LoginEvent(player)
	if (WelcomeMessage ~= nil) then --欢迎词
		for _,text in ipairs(WelcomeMessage) do
		      NLG.TalkToCli(player,-1,text,%颜色_黄色%,%字体_小%);
		end
		NLG.TalkToCli(player,-1,"各完家请珍惜目前的游戏平台，就上魔力3.0以让玩家在游戏内互动为目标开设，属于绿色游戏平台。",%颜色_绿色%,%字体_小%);
		NLG.TalkToCli(player,-1,"服务器线路分布：1-2线为双线路，3线为电信，4线为BGP多线，如游戏时感觉网络不畅请换线登陆。",%颜色_灰蓝色%,%字体_小%);
		--NLG.TalkToCli(player,-1,"服务器将于6月7日早上10:30进行停机维护,优化封印冰城任务",%颜色_红色%,%字体_小%);
		NLG.SystemMessage(player,"6月11日更新内容:开放端午节任务<化龙舟>，修改冰封副本奖励,详情请查看登陆器公告。");
		NLG.TalkToCli(player,-1,"冰封副本目前已经修复进入次数为3次，并且时间限制修改为40分钟以及战斗中时间到了不会卡住战斗。",%颜色_绿色%,%字体_中%);
	end
	
end