
public class Main {

	public static void main(String[] args) {
		
		Chopstick c1 = new Chopstick(1L);
		Chopstick c2 = new Chopstick(2L);
		Chopstick c3 = new Chopstick(3L);
		Chopstick c4 = new Chopstick(4L);
		Chopstick c5 = new Chopstick(5L);
		
		
		Philosopher p1 = new Philosopher(c1, c2, "p1");
		Philosopher p2 = new Philosopher(c2, c3, "p2");
		Philosopher p3 = new Philosopher(c3, c4, "p3");
		Philosopher p4 = new Philosopher(c4, c5, "p4");
		Philosopher p5 = new Philosopher(c5, c1, "p5");
		
		p1.start(); p2.start(); p3.start(); p4.start(); p5.start();
	}

}
