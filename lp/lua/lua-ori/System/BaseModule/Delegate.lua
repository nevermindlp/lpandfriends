--  ***************************************************************************************************** --
--  code by http://www.Cgdev.me
--  适用版本 GMSV Avaritia 所有版本,GMSVPLUS 所有版本
--              #UPDATE LIST#
--  TYPE ***** TIME ***** Editor ***** Text 
--  CREATE  2013/01/15     blue
--  ADD     2013/01/15     blue        增加以下委托调用
--   								   *RegInit 
--   								   *RegDelTalkEvent 
--   								   *RegDelBattleStartEvent
--   								   *RegDelBattleOverEvent
--   								   *RegDelLoginEvent
--   								   *RegDelLogoutEvent
--   								   *RegDelDropEvent
--   								   *RegDelLoginGateEvent
--   								   *RegDelWarpEvent
--   								   *RegDelAllOutEvent /* 注：此委托之前也会调用DropEvent或LogoutEvent */
--  ADD     2013/01/17     blue        增加以下委托调用
--   								   *RegDelBattleSkillExpEvent
--   								   *RegDelProductSkillExpEvent
--   								   *RegDelGetExpEvent
--  ***************************************************************************************************** --

tbl_delegate_Init = {};
tbl_delegate_TalkEvent = {};
tbl_delegate_BattleStartEvent = {};
tbl_delegate_BattleOverEvent = {};
tbl_delegate_LoginEvent = {};
tbl_delegate_LogoutEvent = {};
tbl_delegate_DropEvent = {};
tbl_delegate_LoginGateEvent = {};
tbl_delegate_WarpEvent = {};
tbl_delegate_AllOutEvent = {};

tbl_delegate_BattleSkillExpEvent = {};
tbl_delegate_ProductSkillExpEvent = {};
tbl_delegate_GetExpEvent = {};

Delegate =
{
	RegInit = function(FuncString) RegInit(FuncString) end;
    RegDelTalkEvent = function(FuncString) RegDelTalkEvent(FuncString) end;
	RegDelBattleStartEvent = function(FuncString) RegDelBattleStartEvent(FuncString) end;
	RegDelBattleOverEvent = function(FuncString) RegDelBattleOverEvent(FuncString) end;
	RegDelLoginEvent = function(FuncString) RegDelLoginEvent(FuncString) end;
	RegDelLogoutEvent = function(FuncString) RegDelLogoutEvent(FuncString) end;
	RegDelDropEvent = function(FuncString) RegDelDropEvent(FuncString) end;
	RegDelLoginGateEvent = function(FuncString) RegDelLoginGateEvent(FuncString) end;
	RegDelWarpEvent = function(FuncString) RegDelWarpEvent(FuncString) end;
	RegDelAllOutEvent = function(FuncString) RegDelAllOutEvent(FuncString) end;
	RegDelBattleSkillExpEvent = function(FuncString) RegDelBattleSkillExpEvent(FuncString) end;
	RegDelProductSkillExpEvent = function(FuncString) RegDelProductSkillExpEvent(FuncString) end;
	RegDelGetExpEvent = function(FuncString) RegDelGetExpEvent(FuncString) end;
};

--注册全局对话事件委托
function RegInit(FuncString)
	
   for _,v in ipairs(tbl_delegate_Init) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_Init,FuncString);
   return true;
end


--注册全局对话事件委托
function RegDelTalkEvent(FuncString)
	
   for _,v in ipairs(tbl_delegate_TalkEvent) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_TalkEvent,FuncString);
   return true;
end

--注册全局战斗开始事件委托
function RegDelBattleStartEvent(FuncString)
	
   for _,v in ipairs(tbl_delegate_BattleStartEvent) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_BattleStartEvent,FuncString);
   return true;
end

--注册全局战斗结束事件委托
function RegDelBattleOverEvent(FuncString)
	
   for _,v in ipairs(tbl_delegate_BattleOverEvent) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_BattleOverEvent,FuncString);
   return true;
end

--注册全局登录事件委托
function RegDelLoginEvent(FuncString)
	
   for _,v in ipairs(tbl_delegate_LoginEvent) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_LoginEvent,FuncString);
   return true;
end

--注册全局登出事件委托
function RegDelLogoutEvent(FuncString)
	
   for _,v in ipairs(tbl_delegate_LogoutEvent) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_LogoutEvent,FuncString);
   return true;
end

--注册全局掉线事件委托
function RegDelDropEvent(FuncString)
	
   for _,v in ipairs(tbl_delegate_DropEvent) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_DropEvent,FuncString);
   return true;
end


--注册全局登回城事件委托
function RegDelLoginGateEvent(FuncString)
	
   for _,v in ipairs(tbl_delegate_LoginGateEvent) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_LoginGateEvent,FuncString);
   return true;
end

--注册全局传送事件委托
function RegDelWarpEvent(FuncString)
	
   for _,v in ipairs(tbl_delegate_WarpEvent) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_WarpEvent,FuncString);
   return true;
end

--注册全局离开事件委托（包括登出和掉线）
function RegDelAllOutEvent(FuncString)
	
   for _,v in ipairs(tbl_delegate_AllOutEvent) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_AllOutEvent,FuncString);
   return true;
end


function RegDelBattleSkillExpEvent(FuncString)
	
   for _,v in ipairs(tbl_delegate_BattleSkillExpEvent) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_BattleSkillExpEvent,FuncString);
   return true;
end


function RegDelProductSkillExpEvent(FuncString)
	
   for _,v in ipairs(tbl_delegate_ProductSkillExpEvent) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_ProductSkillExpEvent,FuncString);
   return true;
end


function RegDelGetExpEvent(FuncString)
	
   for _,v in ipairs(tbl_delegate_GetExpEvent) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_GetExpEvent,FuncString);
   return true;
end


