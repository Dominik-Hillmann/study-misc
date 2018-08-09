public enum Dienstgrad {
	HELFER,
	TRUPPFUEHRER,
	GRUPPENFUEHRER,
	ZUGTRUPPENFUEHRER,
	ZUGFUEHRER;	

	public static void printAll() {
		for (Dienstgrad d : Dienstgrad.values()) {
			System.out.println(d.toString());
		}
	}
	
	public String toString() {
		String re;
		switch (this) {
			case HELFER:
				re = "Helfer";
				break;
			case TRUPPFUEHRER:
				re = "Truppenf�hrer";
				break;
			case GRUPPENFUEHRER:
				re = "Gruppenfuehrer";
				break;
			case ZUGTRUPPENFUEHRER:
				re = "Zugtruppenf�hrer";
				break;
			case ZUGFUEHRER:
				re = "Zugf�hrer";
				break;
			default:
				re = null;
				break;
		}
		return re;
	}
	
	public boolean istVorgesetzterVor(Dienstgrad d) {
		return this.ordinal() > d.ordinal();
	}
	
	public static void main(String[] args) {
		printAll();
		System.out.println(HELFER.istVorgesetzterVor(GRUPPENFUEHRER));
		System.out.println(TRUPPFUEHRER.istVorgesetzterVor(HELFER));
		System.out.println(GRUPPENFUEHRER.istVorgesetzterVor(GRUPPENFUEHRER));
	}
}
