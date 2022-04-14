package regulatorios.servicio;

import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;


import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import regulatorios.bean.CalificacionYEstimacionB0417Bean;
import regulatorios.bean.DesagregadoCarteraC0451Bean;
import regulatorios.dao.CalificacionYEstimacionB0417DAO;
import regulatorios.servicio.RegulatorioD2442Servicio.Enum_Lis_RegulatorioD2442;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;


public class CalificacionYEstimacionB0417Servicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	ParametrosSesionBean parametrosSesionBean;
	CalificacionYEstimacionB0417DAO calificacionYEstimacionB0417DAO = null;

	//-------------------------------------------------------------------------------------------------
	// -------------------- TRANSACCIONES (CONSULTAS, LISTADOS, REPORTES)
	//-------------------------------------------------------------------------------------------------	
	
	public static interface Enum_Reporte_Desagregado{
		int desagregadoExcel = 1;
		int desagregadoCsv = 2;
	}
	
	public static interface Enum_Reporte_CalificaEstima{
		int calificaEstimaExcel = 1;
		int calificaEstimaCsv = 2;
	}
	
	public static interface Enum_Reporte_EstPrevA419{
		int estPrevA419Excel = 1;
		int estPrevA419Csv = 2;
	}

	/**
	 * Regulatorio de Calificacion de Cartera y Estimaciones Preventivas B0417 
	 * @param tipoLista
	 * @param b0417Bean
	 * @param response
	 * @return
	 */
	public List<CalificacionYEstimacionB0417Bean> consultaRegulatorioB0417(int tipoLista, CalificacionYEstimacionB0417Bean b0417Bean,HttpServletResponse response) {
		List<CalificacionYEstimacionB0417Bean> listaRegulatorio = null;
		switch (tipoLista) {
			case Enum_Reporte_CalificaEstima.calificaEstimaExcel :
				listaRegulatorio = calificacionYEstimacionB0417DAO
						.consultaRegulatorioB0417(b0417Bean, tipoLista);
				break;
			case Enum_Reporte_CalificaEstima.calificaEstimaCsv :
				listaRegulatorio = generaRegulatorioCalifEstimaCSV(b0417Bean,
						tipoLista, response);
				break;
		}
		return listaRegulatorio;
	}
	
	/**
	 * Regulatorio de Calificacion de Cartera y Estimaciones Preventivas B0417 Consultas para generacion
	 * de reportes version 2015
	 * @param tipoLista
	 * @param b0417Bean
	 * @param response
	 * @return
	 */
	public List<CalificacionYEstimacionB0417Bean> consultaRegulatorioB0417Version2015(int tipoLista, int tipoEntidad, CalificacionYEstimacionB0417Bean b0417Bean,HttpServletResponse response) {
		List<CalificacionYEstimacionB0417Bean> listaRegulatorio = null;
		
		
		
		/*SOCAP*/
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			switch(tipoLista){
				case Enum_Reporte_CalificaEstima.calificaEstimaExcel:
					listaRegulatorio = reporteRegulatorioB0417XLSX_SOCAP(Enum_Lis_TipoReporte.excel, b0417Bean, response); 
					break;
				case  Enum_Reporte_CalificaEstima.calificaEstimaCsv:
					listaRegulatorio = generarReporteRegulatorioB0417(b0417Bean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
		/*SOFIPO*/
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch(tipoLista){
				case Enum_Reporte_CalificaEstima.calificaEstimaExcel:
					listaRegulatorio = reporteRegulatorioB0417XLSX_SOFIPO(Enum_Lis_TipoReporte.excel, b0417Bean, response); 
					break;
				case Enum_Reporte_CalificaEstima.calificaEstimaCsv:
					listaRegulatorio = generarReporteRegulatorioB0417(b0417Bean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
		
		
	
		
		return listaRegulatorio;
	}
	


	private List<CalificacionYEstimacionB0417Bean> reporteRegulatorioB0417XLSX_SOFIPO(
			int tipoLista, CalificacionYEstimacionB0417Bean b0417Bean,
			HttpServletResponse response) {
		List<CalificacionYEstimacionB0417Bean> listaC0451Bean = null;
		String mesEnLetras	= "";
		String anio		= "";
		String nombreArchivo = "";

		mesEnLetras = descripcionMes(b0417Bean.getFecha().substring(5,7));
		anio	= b0417Bean.getFecha().substring(0,4);
		nombreArchivo = "R04_B_0417_"+mesEnLetras +"_"+anio; 
		
		/*Se hace la llamada para obtener la lista para llenar el reporte*/
		listaC0451Bean = calificacionYEstimacionB0417DAO.consultaRegulatorioB0417Sofipo(b0417Bean,tipoLista);
		int contador = 1;
		
		if(listaC0451Bean != null){
			try {
				//////////////////////////////////////////////////////////////////////////////////////
				////////////////////// ENCABEZADO y CONFIGURACION DEL  EXCEL /////////////////////////////////////////
				XSSFWorkbook libro = new XSSFWorkbook();
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				XSSFFont fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)10);
				fuenteNegrita8.setFontName("Arial");
				fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
				
				XSSFFont fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setFontName("Arial");
				fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
						
				//Estilo Formato decimal (0.00)
				XSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
				XSSFDataFormat format = libro.createDataFormat();
				estiloFormatoDecimal.setDataFormat(format.getFormat("#,##0"));
				estiloFormatoDecimal.setBorderTop((short)XSSFCellStyle.BORDER_THIN);
				estiloFormatoDecimal.setBorderBottom((short)XSSFCellStyle.BORDER_THIN);
				estiloFormatoDecimal.setBorderRight((short)XSSFCellStyle.BORDER_THIN);
				estiloFormatoDecimal.setBorderLeft((short)XSSFCellStyle.BORDER_THIN);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				XSSFFont fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)10);
				fuente8.setFontName("Arial");
				
				//Estilo formato vacio monto
				XSSFCellStyle estiloFormatoVacioMonto = libro.createCellStyle();
				estiloFormatoVacioMonto.setFont(fuente8);
				estiloFormatoVacioMonto.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloFormatoVacioMonto.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				
				//Estilo de 8  para Contenido
				XSSFCellStyle estilo8 = libro.createCellStyle();
				estilo8.setFont(fuente8);
				estilo8.setBorderTop((short)XSSFCellStyle.BORDER_THIN);
				estilo8.setBorderBottom((short)XSSFCellStyle.BORDER_THIN);
				estilo8.setBorderRight((short)XSSFCellStyle.BORDER_THIN);
				estilo8.setBorderLeft((short)XSSFCellStyle.BORDER_THIN);
				
				XSSFCellStyle estilo8Center = libro.createCellStyle();
				estilo8Center.setFont(fuente8);
				estilo8Center.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estilo8Center.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				
				//Estilo Formato Tasa (0.0000)
				XSSFCellStyle estiloFormatoTasa = libro.createCellStyle();
				format = libro.createDataFormat();
				estiloFormatoTasa.setDataFormat(format.getFormat("0.0000"));
				estiloFormatoTasa.setFont(fuente8);
				
				//Encabezado agrupaciones
				XSSFCellStyle estiloAgrupacion = libro.createCellStyle();
				estiloAgrupacion.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloAgrupacion.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloAgrupacion.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setFont(fuenteNegrita8);
				estiloAgrupacion.setWrapText(true);
				estiloAgrupacion.setFillBackgroundColor(HSSFColor.GREY_25_PERCENT.index);
				estiloAgrupacion.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
				
				//Estilo negrita tamaño 8 centrado
				XSSFCellStyle estiloEncabezadoArribaDer = libro.createCellStyle();
				estiloEncabezadoArribaDer.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
				estiloEncabezadoArribaDer.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezadoArribaDer.setFont(fuenteNegrita8);
				
				XSSFCellStyle estiloEncabezadoArribaIzq = libro.createCellStyle();
				estiloEncabezadoArribaIzq.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
				estiloEncabezadoArribaIzq.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezadoArribaIzq.setFont(fuenteNegrita10);
				
				//Estilo negrita tamaño 8 centrado
				XSSFCellStyle estiloEncabezado = libro.createCellStyle();
				estiloEncabezado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloEncabezado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezado.setBorderTop((short)XSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderBottom((short)XSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderRight((short)XSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderLeft((short)XSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setFont(fuenteNegrita8);
				estiloEncabezado.setWrapText(true);
			
				
				// Creacion de hoja
				XSSFSheet hoja = libro.createSheet("R04 A 0417");
				XSSFRow fila = hoja.createRow(0);
				fila = hoja.createRow(0);				
				XSSFCell celda=fila.createCell((short)1);
									
					//Titulos del Reporte
					fila = hoja.createRow(0);
					celda=fila.createCell((short)0);
					celda.setCellValue("Sociedades Financieras Populares ");
					celda.setCellStyle(estiloEncabezadoArribaDer);
					hoja.addMergedRegion(new CellRangeAddress(
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            2  //ultima celda   (0-based)   
				    ));
					
					fila = hoja.createRow(2);
					celda=fila.createCell((short)0);
					celda.setCellValue("Serie R04 Cartera de crédito");
					celda.setCellStyle(estiloEncabezadoArribaDer);
					hoja.addMergedRegion(new CellRangeAddress(
				            1, //primera fila (0-based)
				            1, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            2  //ultima celda   (0-based)   
				    ));
					fila = hoja.createRow(3);
					celda=fila.createCell((short)0);
					celda.setCellValue("Reporte A-0417 Calificación de la cartera de crédito y estimación preventiva para riesgos crediticios");
					celda.setCellStyle(estiloEncabezadoArribaDer);
					hoja.addMergedRegion(new CellRangeAddress(
				            2, //primera fila (0-based)
				            2, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            2  //ultima celda   (0-based)   
				    ));
					fila = hoja.createRow(4);
					celda=fila.createCell((short)0);
					celda.setCellValue("Incluye cifras en moneda nacional y UDIS valorizadas en pesos");
					celda.setCellStyle(estiloEncabezadoArribaIzq);
					hoja.addMergedRegion(new CellRangeAddress(
				            3, //primera fila (0-based)
				            3, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            2  //ultima celda   (0-based)   
				    ));
					
					
					fila = hoja.createRow(5);
					celda=fila.createCell((short)0);
					celda.setCellValue("Cifras en pesos");
					celda.setCellStyle(estiloEncabezadoArribaIzq);
					hoja.addMergedRegion(new CellRangeAddress(
				            4, //primera fila (0-based)
				            4, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            2  //ultima celda   (0-based)   
				    ));
				
					
					//Titulos del Reporte
					fila = hoja.createRow(7);
					celda=fila.createCell((short)0);
					celda.setCellValue("Concepto");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)1);
					celda.setCellValue("Cartera base de calificación mes actual");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)2);
					celda.setCellValue("Estimación preventiva para riesgos crediticios");
					celda.setCellStyle(estiloEncabezado);

					int rowExcel=8;
					contador=8;
					for(CalificacionYEstimacionB0417Bean regC0451Bean : listaC0451Bean ){
			
						fila=hoja.createRow(rowExcel);
						fila = hoja.createRow(contador);

						celda=fila.createCell((short)0);
						celda.setCellValue(regC0451Bean.getDescripcion());
						celda.setCellStyle(estilo8);

					celda = fila.createCell((short) 1);
					if (regC0451Bean.getMontoCartera().isEmpty() || Utileria.convierteDoble(regC0451Bean.getMontoCartera()) ==0 ) {
						celda.setCellValue(0.00);
						celda.setCellStyle(estiloFormatoDecimal);
					} else {
						celda.setCellValue(Utileria.convierteDoble(regC0451Bean.getMontoCartera()));
						celda.setCellStyle(estiloFormatoDecimal);
					}
					
					celda = fila.createCell((short) 2);
					if (regC0451Bean.getMontoEPRC().isEmpty() || Utileria.convierteDoble(regC0451Bean.getMontoEPRC()) ==0 ) {
						celda.setCellValue(0.00);
						celda.setCellStyle(estiloFormatoDecimal);
					} else {
						celda.setCellValue(Utileria.convierteDoble(regC0451Bean.getMontoEPRC()));
						celda.setCellStyle(estiloFormatoDecimal);
						
					}

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

					
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
			
			}catch(Exception e){
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte regulatorio A0417 Excel: " + e.getMessage());
				e.printStackTrace();
			}//Fin del catch
		}
		return listaC0451Bean;
	}

	private List<CalificacionYEstimacionB0417Bean> reporteRegulatorioB0417XLSX_SOCAP(
			int tipoLista, CalificacionYEstimacionB0417Bean b0417Bean,
			HttpServletResponse response) {
		List<CalificacionYEstimacionB0417Bean> listaC0451Bean = null;
		String mesEnLetras	= "";
		String anio			= "";
		String nombreArchivo = "";

		mesEnLetras = descripcionMes(b0417Bean.getFecha().substring(5,7));
		anio	= b0417Bean.getFecha().substring(0,4);
		nombreArchivo = "R04_B_0417_"+mesEnLetras +"_"+anio; 
		
		/*Se hace la llamada para obtener la lista para llenar el reporte*/
		listaC0451Bean = calificacionYEstimacionB0417DAO.consultaRegulatorioB0417Socap(b0417Bean,tipoLista);
		int contador = 1;
		
		if(listaC0451Bean != null){
			try {
				//////////////////////////////////////////////////////////////////////////////////////
				////////////////////// ENCABEZADO y CONFIGURACION DEL  EXCEL /////////////////////////////////////////
				XSSFWorkbook libro = new XSSFWorkbook();
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				XSSFFont fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)10);
				fuenteNegrita8.setFontName("Arial");
				fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
				
				//Estilo Formato decimal (0.00)
				XSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
				XSSFDataFormat format = libro.createDataFormat();
				estiloFormatoDecimal.setDataFormat(format.getFormat("#,##0"));
				estiloFormatoDecimal.setBorderTop((short)XSSFCellStyle.BORDER_THIN);
				estiloFormatoDecimal.setBorderBottom((short)XSSFCellStyle.BORDER_THIN);
				estiloFormatoDecimal.setBorderRight((short)XSSFCellStyle.BORDER_THIN);
				estiloFormatoDecimal.setBorderLeft((short)XSSFCellStyle.BORDER_THIN);
			
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				XSSFFont fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)10);
				fuente8.setFontName("Arial");
				
				//Estilo formato vacio monto
				XSSFCellStyle estiloFormatoVacioMonto = libro.createCellStyle();
				estiloFormatoVacioMonto.setFont(fuente8);
				estiloFormatoVacioMonto.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloFormatoVacioMonto.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				
				//Estilo de 8  para Contenido
				XSSFCellStyle estilo8 = libro.createCellStyle();
				estilo8.setFont(fuente8);
				estilo8.setBorderTop((short)XSSFCellStyle.BORDER_THIN);
				estilo8.setBorderBottom((short)XSSFCellStyle.BORDER_THIN);
				estilo8.setBorderRight((short)XSSFCellStyle.BORDER_THIN);
				estilo8.setBorderLeft((short)XSSFCellStyle.BORDER_THIN);
				
				
				XSSFCellStyle estilo8Center = libro.createCellStyle();
				estilo8Center.setFont(fuente8);
				estilo8Center.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estilo8Center.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				
				//Estilo Formato Tasa (0.0000)
				XSSFCellStyle estiloFormatoTasa = libro.createCellStyle();
				format = libro.createDataFormat();
				estiloFormatoTasa.setDataFormat(format.getFormat("0.0000"));
				estiloFormatoTasa.setFont(fuente8);
				
				//Encabezado agrupaciones
				XSSFCellStyle estiloAgrupacion = libro.createCellStyle();
				estiloAgrupacion.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloAgrupacion.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloAgrupacion.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setFont(fuenteNegrita8);
				estiloAgrupacion.setWrapText(true);
				estiloAgrupacion.setFillBackgroundColor(HSSFColor.GREY_25_PERCENT.index);
				estiloAgrupacion.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
				
				//Estilo negrita tamaño 8 centrado
				XSSFCellStyle estiloEncabezadoArriba = libro.createCellStyle();
				estiloEncabezadoArriba.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloEncabezadoArriba.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezadoArriba.setFont(fuenteNegrita8);
				
				//Estilo negrita tamaño 8 centrado
				XSSFCellStyle estiloEncabezado = libro.createCellStyle();
				estiloEncabezado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloEncabezado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezado.setBorderTop((short)XSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderBottom((short)XSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderRight((short)XSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderLeft((short)XSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setFont(fuenteNegrita8);
				estiloEncabezado.setWrapText(true);
			
				
				// Creacion de hoja
				XSSFSheet hoja = libro.createSheet("R04 B 0417");
				XSSFRow fila = hoja.createRow(0);
				fila = hoja.createRow(0);				
				XSSFCell celda=fila.createCell((short)1);
				
				/////////////////////////////////////////////////////////////////////////////////////
					
					//Titulos del Reporte
					fila = hoja.createRow(0);
					celda=fila.createCell((short)0);
					celda.setCellValue("Sociedades cooperativas de ahorro y préstamo");
					celda.setCellStyle(estiloEncabezadoArriba);
					hoja.addMergedRegion(new CellRangeAddress(
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            2  //ultima celda   (0-based)   
				    ));
					
					fila = hoja.createRow(1);
					celda=fila.createCell((short)0);
					celda.setCellValue("Serie R04 Cartera de crédito");
					celda.setCellStyle(estiloEncabezadoArriba);
					hoja.addMergedRegion(new CellRangeAddress(
				            1, //primera fila (0-based)
				            1, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            2  //ultima celda   (0-based)   
				    ));
					fila = hoja.createRow(2);
					celda=fila.createCell((short)0);
					celda.setCellValue("Reporte A-0417 Calificación de la cartera de crédito y estimación preventiva para riesgos crediticios");
					celda.setCellStyle(estiloEncabezadoArriba);
					hoja.addMergedRegion(new CellRangeAddress(
				            2, //primera fila (0-based)
				            2, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            2  //ultima celda   (0-based)   
				    ));
					fila = hoja.createRow(3);
					celda=fila.createCell((short)0);
					celda.setCellValue("Incluye cifras en moneda nacional y UDIS valorizadas en pesos");
					celda.setCellStyle(estiloEncabezadoArriba);
					hoja.addMergedRegion(new CellRangeAddress(
				            3, //primera fila (0-based)
				            3, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            2  //ultima celda   (0-based)   
				    ));
					
					
					fila = hoja.createRow(4);
					celda=fila.createCell((short)0);
					celda.setCellValue("Cifras en pesos");
					celda.setCellStyle(estiloEncabezadoArriba);
					hoja.addMergedRegion(new CellRangeAddress(
				            4, //primera fila (0-based)
				            4, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            2  //ultima celda   (0-based)   
				    ));
				
					
					//Titulos del Reporte
					fila = hoja.createRow(5);
					celda=fila.createCell((short)0);
					celda.setCellValue("Concepto");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)1);
					celda.setCellValue("Cartera base de calificación mes actual");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)2);
					celda.setCellValue("Estimación preventiva para riesgos crediticios");
					celda.setCellStyle(estiloEncabezado);

					int rowExcel=6;
					contador=6;
					for(CalificacionYEstimacionB0417Bean regC0451Bean : listaC0451Bean ){
			
						fila=hoja.createRow(rowExcel);
						fila = hoja.createRow(contador);

						celda=fila.createCell((short)0);
						celda.setCellValue(regC0451Bean.getDescripcion());
						celda.setCellStyle(estilo8);

					celda = fila.createCell((short) 1);
					if (regC0451Bean.getMontoCartera().isEmpty() || Utileria.convierteDoble(regC0451Bean.getMontoCartera()) ==0 ) {
						celda.setCellValue(0.00);
						celda.setCellStyle(estiloFormatoDecimal);
					} else {
						celda.setCellValue(Utileria.convierteDoble(regC0451Bean.getMontoCartera()));
						celda.setCellStyle(estiloFormatoDecimal);
					}
					
					celda = fila.createCell((short) 2);
					if (regC0451Bean.getMontoEPRC().isEmpty() || Utileria.convierteDoble(regC0451Bean.getMontoEPRC()) ==0 ) {
						celda.setCellValue(0.00);
						celda.setCellStyle(estiloFormatoDecimal);
					} else {
						celda.setCellValue(Utileria.convierteDoble(regC0451Bean.getMontoEPRC()));
						celda.setCellStyle(estiloFormatoDecimal);
						
					}

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

					
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
			
			}catch(Exception e){
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte regulatorio A0417 Excel: " + e.getMessage());
				e.printStackTrace();
			}//Fin del catch
		}
		return listaC0451Bean;
	}

	/**
	 * Reporte de Regulatorio de Calificacion de Cartera y Estimaciones Preventivas B0417 en CSV 
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @return
	 */
	private List generaRegulatorioCalifEstimaCSV(CalificacionYEstimacionB0417Bean reporteBean, int tipoReporte,HttpServletResponse response) {
		String mesEnLetras = "";
		String anio = "";
		String nombreArchivo = "";
		List listaBeans = calificacionYEstimacionB0417DAO.reporteRegulatorio0417Csv(
				reporteBean, tipoReporte);

		mesEnLetras = descripcionMes(reporteBean.getFecha().substring(5, 7));
		anio = reporteBean.getFecha().substring(0, 4);
		nombreArchivo = "R04_B_0417_" + mesEnLetras + "_" + anio + ".csv";

		// se inicia seccion para pintar el archivo csv
		try {
			CalificacionYEstimacionB0417Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(
					nombreArchivo));
			if (!listaBeans.isEmpty()) {
				for (int i = 0; i < listaBeans.size(); i++) {
					bean = (CalificacionYEstimacionB0417Bean) listaBeans.get(i);
					writer.write(bean.getValor());
					writer.write("\r\n"); // Esto es un salto de linea
				}
			} else {
				writer.write("");
			}
			writer.close();

			FileInputStream archivo = new FileInputStream(nombreArchivo);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition", "attachment;filename="
					+ nombreArchivo);
			response.setContentType("application/text");
			ServletOutputStream outputStream = response.getOutputStream();
			outputStream.write(datos);
			outputStream.flush();
			outputStream.close();

		} catch (IOException io) {
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte regulatorio A0417 CSV: " + io.getMessage());
			io.printStackTrace();
		}
		return listaBeans;
	}
	
	/**
	 * Reporte de Regulatorio de Calificacion de Cartera y Estimaciones Preventivas B0417 en formato cvs
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @return
	 */
	private List generarReporteRegulatorioB0417(CalificacionYEstimacionB0417Bean reporteBean, int tipoReporte,HttpServletResponse response) {
		String mesEnLetras = "";
		String anio = "";
		String  nombreArchivo = "";
		List listaBeans = calificacionYEstimacionB0417DAO.reporteRegulatorio0417CSVVersion2015(reporteBean, tipoReporte);

		mesEnLetras = descripcionMes(reporteBean.getFecha().substring(5, 7));
		anio = reporteBean.getFecha().substring(0, 4);
		nombreArchivo = "R04_B_0417_" + mesEnLetras + "_" + anio + ".csv";

		try {
			CalificacionYEstimacionB0417Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(
					nombreArchivo));
			if (!listaBeans.isEmpty()) {
				for (int i = 0; i < listaBeans.size(); i++) {
					bean = (CalificacionYEstimacionB0417Bean) listaBeans.get(i);
					writer.write(bean.getValor());
					writer.write("\r\n"); // Esto es un salto de linea
				}
			} else {
				writer.write("");
			}
			writer.close();

			FileInputStream archivo = new FileInputStream(nombreArchivo);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition", "attachment;filename="
					+ nombreArchivo);
			response.setContentType("application/text");
			ServletOutputStream outputStream = response.getOutputStream();
			outputStream.write(datos);
			outputStream.flush();
			outputStream.close();

		} catch (Exception io) {
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte regulatorio A0417 CSV: " + io.getMessage());
			io.printStackTrace();
		}
		return listaBeans;
	}
	

	
	public String descripcionMes(String meses) {
		String mes = "";
		int mese = Integer.parseInt(meses);
		switch (mese) {
			case 1 :
				mes = "ENERO";
				break;
			case 2 :
				mes = "FEBRERO";
				break;
			case 3 :
				mes = "MARZO";
				break;
			case 4 :
				mes = "ABRIL";
				break;
			case 5 :
				mes = "MAYO";
				break;
			case 6 :
				mes = "JUNIO";
				break;
			case 7 :
				mes = "JULIO";
				break;
			case 8 :
				mes = "AGOSTO";
				break;
			case 9 :
				mes = "SEPTIEMBRE";
				break;
			case 10 :
				mes = "OCTUBRE";
				break;
			case 11 :
				mes = "NOVIEMBRE";
				break;
			case 12 :
				mes = "DICIEMBRE";
				break;
		}
		return mes;
	}

	
	//-------------------------------------------------------------------------------------------------
	// -------------------- SETTERS Y GETTERS	-------------------------------------------------------
	//-------------------------------------------------------------------------------------------------
	
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public CalificacionYEstimacionB0417DAO getCalificacionYEstimacionB0417DAO() {
		return calificacionYEstimacionB0417DAO;
	}

	public void setCalificacionYEstimacionB0417DAO(
			CalificacionYEstimacionB0417DAO calificacionYEstimacionB0417DAO) {
		this.calificacionYEstimacionB0417DAO = calificacionYEstimacionB0417DAO;
	}
	
	
}
