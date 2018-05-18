import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.StringTokenizer;


/**
 * Created by LW on 2018/4/25.
 */

public class WordCount {

    /*Object 行号, Text 行内容, Text 单词内容, IntWritable 固定1次*/
    public static class TokenizerMapper extends Mapper<Object, Text, Text, IntWritable> {
        private Text word = new Text();
        private final static IntWritable one = new IntWritable(1);

        @Override
        public void map(Object key, Text value, Context context)
                throws IOException, InterruptedException {
            StringTokenizer stringTokenizer = new StringTokenizer(value.toString());
            /*分词器*/
            while (stringTokenizer.hasMoreTokens()) {
                word.set(stringTokenizer.nextToken());
                context.write(word, one); // 上下文返回map结果
            }
        }
    }

    /*Text 单词内容, IntWritable 固定1次, Text 单词内容, IntWritable 出现次数累计值*/
    public static class IntSumReducer extends Reducer<Text, IntWritable, Text, IntWritable> {
        private IntWritable sumResult = new IntWritable();

        @Override
        public void reduce(Text key, Iterable<IntWritable> values, Context context)
                throws IOException, InterruptedException {
            int sum = 0;
            for (IntWritable value : // Map结果通过Shuffle阶段整理后成为<key, Iterable容器>
                    values) {
                sum += value.get();
            }
            sumResult.set(sum);
            context.write(key, sumResult); // 上下文返回reduce结果
        }
    }

    public static void main(String[] args) throws Exception {

        Configuration conf = new Configuration(); // 程序运行时参数
        // 伪分布式需要导入一下两个配置文件
        conf.addResource(new Path("/usr/local/Cellar/hadoop/3.0.0/libexec/etc/hadoop/core-site.xml"));
        conf.addResource(new Path("/usr/local/Cellar/hadoop/3.0.0/libexec/etc/hadoop/hdfs-site.xml"));

        String inputPath = "hdfs://localhost:9000/user/DeCatOfDestruction/wordcount/resource/wordCountFile.txt";
        String outputPath = "hdfs://localhost:9000/user/DeCatOfDestruction/wordcount/mapreduce/";
        FileSystem fileSystem = FileSystem.get(conf);
        if (fileSystem.exists(new Path(outputPath))) {
            fileSystem.delete(new Path(outputPath), true);
        }

        // 将测试文件从本地拷贝到hdfs上mapreduce app的输入路径
        fileSystem.copyFromLocalFile(new Path(System.getProperty("user.home") + "/Desktop/facePoints.txt"),
                new Path(inputPath));
        wordCountWithFile(inputPath, outputPath, conf);
    }

    /*
    *
    * 词频统计任务
    * */
    private static void wordCountWithFile(String inputPath, String outputPath, Configuration conf)
            throws Exception {

        Job job = Job.getInstance(conf, "word count"); // 设置环境参数
        job.setJarByClass(WordCount.class); // 设置整个程序类名
        job.setMapperClass(TokenizerMapper.class); // 添加Mapper类
        job.setReducerClass(IntSumReducer.class); // 添加Reducer类

        job.setOutputKeyClass(Text.class); // 设置输出键类型
        job.setOutputValueClass(IntWritable.class); // 设置输出值类型

        FileInputFormat.addInputPath(job, new Path(inputPath)); // 设置输入文件
        FileOutputFormat.setOutputPath(job, new Path(outputPath)); // 设置输出文件

        if (job.waitForCompletion(true)) {
            FileSystem fileSystem = FileSystem.get(conf);
            FileStatus[] statuses = fileSystem.listStatus(new Path(outputPath));
            for (FileStatus status :
                    statuses) {
                showFileInfo(fileSystem, status.getPath().toString());
            }
            System.exit(0);
        }
        else {
            System.exit(1);
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
