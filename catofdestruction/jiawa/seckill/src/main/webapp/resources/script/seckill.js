// 存放主要交互逻辑js代码
// JavaScript 模块化（java 通过分包进行模块拆分）
// JavaScript 使用 Json 表示对象的方式 来模拟 分包（分包的好处是 规范程序 易于维护）
// 如 seckill.detail.init(params) -> 包名.类名.方法名
var seckill = {
    // 封装秒杀相关ajax的url
    URL: {
        exposer: function (seckillId) {
            return '/seckill/' + seckillId + "/exposer";
        },
        execution: function (seckillId, md5) {
            return '/seckill/' + seckillId + '/' + md5 + '/execution';
        },
        now: function () { // 获取系统时间
            return '/seckill/time/now';
        }
    },
    validatePhone: function (phone) { // 验证手机号
        if (phone && phone.length == 11 && !isNaN(phone)) {
            return true
        } else {
            return false
        }
    },
    countDown: function (seckillId, nowTime, startTime, endTime) { // 倒计时逻辑
        var seckillBox = $('#seckill-box');
        if (nowTime > endTime) { // 秒杀结束
            seckillBox.html('秒杀结束！');
        } else if (nowTime < startTime) { // 秒杀未开始
            // 使用jQuery计时插件 计时事件绑定
            var killTime = new Date(startTime + 1000); // 计时基准
            seckillBox.countdown(killTime, function (event) { // 第二个参数是回调函数 每次回调更新界面时间
                // 根据时间格式 显示倒计时
                var format = event.strftime('秒杀计时: %D天 %H时 %M分 %S秒');
                seckillBox.html(format);
            }).on('finish.countdown', function () { // 秒杀倒计时完成之后执行
                seckill.handleSeckill(seckillId, seckillBox);
            });
        } else { // 秒杀进行中
            seckill.handleSeckill(seckillId, seckillBox);
        }
    },
    handleSeckill: function (seckillId, node) { // 处理秒杀逻辑
        // 获取秒杀地址，控制显示逻辑，执行秒杀（显示秒杀按钮）
        node.hide()
            .html('<button class="btn btn-primary btn-lg" id="killBtn">开始秒杀</button>');
        $.post(seckill.URL.exposer(seckillId), {}, function (result) {    // result是Controller ajax接口返回的 SeckillResult<T> 对象

            // 在回调函数中 执行交互流程
            if (result && result['success']) {
                var exposer = result['data'];
                if (exposer['exposed']) { // 开启秒杀
                    // 获取秒杀地址
                    var md5 = exposer['md5'];
                    var killUrl = seckill.URL.execution(seckillId, md5);
                    console.log("killUrl: " + killUrl);

                    // 获取到地址后 给秒杀按钮注册 秒杀事件
                    // 注意：秒杀按钮是 在进入方法后 在传入的 节点内 生成的 id="killBtn"
                    // 使用 click() 做事件绑定 会一直绑定 如果用户连续点击按钮 会发送多次秒杀事件请求 造成服务器压力
                    // 此处使用 one() 做事件绑定（事件的名字叫click） 只会绑定一次点击事件（即执行秒杀请求的操作）
                    $('#killBtn').one('click', function () {
                        // 执行秒杀请求 此处 $.(this) 比 $('#killBtn') 更高效

                        // 1. 点击后立刻禁用按钮
                        $(this).addClass('disabled');

                        // 2. 发送秒杀请求
                        $.post(killUrl, {}, function (result) { // result是Controller ajax接口返回的 SeckillResult<T> 对象
                            if (result && result['success']) {
                                var killResult = result['data'];
                                var state = killResult['state'];
                                var stateInfo = killResult['stateInfo'];

                                // 展示秒杀返回的结果（秒杀成功、重复秒杀、秒杀结束） 展示在node节点上（即 seckillBox）
                                node.html('<span class="label label-success">' + stateInfo + '</span>');
                            } else {
                                conole.log('execution error=' + result);
                            }
                        });

                    });
                    node.show(); // 绑定事件完成之后 重新显示node（即 seckillBox）

                } else { // 没有开启秒杀
                    // 开启计时面板等待时间很长 每个客户端时间计时跳转存在差异
                    // 线上服务器会通过ntp来匹配时间 而客户端没有匹配时间
                    // 所以 客户端可能会认为已经达到了killTime 而实际服务器时间还没有到（这个偏差普遍很小）
                    // 此时 需要重新计算 倒计时逻辑 纠正时间偏差
                    var now = exposer['now'];
                    var start = exposer['start'];
                    var end = exposer['end'];
                    seckill.countDown(seckillId, now, start, end);
                }
            } else {
                conole.log('exposer error=' + result);
            }
        });
    },
    // 详情页秒杀逻辑
    detail: {
        // 详情页初始化
        init: function (params) {
            // 用户手机验证和登录，计时交互
            // 规划交互流程

            // 在cookie中查找手机号 使用导入的cookie插件
            var killPhone = $.cookie('killPhone');

            // 验证手机号
            // 如果未登录从cookie中获取的 killPhone 为空 不会通过 validatePhone 方法
            if (!seckill.validatePhone(killPhone)) { // 未登录情况下弹出登录弹出层

                // 绑定手机号（取到弹出层） 使用jQuery 的选择器语法 #xxx
                // 控制输出
                var killPhoneModal = $('#killPhoneModal');
                // 显示弹出层
                killPhoneModal.modal({
                    show: true, // 显示弹出层
                    backdrop: 'static', // 禁止位置关闭w
                    keyboard: false, // 关闭键盘事件
                });
                // 给弹出层按钮做时间绑定
                // JavaScript 动态语言 函数也是一个对象 可以作为参数参入
                $('#killPhoneBtn').click(function () {
                    var inputPhone = $('#killPhoneKey').val(); // val取值
                    console.log('inputPhone=' + inputPhone);
                    if (seckill.validatePhone(inputPhone)) { // 验证通过
                        // 验证通过后 将填写电话 写入cookie
                        // 第三个参数是有效期 设置为7天 设置在/seckill路径下有效
                        // 参看cookie实现原理：一些url用不到的时候 cookie也会传递到后端
                        // 设置在/seckill路径下有效 可以降低web服务器的处理量 和用户发送的http协议的字节量
                        // 当前 killPhone cookie 只在 /seckill path下生效
                        // 使用jQuery的cookie插件操作
                        $.cookie('killPhone', inputPhone, {expires: 7, path: '/seckill'})
                        // 刷新页面（会重新执行init）
                        window.location.reload();
                    } else { // 验证不通过
                        // 做html操作之前先隐藏一下（保证用户不会看到 向html put内容时的运行中间效果）
                        // 操作html（填充内容）之后再显示（设置300ms 会有一个运行的动态效果）
                        $('#killPhoneMessage').hide().html('<label class="label label-danger">手机号错误！<label/>').show(300);
                    }
                });
            }

            // 已经登录

            // 计时交互（秒杀未开始显示倒计时）
            // JavaScript访问json的方式 使用xxx[]
            var seckillId = params['seckillId'];
            var startTime = params['startTime'];
            var endTime = params['endTime'];

            $.get(seckill.URL.now(), {}, function (result) { // result是Controller ajax接口返回的 SeckillResult<T> 对象
                if (result && result['success']) {
                    var nowTime = result['data'];
                    // 时间判断 计时交互
                    seckill.countDown(seckillId, nowTime, startTime, endTime);
                } else {
                    conole.log('now time error=' + result);
                }
            });
        }
    }
}