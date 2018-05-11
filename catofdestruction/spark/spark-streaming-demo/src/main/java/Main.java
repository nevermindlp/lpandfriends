/**
 * Created by DeCatOfDestruction on 2018/5/10.
 */
public class Main {

    public Main() {

    }

    public static void main(String[] args) throws Exception {

        WordCount wordCount = new WordCount();
        wordCount.wordCountWithFile("hdfs://localhost:9000/user/DeCatOfDestruction/wordcount/resource/");
    }
}
