package regulatorios.servicio;

import general.servicio.BaseServicio;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

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

import regulatorios.bean.RegulatorioB2612Bean;
import regulatorios.dao.RegulatorioB2612DAO;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;


public class RegulatorioB2612Servicio extends BaseServicio {
	
	RegulatorioB2612DAO regulatorioB2612DAO = null;	
	
	
	public RegulatorioB2612Servicio() {
		super();
	}
	
	public List <RegulatorioB2612Bean>listaReporteRegulatorioB2612(int tipoLista,int tipoEntidad, RegulatorioB2612Bean reporteBean, HttpServletResponse response) throws IOException{
		List<RegulatorioB2612Bean> listaReportes=null;
		/*
		 * SOCAP
		 */
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			switch(tipoLista){
				case Enum_Lis_TipoReporte.excel:
					listaReportes = reporteRegulatorioB2612XLSXSOCAP(Enum_Lis_TipoReporte.excel,reporteBean, response); 
					break;
				case Enum_Lis_TipoReporte.csv:
					listaReportes = generarReporteRegulatorioB2612(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
		/*
		 * SOFIPO
		 */
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch(tipoLista){
				case Enum_Lis_TipoReporte.excel:
					listaReportes = reporteRegulatorioB2612XLSXSOFIPO(Enum_Lis_TipoReporte.excel,reporteBean, response); 
					break;
				case Enum_Lis_TipoReporte.csv:
					listaReportes = generarReporteRegulatorioB2612(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
		
		return listaReportes;
	}
	
	
	
/* ======================================  FUNCIONES PARA GENERAR REPORTES CSV  ========================================*/	
	
	private List generarReporteRegulatorioB2612(RegulatorioB2612Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = regulatorioB2612DAO.reporteRegulatorioB2612Csv(reporteBean, tipoReporte);
		nombreArchivo="R26_B2612.csv"; 
		// se inicia seccion para pintar el archivo csv
		try{
			RegulatorioB2612Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioB2612Bean) listaBeans.get(i);
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
	 * Generacion del reporte SOCAP
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List<RegulatorioB2612Bean> reporteRegulatorioB2612XLSXSOCAP(int tipoLista,RegulatorioB2612Bean reporteBean,  HttpServletResponse response) throws IOException
	{
		List<RegulatorioB2612Bean> listaRegulatorioB2612Bean = null;
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		
		anio			= reporteBean.getAnio();
		mesEnLetras		= RegulatorioInsServicio.descripcionMes(reporteBean.getMes());
		nombreArchivo 	= "R26_B_2612_"+mesEnLetras+"_"+anio; 
		
		listaRegulatorioB2612Bean = regulatorioB2612DAO.reporteRegulatorioB2612Socap(reporteBean,tipoLista);
		int contador = 1;
		
		if(listaRegulatorioB2612Bean != null){
			try {
				//////////////////////////////////////////////////////////////////////////////////////
				////////////////////// ENCABEZADO y CONFIGURACION DEL  EXCEL /////////////////////////////////////////
	
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
				
				//Estilo Formato Tasa (0.0000)
				CellStyle estiloFormatoTasa = libro.createCellStyle();
				DataFormat format = libro.createDataFormat();
				estiloFormatoTasa.setDataFormat(format.getFormat("0.0000"));
				estiloFormatoTasa.setFont(fuente8);
				
				//Encabezado agrupaciones
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
				hoja = (SXSSFSheet) libro.createSheet("B 2612");
				
				Row fila = hoja.createRow(0);
				Cell celda=fila.createCell((short)1);
				/////////////////////////////////////////////////////////////////////////////////////
				///////////////////////// FIN ENCABEZADO EXCEL //////////////////////////////////////
				//AGREGAR GRUPOS DE COLUMNAS
				//////////////////////////////////////////////////////////////////////////////
					
				celda = fila.createCell((short)0);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL REPORTE");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            3  //ultima celda   (0-based)
			    ));
				
				
				celda = fila.createCell((short)4);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL COMISIONISTA");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            4, //primer celda (0-based)
			            5 //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)6);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL MÓDULO O ESTABLECIMIENTO");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            6, //primer celda (0-based)
			            8  //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)9);
				celda.setCellValue("SECCIÓN BAJA DEL MÓDULO O ESTABLECIMIENTO");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            9, //primer celda (0-based)
			            11  //ultima celda   (0-based)
			    ));
				
								
											
					//Titulos del Reporte
					fila = hoja.createRow(1);
					celda=fila.createCell((short)0);
					celda.setCellValue("PERIODO QUE SE REPORTA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)1);
					celda.setCellValue("CLAVE DE LA ENTIDAD");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)2);
					celda.setCellValue("CLAVE DEL FORMULARIO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)3);
					celda.setCellValue("NÚMERO DE SECUENCIA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)4);
					celda.setCellValue("IDENTIFICADOR DEL COMISIONISTA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)5);
					celda.setCellValue("RFC DEL COMISIONISTA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)6);
					celda.setCellValue("TIPO DE MOVIMIENTO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)7);
					celda.setCellValue("CLAVE DEL MÓDULO O ESTABLECIMIENTO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)8);
					celda.setCellValue("LOCALIDAD DEL MÓDULO O ESTABLECIMIENTO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)9);
					celda.setCellValue("CAUSA DE BAJA DEL MÓDULO O ESTABLECIMIENTO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)10);
					celda.setCellValue("MUNICIPIO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)11);
					celda.setCellValue("ESTADO");
					celda.setCellStyle(estiloEncabezado);
					
					int rowExcel=2;
					contador=2;
					RegulatorioB2612Bean regRegulatorioB2612Bean = null;
					
					for(int x = 0; x< listaRegulatorioB2612Bean.size() ; x++ ){
						
											
						
						fila=hoja.createRow(rowExcel);
								
						celda=fila.createCell((short)0);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getPeriodo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)1);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getClaveEntidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)2);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getNumReporte());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)3);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getNumSecuencia());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)4);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getIdenComisionista());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)5);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getrFCCOmisionista());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)6);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getTipoMovimiento());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)7);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getClaveModulo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getLocalidadModulo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)9);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getCausaBajaModulo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)10);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getMunicipio());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)11);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getEstado());
						celda.setCellStyle(estilo8);
												
						
						rowExcel++;
						contador++;
					}

							
										
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
		return listaRegulatorioB2612Bean;
	}
	
		

	
	/**
	 * Generacion del reporte SOCIPO
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List<RegulatorioB2612Bean> reporteRegulatorioB2612XLSXSOFIPO(int tipoLista,RegulatorioB2612Bean reporteBean,  HttpServletResponse response) throws IOException
	{
		List<RegulatorioB2612Bean> listaRegulatorioB2612Bean = null;
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		
		anio			= reporteBean.getAnio();
		mesEnLetras		= RegulatorioInsServicio.descripcionMes(reporteBean.getMes());
		nombreArchivo 	= "R26_B_2612_"+mesEnLetras+"_"+anio; 
		
		listaRegulatorioB2612Bean = regulatorioB2612DAO.reporteRegulatorioB2612Sofipo(reporteBean,tipoLista);
		int contador = 1;
		
		if(listaRegulatorioB2612Bean != null){
			try {
				//////////////////////////////////////////////////////////////////////////////////////
				////////////////////// ENCABEZADO y CONFIGURACION DEL  EXCEL /////////////////////////////////////////
	
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
				
				//Estilo Formato Tasa (0.0000)
				CellStyle estiloFormatoTasa = libro.createCellStyle();
				DataFormat format = libro.createDataFormat();
				estiloFormatoTasa.setDataFormat(format.getFormat("0.0000"));
				estiloFormatoTasa.setFont(fuente8);
				
				//Encabezado agrupaciones
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
				hoja = (SXSSFSheet) libro.createSheet("B 2612");
				
				Row fila = hoja.createRow(0);
				Cell celda=fila.createCell((short)1);
				/////////////////////////////////////////////////////////////////////////////////////
				///////////////////////// FIN ENCABEZADO EXCEL //////////////////////////////////////
				//AGREGAR GRUPOS DE COLUMNAS
				//////////////////////////////////////////////////////////////////////////////
					
				celda = fila.createCell((short)0);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL REPORTE");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            3  //ultima celda   (0-based)
			    ));
				
				
				celda = fila.createCell((short)4);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL COMISIONISTA");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            4, //primer celda (0-based)
			            5 //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)6);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL MÓDULO O ESTABLECIMIENTO");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            6, //primer celda (0-based)
			            8  //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)9);
				celda.setCellValue("SECCIÓN BAJA DEL MÓDULO O ESTABLECIMIENTO");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            9, //primer celda (0-based)
			            11  //ultima celda   (0-based)
			    ));
				
								
											
					//Titulos del Reporte
					fila = hoja.createRow(1);
					celda=fila.createCell((short)0);
					celda.setCellValue("PERIODO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)1);
					celda.setCellValue("CLAVE DE LA ENTIDAD");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)2);
					celda.setCellValue("REPORTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)3);
					celda.setCellValue("NÚMERO DE SECUENCIA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)4);
					celda.setCellValue("IDENTIFICADOR DEL COMISIONISTA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)5);
					celda.setCellValue("RFC DEL COMISIONISTA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)6);
					celda.setCellValue("TIPO DE MOVIMIENTO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)7);
					celda.setCellValue("CLAVE DEL MÓDULO O ESTABLECIMIENTO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)8);
					celda.setCellValue("LOCALIDAD DEL MÓDULO O ESTABLECIMIENTO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)9);
					celda.setCellValue("CAUSA DE BAJA DEL MÓDULO O ESTABLECIMIENTO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)10);
					celda.setCellValue("CLAVE DE MUNICIPIO DEL MÓDULO O ESTABLECIMIENTO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)11);
					celda.setCellValue("CLAVE DEL ESTADO DEL MÓDULO O ESTABLECIMIENTO");
					celda.setCellStyle(estiloEncabezado);
					
					int rowExcel=2;
					contador=2;
					RegulatorioB2612Bean regRegulatorioB2612Bean = null;
					
					for(int x = 0; x< listaRegulatorioB2612Bean.size() ; x++ ){
						
											
						
						fila=hoja.createRow(rowExcel);
								
						celda=fila.createCell((short)0);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getPeriodo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)1);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getClaveEntidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)2);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getNumReporte());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)3);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getNumSecuencia());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)4);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getIdenComisionista());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)5);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getrFCCOmisionista());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)6);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getTipoMovimiento());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)7);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getClaveModulo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getLocalidadModulo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)9);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getCausaBajaModulo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)10);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getMunicipio());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)11);
						celda.setCellValue(listaRegulatorioB2612Bean.get(x).getEstado());
						celda.setCellStyle(estilo8);
												
						
						rowExcel++;
						contador++;
					}

							
										
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
		return listaRegulatorioB2612Bean;
	}

	public RegulatorioB2612DAO getRegulatorioB2612DAO() {
		return regulatorioB2612DAO;
	}

	public void setRegulatorioB2612DAO(RegulatorioB2612DAO regulatorioB2612DAO) {
		this.regulatorioB2612DAO = regulatorioB2612DAO;
	}
	
	
	

}
