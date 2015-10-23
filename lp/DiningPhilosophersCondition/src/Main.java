
public class Main {

	public static void main(String[] args) {
		Table table = new Table();
		Philosopher p1 = new Philosopher("p1", table);
		Philosopher p2 = new Philosopher("p2", table);
		Philosopher p3 = new Philosopher("p3", table);
		Philosopher p4 = new Philosopher("p4", table);
		Philosopher p5 = new Philosopher("p5", table);

		p1.setLeft(p5);
		p1.setRight(p2);
		
		p2.setLeft(p1);
		p2.setRight(p3);
		
		p3.setLeft(p2);
		p3.setRight(p4);
		
		p4.setLeft(p3);
		p4.setRight(p5);
		
		p5.setLeft(p4);
		p5.setRight(p1);
		
		p1.start(); p2.start(); p3.start(); p4.start(); p5.start();
		
	}

}
