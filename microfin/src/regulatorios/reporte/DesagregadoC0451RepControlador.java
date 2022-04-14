package regulatorios.reporte;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.DesagregadoCarteraC0451Bean;
import regulatorios.servicio.DesagregadoCarteraC0451Servicio;

public class DesagregadoC0451RepControlador extends AbstractCommandController  {

	public static interface Enum_Con_TipReporte {
		  int  ReporPantalla= 1;
		  int  ReporPDF= 2;
		  int  ReporExcel= 3;
		  int  ReporCsv= 4;
	}
	
	DesagregadoCarteraC0451Servicio desagregadoCarteraC0451Servicio = null;
	String successView = null;
	
	public DesagregadoC0451RepControlador () {
		setCommandClass(DesagregadoCarteraC0451Bean.class);
		setCommandName("C0451");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response,
								  Object command, BindException errors)throws Exception {
		
		MensajeTransaccionBean mensaje = null;
		DesagregadoCarteraC0451Bean c0451Bean = (DesagregadoCarteraC0451Bean) command;

		int tipoReporte =(request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")): 0;
		int tipoLista =(request.getParameter("tipoLista")!=null)?Integer.parseInt(request.getParameter("tipoLista")):0;
		int version=(request.getParameter("version")!=null)?Integer.parseInt(request.getParameter("version")):2014;		
		
		switch(tipoReporte){	
			case Enum_Con_TipReporte.ReporExcel:
				switch(version){
				case 2014:
					List<DesagregadoCarteraC0451Bean>listaReportes = reporteB0451Excel(tipoLista,c0451Bean,response);
					break;
				case 2015:
					List<DesagregadoCarteraC0451Bean> listaReportes2015 = reporteC0451Version2015Excel(tipoLista,c0451Bean,response);
					break;
				}
				 
					break;
			case Enum_Con_TipReporte.ReporCsv:		
				switch (version){
				case 2014:
					desagregadoCarteraC0451Servicio.consultaRegulatorioC0451(tipoLista,c0451Bean,response);
					break;
				case 2015:
					desagregadoCarteraC0451Servicio.consultaRegulatorioC0451Version2015(tipoLista,c0451Bean,response);
					break;
				}
			break;
			}
		return null;	
		}

	// Reporte de Desagregado de Cartera a Excel
	@SuppressWarnings("deprecation")
	public List<DesagregadoCarteraC0451Bean>reporteB0451Excel(int tipoLista,DesagregadoCarteraC0451Bean c0451Bean,  HttpServletResponse response){
			List<DesagregadoCarteraC0451Bean> listaC0451Bean = null;
			String mesEnLetras	= "";
			String anio		= "";
			String nombreArchivo = "";
			
			mesEnLetras = desagregadoCarteraC0451Servicio.descripcionMes(c0451Bean.getFecha().substring(5,7));
			anio	= c0451Bean.getFecha().substring(0,4);
			
			nombreArchivo = "R04_C_451_"+mesEnLetras +"_"+anio; 
			
			/*Se hace la llamada para obtener la lista para llenar el reporte*/
			listaC0451Bean = desagregadoCarteraC0451Servicio.consultaRegulatorioC0451(tipoLista,c0451Bean,response);
			int contador = 1;
			
			if(listaC0451Bean != null){
		
				try {
					HSSFWorkbook libro = new HSSFWorkbook();
					
					//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
					HSSFFont fuenteNegrita8= libro.createFont();
					fuenteNegrita8.setFontHeightInPoints((short)8);
					fuenteNegrita8.setFontName("Negrita");
					fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				
					//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
					HSSFFont fuente8= libro.createFont();
					fuente8.setFontHeightInPoints((short)8);
					
					//Estilo de 8  para Contenido
					HSSFCellStyle estilo8 = libro.createCellStyle();
					estilo8.setFont(fuente8);
					
					
					//Estilo Formato Tasa (0.0000)
					HSSFCellStyle estiloFormatoTasa = libro.createCellStyle();
					HSSFDataFormat format = libro.createDataFormat();
					estiloFormatoTasa.setDataFormat(format.getFormat("0.0000"));
					estiloFormatoTasa.setFont(fuente8);
					
					//Estilo negrita tamaño 8 centrado
					HSSFCellStyle estiloEncabezado = libro.createCellStyle();
					estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
					estiloEncabezado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
					estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_MEDIUM);
					estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
					estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
					estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
					estiloEncabezado.setFont(fuenteNegrita8);
					
					// Creacion de hoja
					HSSFSheet hoja = libro.createSheet("R04 C 451");
					HSSFRow fila = hoja.createRow(0);
					fila = hoja.createRow(0);				
					HSSFCell celda=fila.createCell((short)1);

					//Titulos del Reporte
					fila = hoja.createRow(0);
					celda=fila.createCell((short)0);
					celda.setCellValue("Número de \nSecuencia");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)1);
					celda.setCellValue("Nombre / Razón Social");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)2);
					celda.setCellValue("Número del \nDeudor");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)3);
					celda.setCellValue("Número del \nCrédito");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)4);
					celda.setCellValue("Persona");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)5);
					celda.setCellValue("RFC");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)6);
					celda.setCellValue("Clasificación \nContable");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)7);
					celda.setCellValue("Monto del Crédito \nOtorgado");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)8);
					celda.setCellValue("Responsabilidad Total \na la Fecha");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)9);
					celda.setCellValue("Fecha de \nDisposición");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)10);
					celda.setCellValue("Fecha de \nVencimiento");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)11);
					celda.setCellValue("Forma de \nAmortización");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)12);
					celda.setCellValue("Formula");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)13);
					celda.setCellValue("Tasa de Interés \nBruta");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)14);
					celda.setCellValue("Intereses \nDevengados \nNo Cobrados");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)15);
					celda.setCellValue("Intereses \nVencidos");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)16);
					celda.setCellValue("Intereses \nRefinanciados \no Capitalizados");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)17);
					celda.setCellValue("Situación \ndel Crédito");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)18);  
					celda.setCellValue("Número de \nReestructuras \no Renovaciones");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)19);   
					celda.setCellValue("Calificación por \nOperación Metodología \nCNBV (Parte Cubierta)");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)20);  
					celda.setCellValue("Calificación por \nOperación Metodología \nCNBV (Parte Expuesta)");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)21);  
					celda.setCellValue("Estimaciones \nPreventivas \n(Parte Cubierta)");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)22);  
					celda.setCellValue("Estimaciones \nPreventivas \n(Parte Expuesta)");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)23);  
					celda.setCellValue("Estimaciones \nPreventivas\nTotales2");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)24);  
					celda.setCellValue("Porcentaje que \nGarantiza el Aval");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)25);  
					celda.setCellValue(" Valor de la \nGarantía");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)26);  
					celda.setCellValue("Fecha de Valuación \nde la Garantía");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)27);   
					celda.setCellValue("Grado de Prelación \nde la Garantía");
					celda.setCellStyle(estiloEncabezado);
	 
					celda=fila.createCell((short)28);   
					celda.setCellValue("Acreditado \nRelacionado");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)29);  
					celda.setCellValue("Tipo de Acreditado \nRelacionado");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)30);
					celda.setCellValue("Número de\nDías de Mora");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)31);
					celda.setCellValue("Reciprocidad");
					celda.setCellStyle(estiloEncabezado);

					int i=1;
					for(DesagregadoCarteraC0451Bean regC0451Bean : listaC0451Bean ){
			
						fila=hoja.createRow(i);
						celda=fila.createCell((short)0);
						celda.setCellValue(contador);
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)1);
						celda.setCellValue(regC0451Bean.getNombreCompleto());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)2);
						celda.setCellValue(regC0451Bean.getNumeroCliente());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)3);
						celda.setCellValue(regC0451Bean.getNumeroCredito());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)4);
						celda.setCellValue(Integer.parseInt(regC0451Bean.getTipoPersona()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)5);
						celda.setCellValue(regC0451Bean.getRfc());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)6);
						celda.setCellValue(regC0451Bean.getClasifContable());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)7);
						celda.setCellValue(Long.parseLong(Utileria.eliminaDecimales(regC0451Bean.getMontoOtorgado())));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)8);
						celda.setCellValue(Long.parseLong(Utileria.eliminaDecimales(regC0451Bean.getSaldoTotal())));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)9);
						celda.setCellValue(regC0451Bean.getFechaDisposicion());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)10);
						celda.setCellValue(regC0451Bean.getFechaVencimiento());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)11);
						celda.setCellValue(Integer.parseInt(Utileria.eliminaDecimales(regC0451Bean.getFormaAmortizacion())));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)12);
						celda.setCellValue(regC0451Bean.getFormula());										
						celda.setCellStyle(estiloFormatoTasa);

						celda=fila.createCell((short)13);
						celda.setCellValue(Double.parseDouble(regC0451Bean.getTasaInteres()));										
						celda.setCellStyle(estiloFormatoTasa);
						
						celda=fila.createCell((short)14);
						celda.setCellValue(Long.parseLong(Utileria.eliminaDecimales(regC0451Bean.getInteresNoCobrado())));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)15);
						celda.setCellValue(Long.parseLong(Utileria.eliminaDecimales(regC0451Bean.getInteresVencido())));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)16);
						celda.setCellValue(Long.parseLong(Utileria.eliminaDecimales(regC0451Bean.getInteresCapitalizado())));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)17);
						celda.setCellValue(Integer.parseInt(Utileria.eliminaDecimales(regC0451Bean.getSituacionCredito())));
						celda.setCellStyle(estilo8);	
						
						celda=fila.createCell((short)18);
						celda.setCellValue(Integer.parseInt(Utileria.eliminaDecimales(regC0451Bean.getNumeroReestructuras())));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)19);
						celda.setCellValue(regC0451Bean.getCalifCubierta());
						celda.setCellStyle(estilo8);	
						
						celda=fila.createCell((short)20);
						celda.setCellValue(regC0451Bean.getCalifExpuesta());
						celda.setCellStyle(estilo8);	

						celda=fila.createCell((short)21);
						celda.setCellValue(Long.parseLong(Utileria.eliminaDecimales(regC0451Bean.getEstimacionCubierta())));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)22);
						celda.setCellValue(Long.parseLong(Utileria.eliminaDecimales(regC0451Bean.getEstimacionExpuesta())));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)23);
						celda.setCellValue(Long.parseLong(Utileria.eliminaDecimales(regC0451Bean.getEstimacionTotal())));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)24);
						celda.setCellValue(Long.parseLong(Utileria.eliminaDecimales(regC0451Bean.getPorcentajeGarAval())));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)25);
						celda.setCellValue(Long.parseLong(Utileria.eliminaDecimales(regC0451Bean.getValorGarantia())));
						celda.setCellStyle(estilo8);
											
						celda=fila.createCell((short)26);
						celda.setCellValue(regC0451Bean.getFechaValuaGarantia());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)27);
						celda.setCellValue(Long.parseLong(Utileria.eliminaDecimales(regC0451Bean.getPrelacionGarantia())));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)28);
						celda.setCellValue(Long.parseLong(Utileria.eliminaDecimales(regC0451Bean.getClienteRelacionado())));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)29);
						celda.setCellValue(Long.parseLong(Utileria.eliminaDecimales(regC0451Bean.getClaveRelacionado())));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)30);
						celda.setCellValue(Long.parseLong(Utileria.eliminaDecimales(regC0451Bean.getDiasAtraso())));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)31);
						celda.setCellValue(Long.parseLong(Utileria.eliminaDecimales(regC0451Bean.getReciprocidad())));
						celda.setCellStyle(estilo8);
						
						i++;
						contador++;
					}
					
					
					hoja.autoSizeColumn((short)0);
					hoja.autoSizeColumn((short)1);
					hoja.autoSizeColumn((short)2);
					hoja.autoSizeColumn((short)3);
					hoja.autoSizeColumn((short)4);
					hoja.autoSizeColumn((short)5);
					hoja.autoSizeColumn((short)6);
					hoja.autoSizeColumn((short)7);
					hoja.autoSizeColumn((short)8);
					hoja.autoSizeColumn((short)9);
					hoja.autoSizeColumn((short)10);
					
					hoja.autoSizeColumn((short)11);
					hoja.autoSizeColumn((short)12);
					hoja.autoSizeColumn((short)13);
					hoja.autoSizeColumn((short)14);
					hoja.autoSizeColumn((short)15);
					hoja.autoSizeColumn((short)16);
					hoja.autoSizeColumn((short)17);
					hoja.autoSizeColumn((short)18);
					hoja.autoSizeColumn((short)19);
					hoja.autoSizeColumn((short)20);
					
					hoja.autoSizeColumn((short)21);
					hoja.autoSizeColumn((short)22);
					hoja.autoSizeColumn((short)23);
					hoja.autoSizeColumn((short)24);
					hoja.autoSizeColumn((short)25);
					hoja.autoSizeColumn((short)26);
					hoja.autoSizeColumn((short)27);
					hoja.autoSizeColumn((short)28);
					hoja.autoSizeColumn((short)29);
					hoja.autoSizeColumn((short)30);
					hoja.autoSizeColumn((short)31);
					
											
					//Creo la cabecera
					response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xls");
					response.setContentType("application/vnd.ms-excel");
					
					ServletOutputStream outputStream = response.getOutputStream();
					hoja.getWorkbook().write(outputStream);
					outputStream.flush();
					outputStream.close();
				
				}catch(Exception e){
					e.printStackTrace();
				}//Fin del catch
			}
			return listaC0451Bean;
		}

	/**
	 * Generacion de reporte C0451 en Excel version 2015
	 * @param tipoLista
	 * @param version
	 * @param c0451Bean
	 * @param response
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public List<DesagregadoCarteraC0451Bean>reporteC0451Version2015Excel(int tipoLista, DesagregadoCarteraC0451Bean c0451Bean,  HttpServletResponse response){
		List<DesagregadoCarteraC0451Bean> listaC0451Bean = null;
		String mesEnLetras	= "";
		String anio		= "";
		String nombreArchivo = "";

		mesEnLetras = desagregadoCarteraC0451Servicio.descripcionMes(c0451Bean.getFecha().substring(5,7));
		anio	= c0451Bean.getFecha().substring(0,4);
		nombreArchivo = "R04_C_451_"+mesEnLetras +"_"+anio; 
		
		/*Se hace la llamada para obtener la lista para llenar el reporte*/
		listaC0451Bean = desagregadoCarteraC0451Servicio.consultaRegulatorioC0451Version2015(tipoLista,c0451Bean,response);
		int contador = 1;
		
		if(listaC0451Bean != null){
			try {
				//////////////////////////////////////////////////////////////////////////////////////
				////////////////////// ENCABEZADO y CONFIGURACION DEL  EXCEL /////////////////////////////////////////
				HSSFWorkbook libro = new HSSFWorkbook();
				HSSFFont fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setFontName("Negrita");
				fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);

				HSSFFont fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)8);
				
				HSSFCellStyle estilo8 = libro.createCellStyle();
				estilo8.setFont(fuente8);
				
				HSSFCellStyle estiloFormatoTasa = libro.createCellStyle();
				HSSFDataFormat format = libro.createDataFormat();
				estiloFormatoTasa.setDataFormat(format.getFormat("0.0000"));
				estiloFormatoTasa.setFont(fuente8);
				
				//Encabezado agrupaciones
				HSSFCellStyle estiloAgrupacion = libro.createCellStyle();
				estiloAgrupacion.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				estiloAgrupacion.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
				estiloAgrupacion.setBorderTop((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setFont(fuenteNegrita8);
				estiloAgrupacion.setWrapText(true);
				estiloAgrupacion.setFillBackgroundColor(HSSFColor.GREY_25_PERCENT.index);
				estiloAgrupacion.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				
				//Estilo negrita tamaño 8 centrado
				HSSFCellStyle estiloEncabezado = libro.createCellStyle();
				estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				estiloEncabezado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setFont(fuenteNegrita8);
				estiloEncabezado.setWrapText(true);
			
				
				// Creacion de hoja
				HSSFSheet hoja = libro.createSheet("R04 C 451");
				HSSFRow fila = hoja.createRow(0);
				fila = hoja.createRow(0);				
				HSSFCell celda=fila.createCell((short)1);
				/////////////////////////////////////////////////////////////////////////////////////
				///////////////////////// FIN ENCABEZADO EXCEL //////////////////////////////////////
				
					//AGREGAR GRUPOS DE COLUMNAS
					//////////////////////////////////////////////////////////////////////////////
					fila = hoja.createRow(0);
					celda=fila.createCell((short)0);
					celda.setCellValue("SECCIÓN IDENTIFICADOR DEL REPORTE");
					celda.setCellStyle(estiloAgrupacion);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            2  //ultima celda   (0-based)
				    ));
					
					celda=fila.createCell((short)3);
					celda.setCellValue("SECCIÓN UBICACIÓN DEL CRÉDITO");
					celda.setCellStyle(estiloAgrupacion);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            3, //primer celda (0-based)
				            4 //ultima celda   (0-based)
				    ));
					
					celda=fila.createCell((short)5);
					celda.setCellValue("SECCIÓN IDENTIFICADOR DEL ACREDITADO");
					celda.setCellStyle(estiloAgrupacion);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            5, //primer celda (0-based)
				            12  //ultima celda   (0-based)
				    ));
					
					celda=fila.createCell((short)13);
					celda.setCellValue("SECCIÓN IDENTIFICADOR DEL CRÉDITO");
					celda.setCellStyle(estiloAgrupacion);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            13, //primer celda (0-based)
				            52  //ultima celda   (0-based)
				    ));
					
					celda=fila.createCell((short)53);
					celda.setCellValue("SECCIÓN IDENTIFICACIÓN DE LAS GARANTÍAS");
					celda.setCellStyle(estiloAgrupacion);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            53, //primer celda (0-based)
				            54  //ultima celda   (0-based)
				    ));
					
					////////////////////////////////////////////////////////////////////////////////
					
					//Titulos del Reporte
					fila = hoja.createRow(1);
					fila.setHeight((short)800);
					celda=fila.createCell((short)0);
					celda.setCellValue("PERÍODO QUE SE REPORTA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)1);
					celda.setCellValue("CLAVE DE LA ENTIDAD");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)2);
					celda.setCellValue("SUBREPORTE");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)3);
					celda.setCellValue("MUNICIPIO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)4);
					celda.setCellValue("ESTADO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)5);
					celda.setCellValue("IDENTIFICADOR DEL ACREDITADO ASIGNADO POR LA SOCIEDAD");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)6);
					celda.setCellValue("PERSONALIDAD JURÍDICA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)7);
					celda.setCellValue("NOMBRE, RAZÓN O DENOMINACIÓN SOCIAL DEL SOCIO O SOCAP");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)8);
					celda.setCellValue("PRIMER APELLIDO DEL SOCIO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)9);
					celda.setCellValue("SEGUNDO APELLIDO DEL SOCIO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)10);
					celda.setCellValue("RFC DEL ACREDITADO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)11);
					celda.setCellValue("CURP EL ACREDITADO SI ES PERSONA FÍSICA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)12);
					celda.setCellValue("GÉNERO DEL SOCIO O CLIENTE");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)13);
					celda.setCellValue("IDENTIFICADOR DEL CRÉDITO ASIGNADO POR LA SOCIEDAD");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)14);
					celda.setCellValue("SUCURSAL QUE OPERA EL CRÉDITO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)15);
					celda.setCellValue("CLASIFICACIÓN DEL CRÉDITO POR DESTINO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)16);
					celda.setCellValue("PRODUCTO DE CRÉDITO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)17);
					celda.setCellValue("FECHA DE DISPOSICIÓN DEL CRÉDITO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)18);
					celda.setCellValue("FECHA DE VENCIMIENTO DEL CRÉDITO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)19);	
					celda.setCellValue("MODALIDAD DE PAGO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)20);
					celda.setCellValue("MONTO ORIGINAL");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)21);
					celda.setCellValue("FRECUENCIA DE PAGO DE CAPITAL");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)22);
					celda.setCellValue("FRECUENCIA DE PAGO DE INTERESES");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)23);
					celda.setCellValue("FORMULA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)24);
					celda.setCellValue("TASA DE INTERÉS ORDINARIA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)25);
					celda.setCellValue("FECHA DEL ÚLTIMO PAGO DE CAPITAL");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)26);
					celda.setCellValue("MONTO DEL ÚLTIMO PAGO DE CAPITAL");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)27);
					celda.setCellValue("FECHA DEL ÚLTIMO PAGO DE INTERESES");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)28);
					celda.setCellValue("MONTO DEL ÚLTIMO PAGO DE INTERESES");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)29);
					celda.setCellValue("FECHA DE LA PRIMERA AMORTIZACIÓN NO CUBIERTA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)30);	
					celda.setCellValue("MONTO DE LA CONDONACIÓN, QUITA, BONIFICACIÓN O DESCUENTO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)31);
					celda.setCellValue("FECHA DE LA CONDONACIÓN, QUITA, BONIFICACIÓN O DESCUENTO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)32);
					celda.setCellValue("DÍAS DE MORA (RETRASO)");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)33);
					celda.setCellValue("TIPO DE CRÉDITO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)34);
					celda.setCellValue("SITUACIÓN CONTABLE DEL CRÉDITO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)35);
					celda.setCellValue("CAPITAL");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)36);
					celda.setCellValue("INTERESES ORDINARIOS");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)37);
					celda.setCellValue("INTERESES MORATORIOS");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)38);
					celda.setCellValue("INTERESES ORDINARIOS VENCIDOS FUERA DE BALANCE");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)39);
					celda.setCellValue("INTERESES MORATORIOS FUERA DE BALANCE");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)40);
					celda.setCellValue("INTERESES REFINANCIADOS O INTERESES RECAPITALIZADOS");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)41);
					celda.setCellValue("SALDO INSOLUTO DEL CRÉDITO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)42);
					celda.setCellValue("TIPO DE ACREDITADO RELACIONADO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)43);
					celda.setCellValue("TIPO DE CARTERA PARA FINES DE CALIFICACIÓN");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)44);
					celda.setCellValue("CALIFICACIÓN DEL DEUDOR");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)45);
					celda.setCellValue("CALIFICACIÓN PARTE CUBIERTA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)46);
					celda.setCellValue("CALIFICACIÓN PARTE EXPUESTA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)47);
					celda.setCellValue("MONTO DE ESTIMACIONES PARTE CUBIERTA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)48);
					celda.setCellValue("MONTO DE ESTIMACIONES PARTE EXPUESTA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)49);
					celda.setCellValue("ESTIMACIONES PREVENTIVAS ADICIONALES DE INTERESES DEVENGADOS DE LA CARTERA VENCIDA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)50);
					celda.setCellValue("ESTIMACIONES PREVENTIVAS ADICIONALES POR RIESGOS OPERATIVOS (SIC)");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)51);
					celda.setCellValue("ESTIMACIONES PREVENTIVAS ADICIONALES ORDENADAS POR LA CNBV");
					celda.setCellStyle(estiloEncabezado);
					
					
					celda=fila.createCell((short)52);
					celda.setCellValue("FECHA DE LA CONSULTA A LA SIC");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)53);
					celda.setCellValue("CLAVE DE PREVENCIÓN");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)54);
					celda.setCellValue("GARANTÍA LÍQUIDA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)55);
					celda.setCellValue("GARANTÍA HIPOTECARIA");
					celda.setCellStyle(estiloEncabezado);


					int rowExcel=2;
					contador=2;
					for(DesagregadoCarteraC0451Bean regC0451Bean : listaC0451Bean ){
			
						fila=hoja.createRow(rowExcel);
						fila = hoja.createRow(contador);
						celda=fila.createCell((short)0);
						celda.setCellValue(regC0451Bean.getVar_Periodo());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)1);
						celda.setCellValue(regC0451Bean.getVar_ClaveEntidad());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)2);
						celda.setCellValue(regC0451Bean.getFor_0451());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)3);
						celda.setCellValue(regC0451Bean.getMunicipioClave());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)4);
						celda.setCellValue(regC0451Bean.getEstadoClave());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)5);
						celda.setCellValue(regC0451Bean.getClienteID());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)6);
						celda.setCellValue(regC0451Bean.getTipoPersona());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)7);
						celda.setCellValue(regC0451Bean.getDenominacion());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)8);
						celda.setCellValue(regC0451Bean.getApellidoPat());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)9);
						celda.setCellValue(regC0451Bean.getApellidoMat());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)10);
						celda.setCellValue(regC0451Bean.getRFC());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)11);
						celda.setCellValue(regC0451Bean.getCURP());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)12);
						celda.setCellValue(regC0451Bean.getGenero());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)13);
						celda.setCellValue(regC0451Bean.getCreditoID());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)14);
						celda.setCellValue(regC0451Bean.getClaveSucursal());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)15);
						celda.setCellValue(regC0451Bean.getClasifConta());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)16);
						celda.setCellValue(regC0451Bean.getProductoCredito());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)17);
						celda.setCellValue(regC0451Bean.getFechaDisp());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)18);
						celda.setCellValue(regC0451Bean.getFechaVencim());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)19);	
						celda.setCellValue(regC0451Bean.getTipoAmorti());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)20);
						celda.setCellValue(regC0451Bean.getMontoCredito());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)21);
						celda.setCellValue(regC0451Bean.getPeriodicidadCap());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)22);
						celda.setCellValue(regC0451Bean.getPeriodicidadInt());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)23);
						celda.setCellValue(regC0451Bean.getFormula());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)24);
						celda.setCellValue(regC0451Bean.getTasaInteres());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)25);
						celda.setCellValue(regC0451Bean.getFecUltPagoCap());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)26);
						celda.setCellValue(regC0451Bean.getMonUltPagoCap());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)27);
						celda.setCellValue(regC0451Bean.getFecUltPagoInt());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)28);
						celda.setCellValue(regC0451Bean.getMonUltPagoInt());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)29);
						celda.setCellValue(regC0451Bean.getFecPrimAtraso());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)30);	
						celda.setCellValue(regC0451Bean.getMontoCondona());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)31);
						celda.setCellValue(regC0451Bean.getFecUltCondona());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)32);
						celda.setCellValue(regC0451Bean.getNumDiasAtraso());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)33);
						celda.setCellValue(regC0451Bean.getTipoCredito());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)34);
						celda.setCellValue(regC0451Bean.getSituacContable());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)35);
						celda.setCellValue(regC0451Bean.getSalCapital());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)36);
						celda.setCellValue(regC0451Bean.getSalIntOrdin());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)37);
						celda.setCellValue(regC0451Bean.getSalIntMora());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)38);
						celda.setCellValue(regC0451Bean.getSalIntCtaOrden());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)39);
						celda.setCellValue(regC0451Bean.getSalMoraCtaOrden());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)40);
						celda.setCellValue(regC0451Bean.getIntereRefinan());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)41);
						celda.setCellValue(regC0451Bean.getSaldoInsoluto());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)42);
						celda.setCellValue(regC0451Bean.getTipoRelacion());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)43);
						celda.setCellValue(regC0451Bean.getTipCarCalifi());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)44);
						celda.setCellValue(regC0451Bean.getCalifiIndiv());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)45);
						celda.setCellValue(regC0451Bean.getCalifCubierta());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)46);
						celda.setCellValue(regC0451Bean.getCalifExpuesta());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)47);
						celda.setCellValue(regC0451Bean.getReservaCubierta());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)48);
						celda.setCellValue(regC0451Bean.getReservaExpuesta());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)49);
						celda.setCellValue(regC0451Bean.getEPRCAdiCarVen());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)50);
						celda.setCellValue(regC0451Bean.getEPRCAdiSIC());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)51);
						celda.setCellValue(regC0451Bean.getEPRCAdiCNVB());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)52);
						celda.setCellValue(regC0451Bean.getFecConsultaSIC());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)53);
						celda.setCellValue(regC0451Bean.getClaveSIC());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)54);
						celda.setCellValue(regC0451Bean.getTotGtiaLiquida());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)55);
						celda.setCellValue(regC0451Bean.getGtiaHipotecaria());
						celda.setCellStyle(estilo8);
						
						rowExcel++;
						contador++;
					}

				hoja.autoSizeColumn((short)0);
				hoja.autoSizeColumn((short)1);
				hoja.autoSizeColumn((short)2);
				hoja.autoSizeColumn((short)3);
				hoja.autoSizeColumn((short)4);
				hoja.autoSizeColumn((short)5);
				hoja.autoSizeColumn((short)6);
				hoja.autoSizeColumn((short)7);
				hoja.autoSizeColumn((short)8);
				hoja.autoSizeColumn((short)9);
				hoja.autoSizeColumn((short)10);
				
				hoja.autoSizeColumn((short)11);
				hoja.autoSizeColumn((short)12);
				hoja.autoSizeColumn((short)13);
				hoja.autoSizeColumn((short)14);
				hoja.autoSizeColumn((short)15);
				hoja.autoSizeColumn((short)16);
				hoja.autoSizeColumn((short)17);
				hoja.autoSizeColumn((short)18);
				hoja.autoSizeColumn((short)19);
				hoja.autoSizeColumn((short)20);
				
				hoja.autoSizeColumn((short)21);
				hoja.autoSizeColumn((short)22);
				hoja.autoSizeColumn((short)23);
				hoja.autoSizeColumn((short)24);
				hoja.autoSizeColumn((short)25);
				hoja.autoSizeColumn((short)26);
				hoja.autoSizeColumn((short)27);
				hoja.autoSizeColumn((short)28);
				hoja.autoSizeColumn((short)29);
				hoja.autoSizeColumn((short)30);
				
				hoja.autoSizeColumn((short)31);
				hoja.autoSizeColumn((short)32);
				hoja.autoSizeColumn((short)33);
				hoja.autoSizeColumn((short)34);
				hoja.autoSizeColumn((short)35);
				hoja.autoSizeColumn((short)36);
				hoja.autoSizeColumn((short)37);
				hoja.autoSizeColumn((short)38);
				hoja.autoSizeColumn((short)39);
				hoja.autoSizeColumn((short)40);
				
				hoja.autoSizeColumn((short)41);
				hoja.autoSizeColumn((short)42);
				hoja.autoSizeColumn((short)43);
				hoja.autoSizeColumn((short)44);
				hoja.autoSizeColumn((short)45);
				hoja.autoSizeColumn((short)46);
				hoja.autoSizeColumn((short)47);
				hoja.autoSizeColumn((short)48);
				hoja.autoSizeColumn((short)49);
				hoja.autoSizeColumn((short)50);
				
				hoja.autoSizeColumn((short)51);
				hoja.autoSizeColumn((short)52);
				hoja.autoSizeColumn((short)53);
				
				
				
										
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
			
			}catch(Exception e){
				e.printStackTrace();
			}//Fin del catch
		}
		return listaC0451Bean;
	}

	// Setter y Getters
	
	
	public String getSuccessView() {
		return successView;
	}
	
	public DesagregadoCarteraC0451Servicio getDesagregadoCarteraC0451Servicio() {
		return desagregadoCarteraC0451Servicio;
	}

	public void setDesagregadoCarteraC0451Servicio(
			DesagregadoCarteraC0451Servicio desagregadoCarteraC0451Servicio) {
		this.desagregadoCarteraC0451Servicio = desagregadoCarteraC0451Servicio;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	
}
