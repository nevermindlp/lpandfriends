EXP_RATE_LIST =
{
    exprate_49 = 4;
    exprate_79 = 3;
    exprate_99 = 2;
    exprate_120 = 0;
    exprate_130 = 0;
};

local ADD_EXP_RATE = 0;
local magic_word = "www";
local INIT_B_SKILL_RATE = 10;
local ADD_B_SKILL_RATE = 0;
local INIT_P_SKILL_RATE = 2;
local ADD_P_SKILL_RATE = 0;

Delegate.RegDelTalkEvent("ExpSettingTalkEvent");

function ExpSettingTalkEvent(player, msg, color, range, size)
	local tbl = {};
	local cnt = 1;
	if(check_msg(msg,"["..magic_word.." setexprate ")) then
		for token in string.gmatch(msg, "[%d]+") do
		   if(tonumber(token)~=nil) then
				ADD_EXP_RATE = tonumber(token);
--				NLG.SystemMessage(player,"目前战斗经验 "..INIT_EXP_RATE.."倍, 加成经验 "..ADD_EXP_RATE.."倍, 总计经验 "..INIT_EXP_RATE * (ADD_EXP_RATE + 1).."倍");
				NLG.SystemMessage(player,"系统调整了战斗经验加成，目前总经验附加了"..ADD_EXP_RATE.."%");
				return 0;
			end
		end
		return 0;
	end
	if(check_msg(msg,"["..magic_word.." setbattleskillrate ")) then
		for token in string.gmatch(msg, "[%d]+") do
		   if(tonumber(token)~=nil) then
				ADD_B_SKILL_RATE = tonumber(token);
				NLG.SystemMessage(player,"系统调整了战斗技能经验加成，目前总经验附加了"..ADD_B_SKILL_RATE.."%");
				return 0;
			end
		end
		return 0;
	end
	if(check_msg(msg,"["..magic_word.." setproductskillrate ")) then
		for token in string.gmatch(msg, "[%d]+") do
		   if(tonumber(token)~=nil) then
				ADD_P_SKILL_RATE = tonumber(token);
				NLG.SystemMessage(player,"系统调整了生产技能经验加成，目前总经验附加了"..ADD_P_SKILL_RATE.."%");
				return 0;
			end
		end
		return 0;
	end
end


Delegate.RegDelBattleSkillExpEvent("ExpSettingBattleSkillExpEvent");
Delegate.RegDelProductSkillExpEvent("ExpSettingProductSkillExpEvent");
Delegate.RegDelGetExpEvent("ExpSettingGetExpEvent");

function ExpSettingBattleSkillExpEvent(index, skill, exp)
	exp = exp * INIT_B_SKILL_RATE;
	if(ADD_B_SKILL_RATE>0) then
		exp = exp * (1 + ADD_B_SKILL_RATE/100);
	end
	return math.floor(exp);
end

function ExpSettingProductSkillExpEvent(index, skill, exp)
	exp = exp * INIT_P_SKILL_RATE;
	if(ADD_P_SKILL_RATE>0) then
		exp = exp * (1 + ADD_P_SKILL_RATE/100);
	end
	return math.floor(exp);
end

function ExpSettingGetExpEvent(index, exp)
	if(VaildChar(index)==false)then
		return exp;
	end
	local lv = Char.GetData(index,%对象_等级%);
	local THIS_RATE = 0;
    if (lv <= 49) then
        THIS_RATE = EXP_RATE_LIST.exprate_49;
    elseif (lv <= 79) then
        THIS_RATE = EXP_RATE_LIST.exprate_79;
    elseif (lv <= 99) then
        THIS_RATE = EXP_RATE_LIST.exprate_99;
    elseif (lv <= 120) then
        THIS_RATE = EXP_RATE_LIST.exprate_120;
    elseif (lv <= 130) then
        THIS_RATE = EXP_RATE_LIST.exprate_130;
    end

	exp = exp * tonumber(THIS_RATE);
	if(ADD_EXP_RATE > 0) then
		exp = exp * (1 + ADD_EXP_RATE/100);
	end

	return exp;
end
