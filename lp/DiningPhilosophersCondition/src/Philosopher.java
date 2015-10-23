import java.util.Random;
import java.util.concurrent.locks.Condition;


public class Philosopher extends Thread{

	private Philosopher left, right;
	private String name;
	private boolean eating;
	private Table table;
	private Condition condition;
	private Random random;
	
	public Philosopher(String name, Table table) {
		this.name = name;
		this.table = table;
		this.condition = table.newCondition();
		random = new Random();
	}
	
	public Philosopher getLeft() {
		return left;
	}
	public void setLeft(Philosopher left) {
		this.left = left;
	}
	public Philosopher getRight() {
		return right;
	}
	public void setRight(Philosopher right) {
		this.right = right;
	}

	public void think() throws InterruptedException {
		table.lock();
		try {
			eating = false;
			System.out.println(this.name + " is thinking...");
			left.condition.signal();
			System.out.println(this.name + " signaled to " + left.name);
			right.condition.signal();
			System.out.println(this.name + " signaled to " + right.name);
		} finally {
			table.unlock();
		}
		Thread.sleep(random.nextInt(10000));
		System.out.println(this.name + " out of thinking.");
	}
	
	public void eat() throws InterruptedException {
		table.lock();
		try {
			System.out.println(this.name + " is checking whether can eat.");
			while (left.eating || right.eating) {
				condition.await();
			}
			System.out.println(this.name + " can eat.");
			System.out.println(this.name + " is eating...");
			eating = true;
		} finally {
			table.unlock();
		}
		Thread.sleep(random.nextInt(1000));
		System.out.println(this.name + " is full.");
	}
	
	public void run() {
		while(true) {
			try {
				think();
				eat();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}
	}
}
