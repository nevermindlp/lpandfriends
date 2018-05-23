<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>秒杀详情页</title>
    <%-- 此处是静态包含
           静态包含和动态包含的区别：
           静态包含：包含的jsp的内容直接合并过来 作为一个servlet输出
           动态包含：jsp作为一个独立的servlet 先运行得到结果 然后和list.jsp运行结果 进行合并 --%>
    <%@include file="common/head.jsp"%>
</head>
<body>
    <div class="container">
        <div class="panel panel-default text-center">
            <div class="pannel-heading">
                <h1>${seckill.name}</h1>
            </div>
            <div class="panel-body">
                <h2 class="text-danger">
                    <%-- 显示time图标 --%>
                    <span class="glyphicon glyphicon-time"></span>
                    <%-- 展示倒计时 --%>
                    <span class="glyphicon" id="seckill-box"></span>
                </h2>
            </div>
        </div>
    </div>
    <%-- 登录弹出层，输入电话 --%>
    <div id="killPhoneModal" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">

                <div class="modal-header">
                    <h3 class="modal-title text-center">
                        <span class="glyphicon glyphicon-phone"></span>秒杀电话：
                    </h3>
                </div>

                <div class="modal-body">
                    <div class="row">
                        <div class="col-xs-8 col-xs=offset-2">
                            <input type="text" name="killPhone" id="killPhoneKey"
                                   placeholder="填写手机号^_^" class="form-control"/>
                        </div>
                    </div>
                </div>

                <div class="modal-footer">
                    <%-- 验证信息 --%>
                    <span id="killPhoneMessage" class="glyphicon"></span>
                    <button type="button" id="killPhoneBtn" class="btn btn-success">
                        <span class="glyphicon glyphicon-phone"></span>
                        提交
                    </button>
                </div>
            </div>
        </div>
    </div>
</body>
<!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
<script src="https://cdn.bootcss.com/jquery/2.1.1/jquery.min.js"></script>
<!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
<script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<%-- 使用CDN 获取公共js http://www.bootcdn.cn/ --%>
<%-- jQuery cookie 操作插件 --%>
<script src="https://cdn.bootcss.com/jquery-cookie/1.4.1/jquery.cookie.min.js"></script>
<%-- jQuery countDown 倒计时插件 --%>
<script src="https://cdn.bootcss.com/jquery.countdown/2.1.0/jquery.countdown.min.js"></script>

<%-- 交互逻辑 --%>
<%-- 导入seckill.js --%>
<script src="/resources/script/seckill.js" type="text/javascript"></script>
<%-- 调用seckill.js 中的业务方法 --%>
<script type="text/javascript">
    $(function () {
        // 通过jsp的 EL表达式 传入参数
        seckill.detail.init({
            seckillId : ${seckill.seckillId},
            startTime : ${seckill.startTime.time}, // 通过time方法转化成毫秒类型 方便JavaScript做解析
            endTime : ${seckill.endTime.time}, // 通过time方法转化成毫秒类型 方便JavaScript做解析
        });
    })
</script>

</html>