import org.apache.spark.SparkConf;
import org.apache.spark.streaming.Durations;
import org.apache.spark.streaming.api.java.JavaDStream;
import org.apache.spark.streaming.api.java.JavaPairDStream;
import org.apache.spark.streaming.api.java.JavaStreamingContext;
import scala.Tuple2;

import java.util.Arrays;

/**
 * Created by DeCatOfDestruction on 2018/5/10.
 */
public class WordCount {

    private SparkConf sparkConf;

    private JavaStreamingContext javaStreamingContext;

    public WordCount() {

        /**
         *
         * http://www.infoq.com/cn/articles/apache-spark-streaming
         * http://codingxiaxw.cn/2016/12/10/61-spark-streaming/
         *
         * */
        sparkConf = new SparkConf().setAppName("word count using streaming").setMaster("local[*]");

        /**
         *
         *
         * 创建StreamingContext对象: 同Spark初始化需要创建SparkContext对象一样，
         * 使用Spark Streaming就需要创建StreamingContext对象。创建StreamingContext对象所需的参数与SparkContext基本一致，
         * 包括指明Master，设定名称(word count using streaming)。
         * 需要注意的是参数Seconds(1)，Spark Streaming需要指定处理数据的时间间隔，
         * 如上例所示的1s，那么Spark Streaming会以1s为时间窗口进行数据处理。此参数需要根据用户的需求和集群的处理能力进行适当的设置；
         *
         * 与Spark中的Spark上下文(SparkContext)相似，流上下文(StreamingContext)是所有流功能的主入口。
         */
        javaStreamingContext = new JavaStreamingContext(sparkConf, Durations.seconds(1));
    }

    public void wordCountWithFile(String inputPath) {

        /**
         * 创建InputDStream:如同Storm的Spout，Spark Streaming需要指明数据源。如上例所示的socketTextStream，Spark Streaming以
         * socket连接作为数据源读取数据。当然Spark Streaming支持多种不同的数据源，包括Kafka、 Flume、HDFS/S3、Kinesis和Twitter
         * 等数据源
         */
//        JavaReceiverInputDStream<String> lines = javaStreamingContext.socketTextStream("localhost", 9999); // http://spark.apachecn.org/docs/cn/2.2.0/streaming-programming-guide.html
        JavaDStream<String> lines = javaStreamingContext.textFileStream(inputPath);

        /**
         * 操作DStream:对于从数据源得到的DStream，用户可以在其基础上进行各种操作，
         * 对于当前 时间窗口 内从数据源得到的数据首先进行分割，然后利用Map和ReduceByKey方法进行计算，当然最后还有使用print()方法输出结果；
         */
        JavaDStream<String> words = lines.flatMap(line -> Arrays.asList(line.split(" ")).iterator());

        /**
         * 启动Spark Streaming之前所作的所有步骤只是创建了执行流程，程序没有真正连接上数据源，
         * 也没有对数据进行任何操作，只是设定好了所有的执行计划，javaStreamingContext.start()启动后程序才真正进行所有预期的操作。
         */
        JavaPairDStream<String, Integer> pairs = words.mapToPair(word -> new Tuple2<>(word, 1));
        JavaPairDStream<String, Integer> wordCountPairs = pairs.reduceByKey((integer, integer2) -> integer + integer2);

//        wordCountPairs.print();
        wordCountPairs.foreachRDD((wordCountPair, time) -> {
            System.out.println("handle total count: " + wordCountPair.count() + "   time=> " + time.toString());
            wordCountPair.foreach(stringIntegerTuple2 -> {
                System.out.println("====> " + stringIntegerTuple2);
            });
        });

        javaStreamingContext.start();

        try {
            javaStreamingContext.awaitTermination();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
