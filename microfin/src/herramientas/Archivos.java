package herramientas;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.reflect.Method;
import java.util.List;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.util.Date;



public class Archivos {
	/*	Tipos de Contenido que se regresan en la respuesta al servlet*/
	final public static String VerImagenGif 				= "image/gif";
	final public static String VerImagenJpeg				= "image/jpeg";
	final public static String VerImagenJpg				= "image/jpg";
	final public static String VerDocumentoTexo			= "text/plain";
	final public static String VerArchivoHtml				= "text/html";
	final public static String VerArchivoXml				= "text/xml";
	final public static String DescargaDocumentoPDF		= "application/pdf";
	final public static String DescargaDocumentoGral		= "application/download";
	final public static String DescargaArchivoZip			= "application/zip";
	final public static String DescargaArchivoTar			= "application/tar";
	final public static String DescargaDocumentoDoc		= "application/doc";	 
	final public static String DescargaDocumentoWord		= "application/word";
	final public static String DescargarDocumentoExcel		= "application/vnd.ms-excel";
	final public static String DescargaArchivoTexto		= "application/text";
	final public static String DescargaImagenGif			= "application/gif";
	final public static String DescargaImagenJpeg			= "application/jpeg";
	final static public String DescargaImagenJpg			= "application/jpg";
		 
	public static String Str_SI	= "S";
	public static String Str_NO	= "N";
	
	
	/**
	 * Genera un Archivo de Texto a partir de una lista de Beans de una manera flexible ya que permite definir que campos 
	 * se incluyen en el orden en que estan especificados	 	 *  
	 * ARGUMENTOS	 * 
	 * @param	informacion:   Contiene la lista de Beans	 
	 * @param	columnas:      Array que contiene el nombre de los campos tal y como se definen en el Bean. Debe de existir 
	 *                   	   un metodo get para cada columna	y se construye concatenando el "get" + columnas[i]
	 * @param	claseBean:     Contiene el nombre completo de la clase bean a la cual hace referencia la lista y esta se obtiene "bean.class.getName()"
	 * @param	rutaDestino:   Contiene la ruta donde se guardara el archivo en caso que se requiera especificar, debe finalizar con el separador  Ejemplo "/home/usuario/archivos/"  
	 * @param	nombreArchivo: Nombre del archivo que se guardara Ejemplo   "Archivo"
	 * @param	extension:     Contiene la extencion con la que se guardara el archivo  Ejemplo "txt"
	 * @param	separador:     Contiene el caracter que se usara como separador de columnas en caso que asi se requiera  Ejeplo ";"
	 * @return String con la ruta, nombre y extension de donde se guardo el archivo
	 * @author Josue Castañeda
	 * 
	 */
	public static String EscribeArchivoTexto(List informacion,String[] columnas,String claseBean, String rutaDestino, String nombreArchivo, String extension, String separador) throws IOException, ClassNotFoundException, Exception{
		String nombresColumnas="";
		if(rutaDestino == null){
			rutaDestino = Constantes.STRING_VACIO;
		}
		int bandera=0;
		if(separador == null){
			separador = Constantes.STRING_VACIO;
		}		
		nombreArchivo = rutaDestino+nombreArchivo;
		Object beanGenerico;		
		BufferedWriter writer = null;
		  
		  boolean exists = (new File(rutaDestino)).exists();
  		if (exists) {
  			writer = new BufferedWriter(new FileWriter(nombreArchivo));		
  			
  		}else{			
	  			File archivo = new File(rutaDestino);
	  			archivo.mkdir();
	  			writer = new BufferedWriter(new FileWriter(nombreArchivo));		
	  			
	  		}  
				
  		// Process process = Runtime.getRuntime().exec("sudo /opt/tomcat6/Archivos/Permisos/permisosArchivos.sh " +nombreArchivo );  		 
			try{
			 if (!informacion.isEmpty()){
				 
				 Class clase = Class.forName(claseBean);
				 Method propiedades[] = new Method[columnas.length];		
				 for (int i = 0; i < columnas.length; i++) {						
					 try {						 	
						 	columnas[i]= columnas[i].substring(0, 1).toUpperCase() + columnas[i].substring(1, columnas[i].length()); 
						 	propiedades[i] =  clase.getMethod("get"+ columnas[i],null);						 						 
						
						 } catch (SecurityException e) {
							e.printStackTrace();
						 } catch (NoSuchMethodException e) {
							e.printStackTrace();
						 }						
				 }  // fin del ciclo for
				 
				 String valor = Constantes.STRING_VACIO;
				 
				 for (int i = 0; i < informacion.size(); i++) {
					 beanGenerico = clase.newInstance();
					 beanGenerico = informacion.get(i);					 
					 for (int j=0;j < propiedades.length; j++){
						 Object objetoDato = propiedades[j].invoke(beanGenerico,null);
						 valor = Constantes.STRING_VACIO;
						 if( objetoDato != null){								
							 valor = objetoDato.toString();								
						 }	
						 
						 if (j == propiedades.length - 1) {
							 writer.write(valor);
						 }else{
							 writer.write(valor + separador);
						 }

					 }
						
					 if(i < informacion.size()){
						 writer.newLine(); // Realiza un saldo de linea mientras no sea el ultimo registro						 
					 }
				 }				 				 
			 }else{
				 writer.write("");
			 }
		  	
	    
	            
		}catch(IOException io ){
			io.printStackTrace();
		} catch (ClassNotFoundException e) {			
			e.printStackTrace();
		}catch(Exception e ){
			e.printStackTrace();
		}finally{
			if(writer != null)
				writer.close();
		}
		
		
		
		
		return nombreArchivo;
	
	}
	
	// Metodo Sobrecargado que muestra las columnas de la consulta
	public static String EscribeArchivoTexto(List informacion,String[] columnas,String[] titulosColumnas,String claseBean, String rutaDestino, String nombreArchivo, String extension, String separador,boolean encabezados) throws IOException, ClassNotFoundException, Exception{
		String nombresColumnas="";
		int bandera=0;				
		if(rutaDestino == null){
			rutaDestino = Constantes.STRING_VACIO;
		}		
		if(separador == null){
			separador = Constantes.STRING_VACIO;
		}

		nombreArchivo = rutaDestino+nombreArchivo+"."+extension;
		Object beanGenerico;		
		BufferedWriter writer = null;
		  
		boolean exists = (new File(rutaDestino)).exists();
  		if (exists) {
  			writer = new BufferedWriter(new FileWriter(nombreArchivo));		
  			
  		}else{			
	  			File archivo = new File(rutaDestino);
	  			archivo.mkdir();
	  			writer = new BufferedWriter(new FileWriter(nombreArchivo));		
	  			
	  		}  
				
  		// Process process = Runtime.getRuntime().exec("sudo /opt/tomcat6/Archivos/Permisos/permisosArchivos.sh " +nombreArchivo );  		 
			try{
			 if (!informacion.isEmpty()){
				 
				 Class clase = Class.forName(claseBean);
				 Method propiedades[] = new Method[columnas.length];
				 for (int i = 0; i < columnas.length; i++){		
					 try {
						 	columnas[i]= columnas[i].substring(0, 1).toUpperCase() + columnas[i].substring(1, columnas[i].length());
						 	propiedades[i] =  clase.getMethod("get"+columnas[i],null);
						 	if(encabezados==true){
						 		nombresColumnas+=titulosColumnas[i]+separador;
						 	}
						
						 } catch (SecurityException e) {
							e.printStackTrace();
						 } catch (NoSuchMethodException e) {
							e.printStackTrace();
						 }						
				 }  // fin del ciclo for
				 
				 String valor = Constantes.STRING_VACIO;
				 
				 for (int i = 0; i < informacion.size(); i++) {
					 beanGenerico = clase.newInstance();
					 beanGenerico = informacion.get(i);					 
					 for (int j=0;j < propiedades.length; ++j){
						 Object objetoDato = propiedades[j].invoke(beanGenerico,null);
						 valor = Constantes.STRING_VACIO;
						 if( objetoDato != null){								
							 valor = objetoDato.toString();								
						 }		 
						 if(bandera==0 && encabezados==true){
							 writer.write(nombresColumnas);
							 writer.newLine();
							 bandera=1;
						 }
						 writer.write(valor + separador);
					 }
						
					 if(i < informacion.size()){
						 writer.newLine(); // Realiza un salto de linea mientras no sea el ultimo registro						 
					 }
				 }				 				 
			 }else{
				 writer.write("");
			 }
		  	
	    
	            
		}catch(IOException io ){
			io.printStackTrace();
		} catch (ClassNotFoundException e) {			
			e.printStackTrace();
		}catch(Exception e ){
			e.printStackTrace();
		}finally{
			if(writer != null)
				writer.close();
		}
		
		
		
		
		return nombreArchivo;
	
	}
	/**
	 * Obtiene un Archivo como respues a un peticion de pantalla indicando el tipo de respuesta para el servlet
	 * ARGUMENTOS	 *   
	 * @param	nombreArchivo:  Nombre del archivo que se quiere obtener Ejemplo   "/home/usuario/Documentos/Archivo.txt"
	 * @param	response:       Respuesta al servlet
	 * @param	tipoRespuesta:  Indica el tipo de respues que se enviara al servlet
	 * @param	eliminarArchivo Indica si se desae que se elimine el archivo despues de obtener la respuesta en pantalla solo puede tener valores de "S" o "N"
	 * @return  String que indica si el metodo termino con exito o no  "S" para indicar que fue Exito y "N" para indicar que fallo
	 * @author Josue Castañeda
	 */
	public static String obtenerArchivo(String nombreArchivo, HttpServletResponse response, String tipoRespuesta, String eliminarArchivo) throws Exception {	
		String exito = Str_NO;
		ServletOutputStream ouputStream = null;
		try{				
			 FileInputStream archivo = new FileInputStream(nombreArchivo);
		     int longitud = archivo.available();
		     byte[] datos = new byte[longitud];
		     archivo.read(datos);		     
		     archivo.close();
			
			response.setHeader("Content-Disposition","attachment;filename="+nombreArchivo);
	    	response.setContentType(tipoRespuesta);
	    	ouputStream = response.getOutputStream();
	    	ouputStream.write(datos);
	    	ouputStream.flush();
	    	ouputStream.close();
	    	
	    	if(eliminarArchivo == Str_SI){
	    		exito = eliminarArchivo(nombreArchivo);
	    	}else{
	    		exito = Str_SI;
	    	}

		}catch(Exception e ){
			e.printStackTrace();
		}	
		
		return exito;
	}
	
	
	 public static String obtenerArchivo(String ruta, String nombreArchivo, HttpServletResponse response, String tipoRespuesta, String eliminarArchivo) throws Exception {	
		String exito = Str_NO;
		ServletOutputStream ouputStream = null;
		try{				
			 FileInputStream archivo = new FileInputStream(ruta+nombreArchivo);
		     int longitud = archivo.available();
		     byte[] datos = new byte[longitud];
		     archivo.read(datos);		     
		     archivo.close();
			
			response.setHeader("Content-Disposition","attachment;filename="+nombreArchivo);
	    	response.setContentType(tipoRespuesta);
	    	ouputStream = response.getOutputStream();
	    	ouputStream.write(datos);
	    	ouputStream.flush();
	    	ouputStream.close();
	    	
	    	if(eliminarArchivo == Str_SI){
	    		exito = eliminarArchivo(nombreArchivo);
	    	}else{
	    		exito = Str_SI;
	    	}
	    			    
		}catch(Exception e ){
			e.printStackTrace();
		}	
		
		return exito;
	}
	 
	
	/**
	 * Metodo para eliminar un archivo
	 * ARGUMENTOS	 *   
	 * @param	nombreArchivo:  Nombre del archivo que se quiere eliminar Ejemplo   "/home/usuario/Documentos/Archivo.txt"
	 * @return  String que indica si el metodo termino con exito o no  "S" para indicar que fue Exito y "N" para indicar que fallo
	 * @author Josue Castañeda
	 */
	public static String eliminarArchivo(String nombreArchivo) throws Exception {
		String exito = Str_NO;
		try {
			File archivo = new File(nombreArchivo);
			if (archivo.delete())
					exito = Str_SI;
			
		} catch (Exception e) {
			throw new Exception(e);
		}
		
		return exito;
	} 
	
	/**

	 * Genera un Excel a partir de una lista de Beans de manera simple, donde cada bean representa una fila del excel
	 * 		
	 * ARGUMENTOS
	 * -------------------------------------
	 * informacion:   Lista de Beans
	 * titulos:       Array de titulos, es 1 a 1 con las columnas
	 * columnas:      Array que contiene el nombre de los campos tal y como se definen en el Bean. Debe de existir 
	 * 		           un metodo get para cada columna	y se construye concatenando el "get" + columnas[i]
	 * nombreHoja:    nombre de la hoja
	 * classBean:     clase del Bean, dao.class.getName()
	 * filasPorHoja:  Indica la cantidad de Filas que tendra la hoja, si la lista contiene mas automaticamente genera otra hoja
	 * 				  Si en este campo recibe 0, el default que asignara sera 60,000 filas
	 */
	public static HSSFSheet beansEnExcel(
			List informacion, 
			String[] encabezados,
			String[] titulos,
			String[] columnas,	
			String[] auditoria,
			String nombreHoja,
			String claseBeanOriginal,
			int filasPorHoja) throws Exception{
		
		Object beanGenerico;
		int	NumeroHoja			= 0;
		int CantidadFilasPorHoja = 60000;
		int contadorDeFilas		 = 0;
		
		if(filasPorHoja > 0 ){
			CantidadFilasPorHoja = filasPorHoja;
		};

	
		HSSFWorkbook libro = null;
		HSSFSheet hojaExcel = null;
		HSSFRow filaExcel = null;
		int[] columnSize;


		libro = new HSSFWorkbook();
		
		hojaExcel = libro.createSheet(nombreHoja);
		filaExcel = hojaExcel.createRow(NumeroHoja);
		
		HSSFFont fuenteNegrita8= libro.createFont();
		fuenteNegrita8.setFontHeightInPoints((short)8);
		fuenteNegrita8.setFontName("Negrita");
		fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		
		HSSFFont fuenteNegrita12= libro.createFont();
		fuenteNegrita12.setFontHeightInPoints((short)10);
		fuenteNegrita12.setFontName("Negrita");
		fuenteNegrita12.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);		
		
		HSSFCellStyle encabezadoStyle = libro.createCellStyle();
		encabezadoStyle.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
		encabezadoStyle.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
		encabezadoStyle.setFont(fuenteNegrita12);
		
		HSSFCellStyle tituloStyle = libro.createCellStyle();
		tituloStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
		tituloStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		tituloStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);		
		
		HSSFCellStyle dateStyle = libro.createCellStyle();
		dateStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat("m/d/yy"));
		
		HSSFCellStyle doubleStyle = libro.createCellStyle();
		doubleStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat("$#,##0.00"));
						
		HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
		HSSFDataFormat format = libro.createDataFormat();
		estiloFormatoDecimal.setDataFormat(format.getFormat("$#,###,##0.00"));
		
		HSSFCellStyle estiloNeg12 = libro.createCellStyle();
		estiloNeg12.setFont(fuenteNegrita12);
		
		HSSFCellStyle estiloNeg8 = libro.createCellStyle();
		estiloNeg8.setFont(fuenteNegrita8);
		
		Class claseBean = Class.forName(claseBeanOriginal);
		Method meth[] = new Method[columnas.length];
		filaExcel = hojaExcel.createRow(0);
		contadorDeFilas  = 1;
		columnSize = new int[columnas.length];
		
		
		// Se valida si hay encabezados, si los hay se insertan al excel
		if(encabezados.length!=0){	
			int aux=encabezados.length;
			filaExcel = hojaExcel.createRow(NumeroHoja);
			HSSFCell cellEn = filaExcel.createCell((short)0);
			cellEn.setCellValue((String)encabezados[0]);
			cellEn.setCellStyle(encabezadoStyle);
			hojaExcel.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            0, //primera fila (0-based)
		            0, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            columnas.length-2  //ultima celda   (0-based)
		    ));
			
			cellEn=filaExcel.createCell((short)columnas.length-1);
			cellEn.setCellStyle(estiloNeg12);
			cellEn.setCellValue("Usuario: "+ auditoria[0]);
			filaExcel = hojaExcel.createRow(1);
			cellEn=filaExcel.createCell((short)columnas.length-1);
			cellEn.setCellStyle(estiloNeg12);
			cellEn.setCellValue("Fecha: "+ auditoria[1]);
			
		
			
			NumeroHoja=NumeroHoja+2;			
			
			for(int i=1;i<encabezados.length;i++){
				filaExcel = hojaExcel.createRow(NumeroHoja);			
				HSSFCell cellEn2 = filaExcel.createCell((short)0);
				cellEn2.setCellValue((String)encabezados[i]);
				cellEn2.setCellStyle(encabezadoStyle);
				hojaExcel.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
								aux, //primera fila (0-based)
								aux, //ultima fila  (0-based)
					            0, //primer celda (0-based)
					            columnas.length-2  //ultima celda   (0-based)
					    ));
				if (i == 1){
					cellEn=filaExcel.createCell((short)columnas.length-1);
					cellEn.setCellStyle(estiloNeg12);
					cellEn.setCellValue("Hora: "+ auditoria[2]);			
				}
				aux--;
				NumeroHoja++;			
			}
			NumeroHoja++;
		}
		
		filaExcel = hojaExcel.createRow(NumeroHoja);
		
		// Se construyen los Metodos Get con los que se obtendran los Valores de los Beans y se genera la fila con los titulos
		for (int i = 0; i < columnas.length; i++) {
			HSSFCell cell = filaExcel.createCell((short)i);
			cell.setCellValue((String)titulos[i]);
			cell.setCellStyle(tituloStyle);
			try {
				columnas[i]= columnas[i].substring(0, 1).toUpperCase() + columnas[i].substring(1, columnas[i].length()); 
				meth[i] =  claseBean.getMethod("get"+ columnas[i],null);
			} catch (SecurityException e) {
				e.printStackTrace();
			} catch (NoSuchMethodException e) {
				e.printStackTrace();
			}
			columnSize[i] = ((String)titulos[i]).length() + 5;
		}
		
		for (int i = 0; i < informacion.size(); i++) {
			beanGenerico = claseBean.newInstance();
			beanGenerico = informacion.get(i);

			if(contadorDeFilas == CantidadFilasPorHoja){				
				NumeroHoja = NumeroHoja + 1;
				hojaExcel = libro.createSheet(nombreHoja+"_"+ String.valueOf(NumeroHoja));
				filaExcel = hojaExcel.createRow(0);
				contadorDeFilas  = 1;
				
				for (int columna = 0; columna < columnas.length; columna++) {
					HSSFCell cell = filaExcel.createCell((short)i);
					cell.setCellValue((String)titulos[i]);
					cell.setCellStyle(tituloStyle);					
				}
				
			}
			
			NumeroHoja++;
			filaExcel = hojaExcel.createRow(NumeroHoja);
			contadorDeFilas = contadorDeFilas +1;
								
			for (int j=0;j < meth.length; ++j){
				Object obj = meth[j].invoke(beanGenerico,null);
				HSSFCell cell  = filaExcel.createCell((short)j);
				Class returnType = meth[j].getReturnType();
				
				if( obj != null){
					if(returnType == java.util.Date.class){
						cell.setCellValue((Date)obj);
						cell.setCellStyle(dateStyle);
					}else if(returnType == int.class){
						int value = Integer.parseInt(obj.toString());						
						cell.setCellValue(value);
					}else if(returnType == float.class || returnType == double.class){					
						double value =Double.parseDouble(obj.toString());						
						cell.setCellValue(value);						
						cell.setCellStyle(estiloFormatoDecimal);						
					}else{
						String value = obj.toString();
						if(value.length() > columnSize[j]) columnSize[j] = value.length();
						cell.setCellValue(value);
						cell.setCellType(HSSFCell.CELL_TYPE_STRING);
					}
				}
				else cell.setCellValue("");
			}
		}
		
		int registros = informacion.size();
		
		filaExcel=hojaExcel.createRow(NumeroHoja+2); // Fila Registros Exportados
		HSSFCell celda  = filaExcel.createCell((short)0);
		celda = filaExcel.createCell((short)0);
		celda.setCellValue("Registros Exportados");
		celda.setCellStyle(estiloNeg8);
		
		celda=filaExcel.createCell((short)columnas.length-2);
		celda.setCellValue("Procedure: ");
		celda.setCellStyle(estiloNeg8);
		
		celda=filaExcel.createCell((short)columnas.length-1);
		celda.setCellValue(auditoria[3]);
		
		filaExcel=hojaExcel.createRow(NumeroHoja+3); // Fila Registros Exportados
		celda=filaExcel.createCell((short)0);
		celda.setCellValue(registros);
		
		for(int i=0; i<columnSize.length; ++i){
			int size = columnSize[i] > 255 ? 255 : columnSize[i];
			hojaExcel.setColumnWidth((short)i,(short)(size * 256));
		}	
		return hojaExcel;
	}
}
