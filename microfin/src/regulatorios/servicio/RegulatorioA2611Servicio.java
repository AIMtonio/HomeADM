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

import regulatorios.bean.RegulatorioA2611Bean;
import regulatorios.dao.RegulatorioA2611DAO;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;


public class RegulatorioA2611Servicio extends BaseServicio {
	
	RegulatorioA2611DAO regulatorioA2611DAO = null;	
	
	
	public RegulatorioA2611Servicio() {
		super();
	}

	

	public List <RegulatorioA2611Bean>listaReporteRegulatorioA2611(int tipoLista,int tipoEntidad, RegulatorioA2611Bean reporteBean, HttpServletResponse response) throws IOException{
		List<RegulatorioA2611Bean> listaReportes=null;
		
		/*
		 * SOCAPS
		 */
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			switch(tipoLista){
				case Enum_Lis_TipoReporte.excel:
					listaReportes = reporteRegulatorioA2611XLSXSOCAP(Enum_Lis_TipoReporte.excel,reporteBean,response);
					break;
				case Enum_Lis_TipoReporte.csv:
					listaReportes = generarReporteRegulatorioA2611(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		
		}
		
		/*
		 * SOFIPOS
		 */
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch(tipoLista){
				case Enum_Lis_TipoReporte.excel:
					listaReportes = reporteRegulatorioA2611XLSXSOFIPO(Enum_Lis_TipoReporte.excel,reporteBean,response);
					break;
				case Enum_Lis_TipoReporte.csv:
					listaReportes = generarReporteRegulatorioA2611(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
		return listaReportes;
		
	}
	
	
	/* ======================================  FUNCION PARA GENERAR REPORTE CSV  ========================================*/	
	
	private List generarReporteRegulatorioA2611(RegulatorioA2611Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = regulatorioA2611DAO.reporteRegulatorioA2611Csv(reporteBean, tipoReporte);
		nombreArchivo="R26_A2611.csv"; 
		// se inicia seccion para pintar el archivo csv
		try{
			RegulatorioA2611Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioA2611Bean) listaBeans.get(i);
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
	
	
	/* ========= REPORTES EN EXCEL ======================================================================= */
	
	/**
	 * Generacion del reporte SOCAP
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List<RegulatorioA2611Bean> reporteRegulatorioA2611XLSXSOCAP(int tipoLista,RegulatorioA2611Bean reporteBean, HttpServletResponse response) throws IOException
	{
		List<RegulatorioA2611Bean> listaRegulatorioA2611Bean = null;
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		
		anio			= reporteBean.getAnio();
		mesEnLetras		= RegulatorioInsServicio.descripcionMes(reporteBean.getMes());
		nombreArchivo 	= "R26_A_2611_"+mesEnLetras+"_"+anio; 
		
		listaRegulatorioA2611Bean = regulatorioA2611DAO.reporteRegulatorioA2611Socap(reporteBean,tipoLista);
		int contador = 1;
		
		if(listaRegulatorioA2611Bean != null){
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
				hoja = (SXSSFSheet) libro.createSheet("A 2611");
				
				Row fila = hoja.createRow(0);
				Cell celda=fila.createCell((short)1);
				/////////////////////////////////////////////////////////////////////////////////////
				///////////////////////// FIN ENCABEZADO EXCEL //////////////////////////////////////
				//AGREGAR GRUPOS DE COLUMNAS
				//////////////////////////////////////////////////////////////////////////////
				
				celda = fila.createCell((short)0);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL FORMULARIO");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            3  //ultima celda   (0-based)
			    ));
				
				
				celda = fila.createCell((short)4);
				celda.setCellValue("IDENTIFICADOR DEL ADMINISTRADOR");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            4, //primer celda (0-based)
			            6 //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)7);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL COMISIONISTA");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            7, //primer celda (0-based)
			            12  //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)13);
				celda.setCellValue("SECCIÓN OPERACIONES CONTRATADAS POR EL COMISIONISTA");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            13, //primer celda (0-based)
			            13  //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)14);
				celda.setCellValue("SECCIÓN DE BAJAS");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            14, //primer celda (0-based)
			            14  //ultima celda   (0-based)
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
					celda.setCellValue("OPERACIONES CON ADMINISTRADORES");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)5);
					celda.setCellValue("IDENTIFICADOR DEL ADMINISTRADOR");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)6);
					celda.setCellValue("RFC DEL ADMINISTRADOR");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)7);
					celda.setCellValue("TIPO DE MOVIMIENTO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)8);
					celda.setCellValue("IDENTIFICADOR DEL COMISIONISTA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)9);
					celda.setCellValue("NOMBRE DEL COMISIONISTA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)10);
					celda.setCellValue("RFC DEL COMISIONISTA");

					celda.setCellStyle(estiloEncabezado);
					celda=fila.createCell((short)11);
					celda.setCellValue("PERSONALIDAD JURÍDICA DEL COMISIONISTA");
					
					celda.setCellStyle(estiloEncabezado);
					celda=fila.createCell((short)12);
					celda.setCellValue("ACTIVIDAD DEL COMISIONISTA");


					celda.setCellStyle(estiloEncabezado);
					celda=fila.createCell((short)13);
					celda.setCellValue("OPERACIONES CONTRATADAS");

					celda.setCellStyle(estiloEncabezado);
					celda=fila.createCell((short)14);
					celda.setCellValue("CAUSA DE BAJA DEL COMISIONISTA");
					celda.setCellStyle(estiloEncabezado);
					
					
					int rowExcel=2;
					contador=2;
					RegulatorioA2611Bean regRegulatorioA2611Bean = null;
					
					for(int x = 0; x< listaRegulatorioA2611Bean.size() ; x++ ){
						
											
						
						fila=hoja.createRow(rowExcel);
								
						celda=fila.createCell((short)0);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getPeriodo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)1);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getClaveEntidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)2);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getNumReporte());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)3);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getNumSecuencia());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)4);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getOperacionConAdmin());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)5);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getIdenAdministrador());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)6);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getrFCAdministrador());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)7);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getTipoMovimiento());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getIdenComisionista());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)9);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getNombreComisionista());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)10);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getrFCCOmisionista());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)11);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getPersJuridicaComi());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)12);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getActividadComision());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)13);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getOperaContratadas());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)14);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getCausaBaja());
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
		return listaRegulatorioA2611Bean;
	}
	
	
	
	/**
	 * Generacion del reporte SOFIPO
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List<RegulatorioA2611Bean> reporteRegulatorioA2611XLSXSOFIPO(int tipoLista,RegulatorioA2611Bean reporteBean, HttpServletResponse response) throws IOException
	{
		List<RegulatorioA2611Bean> listaRegulatorioA2611Bean = null;
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		
		anio			= reporteBean.getAnio();
		mesEnLetras		= RegulatorioInsServicio.descripcionMes(reporteBean.getMes());
		nombreArchivo 	= "R26_A_2611_"+mesEnLetras+"_"+anio; 
		
		listaRegulatorioA2611Bean =  regulatorioA2611DAO.reporteRegulatorioA2611Socap(reporteBean,tipoLista);
		int contador = 1;
		
		if(listaRegulatorioA2611Bean != null){
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
				hoja = (SXSSFSheet) libro.createSheet("A 2611");
				
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
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL ADMINISTRADOR");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            4, //primer celda (0-based)
			            6 //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)7);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL COMISIONISTA");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            7, //primer celda (0-based)
			            11  //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)12);
				celda.setCellValue("SECCIÓN OPERACIONES CONTRATADAS POR EL COMISIONISTA");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            12, //primer celda (0-based)
			            12  //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)13);
				celda.setCellValue("SECCIÓN DE BAJAS");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            13, //primer celda (0-based)
			            13  //ultima celda   (0-based)
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
					celda.setCellValue("OPERACIONES CON ADMINISTRADORES");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)5);
					celda.setCellValue("IDENTIFICADOR DEL ADMINISTRADOR");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)6);
					celda.setCellValue("RFC DEL ADMINISTRADOR");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)7);
					celda.setCellValue("TIPO DE MOVIMIENTO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)8);
					celda.setCellValue("IDENTIFICADOR DEL COMISIONISTA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)9);
					celda.setCellValue("NOMBRE DEL COMISIONISTA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)10);
					celda.setCellValue("RFC DEL COMISIONISTA");

					celda.setCellStyle(estiloEncabezado);
					celda=fila.createCell((short)11);
					celda.setCellValue("PERSONALIDAD JURÍDICA DEL COMISIONISTA");	
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)12);
					celda.setCellValue("OPERACIONES CONTRATADAS");

					celda.setCellStyle(estiloEncabezado);
					celda=fila.createCell((short)13);
					celda.setCellValue("CAUSA DE BAJA DEL COMISIONISTA");
					celda.setCellStyle(estiloEncabezado);
					
					
					int rowExcel=2;
					contador=2;
					RegulatorioA2611Bean regRegulatorioA2611Bean = null;
					
					for(int x = 0; x< listaRegulatorioA2611Bean.size() ; x++ ){
						
											
						
						fila=hoja.createRow(rowExcel);
								
						celda=fila.createCell((short)0);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getPeriodo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)1);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getClaveEntidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)2);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getNumReporte());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)3);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getNumSecuencia());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)4);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getOperacionConAdmin());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)5);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getIdenAdministrador());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)6);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getrFCAdministrador());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)7);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getTipoMovimiento());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getIdenComisionista());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)9);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getNombreComisionista());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)10);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getrFCCOmisionista());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)11);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getPersJuridicaComi());
						celda.setCellStyle(estilo8);
						
						
						celda=fila.createCell((short)12);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getOperaContratadas());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)13);
						celda.setCellValue(listaRegulatorioA2611Bean.get(x).getCausaBaja());
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
		return listaRegulatorioA2611Bean;
	}


	public RegulatorioA2611DAO getRegulatorioA2611DAO() {
		return regulatorioA2611DAO;
	}


	public void setRegulatorioA2611DAO(RegulatorioA2611DAO regulatorioA2611DAO) {
		this.regulatorioA2611DAO = regulatorioA2611DAO;
	}

	
	
}
