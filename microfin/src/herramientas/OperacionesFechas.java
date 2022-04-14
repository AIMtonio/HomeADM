package herramientas;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.text.DateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

public class OperacionesFechas {

	//Definicion de Constantes
	public final static String FEC_VACIA = "1900-01-01";
	public final static String Formato_Fecha = "yyyyMMdd";
	public final static String Formato_Hora  = "HHmmss";
	public final static String Formato_SAFI = "yyyy-MM-dd";
	
	public static interface Operacion {
		int Fecha 	= 1;
		int Hora 	= 2;
	}
	//Definicion de Metodos
	
	//Metodo de Convirte un String en un Sql.Date
	 public  static java.sql.Date conversionStrDate(String fecha){
         SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
         java.sql.Date fechaSQLDate = null;
         if(fecha== null || fecha ==""){
        	 
        	 fecha=FEC_VACIA;
        	  
         }
         
         try {
        	 fechaSQLDate = new java.sql.Date(sdf.parse(fecha).getTime());
          
         } catch (ParseException e) { 
             // TODO Auto-generated catch block
             e.printStackTrace();
             try {
            	 fechaSQLDate = new java.sql.Date(sdf.parse(FEC_VACIA).getTime());
			} catch (ParseException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
         }
         return fechaSQLDate;
     }	
	
	 public static boolean validarFecha(String fecha) {  
		  
		 if (fecha == null)  
			 return false;  
	   
		 SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd"); //año-mes-dia  
	   
		 if (fecha.trim().length() != dateFormat.toPattern().length())  
			 return false;  
	   
		 dateFormat.setLenient(false);  
	   
		 try {  
			 dateFormat.parse(fecha.trim());  
		 }  
		 catch (ParseException pe) {  
			 return false;  
		 }  
		 return true;  
	 }  

	/** 
	 * Método que devuelve el nombre del mes.
	 * @param numeroMes : Número del mes [1 - 12].
	 * @param mayusculas : Indica si el nombre devuelto debe estar o no en mayúsculas, si es false entonces regresará el nombre capitalizado [true, false].
	 * @return String : Nombre del mes.
	 * @author avelasco
	 */
	public static String getNombreMes(String numeroMes, boolean mayusculas){
		String nombreMes = "";
		int mes = Utileria.convierteEntero(numeroMes);
	    switch (mes) {
	        case 1:  nombreMes = "Enero" ;
	        	break;
	        case 2:  nombreMes = "Febrero";
	        	break;
	        case 3:  nombreMes = "Marzo";
	        	break;
	        case 4:  nombreMes = "Abril";
	        	break;
	        case 5:  nombreMes = "Mayo";
	        	break;
	        case 6:  nombreMes = "Junio";
	        	break;
	        case 7:  nombreMes = "Julio";
	        	break;
	        case 8:  nombreMes = "Agosto";
	        	break;
	        case 9:  nombreMes = "Septiembre";
	        	break;
	        case 10: nombreMes = "Octubre";
	        	break;
	        case 11: nombreMes = "Noviembre";
	        	break;
	        case 12: nombreMes = "Diciembre";
	        	break;
	    }
	    return (mayusculas ? nombreMes.toUpperCase() : nombreMes);
	}
	
	public static String getFechaHora(final int tipoOperacion){
		String valor = "";
		Date date = new Date();

		switch(tipoOperacion){
			case Operacion.Fecha:
				DateFormat dateFormat = new SimpleDateFormat(Formato_Fecha);
				valor = String.valueOf(dateFormat.format(date));
			break;
			case Operacion.Hora:
				DateFormat hourFormat = new SimpleDateFormat(Formato_Hora);
				valor = String.valueOf(hourFormat.format(date));
			break;
		}

		return valor;
	}
	
	public static String obtenerUltDiaMes( int year, int month, int day){
		Calendar  calendar = Calendar.getInstance();
       	calendar.set(year, month, day);    	
       	return format(year, month, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
	}
	
	public static String format(int year, int month, int day) {
		SimpleDateFormat format = new SimpleDateFormat(Formato_SAFI);
        return format.format(date(gc(year, month, day)));
    }
	
	public static GregorianCalendar gc(int year, int month, int day) {
        return new GregorianCalendar(year, month, day);
    }
	
	public static Date date(GregorianCalendar c) {
        return new java.util.Date(c.getTime().getTime());
    }
}
