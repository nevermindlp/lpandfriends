import org.apache.zookeeper.WatchedEvent;
import org.apache.zookeeper.Watcher;
import org.apache.zookeeper.ZooKeeper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

/**
 * Created by LW on 2018/6/23.
 */
public class ZKNodeOperator implements Watcher {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    private ZooKeeper zooKeeper = null;
    public static final String zkServerPath = "localhost:2181,localhost:2182,localhost:2183";
    public static final Integer timeout = 5000;

    public ZKNodeOperator() {
    }

    public ZKNodeOperator(String connetPathString) {

        try {
            zooKeeper = new ZooKeeper(connetPathString, timeout, new ZKNodeOperator());
        } catch (IOException e) {
            e.printStackTrace();
            if (zooKeeper == null) {
                try {
                    zooKeeper.close();
                } catch (InterruptedException e1) {
                    e1.printStackTrace();
                }
            }
        }
    }



    public void process(WatchedEvent event) {

    }
}
