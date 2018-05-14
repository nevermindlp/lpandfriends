import org.apache.log4j.Level;
import org.apache.log4j.Logger;

/**
 * Created by DeCatOfDestruction on 2018/4/26.
 */
public class Main {

    public Main() {
    }

    public static void main(String[] args) throws Exception {

        Logger.getLogger("org.apache.spark").setLevel(Level.WARN);

        WordCount wordCount = new WordCount();
        wordCount.wordCountWithFile("hdfs://localhost:9000/user/DeCatOfDestruction/wordcount/resource/wordCountFile.txt");
    }
}
