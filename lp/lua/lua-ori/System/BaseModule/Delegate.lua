--  ***************************************************************************************************** --
--  code by http://www.Cgdev.me
--  ���ð汾 GMSV Avaritia ���а汾,GMSVPLUS ���а汾
--              #UPDATE LIST#
--  TYPE ***** TIME ***** Editor ***** Text 
--  CREATE  2013/01/15     blue
--  ADD     2013/01/15     blue        ��������ί�е���
--   								   *RegInit 
--   								   *RegDelTalkEvent 
--   								   *RegDelBattleStartEvent
--   								   *RegDelBattleOverEvent
--   								   *RegDelLoginEvent
--   								   *RegDelLogoutEvent
--   								   *RegDelDropEvent
--   								   *RegDelLoginGateEvent
--   								   *RegDelWarpEvent
--   								   *RegDelAllOutEvent /* ע����ί��֮ǰҲ�����DropEvent��LogoutEvent */
--  ADD     2013/01/17     blue        ��������ί�е���
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

--ע��ȫ�ֶԻ��¼�ί��
function RegInit(FuncString)
	
   for _,v in ipairs(tbl_delegate_Init) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_Init,FuncString);
   return true;
end


--ע��ȫ�ֶԻ��¼�ί��
function RegDelTalkEvent(FuncString)
	
   for _,v in ipairs(tbl_delegate_TalkEvent) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_TalkEvent,FuncString);
   return true;
end

--ע��ȫ��ս����ʼ�¼�ί��
function RegDelBattleStartEvent(FuncString)
	
   for _,v in ipairs(tbl_delegate_BattleStartEvent) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_BattleStartEvent,FuncString);
   return true;
end

--ע��ȫ��ս�������¼�ί��
function RegDelBattleOverEvent(FuncString)
	
   for _,v in ipairs(tbl_delegate_BattleOverEvent) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_BattleOverEvent,FuncString);
   return true;
end

--ע��ȫ�ֵ�¼�¼�ί��
function RegDelLoginEvent(FuncString)
	
   for _,v in ipairs(tbl_delegate_LoginEvent) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_LoginEvent,FuncString);
   return true;
end

--ע��ȫ�ֵǳ��¼�ί��
function RegDelLogoutEvent(FuncString)
	
   for _,v in ipairs(tbl_delegate_LogoutEvent) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_LogoutEvent,FuncString);
   return true;
end

--ע��ȫ�ֵ����¼�ί��
function RegDelDropEvent(FuncString)
	
   for _,v in ipairs(tbl_delegate_DropEvent) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_DropEvent,FuncString);
   return true;
end


--ע��ȫ�ֵǻس��¼�ί��
function RegDelLoginGateEvent(FuncString)
	
   for _,v in ipairs(tbl_delegate_LoginGateEvent) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_LoginGateEvent,FuncString);
   return true;
end

--ע��ȫ�ִ����¼�ί��
function RegDelWarpEvent(FuncString)
	
   for _,v in ipairs(tbl_delegate_WarpEvent) do
       if (v == FuncString)then
       return false;
	   end
   end
   
   table.insert(tbl_delegate_WarpEvent,FuncString);
   return true;
end

--ע��ȫ���뿪�¼�ί�У������ǳ��͵��ߣ�
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


