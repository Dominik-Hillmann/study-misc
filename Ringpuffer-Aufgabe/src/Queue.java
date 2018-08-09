public class Queue {
	final private int SIZE;
	public Entry first;
	
	Queue(int size) {
		first = new Entry(null, null, null);
		SIZE = size;
		Entry point = first;
		
		for (int i = 1; i <= SIZE - 1; i++) { // because one of them already created
			point.next = (i == SIZE ? first : new Entry(null, null, null));
			point.next.previous = point;			
		}
	}
	
	private static class Entry {
		public String element;
		private Entry next;
		private Entry previous;
		private Entry(String element, Entry next, Entry previous) {
			this.element = element;
			this.next = next;
			this.previous = previous;
		}
	}
	
	public void print() {
		Entry point = first;
		for (int i = 1; i <= SIZE; i++) {
			System.out.println(point.element);
			point = point.next;
		}
	}
	
	public void insert(String s) {
		Entry point = first;
		
		for (int i = 1; i <= SIZE; i++) {
			System.out.println(point.element);
			if (point.element == null) {
				point.element = s;
				break;
			} else {
				if (i == SIZE) {
					Entry point2 = first.previous;
					for (int j = 1; j < SIZE; j++) {
						point2.element = point2.previous.element;
						point2 = point2.previous;
					}
				}
			}			
			point = point.next;
		}
		
		
	}
	
	
	public static void main(String[] args) {
		Queue q = new Queue(4);
		q.insert("Test");
		q.print();
	}
}

/* ringpuffer can store certain num of elements
 * if more elements come in, the oldest get pushed out
 * 
 * a)
 * implement queue where strings can be stored
 * constructor should have size as a parameter
 * all ele should be null after initialization
 * */
