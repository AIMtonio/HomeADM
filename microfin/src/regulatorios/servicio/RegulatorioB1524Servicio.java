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

import regulatorios.bean.RegulatorioB1524Bean;
import regulatorios.dao.RegulatorioB1524DAO;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;



public class RegulatorioB1524Servicio extends BaseServicio {
	
RegulatorioB1524DAO regulatorioB1524DAO = null;	
	
	
	public RegulatorioB1524Servicio() {
		super();
	}
	
	
	/* ============ case para listas de reportes regulatorios ===============*/
	public List <RegulatorioB1524Bean>listaReporteRegulatorioB1524(int tipoLista, int tipoEntidad, RegulatorioB1524Bean reporteBean, HttpServletResponse response) throws IOException{
		List<RegulatorioB1524Bean> listaReportes=null;
		/*SOCAP*/
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			switch(tipoLista){
				case Enum_Lis_TipoReporte.excel:
					listaReportes = reporteRegulatorioB1524XLSX_SOCAP(Enum_Lis_TipoReporte.excel, reporteBean, response); 
					break;
				case Enum_Lis_TipoReporte.csv:
					listaReportes = generarReporteRegulatorioB1524(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
		/*SOFIPO*/
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch(tipoLista){
				case Enum_Lis_TipoReporte.excel:
					listaReportes = reporteRegulatorioB1524XLSX_SOFIPO(Enum_Lis_TipoReporte.excel, reporteBean, response); 
					break;
				case Enum_Lis_TipoReporte.csv:
					listaReportes = generarReporteRegulatorioB1524(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
		return listaReportes;
	}
	
	
/* ======================================  FUNCIONES PARA GENERAR REPORTES CSV  ========================================*/	
	
	private List generarReporteRegulatorioB1524(RegulatorioB1524Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = regulatorioB1524DAO.reporteRegulatorioB1524Csv(reporteBean, tipoReporte);
		nombreArchivo="R15_B1524.csv"; 
		// se inicia seccion para pintar el archivo csv
		try{
			RegulatorioB1524Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioB1524Bean) listaBeans.get(i);
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
	public List<RegulatorioB1524Bean> reporteRegulatorioB1524XLSX_SOCAP(int tipoLista,RegulatorioB1524Bean reporteBean,  HttpServletResponse response) throws IOException
	{
		List<RegulatorioB1524Bean> listaRegulatorioB1524Bean = new ArrayList();
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		
		anio			= reporteBean.getAnio();
		mesEnLetras		= RegulatorioInsServicio.descripcionMes(reporteBean.getMes());
		nombreArchivo 	= "R15_B_1524_"+mesEnLetras+"_"+anio; 
		
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
				hoja = (SXSSFSheet) libro.createSheet("B 1524");
				
				Row fila = hoja.createRow(0);
				Cell celda=fila.createCell((short)1);
				/////////////////////////////////////////////////////////////////////////////////////
				///////////////////////// FIN ENCABEZADO EXCEL //////////////////////////////////////
				//AGREGAR GRUPOS DE COLUMNAS
				//////////////////////////////////////////////////////////////////////////////
										
					celda = fila.createCell((short)0);
					celda.setCellValue("INFORMACIÓN");
					celda.setCellStyle(estiloAgrupacion);	
					
					fila=hoja.createRow(1);
					celda=fila.createCell((short)0);
					celda.setCellValue("El Regulatorio seleccionado no aplica para su tipo de Institución");
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
		
		return listaRegulatorioB1524Bean;
	}
	
		
	/**
	 * Generacion del reporte para SOFIPO
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List<RegulatorioB1524Bean> reporteRegulatorioB1524XLSX_SOFIPO(int tipoLista,RegulatorioB1524Bean reporteBean,  HttpServletResponse response) throws IOException
	{
		List<RegulatorioB1524Bean> listaRegulatorioB1524Bean = null;
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		
		anio			= reporteBean.getAnio();
		mesEnLetras		= RegulatorioInsServicio.descripcionMes(reporteBean.getMes());
		nombreArchivo 	= "R15_B_1524_"+mesEnLetras+"_"+anio; 
		
		listaRegulatorioB1524Bean = regulatorioB1524DAO.reporteRegulatorioB1524SOFIPO(reporteBean,tipoLista);
		int contador = 1;
		
		if(listaRegulatorioB1524Bean != null){
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
				hoja = (SXSSFSheet) libro.createSheet("B 1524");
				
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
				            2  //ultima celda   (0-based)
				    ));
					
					
					celda = fila.createCell((short)3);
					celda.setCellValue("SECCIÓN IDENTIFICADOR DEL SERVICIO PROPORCIONADO A TRAVÉS DEL MEDIO ELECTRÓNICO");
					celda.setCellStyle(estiloAgrupacion);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            3, //primer celda (0-based)
				            4 //ultima celda   (0-based)
				    ));
					
					celda = fila.createCell((short)5);
					celda.setCellValue("SECCIÓN DE DATOS DE CLIENTES");
					celda.setCellStyle(estiloAgrupacion);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            5, //primer celda (0-based)
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
					celda.setCellValue("SERVICIOS PROPORCIONADOS A TRAVÉS DE MEDIOS ELECTRÓNICOS");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)4);
					celda.setCellValue("PERSONALIDAD JURÍDICA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)5);
					celda.setCellValue("TIPO DE CLIENTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)6);
					celda.setCellValue("NÚMERO DE CLIENTES");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)7);
					celda.setCellValue("NÚMERO DE PERSONAS FACULTADAS");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)8);
					celda.setCellValue("NÚMERO DE CLIENTES QUE OPERARON / NÚMERO DE PERSONAS FACULTADAS QUE OPERARON");
					celda.setCellStyle(estiloEncabezado);
					
			
					
					int rowExcel=2;
					contador=2;
					RegulatorioB1524Bean regRegulatorioB1524Bean = null;
					
					for(int x = 0; x< listaRegulatorioB1524Bean.size() ; x++ ){
						
											
						
						fila=hoja.createRow(rowExcel);
								
						celda=fila.createCell((short)0);
						celda.setCellValue(listaRegulatorioB1524Bean.get(x).getPeriodo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)1);
						celda.setCellValue(listaRegulatorioB1524Bean.get(x).getClaveEntidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)2);
						celda.setCellValue(listaRegulatorioB1524Bean.get(x).getNumReporte());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)3);
						celda.setCellValue(listaRegulatorioB1524Bean.get(x).getServicios());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)4);
						celda.setCellValue(listaRegulatorioB1524Bean.get(x).getPersJuridica());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)5);
						celda.setCellValue(listaRegulatorioB1524Bean.get(x).getTipoCliente());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)6);
						celda.setCellValue(listaRegulatorioB1524Bean.get(x).getNumClientes());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)7);
						celda.setCellValue(listaRegulatorioB1524Bean.get(x).getNumFacultadas());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)8);
						celda.setCellValue(listaRegulatorioB1524Bean.get(x).getNumOperaron());
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
		return listaRegulatorioB1524Bean;
	}


	public RegulatorioB1524DAO getRegulatorioB1524DAO() {
		return regulatorioB1524DAO;
	}


	public void setRegulatorioB1524DAO(RegulatorioB1524DAO regulatorioB1524DAO) {
		this.regulatorioB1524DAO = regulatorioB1524DAO;
	}
	
	

}
