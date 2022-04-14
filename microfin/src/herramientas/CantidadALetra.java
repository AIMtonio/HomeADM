package herramientas;

public class CantidadALetra {

	public static String VACIO = "";
	public static String ASTERISCO = "*****";
	public static String PARENTESIS_ABRE = "(";
	public static String PARENTESIS_CIERRA = ")";

	public static String NumerosALetras(String cantidad, int idioma, String monedaDescrpcion) {
		String cifra = "";
		
		switch(idioma){
			case(1): cifra = deNumerosALetras(Double.parseDouble(cantidad), monedaDescrpcion);
				break;
			case(2): cifra = deNumerosALetrasIngles(Double.parseDouble(cantidad), monedaDescrpcion);
				break;
			
		}
		
		return cifra;
	}
	/********** Español ***************/

	public static String deNumerosALetras(double cantidad, String monedaDescrpcion) {

		String cantidadEnLetras = VACIO;

		String strCien = null;
		String strDiez = null;
		String strUno = null;

		long centavos = 0;
		long unidades = 0;
		long diez = 0;
		long cien = 0;
		long milesMill = 0;

		int i = 0;
		long numero = 0;
		try {
			if (cantidad > 999999999999.99) {
				cantidadEnLetras = "Error numero muy Grande";
				return cantidadEnLetras;
			}

			numero = (long) (cantidad / 1000000000);

			cantidadEnLetras = ASTERISCO + ASTERISCO + ASTERISCO + PARENTESIS_ABRE;

			while (i < 4) {
				i++;
				strCien = VACIO;
				strDiez = VACIO;
				strUno = VACIO;
				if (numero != 0) {
					cien = (numero / 100);
					diez = (numero - (cien * 100)) / 10;
					unidades = numero - ((numero / 10) * 10);

					strCien = VACIO;

					switch ((int) cien) {
					case 0:
						strCien = VACIO;
						break;
					case 1:
						if (diez == 0 && unidades == 0) {
							strCien = "CIEN ";
						} else {
							strCien = "CIENTO ";
						}
						break;

					case 2:
						strCien = "DOSCIENTOS ";
						break;
					case 3:
						strCien = "TRESCIENTOS ";
						break;
					case 4:
						strCien = "CUATROCIENTOS ";
						break;
					case 5:
						strCien = "QUINIENTOS ";
						break;
					case 6:
						strCien = "SEISCIENTOS ";
						break;
					case 7:
						strCien = "SETECIENTOS ";
						break;
					case 8:
						strCien = "OCHOCIENTOS ";
						break;
					case 9:
						strCien = "NOVECIENTOS ";
						break;
					}

					strDiez = VACIO;

					switch ((int) diez) {
					case 0:
						strDiez = VACIO;
						break;
					case 1:
						if (unidades <= 5 && unidades > 0) {
							switch ((int) unidades) {
							case 1:
								strDiez = "ONCE ";
								break;
							case 2:
								strDiez = "DOCE ";
								break;
							case 3:
								strDiez = "TRECE ";
								break;
							case 4:
								strDiez = "CATORCE ";
								break;
							case 5:
								strDiez = "QUINCE ";
								break;
							}
						} else {
							strDiez = "DIEZ ";
						}
						break;
					case 2:
						if (unidades > 0) {
							strDiez = "VEINTI";
						} else {
							strDiez = "VEINTE ";
						}
						break;
					case 3:
						strDiez = "TREINTA ";
						break;
					case 4:
						strDiez = "CUARENTA ";
						break;
					case 5:
						strDiez = "CINCUENTA ";
						break;
					case 6:
						strDiez = "SESENTA ";
						break;
					case 7:
						strDiez = "SETENTA ";
						break;
					case 8:
						strDiez = "OCHENTA ";
						break;
					case 9:
						strDiez = "NOVENTA ";
						break;
					}

					if (diez == 1 && unidades > 5) {
						strDiez = strDiez + "Y ";
					}

					if (diez > 2 && unidades != 0) {
						strDiez = strDiez + "Y ";
					}

					strUno = VACIO;

					if (diez == 1 && unidades <= 5 && unidades > 0) {
						strUno = VACIO;
					} else {

						switch ((int) unidades) {
						case 0:
							strUno = VACIO;
							break;
						case 1:
							strUno = "UN ";
							break;
						case 2:
							strUno = "DOS ";
							break;
						case 3:
							strUno = "TRES ";
							break;
						case 4:
							strUno = "CUATRO ";
							break;
						case 5:
							strUno = "CINCO ";
							break;
						case 6:
							strUno = "SEIS ";
							break;
						case 7:
							strUno = "SIETE ";
							break;
						case 8:
							strUno = "OCHO ";
							break;
						case 9:
							strUno = "NUEVE ";
							break;
						}
					}
				}

				switch (i) {
				case 1:
					if (numero > 0) {
						cantidadEnLetras = strCien + strDiez + strUno + "MIL ";
						milesMill = 1;
					}

					cantidad = cantidad - (numero * 1000000000);
					numero = (long) cantidad / 1000000;

					break;

				case 2:
					if (numero > 0 || milesMill == 1) {
						
						cantidadEnLetras = cantidadEnLetras + strCien + strDiez + strUno + "MILLON";
						
						if (numero > 1 || milesMill == 1) {
							if (((numero * 1000000) - cantidad) != 0) {
								cantidadEnLetras = cantidadEnLetras + "ES ";
							} else {
								cantidadEnLetras = cantidadEnLetras + "ES DE ";
							}
						} else {
							if (((numero * 1000000) - cantidad) != 0) {
								cantidadEnLetras = cantidadEnLetras + " ";
							} else {
								cantidadEnLetras = cantidadEnLetras + " DE ";
							}
						}
					}

					cantidad = cantidad - (numero * 1000000);
					numero = (long) (cantidad / 1000);
					break;

				case 3:
					if (numero > 0) {
						cantidadEnLetras = cantidadEnLetras + strCien + strDiez + strUno + "MIL ";
					}
					cantidad = cantidad - (numero * 1000);
					numero = (long) (cantidad / 1);
					break;

				case 4:
					
					if(!monedaDescrpcion.equalsIgnoreCase("DLLS")) {
						cantidadEnLetras = cantidadEnLetras + strCien + strDiez + strUno + "PESOS ";
					}else{
						cantidadEnLetras = cantidadEnLetras + strCien + strDiez + strUno + " DOLARES ";
					}
					

					cantidad = cantidad - numero;
					centavos = (long) (Math.round((cantidad * 100) * Math.pow(10, 0)) / Math.pow(10, 0));

					break;
				}
			}

			if(!monedaDescrpcion.equalsIgnoreCase("DLLS")) {
				if (centavos == 0) {
					cantidadEnLetras = cantidadEnLetras + "00/100 M.N.";
				} else {
					cantidadEnLetras = cantidadEnLetras
							+ Utileria.completaCerosIzquierda((long) centavos, 2) + "/100 M.N.";
				}
				
			}else{
				if (centavos == 0) {
					cantidadEnLetras = cantidadEnLetras + "00/100 DLLS";
				} else {
					cantidadEnLetras = cantidadEnLetras
							+ Utileria.completaCerosIzquierda((long) centavos, 2) + "/100 DLLS";
				}
				
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}
		cantidadEnLetras += PARENTESIS_CIERRA + ASTERISCO + ASTERISCO + ASTERISCO;

		return cantidadEnLetras;
	}

	/**************** En Ingles *************************/

	public static String deNumerosALetrasIngles(double cantidad, String monedaDescrpcion) {
		String cantidadEnLetras = VACIO;

		String strCien = null;
		String strDiez = null;
		String strUno = null;

		long centavos = 0;
		long unidades = 0;
		long diez = 0;
		long cien = 0;
		long milesMill = 0;

		int i = 0;
		long numero = 0;
		try {
			if (cantidad > 999999999999.99) {
				cantidadEnLetras = "Error numero muy Grande";
				return cantidadEnLetras;
			}

			numero = (long) (cantidad / 1000000000);

			cantidadEnLetras = ASTERISCO + ASTERISCO + ASTERISCO + PARENTESIS_ABRE;

			while (i < 4) {
				i++;
				strCien = VACIO;
				strDiez = VACIO;
				strUno = VACIO;
				if (numero != 0) {
					cien = (numero / 100);
					diez = (numero - (cien * 100)) / 10;
					unidades = numero - ((numero / 10) * 10);
					strCien = VACIO;

					switch ((int) cien) {
					case 0:
						strCien = VACIO;
						break;
					case 1:
						strCien = "Hundred ";
						break;
					case 2:
						strCien = "Two Hundred ";
						break;
					case 3:
						strCien = "Three Hundred ";
						break;
					case 4:
						strCien = "Four Hundred ";
						break;
					case 5:
						strCien = "Five Hundred ";
						break;
					case 6:
						strCien = "Six Hundred ";
						break;
					case 7:
						strCien = "Seven Hundred ";
						break;
					case 8:
						strCien = "Eight Hundred ";
						break;
					case 9:
						strCien = "Nine Hundred ";
						break;
					}

					strDiez = VACIO;

					switch ((int) diez) {
					case 0:
						strDiez = VACIO;
						break;
					case 1:
						switch ((int) unidades) {
						case 1:
							strDiez = "Eleven ";
							break;
						case 2:
							strDiez = "Twelve ";
							break;
						case 3:
							strDiez = "Thirteen ";
							break;
						case 4:
							strDiez = "Fourteen ";
							break;
						case 5:
							strDiez = "Fifteen ";
							break;
						case 6:
							strDiez = "Sixteen ";
							break;
						case 7:
							strDiez = "Seventeen ";
							break;
						case 8:
							strDiez = "Eighteen ";
							break;
						case 9:
							strDiez = "Nineteen ";
							break;
						}
						break;
					case 2:
						strDiez = "Twenty";
						break;
					case 3:
						strDiez = "Thirty";
						break;
					case 4:
						strDiez = "Forty";
						break;
					case 5:
						strDiez = "Fifty";
						break;
					case 6:
						strDiez = "Sixty";
						break;
					case 7:
						strDiez = "Seventy";
						break;
					case 8:
						strDiez = "Eighty";
						break;
					case 9:
						strDiez = "Ninety";
						break;
					}

					if (diez > 2 && unidades != 0)
						strDiez = strDiez + "- ";
					else
						strDiez = strDiez + " ";

					strUno = VACIO;

					if (diez == 1) {
						strUno = VACIO;
					} else {

						switch ((int) unidades) {
						case 0:
							strUno = VACIO;
							break;
						case 1:
							strUno = "One ";
							break;
						case 2:
							strUno = "Two ";
							break;
						case 3:
							strUno = "Three ";
							break;
						case 4:
							strUno = "Four ";
							break;
						case 5:
							strUno = "Five ";
							break;
						case 6:
							strUno = "Six ";
							break;
						case 7:
							strUno = "Seven ";
							break;
						case 8:
							strUno = "Eight ";
							break;
						case 9:
							strUno = "Nine ";
							break;
						}
					}
				}

				switch (i) {
				case 1:
					if (numero > 0) {
						cantidadEnLetras = strCien + strDiez + strUno + "Thousand";
						milesMill = 1;
					}

					cantidad = cantidad - (numero * 1000000000);
					numero = (long) cantidad / 1000000;
					break;
				case 2:
					if (numero > 0 || milesMill == 1) {
						cantidadEnLetras = cantidadEnLetras + strCien + strDiez + strUno + "Milion";
					}
					cantidad = cantidad - (numero * 1000000);
					numero = (long) (cantidad / 1000);
					break;
				case 3:
					if (numero > 0) {
						cantidadEnLetras = cantidadEnLetras + strCien + strDiez + strUno + "Thousand ";
					}
					cantidad = cantidad - (numero * 1000);
					numero = (long) (cantidad / 1);
					break;
				case 4:
					

					if(!monedaDescrpcion.equalsIgnoreCase("DLLS")) {
						cantidadEnLetras = cantidadEnLetras + strCien + strDiez + strUno + "PESOS ";
					}else{
						cantidadEnLetras = cantidadEnLetras + strCien + strDiez + strUno + " DOLLARS ";
					}
					
					cantidad = cantidad - numero;
					centavos = (long) (Math.round((cantidad * 100) * Math.pow(10, 0)) / Math.pow(10, 0));
					break;
				}
			}
			
			
			if(!monedaDescrpcion.equalsIgnoreCase("DLLS")) {
				if (centavos == 0) {
					cantidadEnLetras = cantidadEnLetras + "00/100 M.N.";
				} else {
					cantidadEnLetras = cantidadEnLetras
							+ Utileria.completaCerosIzquierda((long) centavos, 2) + "/100 M.N.";
				}
				
			}else{
				if (centavos == 0) {
					cantidadEnLetras = cantidadEnLetras + "00/100 DLLS";
				} else {
					cantidadEnLetras = cantidadEnLetras
							+ Utileria.completaCerosIzquierda((long) centavos, 2) + "/100 DLLS";
				}
				
			}
			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		cantidadEnLetras += PARENTESIS_CIERRA + ASTERISCO + ASTERISCO + ASTERISCO;

		return cantidadEnLetras;
	}

}
