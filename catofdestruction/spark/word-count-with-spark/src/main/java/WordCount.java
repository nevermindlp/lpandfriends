import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaPairRDD;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import scala.Tuple2;

import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

/**
 * Created by LW on 2018/4/26.
 */
public final class WordCount {

    private SparkConf sparkConf;

    private JavaSparkContext javaSparkContext;
    // https://blog.csdn.net/zhaojw_420/article/details/53261771
    private static final Pattern SPACE = Pattern.compile(" ");

    public WordCount() {

        /**
         *
         * https://blog.csdn.net/zhaojw_420/article/details/53261771
         *
         * 对于所有的spark程序所言，要进行所有的操作，首先要创建一个spark上下文。
         * 在创建上下文的过程中，程序会向集群申请资源及构建相应的运行环境。
         * 设置spark应用程序名称
         * 创建的 javaSparkContext 唯一需要的参数就是 sparkConf，它是一组 K-V 属性对。
         */
        sparkConf = new SparkConf().setAppName("word count").setMaster("local");
        // 创建spark 上下文对象, 是数据入口
        javaSparkContext = new JavaSparkContext(sparkConf);
    }

    public void wordCountWithFile(String inputPath) {

        /**
         * 利用textFile接口从文件系统中读入指定的文件，返回一个RDD实例对象。
         * RDD的初始创建都是由SparkContext来负责的，将内存中的集合或者外部文件系统作为输入源。
         * RDD：弹性分布式数据集，即一个 RDD 代表一个被分区的只读数据集。一个 RDD 的生成只有两种途径，
         * 一是来自于内存集合和外部存储系统，另一种是通过转换操作来自于其他 RDD，比如 Map、Filter、Join，等等。
         * textFile()方法可将本地文件或HDFS文件转换成RDD，读取本地文件需要各节点上都存在，或者通过网络共享该文件
         *
         */
        // 获取外部数据源（文件） RDD对象
        JavaRDD<String> lines = javaSparkContext.textFile(inputPath);
        // 匿名内部类会有问题 java.io.NotSerializableException
        // http://www.cnblogs.com/zwCHAN/p/4305156.html
        // https://stackoverflow.com/questions/25914057/task-not-serializable-exception-while-running-apache-spark-job
//        lines.foreach(new VoidFunction<String>() {
//            @Override
//            public void call(String s) throws Exception {

//                System.out.println("====>" + s);
//            }
//        });

        // 使用方法引用也会出问题 lines.foreach(System.out::println);
        lines.foreach(line -> System.out.println(line));

        /**
         *
         * new FlatMapFunction<String, String>两个string分别代表输入和输出类型
         * Override的call方法需要自己实现一个转换的方法，并返回一个Iterable的结构
         *
         * flatMap属于一类非常常用的spark函数，简单的说作用就是将一条rdd数据使用你定义的函数给分解成多条rdd数据
         * 例如，当前状态下，lines这个rdd类型的变量中，每一条数据都是一行String，我们现在想把他拆分成1个个的词的话，
         * 可以这样写 ：
         */

        //flatMap与map的区别是，对每个输入，flatMap会生成一个或多个的输出，而map只是生成单一的输出
        //用空格分割各个单词,输入一行,输出多个对象,所以用flatMap
        JavaRDD<String> words = lines.flatMap(line -> Arrays.asList(SPACE.split(line)).iterator());
        words.foreach(word -> System.out.println(word));

        /**
         * map 键值对 ，类似于MR的map方法
         * pairFunction<T,K,V>: T:输入类型；K,V：输出键值对
         * 表示输入类型为T,生成的key-value对中的key类型为k,value类型为v,对本例,T=String, K=String, V=Integer(计数)
         * 需要重写call方法实现转换
         */
        //scala.Tuple2<K,V> call(T t)
        //Tuple2为scala中的一个对象,call方法的输入参数为T,即输入一个单词s,新的Tuple2对象的key为这个单词,计数为1
        JavaPairRDD<String, Integer> ones = words.mapToPair(word -> new Tuple2<>(word, 1));
        ones.foreach(stringIntegerTuple2 -> System.out.println(stringIntegerTuple2));

        /**
         * 调用reduceByKey方法,按key值进行reduce
         *  reduceByKey方法，类似于MR的reduce
         *  要求被操作的数据（即下面实例中的ones）是KV键值对形式，该方法会按照key相同的进行聚合，在两两运算
         *  /若ones有<"one", 1>, <"one", 1>,会根据"one"将相同的pair单词个数进行统计,输入为Integer,输出也为Integer
         *输出<"one", 2>
         */
        //reduce阶段，key相同的value怎么处理的问题
        //备注：spark也有reduce方法，输入数据是RDD类型就可以，不需要键值对，
        // reduce方法会对输入进来的所有数据进行两两运算
        JavaPairRDD<String, Integer> counts = ones.reduceByKey((integer, integer2) -> integer + integer2);
        counts.foreach(stringIntegerTuple2 -> System.out.println(stringIntegerTuple2));

        /**
         * collect方法其实之前已经出现了多次，该方法用于将spark的RDD类型转化为我们熟知的java常见类型
         */
        List<Tuple2<String, Integer>> resultList = counts.collect();
        System.out.println(resultList.size());

        // 链式调用
//        javaSparkContext.textFile(inputPath)
//                        .flatMap(line -> Arrays.asList(SPACE.split(line)).iterator())
//                        .mapToPair(word -> new Tuple2<>(word, 1))
//                        .reduceByKey((integer, integer2) -> integer + integer2)
//                        .collect()
//                        .forEach(stringIntegerTuple2 -> System.out.println(stringIntegerTuple2));
        javaSparkContext.stop();
    }
}
