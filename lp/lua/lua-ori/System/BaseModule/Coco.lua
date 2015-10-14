--���߳�

coro = {}
--coro.main������ʶ�����������
coro.main = function() end
-- coro.current����������ʶӵ�п���Ȩ��Э�̣�
-- Ҳ���������еĵ�ǰЭ��
coro.current = coro.main

-- ����һ���µ�Э��
function coro.create(f)
   return coroutine.wrap(function(val)
                            return nil,f(val)
                         end)
end

-- �ѿ���Ȩ��ָ��������val����Э��k
function coro.transfer(k,val)
   if coro.current ~= coro.main then
      return coroutine.yield(k,val)
   else
      -- ����Ȩ����ѭ��
      while k do
         coro.current = k
         if k == coro.main then
            return val
         end
         k,val = k(val)
      end
      error("coroutine ended without transfering control...")
   end
end