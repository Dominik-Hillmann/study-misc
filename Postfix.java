import java.util.Stack;
import java.util.StringTokenizer;

public class Postfix {
		
	private Operator[] operators;
	private Stack<Operator> stack = new Stack<Operator>();
	/* Dieser Wert ist fuer die Num-Klasse gedacht, da diese laut Interface zwei Argumente (double, double) braucht.
	 *  Laut Aufgabe muss Num aber ein 0-wertiger Operator sein, weshalb diese beiden Argumente keinen Sinn machen wuerden.
	 *  Ueber calc() gibt ein Num seinen eigenen Wert zurueck (wie andere Operatoren), aber mit useless soll markiert werden, dass
	 *  das Argument eigentlich nutzlos ist und nur der Konsistenz aller Operatoren dient. */
	private final static double useless = 0.0;
		
	
	Postfix(Operator[] operators) {
		this.operators = operators;
	} // Konstruktor
	
	
	private boolean anyOperator(String str) {
		boolean isOperator = false;		
		for (int i = 0; i < operators.length; i++) {
			if (str.equals(operators[i].getType())) {
				isOperator = true;
				break;
			}
		}
		return isOperator;
	} // anyOperator
	
	
	public double eval(String expr) {
		StringTokenizer tokens = new StringTokenizer(expr);
		String currentToken;				
		
		while (tokens.hasMoreTokens()) {			
			currentToken = tokens.nextToken();			
			
			try {
				stack.push(new Num(Double.parseDouble(currentToken)));
			} catch (Exception e) {
				/* Der Token ist also keine Zahl, weshalb zwei Fragen beantwortet werden muessen:
				 * 1) Ist der Token eine der legalen Operationen in operators?
				 * 2) Wenn ja, welcher Operator ist es genau?
				 * Wenn es ueberhaupt kein gueltiger Operator ist, dann gibt die Methode null/Double.NaN zurueck.
				 * Wenn er gueltig ist, dann packe das Ergebnis seiner Operation auf den Stack. */				
				if (anyOperator(currentToken)) {
					// Frage 1 beantwortet.
					double op1 = stack.pop().calc(useless, useless);
					double op2 = stack.pop().calc(useless, useless);
					
					switch (currentToken) {
						// Frage 2 beantwortet.
						case "+":
							stack.push(new Num(new Plus().calc(op1, op2)));
							break;
						case "-":
							stack.push(new Num(new Minus().calc(op1, op2)));
							break;
						case "*":
							stack.push(new Num(new Mult().calc(op1, op2)));
							break;
						case "/":
							stack.push(new Num(new Div().calc(op1, op2)));
							break;
					}					
				} else {
					// Das Zeichen ist weder eine Zahl, noch ein gueltiger Operator.
					// Aufgabe: "Falls es sich nicht um einen gueltigen Ausdruck handelt, soll das Ergebniss null sein."
					return Double.NaN; 
				}
			}			
		} 
		// Nun sollte nur noch ein Element auf dem Stack liegen. Wenn nicht, ist etwas schief gelaufen.
		if (stack.size() > 1) throw new Error("unbekannter Fehler");
		return stack.pop().calc(useless, useless);
	} // eval

	
	public static void main(String[] args) {
		Operator[] ops = {
			new Plus(),
			new Minus(),
			new Mult(),
			new Div()
		};
				
		Postfix postfix = new Postfix(ops);
		
		System.out.println(postfix.eval("3 5 2 * +")); // == 13.0
		System.out.println(postfix.eval("7 3 5 + * 29 *")); // == 1624.0
	}
}
