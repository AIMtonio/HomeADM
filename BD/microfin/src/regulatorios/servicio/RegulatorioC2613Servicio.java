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

import regulatorios.bean.RegulatorioC2613Bean;
import regulatorios.dao.RegulatorioC2613DAO;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;

public class RegulatorioC2613Servicio extends BaseServicio {
	

	RegulatorioC2613DAO regulatorioC2613DAO = null;	
	
	
	public RegulatorioC2613Servicio() {
		super();
	}
	
	
	/* ============ case para listas de reportes regulatorios ===============*/
	public List <RegulatorioC2613Bean>listaReporteRegulatorioC2613(int tipoLista,int tipoEntidad, RegulatorioC2613Bean reporteBean, HttpServletResponse response) throws IOException{
		List<RegulatorioC2613Bean> listaReportes=null;
		
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			switch(tipoLista){
				case Enum_Lis_TipoReporte.excel:
					listaReportes = reporteRegulatorioC2613XLSXSOCAP(Enum_Lis_TipoReporte.excel,reporteBean, response); 
					break;
				case Enum_Lis_TipoReporte.csv:
					listaReportes = generarReporteRegulatorioC2613(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch(tipoLista){
				case Enum_Lis_TipoReporte.excel:
					listaReportes = reporteRegulatorioC2613XLSXSOFIPO(Enum_Lis_TipoReporte.excel,reporteBean, response); 
					break;
				case Enum_Lis_TipoReporte.csv:
					listaReportes = generarReporteRegulatorioC2613(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
		
		return listaReportes;
	}
	
/* ======================================  FUNCIONES PARA GENERAR REPORTES CSV  ========================================*/	
	
	private List generarReporteRegulatorioC2613(RegulatorioC2613Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = regulatorioC2613DAO.reporteRegulatorioC2613Csv(reporteBean, tipoReporte);
		nombreArchivo="R26_C2613.csv"; 
		// se inicia seccion para pintar el archivo csv
		try{
			RegulatorioC2613Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioC2613Bean) listaBeans.get(i);
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
	public List<RegulatorioC2613Bean> reporteRegulatorioC2613XLSXSOCAP(int tipoLista,RegulatorioC2613Bean reporteBean,  HttpServletResponse response) throws IOException
	{
		List<RegulatorioC2613Bean> listaRegulatorioC2613Bean = null;
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		
		anio			= reporteBean.getAnio();
		mesEnLetras		= RegulatorioInsServicio.descripcionMes(reporteBean.getMes());
		nombreArchivo 	= "R26_C_2613_"+mesEnLetras+"_"+anio; 
		
		listaRegulatorioC2613Bean = regulatorioC2613DAO.reporteRegulatorioC2613Socap(reporteBean,tipoLista);
		int contador = 1;
		
		if(listaRegulatorioC2613Bean != null){
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
				hoja = (SXSSFSheet) libro.createSheet("C 2613");
				
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
			            2  //ultima celda   (0-based)
			    ));
				
				
				celda = fila.createCell((short)3);
				celda.setCellValue("SECCIÓN DATOS DE LA SOCIEDAD");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            3, //primer celda (0-based)
			            4 //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)5);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL ADMINISTRADOR");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            5, //primer celda (0-based)
			            5  //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)6);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL COMISIONISTA");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            6, //primer celda (0-based)
			            6  //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)7);
				celda.setCellValue("SECCIÓN DE IDENTIFICACIÓN DE LOS MÓDULOS O ESTABLECIMIENTOS");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            7, //primer celda (0-based)
			            8  //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)9);
				celda.setCellValue("SECCIÓN DE CLASIFICACIÓN DE LA AGRUPACIÓN");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            9, //primer celda (0-based)
			            10  //ultima celda   (0-based)
			    ));
				
				
				celda = fila.createCell((short)11);
				celda.setCellValue("SECCIÓN DE MOVIMIENTOS Y OPERACIONES");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            11, //primer celda (0-based)
			            13  //ultima celda   (0-based)
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
					celda.setCellValue("CAPTACIÓN MENSUAL PROMEDIO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)4);
					celda.setCellValue("NÚMERO DE SECUENCIA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)5);
					celda.setCellValue("IDENTIFICADOR DEL ADMINISTRADOR");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)6);
					celda.setCellValue("IDENTIFICADOR DEL COMISIONISTA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)7);
					celda.setCellValue("CLAVE DEL MÓDULO O ESTABLECIMIENTO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)8);
					celda.setCellValue("LOCALIDAD DEL MÓDULO ESTABLECIMIENTO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)9);
					celda.setCellValue("TIPO DE OPERACIÓN REALIZADA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)10);
					celda.setCellValue("MEDIO DE PAGO UTILIZADO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)11);
					celda.setCellValue("MONTO DE LAS OPERACIONES REALIZADAS");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)12);
					celda.setCellValue("NÚMERO DE OPERACIONES REALIZADAS");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)13);
					celda.setCellValue("NÚMERO DE CLIENTES QUE REALIZARON OPERACIONES");
					celda.setCellStyle(estiloEncabezado);
					
					
					int rowExcel=2;
					contador=2;
					RegulatorioC2613Bean regRegulatorioC2613Bean = null;
					
					for(int x = 0; x< listaRegulatorioC2613Bean.size() ; x++ ){
						
											
						
						fila=hoja.createRow(rowExcel);
								
						celda=fila.createCell((short)0);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getPeriodo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)1);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getClaveEntidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)2);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getNumReporte());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)3);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getCaptacionMensual());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)4);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getNumSecuencia());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)5);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getIdenAdministrador());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)6);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getIdenComisionista());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)7);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getClaveModulo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getLocalidadModulo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)9);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getTipoOperacion());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)10);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getMedioPago());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)11);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getMontoOperaciones());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)12);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getNumOperaciones());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)13);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getNumClientes());
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
		return listaRegulatorioC2613Bean;
	}
	
	
	/**
	 * Generacion del reporte SOFIPO
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List<RegulatorioC2613Bean> reporteRegulatorioC2613XLSXSOFIPO(int tipoLista,RegulatorioC2613Bean reporteBean,  HttpServletResponse response) throws IOException
	{
		List<RegulatorioC2613Bean> listaRegulatorioC2613Bean = null;
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		
		anio			= reporteBean.getAnio();
		mesEnLetras		= RegulatorioInsServicio.descripcionMes(reporteBean.getMes());
		nombreArchivo 	= "R26_C_2613_"+mesEnLetras+"_"+anio; 
		
		listaRegulatorioC2613Bean = regulatorioC2613DAO.reporteRegulatorioC2613Sofipo(reporteBean,tipoLista);
		int contador = 1;
		
		if(listaRegulatorioC2613Bean != null){
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
				hoja = (SXSSFSheet) libro.createSheet("C 2613");
				
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
			            4  //ultima celda   (0-based)
			    ));
				
				
			
				
				celda = fila.createCell((short)5);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL ADMINISTRADOR");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            5, //primer celda (0-based)
			            5  //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)6);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL COMISIONISTA");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            6, //primer celda (0-based)
			            6  //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)7);
				celda.setCellValue("SECCIÓN DE IDENTIFICACIÓN DEL MÓDULO O ESTABLECIMIENTO");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            7, //primer celda (0-based)
			            8  //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)9);
				celda.setCellValue("SECCIÓN DE CLASIFICADORES DE LA AGRUPACIÓN");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            9, //primer celda (0-based)
			            10  //ultima celda   (0-based)
			    ));
				
				
				celda = fila.createCell((short)11);
				celda.setCellValue("SECCIÓN DE MOVIMIENTOS Y OPERACIONES");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            11, //primer celda (0-based)
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
					celda.setCellValue("CAPTACIÓN MENSUAL PROMEDIO");
					celda.setCellStyle(estiloEncabezado);
										
					celda=fila.createCell((short)3);
					celda.setCellValue("REPORTE");
					celda.setCellStyle(estiloEncabezado);
										
					celda=fila.createCell((short)4);
					celda.setCellValue("NÚMERO DE SECUENCIA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)5);
					celda.setCellValue("IDENTIFICADOR DEL ADMINISTRADOR");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)6);
					celda.setCellValue("IDENTIFICADOR DEL COMISIONISTA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)7);
					celda.setCellValue("CLAVE DEL MÓDULO O ESTABLECIMIENTO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)8);
					celda.setCellValue("LOCALIDAD DEL MÓDULO ESTABLECIMIENTO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)9);
					celda.setCellValue("TIPO DE OPERACIÓN REALIZADA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)10);
					celda.setCellValue("MEDIO DE PAGO UTILIZADO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)11);
					celda.setCellValue("MONTO DE LAS OPERACIONES REALIZADAS");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)12);
					celda.setCellValue("NÚMERO DE OPERACIONES REALIZADAS");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)13);
					celda.setCellValue("NÚMERO DE CLIENTES QUE REALIZARON OPERACIONES");
					celda.setCellStyle(estiloEncabezado);
					
					
					int rowExcel=2;
					contador=2;
					RegulatorioC2613Bean regRegulatorioC2613Bean = null;
					
					for(int x = 0; x< listaRegulatorioC2613Bean.size() ; x++ ){
						
											
						
						fila=hoja.createRow(rowExcel);
								
						celda=fila.createCell((short)0);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getPeriodo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)1);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getClaveEntidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)2);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getCaptacionMensual());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)3);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getNumReporte());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)4);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getNumSecuencia());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)5);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getIdenAdministrador());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)6);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getIdenComisionista());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)7);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getClaveModulo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getLocalidadModulo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)9);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getTipoOperacion());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)10);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getMedioPago());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)11);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getMontoOperaciones());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)12);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getNumOperaciones());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)13);
						celda.setCellValue(listaRegulatorioC2613Bean.get(x).getNumClientes());
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
		return listaRegulatorioC2613Bean;
	}


	public RegulatorioC2613DAO getRegulatorioC2613DAO() {
		return regulatorioC2613DAO;
	}


	public void setRegulatorioC2613DAO(RegulatorioC2613DAO regulatorioC2613DAO) {
		this.regulatorioC2613DAO = regulatorioC2613DAO;
	}
	



}
