public class Mult implements Operator {
	
	private final String type = "*";
		
	public double calc(double op1, double op2) {
		return op1 * op2;
	}
	
	public String getType() {
		return type;
	}
}
