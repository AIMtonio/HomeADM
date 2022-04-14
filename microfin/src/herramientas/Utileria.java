package herramientas;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.lang.reflect.Modifier;
import java.text.DateFormat;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.DatatypeConverter;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.http.client.config.RequestConfig;
import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.ss.usermodel.ClientAnchor;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Drawing;
import org.apache.poi.ss.usermodel.Picture;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONObject;
import org.springframework.security.core.codec.Base64;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import cuentas.bean.MonedasBean;

public class Utileria {
	
	public static String Arial = "Arial";
	protected static Gson gson = new GsonBuilder()
    .excludeFieldsWithModifiers(Modifier.FINAL, Modifier.TRANSIENT, Modifier.STATIC)
    .serializeNulls()
    .setPrettyPrinting()     
    .create();
	
	protected static Gson gsonPlane = new GsonBuilder()
    .excludeFieldsWithModifiers(Modifier.FINAL, Modifier.TRANSIENT, Modifier.STATIC)
    .create();

	protected static final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	/* funcion para saber si el valor de string contiene solo numeros.*/
	public static boolean esNumero(String cadena){
		try {
			Integer.parseInt(cadena);
			return true;
		} catch (NumberFormatException nfe){
			return false;
		}
	}
	
	/* funcion para saber si el valor de string contiene solo numeros.*/
	public static boolean esDouble(String cadena){
		try {
			Double.parseDouble(cadena);
			return true;
		} catch (NumberFormatException nfe){
			return false;
		}
	}
	
	/*
	 * Responde con un json a las transacciones
	 * Para los controladores de la aplicación
	 */
	public static void respuestaJsonTransaccion(Object objetoBean,HttpServletResponse response){

		String jsonInString = "";

		jsonInString = gson.toJson(objetoBean,objetoBean.getClass());
		
	
		response.setHeader("Content-Disposition","");
		response.setContentType("application/json");
		PrintWriter writer;
		try {
			writer = response.getWriter();
			writer.write(jsonInString);
			writer.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	   
	}
	
	/* funcion para saber si el valor de string contiene solo numeros.*/
	public static boolean esLong(String cadena){
		try {
			Long.parseLong(cadena);
			return true;
		} catch (NumberFormatException nfe){
			return false;
		}
	}
	
	/* Valida si una fecha es valida  con el formato  yyyy-MM-dd */
	public static boolean esFecha(String fecha) {
        try {
            SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
            formatoFecha.setLenient(false);
            formatoFecha.parse(fecha);
        } catch (ParseException e) {
            return false;
        }
        return true;
    }
	
	
	
	public static String completaCerosIzquierda(String cadena, int longitud) {
		String strPivote = "";

		for (int i = cadena.length(); i < longitud; i++) {
			strPivote = strPivote + "0";
		}

		return strPivote + cadena;
	}
	
	public static String completaCaracteresIzquierda(String cadena, int longitud, String caracter) {
		String strPivote = "";
		for (int i = cadena.length(); i < longitud; i++) {
			strPivote = strPivote + caracter;
		}
		return strPivote + cadena;
	}

	public static String completaCaracteresDerecha(String cadena, int longitud, String caracter) {
		String strPivote = "";
		for (int i = cadena.length(); i < longitud; i++) {
			strPivote =  strPivote + caracter;
		}
		return   cadena + strPivote;
	}

	public static String completaCerosIzquierda(int cadena, int longitud) {
		return completaCerosIzquierda(String.valueOf(cadena), longitud);
	}	

	public static String completaCerosIzquierda(Long cadena, int longitud) {
		return completaCerosIzquierda(String.valueOf(cadena), longitud);
	}	
	
	public static String[] divideString(String cadena, String caracterDivision) {
		
		
		return cadena.split(caracterDivision);
	}	
	
	/* Convierte un campo de tipo string en un arreglo de byte*/

	@SuppressWarnings("finally")
	public static byte[] str64ToBinary(String Entrada){
        byte[] img=null;
        try{
        	img= Base64.decode(Entrada.getBytes());
           
        }catch(Exception e){
        	loggerSAFI.error(e.getMessage());
                e.getStackTrace();
        }finally{
            return img;
        }
	}
	
	public  static String mascaraAstericos(String cadena, int numerosDesenmascarados){
        if(numerosDesenmascarados<cadena.length()) {
            String valorFormateado = "";
            valorFormateado = cadena.substring((cadena.length() - numerosDesenmascarados) , cadena.length() );
            valorFormateado = "**" + valorFormateado;
            return valorFormateado;
        }else{
            return cadena;
        }
    }

	

    /*Convierte un campo de tipo byte[] a un string Base64*/

    @SuppressWarnings("finally")
	public static String bytesToStr64(byte[] Entrada){
           // conversion a base64
           String  str64=null;
           try{
               str64= DatatypeConverter.printBase64Binary(Entrada);
              
           }catch(Exception e){
           		loggerSAFI.error(e.getMessage());
                   e.getStackTrace();
                   str64="error";
               }finally{
                   return str64;
               }
    }
           
        
	
	public static String consultaFechaHoraServidor(){
		SimpleDateFormat formatoHR = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		Date fechaActual = new Date();
		return formatoHR.format(fechaActual);
	}
	
	public static void escribeActividadUsuario(String mensajeLog) throws IOException{
		BufferedWriter archivoSalida = null;
		Date fechaActual = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
		
	
		String rutaArchivo = 
				 		System.getProperty("file.separator")+
						 "opt"+
						 System.getProperty("file.separator")+
						 "tomcat6"+
						 System.getProperty("file.separator")+
						 "logs"+
						 System.getProperty("file.separator")+
						 "bitacoraUsuario" + format.format(fechaActual)+ ".log";
	
		try{
			archivoSalida = new BufferedWriter(new FileWriter(rutaArchivo, true));   
			archivoSalida.write(mensajeLog);
			archivoSalida.newLine();
		} catch (Exception e) {   
		    e.printStackTrace();
		} finally {   
		    if (archivoSalida != null) {
		    	archivoSalida.close();
		    }   
		} 
		
	}
	
	public static void escribelog(String msgLog){
		
		String Ren ;         
		ArrayList Arreglo;		
				
	
		Arreglo = new ArrayList();
		String archivo = System.getProperty("user.home") +
						 System.getProperty("file.separator")+	
						 "SAFI.txt";
		 
		try {       		 
		 
			BufferedReader BuR = new BufferedReader(new FileReader(archivo));                          
			Ren = BuR.readLine();
			
			while (Ren != null) {
				Arreglo.add(Ren);
				Ren = BuR.readLine();               
			}
			BuR.close();
		} catch (IOException e) {

		} 
			
		try {
			BufferedWriter BuW = new BufferedWriter(new java.io.FileWriter(archivo));
			for( int i = 0 ; i < Arreglo.size() ; i ++) 
			{   
				BuW.write((String)Arreglo.get(i));
				BuW.newLine();  
			}			
			BuW.newLine();
			BuW.write(msgLog);
			BuW.close(); 
		} catch (IOException e) {
		
		}	
	}	
	
	public static int convierteEntero(String valorStr){
		int valorInt = 0;
		
		try{
			if (!valorStr.equalsIgnoreCase("")){
				valorInt = Integer.parseInt(valorStr);
			}			
		}catch(Exception error){
			valorInt = 0;
		}
		
		return valorInt; 
		
	}
	public static long convierteLong(String valorStr){
		long valorLong = 0;
		
		try{
			if (!valorStr.equalsIgnoreCase("")){
				valorLong = Long.parseLong(valorStr);
			}			
		}catch(Exception error){
			valorLong = 0;
		}
		
		return valorLong; 
		
	}
	
	public static float convierteFlotante(String valorStr){
		float valorFlotante = 0;
		
		try{
			if (!valorStr.equalsIgnoreCase("")){
				valorFlotante = Float.parseFloat(valorStr);
			}			
		}catch(Exception error){
			valorFlotante = 0;
		}
		
		return valorFlotante; 
		
	}	

	public static double convierteDoble(String valorStr){
		double valorDoble = 0.0;
		
		try{
			if (!valorStr.equalsIgnoreCase("")){
				valorDoble = Double.parseDouble(valorStr);
			}			
		}catch(Exception error){
			valorDoble = 0.0;
		}
		
		return valorDoble; 
		
	}	
	
	public static String convierteFecha(String valorStr){
		String valorFecha = "1900-01-01" ;
		
		try{
			if (!valorStr.equalsIgnoreCase("")){
			valorFecha =valorStr;	}
		}catch(Exception error){
			valorFecha ="1900-01-01";	

		}
		
		return valorFecha; 
		
	}
	
	public static String convierteFormatoMoneda(String valorMonto){
		
		double monto = convierteDoble(valorMonto);
 		Locale locale = new Locale("es","MX"); // elegimos MX=Mexico
 		NumberFormat formato = NumberFormat.getCurrencyInstance(locale);
 		String formatoMoneda = formato.format(monto);
		return formatoMoneda;
	}
	// Metodo de Convierte una Cantidad(En String) a Su correspondiente representacion
	// En Letras  
	public static String cantidadEnLetras(String cantidad, int monedaID,
			   							  String simboloMoneda, String monedaDescripcion) {
		String cifra = "";			
		switch(monedaID){
			case(MonedasBean.MONEDA_BASE_LOCAL):
				cifra = convierteALetras(Double.parseDouble(cantidad), monedaID, simboloMoneda, monedaDescripcion);
				break;
			case(MonedasBean.MONEDA_BASE_EXTRANJERA): 
				cifra = convierteALetrasIngles(Double.parseDouble(cantidad), monedaID, simboloMoneda, monedaDescripcion);
				break;
		}
		
		return cifra;
	}					
	// Metodo que puede ser accedito por DWR bean declarado en soporte.xml
	public static String cantidadEnLetrasWeb(String cantidad, int monedaID, String simboloMoneda, String monedaDescripcion) {
		String cifra = "";
		cantidad = cantidad.trim().replaceAll(",","").replaceAll("\\$","");

		switch(monedaID){
			case(MonedasBean.MONEDA_BASE_LOCAL):
				cifra = convierteALetras(convierteDoble(cantidad), monedaID, simboloMoneda, monedaDescripcion);
			break;
			case(MonedasBean.MONEDA_BASE_EXTRANJERA): 
				cifra = convierteALetrasIngles(Double.parseDouble(cantidad), monedaID, simboloMoneda, monedaDescripcion);
			break;
		}
		
	return cifra;
}
	
	public static String cantidadEnLetras(float cantidad, int monedaID,
										  String simboloMoneda, String monedaDescripcion) {
		return(cantidadEnLetras(String.valueOf(cantidad), monedaID, simboloMoneda, monedaDescripcion));
		
	}
	public static String cantidadEnLetras(double cantidad, int monedaID,
			  							  String simboloMoneda, String monedaDescripcion) {
		return(cantidadEnLetras(String.valueOf(cantidad), monedaID, simboloMoneda, monedaDescripcion));
		
	}
	public static String cantidadEnLetras(int cantidad, int monedaID,
			  String simboloMoneda, String monedaDescripcion) {
		return(cantidadEnLetras(String.valueOf(cantidad), monedaID, simboloMoneda, monedaDescripcion));
		
	}
		
	private static String convierteALetras(double cantidad, int monedaID,
										   String simboloMoneda, String monedaDescrpcion) {

		
		String cantidadEnLetras = herramientas.Constantes.STRING_VACIO;

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

			cantidadEnLetras = herramientas.Constantes.ASTERISCO+ herramientas.Constantes.PARENTESIS_ABRE;

			while (i < 4) {
				i++;
				strCien = Constantes.STRING_VACIO;
				strDiez = herramientas.Constantes.STRING_VACIO;
				strUno = herramientas.Constantes.STRING_VACIO;
				if (numero != 0) {
					cien = (numero / 100);
					diez = (numero - (cien * 100)) / 10;
					unidades = numero - ((numero / 10) * 10);

					strCien = herramientas.Constantes.STRING_VACIO;

					switch ((int) cien) {
					case 0:
						strCien = herramientas.Constantes.STRING_VACIO;
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

					strDiez = herramientas.Constantes.STRING_VACIO;

					switch ((int) diez) {
					case 0:
						strDiez = herramientas.Constantes.STRING_VACIO;
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

					strUno = herramientas.Constantes.STRING_VACIO;

					if (diez == 1 && unidades <= 5 && unidades > 0) {
						strUno = herramientas.Constantes.STRING_VACIO;
					} else {

						switch ((int) unidades) {
						case 0:
							strUno = herramientas.Constantes.STRING_VACIO;
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
					cantidadEnLetras = cantidadEnLetras + strCien + strDiez + strUno + monedaDescrpcion + " ";
					cantidad = cantidad - numero;
					centavos = (long) (Math.round((cantidad * 100) * Math.pow(10, 0)) / Math.pow(10, 0));

					break;
				}
			}

			if (centavos == 0) {
				cantidadEnLetras = cantidadEnLetras + "00/100 " + simboloMoneda;
			} else {
				cantidadEnLetras = cantidadEnLetras
						+ Utileria.completaCerosIzquierda((long) centavos, 2) + "/100 " + simboloMoneda;
			}
				
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		cantidadEnLetras += herramientas.Constantes.PARENTESIS_CIERRA + herramientas.Constantes.ASTERISCO;

		return cantidadEnLetras;
	}

	/******************** *********************************/
	private static String convierteALetrasDecimal(double cantidad) {

		String cantidadEnLetras = herramientas.Constantes.STRING_VACIO;
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

			cantidadEnLetras = "";

			while (i < 4) {
				i++;
				strCien = Constantes.STRING_VACIO;
				strDiez = herramientas.Constantes.STRING_VACIO;
				strUno = herramientas.Constantes.STRING_VACIO;
				if (numero != 0) {
					cien = (numero / 100);
					diez = (numero - (cien * 100)) / 10;
					unidades = numero - ((numero / 10) * 10);

					strCien = herramientas.Constantes.STRING_VACIO;

					switch ((int) cien) {
					case 0:
						strCien = herramientas.Constantes.STRING_VACIO;
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

					strDiez = herramientas.Constantes.STRING_VACIO;

					switch ((int) diez) {
					case 0:
						strDiez = herramientas.Constantes.STRING_VACIO;
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

					strUno = herramientas.Constantes.STRING_VACIO;

					if (diez == 1 && unidades <= 5 && unidades > 0) {
						strUno = herramientas.Constantes.STRING_VACIO;
					} else {

						switch ((int) unidades) {
						case 0:
							strUno = herramientas.Constantes.STRING_VACIO;
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
					cantidadEnLetras = cantidadEnLetras + strCien + strDiez + strUno +  " ";
					cantidad = cantidad - numero;
					centavos = (long) (Math.round((cantidad * 100) * Math.pow(10, 0)) / Math.pow(10, 0));

					break;
				}
			}

			 

		} catch (Exception ex) {
			ex.printStackTrace();
		}
		//cantidadEnLetras += herramientas.Constantes.PARENTESIS_CIERRA + herramientas.Constantes.ASTERISCO;

		return cantidadEnLetras;
	}
	
	
	/**************** En Ingles *************************/
	private static String convierteALetrasIngles(double cantidad, int monedaID,
			   									 String simboloMoneda, String monedaDescrpcion) {
		
		String cantidadEnLetras = herramientas.Constantes.STRING_VACIO;

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

			cantidadEnLetras = herramientas.Constantes.ASTERISCO + herramientas.Constantes.ASTERISCO +
							   herramientas.Constantes.ASTERISCO + herramientas.Constantes.PARENTESIS_ABRE;

			while (i < 4) {
				i++;
				strCien = herramientas.Constantes.STRING_VACIO;
				strDiez = herramientas.Constantes.STRING_VACIO;
				strUno = herramientas.Constantes.STRING_VACIO;
				if (numero != 0) {
					cien = (numero / 100);
					diez = (numero - (cien * 100)) / 10;
					unidades = numero - ((numero / 10) * 10);
					strCien = herramientas.Constantes.STRING_VACIO;

					switch ((int) cien) {
					case 0:
						strCien = herramientas.Constantes.STRING_VACIO;
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

					strDiez = herramientas.Constantes.STRING_VACIO;

					switch ((int) diez) {
					case 0:
						strDiez = herramientas.Constantes.STRING_VACIO;
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

					strUno = herramientas.Constantes.STRING_VACIO;

					if (diez == 1) {
						strUno = herramientas.Constantes.STRING_VACIO;
					} else {

						switch ((int) unidades) {
						case 0:
							strUno = herramientas.Constantes.STRING_VACIO;
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
					cantidadEnLetras = cantidadEnLetras + strCien + strDiez + strUno + monedaDescrpcion + " ";					
					cantidad = cantidad - numero;
					centavos = (long) (Math.round((cantidad * 100) * Math.pow(10, 0)) / Math.pow(10, 0));
					break;
				}
			}
			
			
			
				if (centavos == 0) {
					cantidadEnLetras = cantidadEnLetras + "00/100 " + simboloMoneda;
				} else {
					cantidadEnLetras = cantidadEnLetras
							+ Utileria.completaCerosIzquierda((long) centavos, 2) + "/100 " + simboloMoneda;
				}
				
			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		cantidadEnLetras += herramientas.Constantes.PARENTESIS_CIERRA + herramientas.Constantes.ASTERISCO +
							herramientas.Constantes.ASTERISCO + herramientas.Constantes.ASTERISCO;

		return cantidadEnLetras;
	}
	
	/* Metodos para generar espacios en blanco a la izquierda*/
	public static String agregaEspacioIzq(String cadenaStr, int longitud){
		String cadenaCompuesta = String.format("%1$#" + longitud + "s", cadenaStr);
		
		return cadenaCompuesta;
	}
	
	/* Metodos para generar espacios en blanco a la Derecha*/
	public static String agregaEspacioDer(String cadenaStr, int longitud){
		String cadenaCompuesta = String.format("%1$-" + longitud + "s", cadenaStr);
		
		return cadenaCompuesta; 
	}
	
	public static String formatoFecha(String fechaStr){
		String fecha = "";
		String[] arreglo = fechaStr.split("-");
		
		fecha = arreglo[2] + arreglo[1] + arreglo[0];
		
		return fecha;
	}
	
	//Elimina los Decimales incluyendo el Punto Decimal de una Cadena
	//Que representa un Valor Numerico
	public static String eliminaDecimales(String valorStr){
		String valorRetorno = valorStr;
		try{
			if(valorStr.indexOf(".")!=-1){
				valorRetorno = valorStr.substring(0, valorStr.indexOf("."));
			}			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return valorRetorno;
	}	
	/**
	 * Método que reemplaza palabras <b>safilocale</b> en un texto dependiendo del tipo de institución.<br>
	 * <b>Ejemplo:</b><br>
	 * ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
	 * parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.tipoInstitFin, parametrosSisBean);
	 * String safilocaleCliente = Utileria.generaLocale("safilocale.cliente", parametrosSisBean.getNombreCortoInst());
	 * @param mensaje : Mensaje al cuál se le reemplazara texto.
	 * @param locale : Nombre Corto de la Institución 
	 **/
	public static String generaLocale(String mensaje, String locale) {
		String valorRetorno = "";
		String strLocale = "";
		String[] arreglo = null;
		Locale currentLocale;
		ResourceBundle messages;
		currentLocale = new Locale(locale);
		messages = ResourceBundle.getBundle("messages", currentLocale);
		try {
			if (mensaje.contains("safilocale")) {
				arreglo = mensaje.split(" ");
				
				for (int i = 0; i < arreglo.length; i++) {
					if (arreglo[i].contains("safilocale")) {
						valorRetorno = valorRetorno + " " + messages.getString(arreglo[i]);
					} else {
						valorRetorno = valorRetorno + " " + arreglo[i];
					}
				}
			} else {
				valorRetorno = mensaje;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return valorRetorno.trim();
	}
	
	public static String quitaCaracterEsp(String cadenaComponer){
		String cadena="";
		String caracteresESpeciales="ÁáÉéÍíÓóÚúÑñÜü+-*/=%&#!?^@~\\<>()[]{}:´;'\"\\|°¬?¿¡$-_,€«»æ¢ßł¶ŧ←↓→øþæßðđŋħ“”µ¨ØÞÆÐ·½";
		String caracteres		   ="AaEeIiOoUuNnUu";
		
		  cadena = cadenaComponer;
		  
			char[] cadenaArray = cadena.toCharArray();
		    for (int index = 0; index < cadenaArray.length; index++) {
		        int posicion = caracteresESpeciales.indexOf(cadenaArray[index]);////Busca la ubicacion del caracer dentro de la cadena caracteresESeciales 
		        if (posicion>13) {
		        	cadenaArray[index] =' ';
		        }else
		        if (posicion> -1) {
		        	cadenaArray[index] = caracteres.charAt(posicion);
		        }
		    }	
		 
		return new String(cadenaArray);
	}
	
	public static boolean existeArchivo(String ruta){
		File archivo = new File(ruta);
		return archivo.exists();
	}
	
    public static void autoAjustaColumnas(int listSize,Sheet libro) { 

    	try{
		        for (int colIndex = 0; colIndex < listSize; colIndex++) {
		        	libro.autoSizeColumn(colIndex); 
		        }
    	}catch(NullPointerException e){
    		e.printStackTrace();
    	}
    }

    public static byte[] leerArchivo(String archivo)throws IOException {
		try{
			File file = new File(archivo);
			InputStream in = new FileInputStream(file);
			return IOUtils.toByteArray(in);
		}catch(Exception exception){
			exception.printStackTrace();
			return new byte[0];
		}
	}
    
    //Metodo utilizado en para reportes en excel
    public static XSSFCellStyle crearFuente(XSSFWorkbook libro, int tamanioFuente, short alineacion, short tipo){
    	XSSFFont fuente = libro.createFont();
		fuente.setFontHeightInPoints((short)tamanioFuente);
		fuente.setFontName(Arial);
		fuente.setBoldweight(tipo);
		
		XSSFCellStyle estilo = libro.createCellStyle();
		estilo.setFont(fuente);
		estilo.setAlignment(alineacion);
		return estilo;
	}

    //Metodo utilizado en para reportes en excel formato decimal
    public static XSSFCellStyle crearFuenteDecimal(XSSFWorkbook libro, int tamanioFuente, short tipo){
		
    	XSSFFont fuente = libro.createFont();
		fuente.setFontHeightInPoints((short)tamanioFuente);
		fuente.setFontName(Arial);
		fuente.setBoldweight(tipo);
		
		XSSFCellStyle estilo = libro.createCellStyle();
		XSSFDataFormat formatodecimal = libro.createDataFormat();
		estilo.setFont(fuente);
		estilo.setDataFormat(formatodecimal.getFormat("$#,##0.00"));
		estilo.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
		return estilo;
	}

    //Metodo utilizado en para reportes en excel formato decimal
    public static XSSFCellStyle crearFuenteDecimalSinComa(XSSFWorkbook libro, int tamanioFuente, short tipo){
		
    	XSSFFont fuente = libro.createFont();
		
		fuente.setFontHeightInPoints((short)tamanioFuente);
		fuente.setFontName(Arial);
		fuente.setBoldweight(tipo);
		
		XSSFCellStyle estilo = libro.createCellStyle();
		XSSFDataFormat formatodecimal = libro.createDataFormat();
		estilo.setFont(fuente);
		estilo.setDataFormat(formatodecimal.getFormat("0.00"));
		estilo.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
		return estilo;
	}

    //Metodo utilizado en para reportes en excel formato decimal
    public static XSSFCellStyle crearFuenteTasa(XSSFWorkbook libro, int tamanioFuente, short tipo){
		
    	XSSFFont fuente = libro.createFont();
		
		fuente.setFontHeightInPoints((short)tamanioFuente);
		fuente.setFontName(Arial);
		fuente.setBoldweight(tipo);
		
		XSSFCellStyle estilo = libro.createCellStyle();
		XSSFDataFormat formatodecimal = libro.createDataFormat();
		estilo.setFont(fuente);
		estilo.setDataFormat(formatodecimal.getFormat("0.0000"));
		estilo.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
		return estilo;
	}

    //Metodo utilizado en para reportes en excel formato decimal
    public static XSSFCellStyle crearFuenteTasaMoneda(XSSFWorkbook libro, int tamanioFuente, short tipo){
		
    	XSSFFont fuente = libro.createFont();
		
		fuente.setFontHeightInPoints((short)tamanioFuente);
		fuente.setFontName(Arial);
		fuente.setBoldweight(tipo);
		
		XSSFCellStyle estilo = libro.createCellStyle();
		XSSFDataFormat formatodecimal = libro.createDataFormat();
		estilo.setFont(fuente);
		estilo.setDataFormat(formatodecimal.getFormat("$#,##0.0000"));
		estilo.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
		return estilo;
	}

    public static String convertirFechaLetras(String fecha){
		String fechaCompleta = "";
		String nombreMes = "";
		int anio = 0;
		int mes = 0;
		int dia = 0;
		String cadenaDia = "";

		anio = convierteEntero((fecha).substring(0, 4));
		mes = convierteEntero((fecha).substring(5, 7));
		dia = convierteEntero((fecha).substring(8, 10));

		switch(mes) {
			case 1:
				nombreMes = "Enero";
			break;
			case 2:
				nombreMes = "Febrero";
			break;
			case 3:
				nombreMes = "Marzo";
			break;
			case 4:
				nombreMes = "Abril";
			break;
			case 5:
				nombreMes = "Mayo";
			break;
			case 6:
				nombreMes = "Junio";
			break;
			case 7:
				nombreMes = "Julio";
			break;
			case 8:
				nombreMes = "Agosto";
			break;
			case 9:
				nombreMes = "Septiembre";
			break;
			case 10:
				nombreMes = "Octubre";
			break;
			case 11:
				nombreMes = "Noviembre";
			break;
			case 12:
				nombreMes = "Diciembre";
			break;
			default:
				nombreMes = "Mes Invalido";
			break;
		}

		cadenaDia = dia+"";
		if(dia < 10){
			cadenaDia = "0"+dia;
		}

		fechaCompleta = (cadenaDia + " de " + nombreMes+" del " +anio).toString();
		fechaCompleta = fechaCompleta.toUpperCase();

		return fechaCompleta;
	}
    
    public static String logJsonFormat(Object objetoBean){
		String jsonInString = "";

		jsonInString = gsonPlane.toJson(objetoBean,objetoBean.getClass());

		return jsonInString;

	}
    
    public static void borraArchivo(String ruta) throws FileNotFoundException{
    	//VALIDACION QUE RESIVA UNA RUTA
    	if(ruta!="" && ruta!=null){
    		File archivo = new File(ruta);
    		FileInputStream leerArchivo = new FileInputStream(archivo);
    		try {
    			leerArchivo.close();
    		} catch (Exception e) {
    			e.printStackTrace();
    		}
    		archivo.delete();
    		loggerSAFI.info("ARCHIVO ELIMINADO: "+ruta);
    	}
		
	}
    
	public static String imprimeObjeto(Object objetoBean) {

		String jsonInString = "";

		jsonInString = gson.toJson(objetoBean,objetoBean.getClass());

		return jsonInString;
	}

	public static Object jsonToObject(String objetoBean, Class tipoObject) {
		return gson.fromJson(objetoBean, tipoObject);
	}

	public static JSONObject stringToJson(String cadena) {
		JSONObject jsonObj = null;
		if(cadena !=  null){
			jsonObj = new JSONObject(cadena);
		}
		return jsonObj;
	}
	public static Date convierteDate(String fechaStr, String formato) {
        SimpleDateFormat fechaEntrada= new SimpleDateFormat(formato);

        Date fecha = null;
         
        fechaEntrada.setLenient(false);               
        try {
                fecha = fechaEntrada.parse(fechaStr);
        } catch (Exception e) {
            
            
        }           
        return fecha;            
    }
	
	public static RequestConfig requestConfiguration(String tiempoEspera){

		int timeOut = convierteEntero(tiempoEspera);
		RequestConfig requestConfig = RequestConfig.custom().setSocketTimeout(timeOut).setConnectTimeout(timeOut).setConnectionRequestTimeout(timeOut).setStaleConnectionCheckEnabled(true).build();
		return requestConfig;	
	}
	
	//Guardar fisicamente un archivo Excel
	public static String guardaArchivoExcel(String directorio, MultipartFile multipartFile){	
		String nombreArchivo = "";
		try{
			
			Date date = new Date();
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("dd-MM-yyyyhh:mm:ss");
			String fecha = simpleDateFormat.format(date);
			nombreArchivo = directorio+fecha+".xls";
			boolean exists = (new File(directorio)).exists();
	
			if (exists) {
				escribirArchivo(nombreArchivo, multipartFile);
			} else {
				File file = new File(directorio);
				file.mkdir();
				escribirArchivo(nombreArchivo, multipartFile);  
			}
		
		} catch(Exception exception){
			nombreArchivo = "";
			exception.printStackTrace();
    		loggerSAFI.info("Error al Guardar el archivo: " + exception);
		}
		
		return nombreArchivo;
	}
	
	public static void escribirArchivo(String nombreArchivo, MultipartFile multipartFile){
		try{
			if (multipartFile != null) {
				File filespring = new File(nombreArchivo);
				FileUtils.writeByteArrayToFile(filespring, multipartFile.getBytes());  
			}
		} catch(Exception exception){
			exception.printStackTrace();
    		loggerSAFI.info("Error al Escribir el archivo: "+ nombreArchivo + exception);
		}		
	}
	
	// Leer fisicamente un archivo Excel
	public static ArrayList<XSSFRow> leerArchivoExcel(String nombreArchivo, int filaInicio, int numeroHoja) {
		ArrayList<XSSFRow> arrayList = new ArrayList<XSSFRow>();
		try {
			FileInputStream file = new FileInputStream(new File(nombreArchivo));
			XSSFWorkbook libro = new XSSFWorkbook(file);
			XSSFSheet hoja = libro.getSheetAt(numeroHoja);
			XSSFRow fila;
			Iterator iterator = hoja.rowIterator();
			while (iterator.hasNext()) {
				fila = hoja.getRow(filaInicio);
				if (fila != null) {
					arrayList.add(fila);
				} else {
				}
				
				iterator.next();
				filaInicio++;
			}		
		} catch (IOException exception) {
			arrayList = null;
			exception.printStackTrace();
			loggerSAFI.error("error al leer archivo de excel: ", exception);
		}
		return arrayList;
	}
	
	// Funcion para generar la hora actual.
	public static String horaActual() {
		Date horaActual = new Date();
		DateFormat dfLocal = new SimpleDateFormat("HH:mm:ss");

		return dfLocal.format(horaActual);
	}
	
	/**
	 * Funcion que comprime en un archivo zip la lista de archivos especificados
	 * 
	 * @param zipFile Ruta y nombre del archivo zip a generar.
	 * @param srcFiles Ruta y nombre de los archivos a comprimir.
	 * @return
	 */
	public static boolean zipFiles(String zipFile, List<String> srcFiles) {
		boolean archivosComprimidos = false;
        try {
            // create byte buffer
            byte[] buffer = new byte[1024];
            FileOutputStream fos = new FileOutputStream(zipFile);
            ZipOutputStream zos = new ZipOutputStream(fos);
            for (int i=0; i < srcFiles.size(); i++) {
                File srcFile = new File(srcFiles.get(i));
                
                FileInputStream fis = new FileInputStream(srcFile);
                // begin writing a new ZIP entry, positions the stream to the start of the entry data
                zos.putNextEntry(new ZipEntry(srcFile.getName()));
                 
                int length;
                while ((length = fis.read(buffer)) > 0) {
                    zos.write(buffer, 0, length);
                }
 
                zos.closeEntry();
                // close the InputStream
                fis.close();
            }
 
            // close the ZipOutputStream
            zos.close();
            archivosComprimidos = true;
        }
        catch (IOException ioe) {
        	archivosComprimidos = false;
            System.out.println("Error al intentar comprimir los archivos.");
        }
        
        return archivosComprimidos;
    }

	/* funcion para agrega imagen en excel.*/
	public static void agregaLogoClienteExcel(XSSFWorkbook libro,  String rutaLogo, 
											int firstX, int lastX,  
											int firstY, int lastY,
											Sheet hoja, double ajuste){
		// libro indica el archivo a generar
		// rutaLogo indica donde se ubica el logo/imagen del cliente
		// firstX indica la columna del archivo en excel
		// lastX indica la ultima columna del archivo en excel
		// firstY indica la fila del archivo en excel
		// lastY indica la ultima fila del archivo en excel
		// hoja indica con la hoja a trabajar
		try{
			File archivo = new File(rutaLogo);
			if (!archivo.exists()) {
				loggerSAFI.error("El logo del cliente no existe "+rutaLogo);
			}
			
			// Se inserta la imagen
			// Se obtiene los bytes de entrada del archivo de imagen
			InputStream inputStream = new FileInputStream(rutaLogo);
			//ESTILO DE CENTRADO
			XSSFCellStyle estiloCeter = libro.createCellStyle();
			estiloCeter.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			
			//HSSFCell cell = (HSSFCell) hoja.createRow(firstX);
			//cell.setCellStyle(estiloCeter);
			
			//Obtengo el contenido de un InputStream como un byte [].
			byte[] bytes = IOUtils.toByteArray(inputStream);
			
			// Agrego la imagen al libro
			int imagen = libro.addPicture(bytes, XSSFWorkbook.PICTURE_TYPE_PNG);
			
			// Cierro la imagen
			inputStream.close();
			
			// Devuelve un objeto para manejar la Instancia de la clase
			CreationHelper creationHelper = libro.getCreationHelper();
			
			// Se Crea el patron de dibujo de nivel superior.
			Drawing drawing = hoja.createDrawingPatriarch();
			// Se ancla y adjunta el archivo a la hoja de calculo
			
			ClientAnchor clientAnchor = creationHelper.createClientAnchor();
			// se Define la posicion de la imagen por columna y fila
			clientAnchor.setCol1(firstX);
			clientAnchor.setRow1(firstY);
			
			
			//Se crea la imagen
			Picture picture = drawing.createPicture(clientAnchor, imagen);
			// Reajusto el tamaño a un 0
			if(ajuste>0){
				picture.resize(ajuste);
			}else{
				picture.getPreferredSize();
			}
			hoja.getHorizontallyCenter();
			hoja.addMergedRegion(new CellRangeAddress(
					firstY, //first row (0-based)
					lastY, //last row  (0-based)
		            firstX, //first column (0-based)
		            lastX  //last column  (0-based)
		    ));
			
			hoja.setHorizontallyCenter(true);
			
			
			
		} catch(Exception exception){
			exception.printStackTrace();
    		loggerSAFI.info("Error al agregar logo cliente: "+ libro + exception);
		}		
	}

}
