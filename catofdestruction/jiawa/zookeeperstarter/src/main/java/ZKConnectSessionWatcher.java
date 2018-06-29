/**
 * Created by LW on 2018/6/23.
 */

import org.apache.zookeeper.WatchedEvent;
import org.apache.zookeeper.Watcher;
import org.apache.zookeeper.ZooKeeper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 *
 * @Title: ZKConnectDemo.java
 * @Description: zookeeper 恢复之前的会话连接demo演示
 */
public class ZKConnectSessionWatcher implements Watcher {

    private static final Logger logger = LoggerFactory.getLogger(ZKConnectSessionWatcher.class);

    private static final String zkServerPath = "localhost:2183";
    private static final Integer timeout = 5000;

    private static Long sid = Long.valueOf(-1);
    private static byte[] password = null;

    public static void main(String[] args) throws Exception {

        testReconnect(sid, password, false);
        new Thread().sleep(2000);
        testReconnect(sid, password, true);
    }

    public void process(WatchedEvent watchedEvent) {
        logger.warn("recieve watcher: {}", watchedEvent);
    }

    private static void testReconnect(long sessionId, byte[] sessionPasswd, boolean reconnect)
            throws IOException, InterruptedException {

        /**
         * 客户端和zk服务端链接是一个异步的过程
         * 当连接成功后后，客户端会收的一个watch通知
         *
         * 参数：
         * connectString：连接服务器的ip字符串，
         * 		比如: "192.168.1.1:2181,192.168.1.2:2181,192.1wu68.1.3:2181"
         * 		可以是一个ip，也可以是多个ip，一个ip代表单机，多个ip代表集群
         * 		也可以在ip后加路径
         * sessionTimeout：超时时间，心跳收不到了，那就超时
         * watcher：通知事件，如果有对应的事件触发，则会收到一个通知；如果不需要，那就设置为null
         * canBeReadOnly：可读，当这个物理机节点断开后，还是可以读到数据的，只是不能写，
         * 					       此时数据被读取到的可能是旧数据，此处建议设置为false，不推荐使用
         * sessionId：会话的id
         * sessionPasswd：会话密码	当会话丢失后，可以依据 sessionId 和 sessionPasswd 重新获取会话
         */
        String showState = null;
        ZooKeeper zooKeeper = null;
        if (reconnect) {
            showState = " reconnet ";
            zooKeeper = new ZooKeeper(zkServerPath, timeout, new ZKConnectSessionWatcher(), sessionId, sessionPasswd);
        } else {
            showState = " connet ";
            zooKeeper = new ZooKeeper(zkServerPath, timeout, new ZKConnectSessionWatcher());
        }

        logger.warn("start" + showState + "zookeeper server ...");
        logger.warn(showState + "status {}", zooKeeper.getState());
        new Thread().sleep(3600);
        logger.warn(showState + "status {}", zooKeeper.getState());

        sid = zooKeeper.getSessionId();
        String sidStr = "0x" + Long.toHexString(sid);
        password = zooKeeper.getSessionPasswd();

        logger.warn("sessionId {} sessonStringId {} sessionPasswd {}", sid, sidStr, password);
    }
}
