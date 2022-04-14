package herramientas;

public class Levenshtein {


	private int LowerOfThree(int first, int second, int third) {
		int min = Math.min(first, second);
		return Math.min(min, third);
	}

	private void printMatrix(int[][] Matrix, int m, int n) {
		System.out.println("\n\n");
		for (int i = 0; i <= n; i++) {
			for (int j = 0; j <= m; j++)
				System.out.print(Matrix[i][j] + "\t");
			System.out.println("");
		}
	}

	private int LevenshteinPercentil(String str1, String str2, double x) {
		if (x > 1)
			x = x / 100;
		return (int) Math.ceil(Math.max(str1.length(), str2.length()) * (1 - x));
	}

	public double LevenshteinDistancePercent(String str1, String str2, int val) {
		return 1 - (double) val / Math.max(str1.length(), str2.length());
	}

	public double LevenshteinAlgorithm(String str1, String str2) {
		int lc = LevenshteinClasico(str1, str2);
		if (lc < 0)
			return 1;
		return LevenshteinDistancePercent(str1, str2, lc);
	}

	/**
	 * Algoritmo de comparación de similitud entre cadenas Levenshtein Ukkonen.
	 * @param str1 Primer cadena a comparar.
	 * @param str2 Segunda cadena a comparar.
	 * @param perc Porcentaje mínimo.
	 * @return porcentaje de similitud (doble).
	 */
	public double LevenshteinAlgorithm(String str1, String str2, double perc) {
		int lc = LevenshteinUkkonen(str1, str2, perc);
		if (lc < 0)
			return 1;
		return LevenshteinDistancePercent(str1, str2, lc);
	}

	private int LevenshteinClasico(String str1, String str2) {
		long tiempo1 = System.currentTimeMillis();
		int[][] Matrix;
		int n = str1.length();
		int m = str2.length();

		int temp = 0;
		char ch1;
		char ch2;
		int i = 0;
		int j = 0;
		if ((n == 0) && (m == 0))
			return -1;
		if (n == 0) {
			return m;
		}
		if (m == 0) {

			return n;
		}
		Matrix = new int[n + 1][m + 1];

		for (i = 0; i <= n; i++) {
			// Inicializa la primera columna
			Matrix[i][0] = i;
		}

		for (j = 0; j <= m; j++) {
			// Inicializa la primera línea
			Matrix[0][j] = j;
		}

		for (i = 1; i <= n; i++) {
			ch1 = str1.charAt(i - 1);
			for (j = 1; j <= m; j++) {
				ch2 = str2.charAt(j - 1);
				if (ch1 == ch2) {
					temp = 0;
				} else {
					temp = 1;
				}
				Matrix[i][j] = LowerOfThree(Matrix[i - 1][j] + 1,
						Matrix[i][j - 1] + 1, Matrix[i - 1][j - 1] + temp);
			}
		}
		return Matrix[n][m];
	}

	private int LevenshteinUkkonen(String str1, String str2, double perc) {
		long tiempo1 = System.currentTimeMillis();
		int[][] Matrix;
		final int n = str1.length();
		final int m = str2.length();
		final int w = m - n;

		int T = LevenshteinPercentil(str1, str2, perc);
		int temp = 0;
		char ch1;
		char ch2;
		int i = 0;
		int j = 0;
		int y;
		double LIMITE_IZQ = -n;
		double LIMITE_DCHO = m;
		final int M = 999;

		boolean diagonalIsMin = true;
		if ((n == 0) && (m == 0))
			return -1;
		if (n == 0) {
			return m;
		}
		if (m == 0) {

			return n;
		}
		Matrix = new int[n + 1][m + 1];

		for (i = 0; i <= n; i++) {
			// Inicializa la primera columna
			Matrix[i][0] = i;
		}

		for (j = 0; j <= m; j++) {
			// Inicializa la primera línea
			Matrix[0][j] = j;
		}

		for (i = 1; i <= n; i++) {
			ch1 = str1.charAt(i - 1);
			int k = 1;
			if (LIMITE_IZQ + i > 1)
				k = (int) LIMITE_IZQ + i - 1;
			for (j = k; j <= m; j++) {
				if ((j - i >= LIMITE_IZQ) && (j - i <= LIMITE_DCHO)) {

					// numPasos++;
					ch2 = str2.charAt(j - 1);
					if (ch1 == ch2) {
						temp = 0;
					} else {
						temp = 1;
					}
					Matrix[i][j] = LowerOfThree(Matrix[i - 1][j] + 1,
							Matrix[i][j - 1] + 1, Matrix[i - 1][j - 1] + temp);
					y = Math.abs(j - i);
					if (Matrix[i][j] * y > T) {
						if ((i > j) && (LIMITE_IZQ < j - i)) {
							LIMITE_IZQ = j - i;
						}
						if ((j >= i) && (LIMITE_DCHO > j - i)) {
							LIMITE_DCHO = j - i;
						}
						if ((w < LIMITE_IZQ) || (w > LIMITE_DCHO)) {
							i = n;
							j = m;
							diagonalIsMin = false;
						}
					}
					if ((j - i == w) && (Matrix[i][j] > T)) {
						i = n;
						j = m;
						diagonalIsMin = false;
					}
				} else {

					Matrix[i][j] = M;
					if (j > i)
						break;
				}
			}
		}

		if (diagonalIsMin)
			return Matrix[n][m];
		return Math.max(n, m);
	}
}
