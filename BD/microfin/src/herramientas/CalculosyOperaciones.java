package herramientas;

import java.math.BigDecimal;

public class CalculosyOperaciones {

	public static long suma(long primero, long segundo) {
		BigDecimal primerValor = new BigDecimal(String.valueOf(primero));
		BigDecimal segundoValor = new BigDecimal(String.valueOf(segundo));
		long resultado = 0;

		resultado = primerValor.add(segundoValor).longValue();

		return resultado;
	}

	public static double suma(double primero, double segundo) {
		BigDecimal primerValor = new BigDecimal(String.valueOf(primero));
		BigDecimal segundoValor = new BigDecimal(String.valueOf(segundo));
		double resultado = 0;

		resultado = primerValor.add(segundoValor).doubleValue();

		return resultado;
	}

	public static double suma(long primero, double segundo) {
		BigDecimal primerValor = new BigDecimal(String.valueOf(primero));
		BigDecimal segundoValor = new BigDecimal(String.valueOf(segundo));
		double resultado = 0;

		resultado = primerValor.add(segundoValor).doubleValue();

		return resultado;
	}

	public static double suma(double primero, long segundo) {
		BigDecimal primerValor = new BigDecimal(String.valueOf(primero));
		BigDecimal segundoValor = new BigDecimal(String.valueOf(segundo));
		double resultado = 0;

		resultado = primerValor.add(segundoValor).doubleValue();

		return resultado;
	}

	public static long resta(long primero, long segundo) {
		BigDecimal primerValor = new BigDecimal(String.valueOf(primero));
		BigDecimal segundoValor = new BigDecimal(String.valueOf(segundo));
		long resultado = 0;

		resultado = primerValor.subtract(segundoValor).longValue();

		return resultado;
	}

	public static double resta(double primero, double segundo) {
		BigDecimal primerValor = new BigDecimal(String.valueOf(primero));
		BigDecimal segundoValor = new BigDecimal(String.valueOf(segundo));
		double resultado = 0;

		resultado = primerValor.subtract(segundoValor).doubleValue();

		return resultado;
	}

	public static double resta(long primero, double segundo) {
		BigDecimal primerValor = new BigDecimal(String.valueOf(primero));
		BigDecimal segundoValor = new BigDecimal(String.valueOf(segundo));
		double resultado = 0;

		resultado = primerValor.subtract(segundoValor).doubleValue();

		return resultado;
	}

	public static double resta(double primero, long segundo) {
		BigDecimal primerValor = new BigDecimal(String.valueOf(primero));
		BigDecimal segundoValor = new BigDecimal(String.valueOf(segundo));
		double resultado = 0;

		resultado = primerValor.subtract(segundoValor).doubleValue();

		return resultado;
	}

	public static long multiplica(long primero, long segundo) {
		BigDecimal primerValor = new BigDecimal(String.valueOf(primero));
		BigDecimal segundoValor = new BigDecimal(String.valueOf(segundo));
		long resultado = 0;

		resultado = primerValor.multiply(segundoValor).longValue();

		return resultado;
	}

	public static double multiplica(double primero, double segundo) {
		BigDecimal primerValor = new BigDecimal(String.valueOf(primero));
		BigDecimal segundoValor = new BigDecimal(String.valueOf(segundo));
		double resultado = 0;

		resultado = primerValor.multiply(segundoValor).doubleValue();

		return resultado;
	}

	public static double multiplica(long primero, double segundo) {
		BigDecimal primerValor = new BigDecimal(String.valueOf(primero));
		BigDecimal segundoValor = new BigDecimal(String.valueOf(segundo));
		double resultado = 0;

		resultado = primerValor.multiply(segundoValor).doubleValue();

		return resultado;
	}

	public static double multiplica(double primero, long segundo) {
		BigDecimal primerValor = new BigDecimal(String.valueOf(primero));
		BigDecimal segundoValor = new BigDecimal(String.valueOf(segundo));
		double resultado = 0;

		resultado = primerValor.multiply(segundoValor).doubleValue();

		return resultado;
	}

	public static double divide(long primero, long segundo) {
		BigDecimal primerValor = new BigDecimal(String.valueOf(primero));
		BigDecimal segundoValor = new BigDecimal(String.valueOf(segundo));
		double resultado = 0;

		resultado = primerValor.divide(segundoValor, 10, BigDecimal.ROUND_HALF_EVEN).doubleValue();

		return resultado;
	}

	public static double divide(double primero, double segundo) {
		BigDecimal primerValor = new BigDecimal(String.valueOf(primero));
		BigDecimal segundoValor = new BigDecimal(String.valueOf(segundo));
		double resultado = 0;

		resultado = primerValor.divide(segundoValor, 10, BigDecimal.ROUND_HALF_EVEN).doubleValue();

		return resultado;
	}

	public static double divide(long primero, double segundo) {
		BigDecimal primerValor = new BigDecimal(String.valueOf(primero));
		BigDecimal segundoValor = new BigDecimal(String.valueOf(segundo));
		double resultado = 0;

		resultado = primerValor.divide(segundoValor, 10, BigDecimal.ROUND_HALF_EVEN).doubleValue();

		return resultado;
	}

	public static double divide(double primero, long segundo) {
		BigDecimal primerValor = new BigDecimal(String.valueOf(primero));
		BigDecimal segundoValor = new BigDecimal(String.valueOf(segundo));
		double resultado = 0;

		resultado = primerValor.divide(segundoValor, 10, BigDecimal.ROUND_HALF_EVEN).doubleValue();

		return resultado;
	}
	
	public static double potenciaN(double base, long n){
		BigDecimal primerValor = new BigDecimal(String.valueOf(base));
		BigDecimal segundoValor = new BigDecimal(1);
		double resultado = 0;
		for(int i=0; i<n; i++){
			segundoValor = segundoValor.multiply(primerValor);
		}
		resultado = segundoValor.doubleValue();
		return resultado;
	}
	
	
}
