/**
 * Created by LW on 2018/4/24.
 */
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.*;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class TestHDFS {

    public static void main(String[] args) throws Exception {

        Configuration configuration = new Configuration();
        // 伪分布式需要导入一下两个配置文件
        configuration.addResource(new Path("/usr/local/Cellar/hadoop/3.0.0/libexec/etc/hadoop/core-site.xml"));
        configuration.addResource(new Path("/usr/local/Cellar/hadoop/3.0.0/libexec/etc/hadoop/hdfs-site.xml"));

        FileSystem fileSystem = FileSystem.get(configuration);
        String testFilePath = "hdfs://localhost:9000/user/DeCatOfDestruction/putxml/";

        // 将本地图片上传到hdfs
        String home = System.getProperty("user.home");
        fileSystem.copyFromLocalFile(new Path(home + "/Desktop/1.jpeg"),
                new Path(testFilePath + "1.jpeg"));
        fileSystem.copyFromLocalFile(new Path(home + "/Desktop/2.jpeg"),
                new Path(testFilePath + "2.jpeg"));

        // 从hdfs将图片下载到本地
        fileSystem.copyToLocalFile(new Path(testFilePath + "2.jpeg"),
                new Path(home + "/Desktop/3.jpeg"));

        // 创建文件并写入文本
        Path writePath = new Path(testFilePath + "dahuang.txt");
        FSDataOutputStream writeStream = fileSystem.create(writePath, true);
        writeStream.write("大黄 = dahuang".getBytes());
        writeStream.flush();
        writeStream.close();

        // 列出hdfs上 hdfs://localhost:9000/user/DeCatOfDestruction/putxml/ 目录下的所有文件和目录
        FileStatus[] statuses = fileSystem.listStatus(new Path(testFilePath));
        for (FileStatus status :
                statuses) {
            System.out.println(status);
            showFileInfo(fileSystem, status.getPath().toString());
        }
    }

    /*
    *
    * 读取文件内容
    * https://www.programcreek.com/java-api-examples/?api=org.apache.hadoop.fs.FSDataInputStream
    *
    * */
    private static void showFileInfo(FileSystem fileSystem, String filePath) throws IOException {

        Path path = new Path(filePath);

        if (fileSystem.exists(path)) {
            System.out.println("\r\n=======================================================================================");
            System.out.println(path);
            System.out.println("=======================================================================================\r\n");

            StringBuffer stringBuffer = new StringBuffer();

            FSDataInputStream readStream = fileSystem.open(path);
            BufferedReader br = new BufferedReader(new InputStreamReader(readStream));

            String line;
            while ((line = br.readLine()) != null) {
                stringBuffer.append(line);
                stringBuffer.append("\n");
            }
            br.close();
            readStream.close();

            System.out.println(stringBuffer.toString());
        } else {
            System.out.println(path + "is not exist");
        }
    }
}
