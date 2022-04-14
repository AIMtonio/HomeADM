
package regulatorios.servicio;
import general.servicio.BaseServicio;
import herramientas.Utileria;

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
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;

import regulatorios.bean.RegulatorioB2421Bean;
import regulatorios.dao.RegulatorioB2421DAO;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;


public class RegulatorioB2421Servicio  extends BaseServicio{
	RegulatorioB2421DAO regulatorioB2421DAO = null;	
	
    String[] meses = {"","ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"};
	
	public RegulatorioB2421Servicio() {
		super();
	}
 
	
	/* ================== Tipo de Lista para reportes regulatorios ============== */
	public static interface Enum_Lis_RegulatorioB2421{
		int excel	 = 1;
		int csv		 = 2;
	}	

	/* ============ case para listas de reportes regulatorios ===============*/
	public List <RegulatorioB2421Bean>listaReporteRegulatorioB2421(int tipoLista, int tipoEntidad, RegulatorioB2421Bean reporteBean, HttpServletResponse response){
		List<RegulatorioB2421Bean> listaReportes=null;
		
		/*SOCAP*/
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			switch(tipoLista){
				case Enum_Lis_RegulatorioB2421.excel:
					listaReportes = reporteRegulatorioB2421XLSX_SOCAP(Enum_Lis_TipoReporte.excel, reporteBean, response); 
					break;
				case Enum_Lis_RegulatorioB2421.csv:
					listaReportes = generarReporteRegulatorioB2421(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
		/*SOFIPO*/
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch(tipoLista){
				case Enum_Lis_RegulatorioB2421.excel:
					listaReportes = reporteRegulatorioB2421XLSX_SOFIPO(Enum_Lis_TipoReporte.excel, reporteBean, response); 
					break;
				case Enum_Lis_RegulatorioB2421.csv:
					listaReportes = generarReporteRegulatorioB2421(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
	
		return listaReportes;
	}
		
	
	private List<RegulatorioB2421Bean> reporteRegulatorioB2421XLSX_SOCAP(
			int tipoLista, RegulatorioB2421Bean reporteBean,
			HttpServletResponse response) {
		
		List<RegulatorioB2421Bean> listaRegulatorioB2421Bean = null;
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		
		nombreArchivo 	= "R24_B_2421_"+descripcionMes(reporteBean.getPeriodo())+"_"+reporteBean.getAnio(); 
		
		listaRegulatorioB2421Bean = regulatorioB2421DAO.reporteRegulatorioB2421Sofipo(reporteBean,tipoLista);
		int contador = 1;
		
		if(listaRegulatorioB2421Bean != null){
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
				estilo8.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estilo8.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estilo8.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estilo8.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				
				//Estilo Formato Tasa (0.0000)
				CellStyle estiloFormatoTasa = libro.createCellStyle();
				DataFormat format = libro.createDataFormat();
				estiloFormatoTasa.setDataFormat(format.getFormat("0.0000"));
				estiloFormatoTasa.setFont(fuente8);
				
				//Encabezado agrupaciones
				CellStyle estiloAgrupacion = libro.createCellStyle();
				estiloAgrupacion.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloAgrupacion.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloAgrupacion.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setFont(fuenteNegrita8);
				estiloAgrupacion.setWrapText(true);
				estiloAgrupacion.setFillBackgroundColor(IndexedColors.GREY_40_PERCENT.getIndex());
				estiloAgrupacion.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
				
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
				
				
				//Estilo para una celda con dato con color de fondo gris
				CellStyle celdaGrisDato = libro.createCellStyle();
				celdaGrisDato.setFont(fuenteNegrita8);
				celdaGrisDato.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				celdaGrisDato.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				celdaGrisDato.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				celdaGrisDato.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setWrapText(true);
			
				CellStyle estiloDerecha = libro.createCellStyle();
				format = libro.createDataFormat();
				estiloDerecha.setFont(fuente8);
				estiloDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
				estiloDerecha.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setDataFormat(format.getFormat("$#,##0"));
				
				// Creacion de hoja
				SXSSFSheet hoja = null;
				hoja = (SXSSFSheet) libro.createSheet("B 2422");
				
				Row fila = hoja.createRow(0);
				Cell celda=fila.createCell((short)1);
				/////////////////////////////////////////////////////////////////////////////////////
				///////////////////////// FIN ENCABEZADO EXCEL //////////////////////////////////////
				//AGREGAR GRUPOS DE COLUMNAS
				//////////////////////////////////////////////////////////////////////////////
				
				celda = fila.createCell((short)0);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL REPORTE");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));
				
				
				celda = fila.createCell((short)3);
				celda.setCellValue("SECCIÓN UBICACIÓN GEOGRÁFICA");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            3, //primer celda (0-based)
			            6 //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)7);
				celda.setCellValue("SECCIÓN TIPO DE DATOS A REPORTAR");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            7, //primer celda (0-based)
			            12  //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)13);
				celda.setCellValue("SECCIÓN DATOS CAPTACIÓN");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            13, //primer celda (0-based)
			            13  //ultima celda   (0-based)
			    ));
				
				
				fila = hoja.createRow(1);
				celda=fila.createCell((short)0);
				celda.setCellValue("PERÍODO QUE SE REPORTA");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)1);
				celda.setCellValue("CLAVE DE LA ENTIDAD");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)2);
				celda.setCellValue("REPORTE");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)3);
				celda.setCellValue("LOCALIDAD DEL DOMICILIO ");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)4);
				celda.setCellValue("MUNICIPIO DEL DOMICILIO");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)5);
				celda.setCellValue("ESTADO DEL DOMICILIO ");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)6);
				celda.setCellValue("PAÍS DEL DOMICILIO");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)7);
				celda.setCellValue("FECHA DE CONTRATACIÓN");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)8);
				celda.setCellValue("CLASIFICACIÓN CONTABLE");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)9);
				celda.setCellValue("TIPO DE PRODUCTO DE OPERACIÓN ");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)10);
				celda.setCellValue("MONEDA");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)11);
				celda.setCellValue("PERSONALIDAD JURÍDICA");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)12);
				celda.setCellValue("GÉNERO");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)13);
				celda.setCellValue("SALDO DEL PRODUCTO DE CAPTACIÓN AL FINAL DEL PERIODO");
				celda.setCellStyle(estiloEncabezado);
				

					int rowExcel=2;
					contador=2;
					RegulatorioB2421Bean regRegulatorioB2421Bean = null;
					
					for(int x = 0; x< listaRegulatorioB2421Bean.size() ; x++ ){
						
											
						
						fila=hoja.createRow(rowExcel);
								
						celda=fila.createCell((short)0);
						celda.setCellValue(listaRegulatorioB2421Bean.get(x).getPeriodo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)1);
						celda.setCellValue(listaRegulatorioB2421Bean.get(x).getClaveEntidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)2);
						celda.setCellValue(listaRegulatorioB2421Bean.get(x).getSubreporte());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)3);
						celda.setCellValue(listaRegulatorioB2421Bean.get(x).getLocalidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)4);
						celda.setCellValue(Utileria.convierteEntero(listaRegulatorioB2421Bean.get(x).getMunicipio()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)5);
						celda.setCellValue(Utileria.convierteEntero(listaRegulatorioB2421Bean.get(x).getEstado()));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)6);
						celda.setCellValue(Utileria.convierteEntero(listaRegulatorioB2421Bean.get(x).getPais()));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)7);
						celda.setCellValue(listaRegulatorioB2421Bean.get(x).getFechaContratacion());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)8);
						celda.setCellValue(listaRegulatorioB2421Bean.get(x).getClasfContable());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)9);
						celda.setCellValue(listaRegulatorioB2421Bean.get(x).getTipoProducto());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)10);
						celda.setCellValue(listaRegulatorioB2421Bean.get(x).getMoneda());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)11);
						celda.setCellValue(listaRegulatorioB2421Bean.get(x).getPersJuridica());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)12);
						celda.setCellValue(listaRegulatorioB2421Bean.get(x).getGenero());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)13);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioB2421Bean.get(x).getSaldoFinal()));
						celda.setCellStyle(estiloDerecha);
						

						
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
		return listaRegulatorioB2421Bean;
	}


	private List<RegulatorioB2421Bean> reporteRegulatorioB2421XLSX_SOFIPO(
			int tipoLista, RegulatorioB2421Bean reporteBean,
			HttpServletResponse response) {
		
		List<RegulatorioB2421Bean> listaRegulatorioB2421Bean = null;
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		
		nombreArchivo 	= "R24_B_2421_"+descripcionMes(reporteBean.getPeriodo())+"_"+reporteBean.getAnio(); 
		
		listaRegulatorioB2421Bean = regulatorioB2421DAO.reporteRegulatorioB2421Sofipo(reporteBean,tipoLista);
		int contador = 1;
		
		if(listaRegulatorioB2421Bean != null){
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
				estilo8.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estilo8.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estilo8.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estilo8.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				
				//Estilo Formato Tasa (0.0000)
				CellStyle estiloFormatoTasa = libro.createCellStyle();
				DataFormat format = libro.createDataFormat();
				estiloFormatoTasa.setDataFormat(format.getFormat("0.0000"));
				estiloFormatoTasa.setFont(fuente8);
				
				//Encabezado agrupaciones
				CellStyle estiloAgrupacion = libro.createCellStyle();
				estiloAgrupacion.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloAgrupacion.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloAgrupacion.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setFont(fuenteNegrita8);
				estiloAgrupacion.setWrapText(true);
				estiloAgrupacion.setFillBackgroundColor(IndexedColors.GREY_40_PERCENT.getIndex());
				estiloAgrupacion.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
				
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
				
				
				//Estilo para una celda con dato con color de fondo gris
				CellStyle celdaGrisDato = libro.createCellStyle();
				celdaGrisDato.setFont(fuenteNegrita8);
				celdaGrisDato.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				celdaGrisDato.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				celdaGrisDato.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				celdaGrisDato.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setWrapText(true);
			
				CellStyle estiloDerecha = libro.createCellStyle();
				format = libro.createDataFormat();
				estiloDerecha.setFont(fuente8);
				estiloDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
				estiloDerecha.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setDataFormat(format.getFormat("$#,##0"));
				
				// Creacion de hoja
				SXSSFSheet hoja = null;
				hoja = (SXSSFSheet) libro.createSheet("B 2422");
				
				Row fila = hoja.createRow(0);
				Cell celda=fila.createCell((short)1);
				/////////////////////////////////////////////////////////////////////////////////////
				///////////////////////// FIN ENCABEZADO EXCEL //////////////////////////////////////
				//AGREGAR GRUPOS DE COLUMNAS
				//////////////////////////////////////////////////////////////////////////////
				
				celda = fila.createCell((short)0);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL REPORTE");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));
				
				
				celda = fila.createCell((short)3);
				celda.setCellValue("SECCIÓN UBICACIÓN GEOGRÁFICA");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            3, //primer celda (0-based)
			            6 //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)7);
				celda.setCellValue("SECCIÓN TIPO DE DATOS A REPORTAR");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            7, //primer celda (0-based)
			            12  //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)13);
				celda.setCellValue("SECCIÓN DATOS CAPTACIÓN");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            13, //primer celda (0-based)
			            13  //ultima celda   (0-based)
			    ));
				
				
				fila = hoja.createRow(1);
				celda=fila.createCell((short)0);
				celda.setCellValue("PERÍODO QUE SE REPORTA");
				celda.setCellStyle(estiloEncabezado);

				celda=fila.createCell((short)1);
				celda.setCellValue("CLAVE DE LA ENTIDAD");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)2);
				celda.setCellValue("REPORTE");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)3);
				celda.setCellValue("LOCALIDAD DEL DOMICILIO ");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)4);
				celda.setCellValue("MUNICIPIO DEL DOMICILIO");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)5);
				celda.setCellValue("ESTADO DEL DOMICILIO ");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)6);
				celda.setCellValue("PAÍS DEL DOMICILIO");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)7);
				celda.setCellValue("FECHA DE CONTRATACIÓN");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)8);
				celda.setCellValue("CLASIFICACIÓN CONTABLE");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)9);
				celda.setCellValue("TIPO DE PRODUCTO DE OPERACIÓN ");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)10);
				celda.setCellValue("MONEDA");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)11);
				celda.setCellValue("PERSONALIDAD JURÍDICA");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)12);
				celda.setCellValue("GÉNERO");
				celda.setCellStyle(estiloEncabezado);
				
				celda=fila.createCell((short)13);
				celda.setCellValue("SALDO DEL PRODUCTO DE CAPTACIÓN AL FINAL DEL PERIODO");
				celda.setCellStyle(estiloEncabezado);
				

					int rowExcel=2;
					contador=2;
					RegulatorioB2421Bean regRegulatorioB2421Bean = null;
					
					for(int x = 0; x< listaRegulatorioB2421Bean.size() ; x++ ){						
						
						fila=hoja.createRow(rowExcel);
								
						celda=fila.createCell((short)0);
						celda.setCellValue(listaRegulatorioB2421Bean.get(x).getPeriodo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)1);
						celda.setCellValue(listaRegulatorioB2421Bean.get(x).getClaveEntidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)2);
						celda.setCellValue(listaRegulatorioB2421Bean.get(x).getSubreporte());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)3);
						celda.setCellValue(listaRegulatorioB2421Bean.get(x).getLocalidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)4);
						celda.setCellValue(Utileria.convierteEntero(listaRegulatorioB2421Bean.get(x).getMunicipio()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)5);
						celda.setCellValue(Utileria.convierteEntero(listaRegulatorioB2421Bean.get(x).getEstado()));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)6);
						celda.setCellValue(Utileria.convierteEntero(listaRegulatorioB2421Bean.get(x).getPais()));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)7);
						celda.setCellValue(listaRegulatorioB2421Bean.get(x).getFechaContratacion());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)8);
						celda.setCellValue(listaRegulatorioB2421Bean.get(x).getClasfContable());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)9);
						celda.setCellValue(listaRegulatorioB2421Bean.get(x).getTipoProducto());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)10);
						celda.setCellValue(listaRegulatorioB2421Bean.get(x).getMoneda());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)11);
						celda.setCellValue(listaRegulatorioB2421Bean.get(x).getPersJuridica());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)12);
						celda.setCellValue(listaRegulatorioB2421Bean.get(x).getGenero());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)13);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioB2421Bean.get(x).getSaldoFinal()));
						celda.setCellStyle(estiloDerecha);
							
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
		return listaRegulatorioB2421Bean;
		
		
	}


	/* ======================================  FUNCIONES PARA GENERAR REPORTES CSV  ========================================*/	
	
	private List generarReporteRegulatorioB2421(RegulatorioB2421Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = regulatorioB2421DAO.reporteRegulatorioB2421Csv(reporteBean, tipoReporte);
		nombreArchivo="R24_B2421_"+descripcionMes(reporteBean.getPeriodo())+"_"+reporteBean.getAnio()+".csv"; 
		// se inicia seccion para pintar el archivo csv
		try{
			RegulatorioB2421Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioB2421Bean) listaBeans.get(i);
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
	
	public String descripcionMes(String periodo){
		String mes = "";
		int mese = Integer.parseInt(periodo);
        switch (mese) {
            case 1:  mes ="MARZO" ; break;
            case 2:  mes ="JUNIO"; break;
            case 3:  mes ="SEPTIEMBRE"; break;
            case 4:  mes ="DICIEMBRE"; break;
     
        }
        return mes;
	}
	/* ========================= GET  &&  SET  =========================*/
	
	
	public String[] getMeses() {
		return meses;
	}

	public RegulatorioB2421DAO getRegulatorioB2421DAO() {
		return regulatorioB2421DAO;
	}


	public void setRegulatorioB2421DAO(RegulatorioB2421DAO regulatorioB2421DAO) {
		this.regulatorioB2421DAO = regulatorioB2421DAO;
	}


	public void setMeses(String[] meses) {
		this.meses = meses;
	}
	

	
		
}
