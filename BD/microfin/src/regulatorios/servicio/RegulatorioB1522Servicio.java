package regulatorios.servicio;

import general.servicio.BaseServicio;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
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

import regulatorios.bean.RegulatorioB1522Bean;
import regulatorios.dao.RegulatorioB1522DAO;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;



public class RegulatorioB1522Servicio extends BaseServicio {
	
RegulatorioB1522DAO regulatorioB1522DAO = null;	
	
	
	public RegulatorioB1522Servicio() {
		super();
	}
	
	
	/* ============ case para listas de reportes regulatorios ===============*/
	public List <RegulatorioB1522Bean>listaReporteRegulatorioB1522(int tipoLista, int tipoEntidad, RegulatorioB1522Bean reporteBean, HttpServletResponse response) throws IOException{
		List<RegulatorioB1522Bean> listaReportes=null;
		/*SOCAP*/
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			switch(tipoLista){
				case Enum_Lis_TipoReporte.excel:
					listaReportes = reporteRegulatorioB1522XLSX_SOCAP(Enum_Lis_TipoReporte.excel, reporteBean, response); 
					break;
				case Enum_Lis_TipoReporte.csv:
					listaReportes = generarReporteRegulatorioB1522(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
		/*SOFIPO*/
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch(tipoLista){
				case Enum_Lis_TipoReporte.excel:
					listaReportes = reporteRegulatorioB1522XLSX_SOFIPO(Enum_Lis_TipoReporte.excel, reporteBean, response); 
					break;
				case Enum_Lis_TipoReporte.csv:
					listaReportes = generarReporteRegulatorioB1522(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
		return listaReportes;
	}
	
	
/* ======================================  FUNCIONES PARA GENERAR REPORTES CSV  ========================================*/	
	
	private List generarReporteRegulatorioB1522(RegulatorioB1522Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = regulatorioB1522DAO.reporteRegulatorioB1522Csv(reporteBean, tipoReporte);
		nombreArchivo="R15_B1522.csv"; 
		// se inicia seccion para pintar el archivo csv
		try{
			RegulatorioB1522Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioB1522Bean) listaBeans.get(i);
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
	 * Generacion del reporte para SOCAPS
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List<RegulatorioB1522Bean> reporteRegulatorioB1522XLSX_SOCAP(int tipoLista,RegulatorioB1522Bean reporteBean,  HttpServletResponse response) throws IOException
	{
		List<RegulatorioB1522Bean> listaRegulatorioB1522Bean = new ArrayList();
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		
		anio			= reporteBean.getAnio();
		mesEnLetras		= RegulatorioInsServicio.descripcionMes(reporteBean.getMes());
		nombreArchivo 	= "R15_B_1522_"+mesEnLetras+"_"+anio; 
		
		int contador = 1;
		
		
			try {
				//////////////////////////////////////////////////////////////////////////////////////
				////////////////////// ENCABEZADO y CONFIGURACION DEL  EXCEL /////////////////////////////////////////
	
				Workbook libro = new SXSSFWorkbook();
				//Crea un Fuente Negrita con tama??o 8 para informacion del reporte.
				
				Font fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setFontName("Negrita");
				fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
				//Crea un Fuente Negrita con tama??o 8 para informacion del reporte.
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
				
				//Estilo negrita tama??o 8 centrado
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
				hoja = (SXSSFSheet) libro.createSheet("B 1522");
				
				Row fila = hoja.createRow(0);
				Cell celda=fila.createCell((short)1);
				/////////////////////////////////////////////////////////////////////////////////////
				///////////////////////// FIN ENCABEZADO EXCEL //////////////////////////////////////
				//AGREGAR GRUPOS DE COLUMNAS
				//////////////////////////////////////////////////////////////////////////////
				celda = fila.createCell((short)0);
				celda.setCellValue("INFORMACI??N");
				celda.setCellStyle(estiloAgrupacion);	
				
				fila=hoja.createRow(1);
				celda=fila.createCell((short)0);
				celda.setCellValue("El Regulatorio seleccionado no aplica para su tipo de Instituci??n");
				celda.setCellStyle(estilo8);

							
										
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
		
		return listaRegulatorioB1522Bean;
	}
	
		
	/**
	 * Generacion del reporte para SOFIPO
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List<RegulatorioB1522Bean> reporteRegulatorioB1522XLSX_SOFIPO(int tipoLista,RegulatorioB1522Bean reporteBean,  HttpServletResponse response) throws IOException
	{
		List<RegulatorioB1522Bean> listaRegulatorioB1522Bean = null;
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		
		anio			= reporteBean.getAnio();
		mesEnLetras		= RegulatorioInsServicio.descripcionMes(reporteBean.getMes());
		nombreArchivo 	= "R15_B_1522_"+mesEnLetras+"_"+anio; 
		
		listaRegulatorioB1522Bean = regulatorioB1522DAO.reporteRegulatorioB1522SOFIPO(reporteBean,tipoLista);
		int contador = 1;
		
		if(listaRegulatorioB1522Bean != null){
			try {
				//////////////////////////////////////////////////////////////////////////////////////
				////////////////////// ENCABEZADO y CONFIGURACION DEL  EXCEL /////////////////////////////////////////
	
				Workbook libro = new SXSSFWorkbook();
				//Crea un Fuente Negrita con tama??o 8 para informacion del reporte.
				
				Font fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setFontName("Negrita");
				fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
				//Crea un Fuente Negrita con tama??o 8 para informacion del reporte.
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
				
				//Estilo negrita tama??o 8 centrado
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
				hoja = (SXSSFSheet) libro.createSheet("B 1522");
				
				Row fila = hoja.createRow(0);
				Cell celda=fila.createCell((short)1);
				/////////////////////////////////////////////////////////////////////////////////////
				///////////////////////// FIN ENCABEZADO EXCEL //////////////////////////////////////
				//AGREGAR GRUPOS DE COLUMNAS
				//////////////////////////////////////////////////////////////////////////////
										
					celda = fila.createCell((short)0);
					celda.setCellValue("SECCI??N IDENTIFICADOR DEL REPORTE");
					celda.setCellStyle(estiloAgrupacion);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            2  //ultima celda   (0-based)
				    ));
					
					
					celda = fila.createCell((short)3);
					celda.setCellValue("SECCI??N IDENTIFICADOR DEL SERVICIO PROPORCIONADO A TRAV??S DEL MEDIO ELECTR??NICO");
					celda.setCellStyle(estiloAgrupacion);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            3, //primer celda (0-based)
				            4 //ultima celda   (0-based)
				    ));
					
					celda = fila.createCell((short)5);
					celda.setCellValue("SECCI??N DE USUARIOS");
					celda.setCellStyle(estiloAgrupacion);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            5, //primer celda (0-based)
				            5  //ultima celda   (0-based)
				    ));
					
					celda = fila.createCell((short)6);
					celda.setCellValue("SECCI??N DATOS DE LAS OPERACIONES MONETARIAS");
					celda.setCellStyle(estiloAgrupacion);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            6, //primer celda (0-based)
				            8  //ultima celda   (0-based)
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
					celda.setCellValue("TIPO DE PRODUCTO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)4);
					celda.setCellValue("SERVICIOS PROPORCIONADOS A TRAV??S DE MEDIOS ELECTR??NICOS");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)5);
					celda.setCellValue("N??MERO DE USUARIOS QUE OPERARON");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)6);
					celda.setCellValue("TIPO DE OPERACI??N REALIZADA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)7);
					celda.setCellValue("N??MERO DE OPERACIONES");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)8);
					celda.setCellValue("IMPORTE DE LAS OPERACIONES REALIZADAS");
					celda.setCellStyle(estiloEncabezado);
					
				
					
					int rowExcel=2;
					contador=2;
					RegulatorioB1522Bean regRegulatorioB1522Bean = null;
					
					for(int x = 0; x< listaRegulatorioB1522Bean.size() ; x++ ){
						
											
						
						fila=hoja.createRow(rowExcel);
								
						celda=fila.createCell((short)0);
						celda.setCellValue(listaRegulatorioB1522Bean.get(x).getPeriodo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)1);
						celda.setCellValue(listaRegulatorioB1522Bean.get(x).getClaveEntidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)2);
						celda.setCellValue(listaRegulatorioB1522Bean.get(x).getNumReporte());
						celda.setCellStyle(estilo8);
						
					
						celda=fila.createCell((short)3);
						celda.setCellValue(listaRegulatorioB1522Bean.get(x).getTipoProducto());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)4);
						celda.setCellValue(listaRegulatorioB1522Bean.get(x).getServicios());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)5);
						celda.setCellValue(listaRegulatorioB1522Bean.get(x).getNumUsuarios());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)6);
						celda.setCellValue(listaRegulatorioB1522Bean.get(x).getTipoOperacion());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)7);
						celda.setCellValue(listaRegulatorioB1522Bean.get(x).getNumOperaciones());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(listaRegulatorioB1522Bean.get(x).getImporte());
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
		return listaRegulatorioB1522Bean;
	}


	public RegulatorioB1522DAO getRegulatorioB1522DAO() {
		return regulatorioB1522DAO;
	}


	public void setRegulatorioB1522DAO(RegulatorioB1522DAO regulatorioB1522DAO) {
		this.regulatorioB1522DAO = regulatorioB1522DAO;
	}


	

}
