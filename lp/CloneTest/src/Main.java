import java.util.ArrayList;
import java.util.Iterator;


public class Main {

	public static void main(String[] args) {
		ArrayList<User> us = new ArrayList<User>();
		ArrayList<User> usClone;
		User u1 = new User(1L, "a");
		User u2 = new User(2L, "b");
		us.add(u1);
		us.add(u2);
		usClone = (ArrayList<User>) us.clone();
		for (User u : usClone) {
			System.out.println(u.getId() + u.getName());
			u.setName("d");
		}
		Iterator<User> it = usClone.iterator();
		while (it.hasNext()) {
			User u = it.next();
			if (u.getId() == 1L) {
				it.remove();
			}
		}
		
		for (User u : usClone) {
			System.out.println(u.getId() + u.getName());
		}
		
		usClone.add(new User(3L, "c"));
		for (User u : us) {
			System.out.println(u.getId() + u.getName());
		}
	}
}
