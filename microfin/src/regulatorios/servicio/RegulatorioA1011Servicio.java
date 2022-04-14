package regulatorios.servicio;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;


import regulatorios.bean.RegulatorioA1011Bean;
import regulatorios.dao.RegulatorioA1011DAO;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;
import general.servicio.BaseServicio;
import herramientas.Constantes;

public class RegulatorioA1011Servicio extends BaseServicio{
	
	RegulatorioA1011DAO regulatorioA1011DAO = null;
	public static Double DOUBLE_VACIO = 0.00;
	
	public RegulatorioA1011Servicio() {
		super();
	}
	
	/* ============ case para listas de reportes regulatorios ===============*/
	public List <RegulatorioA1011Bean>listaReporteRegulatorioA1011(int tipoLista, int tipoEntidad, RegulatorioA1011Bean reporteBean, HttpServletResponse response) throws IOException{
		List<RegulatorioA1011Bean> listaReportes=null;
		
		/*SOFIPO*/
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch(tipoLista){
				case Enum_Lis_TipoReporte.excel:
					listaReportes = reporteRegulatorioA1011Excel(Enum_Lis_TipoReporte.excel, reporteBean, response); 
					break;
				case Enum_Lis_TipoReporte.csv:
					listaReportes = reporteRegulatorioA1011Csv(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
		return listaReportes;
	}
	
	/*===============  FUNCIONES PARA GENERAR REPORTES CSV  ========================================*/	
	private List reporteRegulatorioA1011Csv(RegulatorioA1011Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = regulatorioA1011DAO.reporteRegulatorioA1011Csv(reporteBean, tipoReporte);
		nombreArchivo="R10_A1011.csv"; 
		// se inicia seccion para pintar el archivo csv
		try{
			RegulatorioA1011Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioA1011Bean) listaBeans.get(i);
					writer.write(bean.getValor());        
					writer.write("\r\n"); // Esto es un salto de linea	
				}
			}else{
				writer.write("");
			}
			writer.close();

			FileInputStream archivo = new FileInputStream(nombreArchivo);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition","attachment;filename="+nombreArchivo);
			response.setContentType("application/text");
			ServletOutputStream outputStream = response.getOutputStream();
			outputStream.write(datos);
			outputStream.flush();
			outputStream.close();
			
		}catch(IOException io ){	
			io.printStackTrace();
		}
		return listaBeans;
	}
	
	/**
	 * Generacion del reporte para SOFIPO
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List<RegulatorioA1011Bean> reporteRegulatorioA1011Excel(int tipoLista,RegulatorioA1011Bean reporteBean,  HttpServletResponse response) throws IOException
	{
		List<RegulatorioA1011Bean> listaRegulatorioA1011Bean = null;
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		
		anio			= reporteBean.getAnio();
		mesEnLetras		= RegulatorioInsServicio.descripcionMes(reporteBean.getMes());
		nombreArchivo 	= "R10_A1011_"+mesEnLetras+"_"+anio; 
		
		listaRegulatorioA1011Bean = regulatorioA1011DAO.reporteRegulatorioA1011Excel(reporteBean,tipoLista);
		int contador = 1;
		
		if(listaRegulatorioA1011Bean != null){
			try {
				
				/* ENCABEZADO y CONFIGURACION DEL  EXCEL */
	
				Workbook libro = new SXSSFWorkbook();
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				
				Font fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setFontName("Negrita");
				fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				Font fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)8);
				
				//Estilo de 8  para Contenido
				CellStyle estilo8 = libro.createCellStyle();
				estilo8.setFont(fuente8);
				DataFormat format8 = libro.createDataFormat();
				estilo8.setDataFormat(format8.getFormat("0.00"));
				estilo8.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estilo8.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estilo8.setWrapText(true);
				
				CellStyle estiloUpper = libro.createCellStyle();
				estiloUpper.setFont(fuente8);
				DataFormat formatUpper = libro.createDataFormat();
				estiloUpper.setDataFormat(formatUpper.getFormat("0.00"));
				estiloUpper.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloUpper.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloUpper.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloUpper.setWrapText(true);
				
				CellStyle estiloBottom = libro.createCellStyle();
				estiloBottom.setFont(fuente8);
				DataFormat formatBottom = libro.createDataFormat();
				estiloBottom.setDataFormat(formatBottom.getFormat("0.00"));
				estiloBottom.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloBottom.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloBottom.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloBottom.setWrapText(true);
				
				//Estilo Formato Tasa (0.0000)
				CellStyle estiloFormatoTasa = libro.createCellStyle();
				DataFormat format = libro.createDataFormat();
				estiloFormatoTasa.setDataFormat(format.getFormat("0.0000"));
				estiloFormatoTasa.setFont(fuente8);
				
				//Encabezado agrupaciones
				
				CellStyle estiloDerecha = libro.createCellStyle();
				estiloDerecha.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
				estiloDerecha.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloDerecha.setFont(fuenteNegrita8);
				estiloDerecha.setWrapText(true);
				
				CellStyle estiloIzquierda = libro.createCellStyle();
				estiloIzquierda.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
				estiloIzquierda.setFont(fuenteNegrita8);
				estiloIzquierda.setWrapText(true);
				
				
				CellStyle estiloAgrupacion = libro.createCellStyle();
				estiloAgrupacion.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				estiloAgrupacion.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
				estiloAgrupacion.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloAgrupacion.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloAgrupacion.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setFont(fuenteNegrita8);
				estiloAgrupacion.setWrapText(true);

				//Estilo negrita tamaño 8 centrado
				CellStyle estiloEncabezado = libro.createCellStyle();
				estiloEncabezado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloEncabezado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezado.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setFont(fuenteNegrita8);
				estiloEncabezado.setWrapText(true);
			
				// Creacion de hoja
				SXSSFSheet hoja = null;
				hoja = (SXSSFSheet) libro.createSheet("REGULATORIO A-1011");
				
				Row fila = hoja.createRow(0);
				Cell celda=fila.createCell((short)1);
				/* FIN ENCABEZADO y CONFIGURACION DEL  EXCEL */

				
				/* AGREGAR GRUPOS DE COLUMNAS */
					fila = hoja.createRow(1);
					celda = fila.createCell((short)1);
					celda.setCellValue("Sociedades Financieras Populares.");
					celda.setCellStyle(estiloDerecha);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            1, //primera fila (0-based)
				            1, //ultima fila  (0-based)
				            1, //primer celda (0-based)
				            10  //ultima celda (0-based)
				    ));
					
					
					fila = hoja.createRow(2);
					celda = fila.createCell((short)1);
					celda.setCellValue("Serie R10 Reclasificaciones.");
					celda.setCellStyle(estiloDerecha);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            2, //primera fila (0-based)
				            2, //ultima fila  (0-based)
				            1, //primer celda (0-based)
				            10  //ultima celda (0-based)
				    ));
					
					fila = hoja.createRow(3);
					celda = fila.createCell((short)1);
					celda.setCellValue("Reporte A-1011 Reclasificaciones en el balance general.");
					celda.setCellStyle(estiloDerecha);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            3, //primera fila (0-based)
				            3, //ultima fila  (0-based)
				            1, //primer celda (0-based)
				            10  //ultima celda (0-based)
				    ));
					
					fila = hoja.createRow(4);
					celda = fila.createCell((short)1);
					celda.setCellValue("Incluye cifras en moneda nacional, moneda extranjera y UDIS valorizadas en pesos.");
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            4, //primera fila (0-based)
				            4, //ultima fila  (0-based)
				            1, //primer celda (0-based)
				            10  //ultima celda (0-based)
				    ));
					
					fila = hoja.createRow(5);
					celda = fila.createCell((short)1);
					celda.setCellValue("Cifras en pesos.");
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            5, //primera fila (0-based)
				            5, //ultima fila  (0-based)
				            1, //primer celda (0-based)
				            10  //ultima celda (0-based)
				    ));
					
					
								
					//Titulos del Reporte
					fila = hoja.createRow(7);
					celda=fila.createCell((short)1);
					celda.setCellValue("Concepto");
					celda.setCellStyle(estiloEncabezado);
					hoja.addMergedRegion(new CellRangeAddress(
				            7, //primera fila (0-based)
				            8, //ultima fila  (0-based)
				            1, //primer celda (0-based)
				            1  //ultima celda (0-based)
				    ));
					
					celda=fila.createCell((short)2);
					celda.setCellValue("Aplicables sólo a");
					celda.setCellStyle(estiloEncabezado);
					hoja.addMergedRegion(new CellRangeAddress(
				            7, //primera fila (0-based)
				            8, //ultima fila  (0-based)
				            2, //primer celda (0-based)
				            2  //ultima celda (0-based)
				    ));
					
					celda=fila.createCell((short)3);
					celda.setCellValue("Saldo catálogo mínimo\n\n(A)");
					celda.setCellStyle(estiloEncabezado);
					hoja.addMergedRegion(new CellRangeAddress(
				            7, //primera fila (0-based)
				            8, //ultima fila  (0-based)
				            3, //primer celda (0-based)
				            3  //ultima celda (0-based)
				    ));
					
					celda=fila.createCell((short)4);
					celda.setCellValue("Movimientos por presentación conforme a criterios contables\n\n(1)");
					celda.setCellStyle(estiloEncabezado);
					hoja.addMergedRegion(new CellRangeAddress(
				            7, //primera fila (0-based)
				            7, //ultima fila  (0-based)
				            4, //primer celda (0-based)
				            5  //ultima celda (0-based)
				    ));
					
					celda=fila.createCell((short)6);
					celda.setCellValue("Compensaciones conforme a criterios contables\n\n(2)");
					celda.setCellStyle(estiloEncabezado);
					hoja.addMergedRegion(new CellRangeAddress(
				            7, //primera fila (0-based)
				            7, //ultima fila  (0-based)
				            6, //primer celda (0-based)
				            7  //ultima celda (0-based)
				    ));
					
					celda=fila.createCell((short)8);
					celda.setCellValue("Estado financiero sin consolidar");
					celda.setCellStyle(estiloEncabezado);
					hoja.addMergedRegion(new CellRangeAddress(
				            7, //primera fila (0-based)
				            7, //ultima fila  (0-based)
				            8, //primer celda (0-based)
				            10  //ultima celda (0-based)
				    ));
					
					//Titulos del Reporte
					fila = hoja.createRow(8);
					celda=fila.createCell((short)4);
					celda.setCellValue("Debe");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)5);
					celda.setCellValue("Haber");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)6);
					celda.setCellValue("Debe");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)7);
					celda.setCellValue("Haber");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)8);
					celda.setCellValue("MN y UDIS");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)9);
					celda.setCellValue("ME");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)10);
					celda.setCellValue("Total (B) = (A)+(1)+(2)");
					celda.setCellStyle(estiloEncabezado);
					
					int rowExcel=9;
					contador=9;
					RegulatorioA1011Bean bean = null;
					CellStyle estiloDinamico = null;
					for(int x = 0; x< listaRegulatorioA1011Bean.size() ; x++ ){
						
						if (x == 0){
							estiloDinamico = estiloUpper;
						}else						
						if(x == (listaRegulatorioA1011Bean.size()-1)){
							estiloDinamico = estiloBottom;
						}else{
							estiloDinamico = estilo8;
						}
						bean = (RegulatorioA1011Bean)listaRegulatorioA1011Bean.get(x);

						fila=hoja.createRow(rowExcel);
						
						celda=fila.createCell((short)1);
						if(bean.getConcepto()!=null && !bean.getConcepto().isEmpty()){
							celda.setCellValue(bean.getConcepto());
							celda.setCellStyle(estiloDinamico);
						}else{
							celda.setCellValue(Constantes.STRING_VACIO);
							celda.setCellStyle(estiloDinamico);
						}
						
						celda=fila.createCell((short)2);
						if(bean.getConcepto()!=null && !bean.getConcepto().isEmpty()){
							celda.setCellValue(Constantes.STRING_VACIO);
							celda.setCellStyle(estiloDinamico);
						}else{
							celda.setCellValue(Constantes.STRING_VACIO);
							celda.setCellStyle(estiloDinamico);
						}
						
						celda=fila.createCell((short)3);
						if(bean.getBalanceSubsidiaria1()!=null && !bean.getBalanceSubsidiaria1().isEmpty()){
							celda.setCellValue(Double.parseDouble(bean.getBalanceSubsidiaria1().toString()));
							celda.setCellStyle(estiloDinamico);
						}else{
							celda.setCellValue(DOUBLE_VACIO);
							celda.setCellStyle(estiloDinamico);
						}

						celda=fila.createCell((short)4);
						if(bean.getSumEstFinanSubsidiaria()!=null && !bean.getSumEstFinanSubsidiaria().isEmpty()){
							celda.setCellValue(Double.parseDouble(bean.getSumEstFinanSubsidiaria().toString()));
							celda.setCellStyle(estiloDinamico);
						}else{
							celda.setCellValue(DOUBLE_VACIO);
							celda.setCellStyle(estiloDinamico);
						}

						celda=fila.createCell((short)5);
						if(bean.getSumEstFinanSubsidiaria()!=null && !bean.getSumEstFinanSubsidiaria().isEmpty()){
							celda.setCellValue(Double.parseDouble(bean.getSumEstFinanSubsidiaria().toString()));
							celda.setCellStyle(estiloDinamico);
						}else{
							celda.setCellValue(DOUBLE_VACIO);
							celda.setCellStyle(estiloDinamico);
						}

						celda=fila.createCell((short)6);
						if(bean.getSumEstFinanSubsidiaria()!=null && !bean.getSumEstFinanSubsidiaria().isEmpty()){
							celda.setCellValue(Double.parseDouble(bean.getSumEstFinanSubsidiaria().toString()));
							celda.setCellStyle(estiloDinamico);
						}else{
							celda.setCellValue(DOUBLE_VACIO);
							celda.setCellStyle(estiloDinamico);
						}

						celda=fila.createCell((short)7);
						if(bean.getSumEstFinanSubsidiaria()!=null && !bean.getSumEstFinanSubsidiaria().isEmpty()){
							celda.setCellValue(Double.parseDouble(bean.getSumEstFinanSubsidiaria().toString()));
							celda.setCellStyle(estiloDinamico);
						}else{
							celda.setCellValue(DOUBLE_VACIO);
							celda.setCellStyle(estiloDinamico);
						}
						
						celda=fila.createCell((short)8);
						if(bean.getSumEstFinanSubsidiaria()!=null && !bean.getSumEstFinanSubsidiaria().isEmpty()){
							celda.setCellValue(Double.parseDouble(bean.getSumEstFinanSubsidiaria().toString()));
							celda.setCellStyle(estiloDinamico);
						}else{
							celda.setCellValue(DOUBLE_VACIO);
							celda.setCellStyle(estiloDinamico);
						}

						celda=fila.createCell((short)9);
						if(bean.getSumEstFinanSubsidiaria()!=null && !bean.getSumEstFinanSubsidiaria().isEmpty()){
							celda.setCellValue(Double.parseDouble(bean.getSumEstFinanSubsidiaria().toString()));
							celda.setCellStyle(estiloDinamico);
						}else{
							celda.setCellValue(DOUBLE_VACIO);
							celda.setCellStyle(estiloDinamico);
						}

						celda=fila.createCell((short)10);
						if(bean.getBalanceSubsidiariaN()!=null && !bean.getBalanceSubsidiariaN().isEmpty()){
							celda.setCellValue(Double.parseDouble(bean.getBalanceSubsidiariaN().toString()));
							celda.setCellStyle(estiloDinamico);
						}else{
							celda.setCellValue(DOUBLE_VACIO);
							celda.setCellStyle(estiloDinamico);
						}
						
						rowExcel++;
						contador++;
					}

				contador++;
				fila = hoja.createRow(contador++);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("Sociedades Financieras Populares.");
				celda.setCellStyle(estiloDerecha);
				hoja.addMergedRegion(new CellRangeAddress(
						(contador-1), //primera fila (0-based)
						(contador-1), //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            10 //ultima celda   (0-based)
			    ));
				
				
				contador++;
				fila = hoja.createRow(contador++);
				celda = fila.createCell((short)1);
				celda.setCellValue("(1) Estos conceptos serán aplicables bajo un entorno económico inflacionario con base en lo establecido en la Norma de información financiera B-10 “Efectos de la inflación”, emitida por el Consejo Mexicano de Normas de Información Financiera, A.C. (CINIF).");
				celda.setCellStyle(estiloIzquierda);
				hoja.addMergedRegion(new CellRangeAddress(
						(contador-1), //primera fila (0-based)
						(contador-1), //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            10 //ultima celda   (0-based)
			    ));
				
				hoja.setColumnWidth(1,20000);
				hoja.setColumnWidth(2,3000);
				hoja.setColumnWidth(3,3000);
				hoja.setColumnWidth(4,3000);
				hoja.setColumnWidth(5,3000);
				hoja.setColumnWidth(6,3000);
				hoja.setColumnWidth(7,3000);
				hoja.setColumnWidth(8,3000);
				hoja.setColumnWidth(9,3000);
				hoja.setColumnWidth(10,3000);

				
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xlsx");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				libro.write(outputStream);
				outputStream.flush();
				outputStream.close();
			
			}catch(Exception e){
				e.printStackTrace();
			}//Fin del catch
		}
		return listaRegulatorioA1011Bean;
	}

	public RegulatorioA1011DAO getRegulatorioA1011DAO() {
		return regulatorioA1011DAO;
	}

	public void setRegulatorioA1011DAO(RegulatorioA1011DAO regulatorioA1011DAO) {
		this.regulatorioA1011DAO = regulatorioA1011DAO;
	}
	
}
