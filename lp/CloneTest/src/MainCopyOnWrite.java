import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;


public class MainCopyOnWrite {

	public static void main(String[] args) {
		CopyOnWriteArrayList<User> us = new CopyOnWriteArrayList<User>();
		us.add(new User(1L, "a"));
		us.add(new User(2L, "b"));
	}
	
}
