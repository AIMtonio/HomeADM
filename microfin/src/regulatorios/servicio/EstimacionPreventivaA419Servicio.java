package regulatorios.servicio;

import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Arrays;
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

import regulatorios.bean.EstimacionPreventivaA419Bean;
import regulatorios.dao.EstimacionPreventivaA419DAO;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;

public class EstimacionPreventivaA419Servicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	ParametrosSesionBean parametrosSesionBean;
	EstimacionPreventivaA419DAO estimacionPreventivaA419DAO = null;

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
	 * Regulatorio de Estimación Preventiva A-419 
	 * @param tipoLista
	 * @param b0419Bean
	 * @param response
	 * @return
	 */
	public List<EstimacionPreventivaA419Bean> consultaRegulatorioA0419(int tipoLista,int tipoEntidad, EstimacionPreventivaA419Bean a0419Bean,HttpServletResponse response) {
		List<EstimacionPreventivaA419Bean> listaRegulatorio = null;
		
		/*
		 * SOCAPS
		 */
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			switch(tipoLista){
				case Enum_Reporte_EstPrevA419.estPrevA419Excel:
					listaRegulatorio = reporteRegulatorioA0419XLSXSOCAP(Enum_Lis_TipoReporte.excel,a0419Bean,response);
					break;
				case Enum_Reporte_EstPrevA419.estPrevA419Csv:
					listaRegulatorio = generaRegulatorioEstPrevA419CSV(a0419Bean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		
		}
		
		/*
		 * SOFIPOS
		 */
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch(tipoLista){
				case Enum_Reporte_EstPrevA419.estPrevA419Excel:
					listaRegulatorio = reporteRegulatorioA0419XLSXSOFIPO(Enum_Lis_TipoReporte.excel,a0419Bean,response);
					break;
				case Enum_Reporte_EstPrevA419.estPrevA419Csv:
					listaRegulatorio = generaRegulatorioEstPrevA419CSV(a0419Bean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
		

		return listaRegulatorio;
	}
	
	
	private List<EstimacionPreventivaA419Bean> reporteRegulatorioA0419XLSXSOFIPO(
			int tipoLista, EstimacionPreventivaA419Bean a0419Bean,
			HttpServletResponse response) {
		List<EstimacionPreventivaA419Bean> listaA0419Bean = null;
		String mesEnLetras	 = "";
		String anio			 = "";
		String nombreArchivo = "";
		
		
		
		mesEnLetras = descripcionMes(a0419Bean.getFecha().substring(5,7));
		anio	= a0419Bean.getFecha().substring(0,4);
		
		nombreArchivo = "R04_A_0419_"+mesEnLetras +"_"+anio; 
		
		
		/*Se hace la llamada para obtener la lista para llenar el reporte*/
		listaA0419Bean = estimacionPreventivaA419DAO.consultaRegulatorioA0419Sofipo(a0419Bean,tipoLista); 	
		
		if(listaA0419Bean != null){
	
			try {
				XSSFWorkbook libro = new XSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				XSSFFont fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
				fuenteNegrita10.setFontName("Arial");
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				XSSFFont fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)10);
				fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
				fuenteNegrita8.setFontName("Arial");
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				XSSFFont fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)10);
				fuente8.setFontName("Arial");
				
				//Estilo negrita de 8  para encabezados del reporte
				XSSFCellStyle estiloNegro = libro.createCellStyle();
				estiloNegro.setBorderTop((short)XSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderBottom((short)XSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderRight((short)XSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderLeft((short)XSSFCellStyle.BORDER_THIN);
				estiloNegro.setBottomBorderColor(HSSFColor.GREY_25_PERCENT.index);
				estiloNegro.setFont(fuenteNegrita8);
				
				//Estilo de 8  para Contenido
				XSSFCellStyle estiloNormal = libro.createCellStyle();
				XSSFDataFormat format = libro.createDataFormat();
				estiloNormal.setFont(fuente8);
				estiloNormal.setBorderTop((short)XSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderBottom((short)XSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderRight((short)XSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderLeft((short)XSSFCellStyle.BORDER_THIN);
				estiloNormal.setBottomBorderColor(HSSFColor.GREY_25_PERCENT.index);
				estiloNormal.setDataFormat(format.getFormat("#,##0.00"));
	
				//Estilo negrita tamaño 8 centrado
				XSSFCellStyle estiloEncabezadoArribaIzq = libro.createCellStyle();
				estiloEncabezadoArribaIzq.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
				estiloEncabezadoArribaIzq.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezadoArribaIzq.setFont(fuenteNegrita8);
				
				XSSFCellStyle estiloEncabezadoArribaDer = libro.createCellStyle();
				estiloEncabezadoArribaDer.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
				estiloEncabezadoArribaDer.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezadoArribaDer.setFont(fuenteNegrita10);
				
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
	
				//Estilo para una celda con dato con color de fondo gris
				XSSFCellStyle celdaGrisDato = libro.createCellStyle();
				XSSFDataFormat formato3 = libro.createDataFormat();
				celdaGrisDato.setFont(fuenteNegrita8);
				celdaGrisDato.setDataFormat(formato3.getFormat("#,##0.00"));
				celdaGrisDato.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				celdaGrisDato.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
				celdaGrisDato.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				celdaGrisDato.setBorderTop((short)XSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderBottom((short)XSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderRight((short)XSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderLeft((short)XSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setWrapText(true);
				
				// Creacion de hoja
				XSSFSheet hoja = libro.createSheet("Est Prev R 04 A 0419");
				
				
				XSSFRow fila= hoja.createRow(0);
				fila = hoja.createRow(0);

				//Encabezados
				XSSFRow filaTitulo= hoja.createRow(0);
				XSSFCell celda=filaTitulo.createCell((short)0);
				
				fila = hoja.createRow(1);
				celda = fila.createCell((short)0);
				celda.setCellValue("Sociedades Financieras Populares");
				celda.setCellStyle(estiloEncabezadoArribaDer);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            1  //ultima celda   (0-based)   
			    ));
				
				fila = hoja.createRow(2);
	
				celda = fila.createCell((short)0);
				celda.setCellValue("Serie R04 Cartera de crédito");
				celda.setCellStyle(estiloEncabezadoArribaDer);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            1  //ultima celda   (0-based)   
			    ));
				
				fila = hoja.createRow(3);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("Reporte A-0419 Movimientos en la estimación preventiva para riesgos crediticios");
				celda.setCellStyle(estiloEncabezadoArribaDer);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            3, //primera fila (0-based)
			            3, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            1  //ultima celda   (0-based)   
			    ));
				
				
				fila = hoja.createRow(4);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("Incluye cifras en moneda nacional, moneda extranjera y UDIS valorizadas en pesos");
				celda.setCellStyle(estiloEncabezadoArribaIzq);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            4, //primera fila (0-based)
			            4, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            1  //ultima celda   (0-based)   
			    ));
				
				fila = hoja.createRow(5);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("Cifras en pesos");
				celda.setCellStyle(estiloEncabezadoArribaIzq);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            5, //primera fila (0-based)
			            5, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            1  //ultima celda   (0-based)   
			    ));
				
				fila = hoja.createRow(7);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("Concepto");
				celda.setCellStyle(celdaGrisDato);
				
				hoja.addMergedRegion(new CellRangeAddress(
			            7, //primera fila (0-based)
			            8, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            0  //ultima celda   (0-based)   
			    ));
				
				celda = fila.createCell((short)1);
				celda.setCellValue("Total (moneda nacional y UDIS valorizadas en pesos)");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            6, //primera fila (0-based)
			            6, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            1  //ultima celda   (0-based)   
			    ));
				
				fila = hoja.createRow(8);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("Importe");
				celda.setCellStyle(estiloEncabezado);
				celda.setCellStyle(celdaGrisDato);
				
				hoja.addMergedRegion(new CellRangeAddress(
			            8, //primera fila (0-based)
			            8, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            1  //ultima celda   (0-based)   
			    ));
				
			
				int i=9;		
				for(EstimacionPreventivaA419Bean regA0419Bean : listaA0419Bean ){
		
					fila=hoja.createRow(i);

					/* Columna 1 "Concepto" */
					
					celda=fila.createCell((short)0);
					celda.setCellValue(regA0419Bean.getDescripcion());
					
					
					if(esResaltado(i)){
						celda.setCellStyle(estiloNegro);
					}else{
						celda.setCellStyle(estiloNormal);
					}
					
					
					
					celda=fila.createCell((short)1);
					celda.setCellValue(Utileria.convierteDoble(regA0419Bean.getMonto()));
					celda.setCellStyle(estiloNormal);
					

					
					
									
					i++;
				}
							
				
				hoja.autoSizeColumn(0);
				hoja.setColumnWidth((short)1, 5000);

				
										
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
			
			}catch(Exception e){
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte regulatorio sofipo A0419 Excel: " + e.getMessage());				
				e.printStackTrace();
			}//Fin del catch
		}
		return listaA0419Bean;
	}

	
	private boolean esResaltado(int pos){
		int celdasNegrita[]  = {10,105,11,112,113,130,138,145,146,163,171,178,179,196,204,211,212,213,
                				214,231,239,246,247,248,265,273,280,281,29,298,306,313,314,37,44,45,46,
                				63,71,78,79,80,9,97}; 
		
		for(int aux=0; aux < celdasNegrita.length ; aux++ ){
			if(pos == celdasNegrita[aux]){
				return true;
			}
		}
		
		return false;
	}

	private List<EstimacionPreventivaA419Bean> reporteRegulatorioA0419XLSXSOCAP(
			int tipoLista, EstimacionPreventivaA419Bean a0419Bean,
			HttpServletResponse response) {
		List<EstimacionPreventivaA419Bean> listaA0419Bean = null;
		String mesEnLetras	 = "";
		String anio			 = "";
		String nombreArchivo = "";
		
		
		mesEnLetras = descripcionMes(a0419Bean.getFecha().substring(5,7));
		anio	= a0419Bean.getFecha().substring(0,4);
		
		nombreArchivo = "R04_A_0419_"+mesEnLetras +"_"+anio; 
		
		/*Se hace la llamada para obtener la lista para llenar el reporte*/
		listaA0419Bean = estimacionPreventivaA419DAO.consultaRegulatorioA0419Socap(a0419Bean,tipoLista); 	
		
		if(listaA0419Bean != null){
	
			try {
				XSSFWorkbook libro = new XSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				XSSFFont fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
				fuenteNegrita10.setFontName("Arial");
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				XSSFFont fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)10);
				fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
				fuenteNegrita8.setFontName("Arial");
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				XSSFFont fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)10);
				fuente8.setFontName("Arial");
				
				//Estilo negrita de 8  para encabezados del reporte
				XSSFCellStyle estiloNegro = libro.createCellStyle();
				estiloNegro.setBorderTop((short)XSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderBottom((short)XSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderRight((short)XSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderLeft((short)XSSFCellStyle.BORDER_THIN);
				estiloNegro.setFont(fuenteNegrita8);
				
				//Estilo de 8  para Contenido
				XSSFCellStyle estiloNormal = libro.createCellStyle();
				XSSFDataFormat format = libro.createDataFormat();
				estiloNormal.setFont(fuente8);
				estiloNormal.setBorderTop((short)XSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderBottom((short)XSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderRight((short)XSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderLeft((short)XSSFCellStyle.BORDER_THIN);
				estiloNormal.setDataFormat(format.getFormat("#,##0.00"));
	
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
	
				//Estilo para una celda con dato con color de fondo gris
				XSSFCellStyle celdaGrisDato = libro.createCellStyle();
				XSSFDataFormat formato3 = libro.createDataFormat();
				celdaGrisDato.setFont(fuenteNegrita8);
				celdaGrisDato.setDataFormat(formato3.getFormat("#,##0.00"));
				celdaGrisDato.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				celdaGrisDato.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
				celdaGrisDato.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				celdaGrisDato.setBorderTop((short)XSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderBottom((short)XSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderRight((short)XSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderLeft((short)XSSFCellStyle.BORDER_THIN);

				
				// Creacion de hoja
				XSSFSheet hoja = libro.createSheet("Est Prev R 04 A 0419");
				
				
				XSSFRow fila= hoja.createRow(0);
				fila = hoja.createRow(0);

				//Encabezados
				XSSFRow filaTitulo= hoja.createRow(0);
				XSSFCell celda=filaTitulo.createCell((short)0);
				
				fila = hoja.createRow(1);
	
				celda = fila.createCell((short)0);
				celda.setCellValue("Serie R04 Cartera de crédito");
				celda.setCellStyle(estiloEncabezadoArriba);
				//celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            3  //ultima celda   (0-based)   
			    ));
				
				fila = hoja.createRow(2);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("Reporte A-0419 Movimientos en la estimación preventiva para riesgos crediticios");
				celda.setCellStyle(estiloEncabezadoArriba);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            3  //ultima celda   (0-based)   
			    ));
				
				
				fila = hoja.createRow(3);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("Incluye cifras en moneda nacional y UDIS valorizadas en pesos");
				celda.setCellStyle(estiloEncabezadoArriba);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            3, //primera fila (0-based)
			            3, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            3  //ultima celda   (0-based)   
			    ));
				
				fila = hoja.createRow(4);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("Cifras en pesos");
				celda.setCellStyle(estiloEncabezadoArriba);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            4, //primera fila (0-based)
			            4, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            3  //ultima celda   (0-based)   
			    ));
				
				fila = hoja.createRow(5);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("Concepto");
				celda.setCellStyle(estiloEncabezado);
				celda.setCellStyle(celdaGrisDato);
				
				
				celda = fila.createCell((short)1);
				celda.setCellValue("Total (moneda nacional y UDIS valorizadas en pesos)");
				celda.setCellStyle(estiloEncabezado);
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            5, //primera fila (0-based)
			            5, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            3  //ultima celda   (0-based)   
			    ));
				
				

				fila = hoja.createRow(6);				
				celda = fila.createCell((short)0);
				celda.setCellStyle(estiloEncabezado);
				celda.setCellStyle(celdaGrisDato);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("Cargos");
				celda.setCellStyle(estiloEncabezado);
				celda.setCellStyle(celdaGrisDato);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("Abonos");
				celda.setCellStyle(estiloEncabezado);
				celda.setCellStyle(celdaGrisDato);

				celda = fila.createCell((short)3);
				celda.setCellValue("Saldo");
				celda.setCellStyle(estiloEncabezado);
				celda.setCellStyle(celdaGrisDato);

				
				//fila = hoja.createRow(3);
				
				int i=8;		
				for(EstimacionPreventivaA419Bean regA0419Bean : listaA0419Bean ){
		
					fila=hoja.createRow(i);

					/* Columna 1 "Concepto" */
					celda=fila.createCell((short)0);
					celda.setCellValue(regA0419Bean.getDescripcion());
					celda.setCellStyle(estiloNormal);
					
					
					
					celda=fila.createCell((short)1);
					celda.setCellStyle(estiloNormal);
					celda=fila.createCell((short)2);
					celda.setCellStyle(estiloNormal);
					celda=fila.createCell((short)3);
					
					celda.setCellStyle(estiloNormal);
					if(regA0419Bean.getTipoSaldo().equals("9") ){
						celda=fila.createCell((short)1);
						celda.setCellValue(Utileria.convierteDoble(regA0419Bean.getMonto()));
						celda.setCellStyle(estiloNormal);
					}else{
						celda=fila.createCell((short)2);
						celda.setCellStyle(estiloNormal);
						if(regA0419Bean.getTipoSaldo().equals("10") ){
							celda.setCellValue(Utileria.convierteDoble(regA0419Bean.getMonto()));
							celda.setCellStyle(estiloNormal);
						}else{
							celda=fila.createCell((short)3);
							celda.setCellStyle(estiloNormal);
							if(regA0419Bean.getTipoSaldo().equals("11") ){
								celda.setCellValue(Utileria.convierteDoble(regA0419Bean.getMonto()));
								celda.setCellStyle(estiloNormal);
							}
						}
					}
									
					i++;
				}
							
				
				hoja.autoSizeColumn(0);
				hoja.autoSizeColumn(1);
				hoja.autoSizeColumn(2);
				hoja.autoSizeColumn(3);
				hoja.autoSizeColumn(4);
				hoja.autoSizeColumn(5);
				hoja.autoSizeColumn(6);
				hoja.autoSizeColumn(7);

				
										
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
			
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte regulatorio socap A0411 Excel: " + e.getMessage());
			}//Fin del catch
		}
		return listaA0419Bean;
	}


	/**
	 * Reporte de Regulatorio de Estimación Preventiva A-419  en formato cvs
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @return
	 */
	private List generaRegulatorioEstPrevA419CSV(EstimacionPreventivaA419Bean reporteBean, int tipoReporte,HttpServletResponse response) {
		String mesEnLetras = "";
		String anio = "";
		String  nombreArchivo = "";
		List listaBeans = estimacionPreventivaA419DAO.reporteRegulatorio0419(reporteBean, tipoReporte);

		mesEnLetras = descripcionMes(reporteBean.getFecha().substring(5, 7));
		anio = reporteBean.getFecha().substring(0, 4);
		nombreArchivo = "R04_A_0419_" + mesEnLetras + "_" + anio + ".csv";

		try {
			EstimacionPreventivaA419Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(
					nombreArchivo));
			if (!listaBeans.isEmpty()) {
				for (int i = 0; i < listaBeans.size(); i++) {
					bean = (EstimacionPreventivaA419Bean) listaBeans.get(i);
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
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte regulatorio A0411 CSV: " + io.getMessage());
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


	public EstimacionPreventivaA419DAO getEstimacionPreventivaA419DAO() {
		return estimacionPreventivaA419DAO;
	}


	public void setEstimacionPreventivaA419DAO(
			EstimacionPreventivaA419DAO estimacionPreventivaA419DAO) {
		this.estimacionPreventivaA419DAO = estimacionPreventivaA419DAO;
	}
	
}
