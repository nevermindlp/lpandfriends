import java.util.Random;

public class Philosopher extends Thread {

	private Chopstick left, right;
	private String name;
	private Random random;
	public Philosopher(Chopstick left, Chopstick right, String name) {
		this.left = left;
		this.right = right;
		this.name = name;
		random = new Random();
	}
	public void run() {
		try {
			while(true) {
				System.out.println(this.name + " is thinking...");
				Thread.sleep(random.nextInt(1000));
				System.out.println(this.name + " stop thinking.");
				synchronized (left) {
					System.out.println(this.name + " keep left chopstick for 10S...");
					Thread.sleep(10000);
					System.out.println(this.name + " keep left chopstick time out");
					synchronized (right) {
						System.out.println(this.name + " is eating...");
						Thread.sleep(random.nextInt(1000));
						System.out.println(this.name + " is full.");
					}
				}
			}
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	};
}
