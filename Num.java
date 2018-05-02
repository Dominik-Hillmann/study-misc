public class Num implements Operator {
	
	private final double num;
	private final String type = "Num";
	
	Num(double num) {
		this.num = num;
	}
	
	public double calc(double op1, double op2) {
		return num;
	}
	
	public String getType() {
		return type;
	}
}
