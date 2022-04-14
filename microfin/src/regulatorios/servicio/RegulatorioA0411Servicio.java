package regulatorios.servicio;

import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;


import regulatorios.bean.CarteraPorTipoA0411Bean;
import regulatorios.dao.RegulatorioA0411DAO;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;



public class RegulatorioA0411Servicio extends BaseServicio {
	
RegulatorioA0411DAO regulatorioA0411DAO = null;	
	
	
	public RegulatorioA0411Servicio() {
		super();
	}
	
	// List para reportes Regulatorios Cartera
	public static interface Enum_Lis_CredRepReg {
		int A0411RepEx = 1;
		int A0411RepEx2013 = 2;
		int A0411RepCsv = 3;
	}
		
	
	/* ============ case para listas de reportes regulatorios ===============*/
	public List <CarteraPorTipoA0411Bean>listaReporteRegulatorioA0411(int tipoLista, int tipoEntidad, CarteraPorTipoA0411Bean reporteBean, HttpServletResponse response) throws IOException{
		List<CarteraPorTipoA0411Bean> listaReportes=null;
		/*SOCAP*/
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			switch(tipoLista){
	
					case Enum_Lis_CredRepReg.A0411RepEx:
					listaReportes = reporteRegulatorioA0411XLSX_SOCAP(tipoLista, reporteBean, response); 
					break;
				case Enum_Lis_CredRepReg.A0411RepEx2013:
					listaReportes = reporteRegulatorioA04112013XLSX_SOCAP(tipoLista, reporteBean, response); 
					break;
				case Enum_Lis_CredRepReg.A0411RepCsv: 
					listaReportes = generarReporteRegulatorioA0411(reporteBean, tipoLista, response); 
					break;		
			}
		}
		
		/*SOFIPO*/
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch(tipoLista){
				case Enum_Lis_TipoReporte.excel:
					listaReportes = reporteRegulatorioA0411XLSX_SOFIPO(Enum_Lis_TipoReporte.excel, reporteBean, response); 
					break;
				case Enum_Lis_TipoReporte.csv:
					listaReportes = generarReporteRegulatorioA0411Sofipo(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
		return listaReportes;
	}
	
	
/* ======================================  FUNCIONES PARA GENERAR REPORTES CSV  ========================================*/	
	
	private List generarReporteRegulatorioA0411(CarteraPorTipoA0411Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String mesEnLetras	= "";
		String anio		= "";
		String rutaArchivo = "",nombreArchivo="";
		List listaBeans = regulatorioA0411DAO.reporteRegulatorioA0411Csv(reporteBean, tipoReporte);
		
		mesEnLetras = RegulatorioInsServicio.descripcionMes(reporteBean.getFecha().substring(5,7));
		anio = reporteBean.getFecha().substring(0,4);
		
		nombreArchivo="R04_A0411"+mesEnLetras+" "+anio +".csv"; 
		// se inicia seccion para pintar el archivo csv
		try{
			CarteraPorTipoA0411Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (CarteraPorTipoA0411Bean) listaBeans.get(i);
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
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte regulatorio socap A0411: " + io.getMessage());
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
	public List<CarteraPorTipoA0411Bean> reporteRegulatorioA0411XLSX_SOCAP(int tipoLista,CarteraPorTipoA0411Bean reporteBean,  HttpServletResponse response) throws IOException
	{
		List<CarteraPorTipoA0411Bean> listaCartera = null;
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo		= "";
		
		mesEnLetras		= RegulatorioInsServicio.descripcionMes(reporteBean.getFecha().substring(5,7));
		anio = reporteBean.getFecha().substring(0,4);
		nombreArchivo 	= "R04_A_0411_"+mesEnLetras+"_"+anio; 
		
		listaCartera = regulatorioA0411DAO.reporteRegulatorioA0411Socap2014(reporteBean,tipoLista);
		int regExport = 0;
		
		if(listaCartera != null){

			try {
			XSSFWorkbook libro = new XSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			fuenteNegrita10.setFontName("Arial");
			
			//Crea un Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)10);
			fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			fuenteNegrita8.setFontName("Arial");
			
			//Crea un Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFFont fuente8= libro.createFont();
			fuente8.setFontHeightInPoints((short)10);
			fuente8.setFontName("Arial");
		
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			XSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
		
			//Estilo negrita de 8  para encabezados del reporte
			XSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
		
			//Estilo de 8  para Contenido
			XSSFCellStyle estilo8 = libro.createCellStyle();
			estilo8.setFont(fuente8);
		
			// Creacion de hoja
			XSSFSheet hoja = libro.createSheet("Reporte de Cartera por Tipo A-0411");
			XSSFRow fila= hoja.createRow(0);
			fila = hoja.createRow(1);
			fila = hoja.createRow(2);
		
			XSSFCell celda=fila.createCell((short)1);
			celda.setCellStyle(estiloNeg10);
		
			celda.setCellValue("REPORTE DE CARTERA POR TIPO (A-0411) AL "+reporteBean.getFecha());
		
			// Creacion de fila
			fila = hoja.createRow(3);
			fila = hoja.createRow(4);
			
			//Inicio en la segunda fila y que el fila uno tiene los encabezados
			celda = fila.createCell((short)0);
			celda.setCellValue("Clave Concepto");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)1);
			celda.setCellValue("Descripción");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("Total Vigente");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)3);
			celda.setCellValue("Principal Vigente");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Interés Vigente");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)5);
			celda.setCellValue("Total Sin Pago Vencido");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)6);
			celda.setCellValue("Principal sin Pago Vencido");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)7);
			celda.setCellValue("Interés sin Pago Vencido");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Total con Pago Vencido.");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)9);
			celda.setCellValue("Principal con Pago Vencido.");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Interés con Pago Vencido.");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)11);
			celda.setCellValue("Total Vencido.");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)12);
			celda.setCellValue("Principal Vencido.");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)13);
			celda.setCellValue("Interés Vencido.");
			celda.setCellStyle(estiloNeg8);
		
			int i=7;
			for(CarteraPorTipoA0411Bean A0411Bean : listaCartera ){

					fila=hoja.createRow(i);
					celda=fila.createCell((short)0);
					celda.setCellValue(A0411Bean.getClaveConcepto());
					celda.setCellStyle(estilo8);
					if(A0411Bean.getTipoConcepto().equals("2")){
						celda.setCellStyle(estiloNeg8);
					}
					celda=fila.createCell((short)1);
					celda.setCellValue(A0411Bean.getDescripcion());
					celda.setCellStyle(estilo8);
					if(A0411Bean.getTipoConcepto().equals("2")){
						celda.setCellStyle(estiloNeg8);
					}
					
					celda=fila.createCell((short)2);
					celda.setCellValue(Double.parseDouble(A0411Bean.getTotalVigente()));
					celda.setCellStyle(estilo8);
					if(A0411Bean.getTipoConcepto().equals("2")){
						celda.setCellStyle(estiloNeg8);
					}
					
					celda=fila.createCell((short)3);
					celda.setCellValue(Double.parseDouble(A0411Bean.getPrincipalVigente()));
					celda.setCellStyle(estilo8);
					if(A0411Bean.getTipoConcepto().equals("2")){
						celda.setCellStyle(estiloNeg8);
					}
					
					celda=fila.createCell((short)4);
					celda.setCellValue(Double.parseDouble(A0411Bean.getInteresVigente()));
					celda.setCellStyle(estilo8);
					if(A0411Bean.getTipoConcepto().equals("2")){
						celda.setCellStyle(estiloNeg8);
					}
					
					celda=fila.createCell((short)5);
					celda.setCellValue(Double.parseDouble(A0411Bean.getTotSinPagVencido()));
					celda.setCellStyle(estilo8);
					if(A0411Bean.getTipoConcepto().equals("2")){
						celda.setCellStyle(estiloNeg8);
					}
					
					celda=fila.createCell((short)6);
					celda.setCellValue(Double.parseDouble(A0411Bean.getPrinSinPagVencido()));
					celda.setCellStyle(estilo8);
					if(A0411Bean.getTipoConcepto().equals("2")){
						celda.setCellStyle(estiloNeg8);
					}
					
					celda=fila.createCell((short)7);
					celda.setCellValue(Double.parseDouble(A0411Bean.getInterSinPagVencido()));
					celda.setCellStyle(estilo8);
					if(A0411Bean.getTipoConcepto().equals("2")){
						celda.setCellStyle(estiloNeg8);
					}
					
					celda=fila.createCell((short)8);
					celda.setCellValue(Double.parseDouble(A0411Bean.getTotConPagVencido()));
					celda.setCellStyle(estilo8);
					if(A0411Bean.getTipoConcepto().equals("2")){
						celda.setCellStyle(estiloNeg8);
					}
					
					celda=fila.createCell((short)9);
					celda.setCellValue(Double.parseDouble(A0411Bean.getPrinConPagVencido()));
					celda.setCellStyle(estilo8);
					if(A0411Bean.getTipoConcepto().equals("2")){
						celda.setCellStyle(estiloNeg8);
					}
					
					celda=fila.createCell((short)10);
					celda.setCellValue(Double.parseDouble(A0411Bean.getInterConPagVencido()));
					celda.setCellStyle(estilo8);
					if(A0411Bean.getTipoConcepto().equals("2")){
						celda.setCellStyle(estiloNeg8);
					}
					
					celda=fila.createCell((short)11);
					celda.setCellValue(Double.parseDouble(A0411Bean.getTotalVencido()));
					celda.setCellStyle(estilo8);
					if(A0411Bean.getTipoConcepto().equals("2")){
						celda.setCellStyle(estiloNeg8);
					}
					
					celda=fila.createCell((short)12);
					celda.setCellValue(Double.parseDouble(A0411Bean.getPrincipalVencido()));
					celda.setCellStyle(estilo8);
					if(A0411Bean.getTipoConcepto().equals("2")){
						celda.setCellStyle(estiloNeg8);
					}
					
					celda=fila.createCell((short)13);
					celda.setCellValue(Double.parseDouble(A0411Bean.getInteresVencido()));
					celda.setCellStyle(estilo8);
					if(A0411Bean.getTipoConcepto().equals("2")){
						celda.setCellStyle(estiloNeg8);
					}
					
				i++;
			}
		
			i = i+2;
			fila=hoja.createRow(i);
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg8);
			
			for(CarteraPorTipoA0411Bean A0411Bean : listaCartera ){			
				regExport = regExport+1;
			}
			
			i = i+1;
			fila=hoja.createRow(i);
			celda=fila.createCell((short)0);
			celda.setCellValue(regExport);
			
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
									
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteCarteraTipoCredA0411.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
			}catch(Exception e){
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte regulatorio socap A0411(2014): " + e.getMessage());
				e.printStackTrace();
			}
		}
		return  listaCartera;
	}
	
	// Reporte de saldos capital de credito en excel A0411 2013
	public List <CarteraPorTipoA0411Bean> reporteRegulatorioA04112013XLSX_SOCAP(int tipoLista,CarteraPorTipoA0411Bean cartera,  HttpServletResponse response){
		List<CarteraPorTipoA0411Bean> listaCartera2013=null;
		String mesEnLetras	= "";
		String anio		= "";
		String nombreArchivo = "";
	
		
		mesEnLetras		= RegulatorioInsServicio.descripcionMes(cartera.getFecha().substring(5,7));
		anio = cartera.getFecha().substring(0,4);
		nombreArchivo 	= "R04_A_0411_"+mesEnLetras+"_"+anio; 
		
		listaCartera2013 = regulatorioA0411DAO.reporteRegulatorioA0411Socap2013(cartera,tipoLista);
		
		
	if(listaCartera2013 != null){

		try {
			XSSFWorkbook libro = new XSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			fuenteNegrita10.setFontName("Arial");
			
			//Crea un Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)10);
			fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			fuenteNegrita8.setFontName("Arial");
			
			//Crea un Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFFont fuente8= libro.createFont();
			fuente8.setFontHeightInPoints((short)10);
			fuente8.setFontName("Arial");
			
			//Estilo negrita de 10  para encabezados del reporte
			XSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			//Estilo de 10  para Contenido
			XSSFCellStyle estilo8 = libro.createCellStyle();
			estilo8.setFont(fuente8);
			estilo8.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
			estilo8.setVerticalAlignment((short)XSSFCellStyle.ALIGN_LEFT);
			
			//Estilo Formato decimal (0.00)
			XSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			XSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("#,##0.00"));
			estiloFormatoDecimal.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
			
			//Estilo tamaño 10 alineado a la izquierda
			XSSFCellStyle estiloSubtitulo = libro.createCellStyle();
			estiloSubtitulo.setFont(fuenteNegrita8);
			estiloSubtitulo.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
			
			// Creacion de hoja
			XSSFSheet hoja = libro.createSheet("Cart Tipo Prom Int R 04 A 0411");
			XSSFRow fila= hoja.createRow(0);
			fila = hoja.createRow(0);
			
			//Estilo negrita tamaño 10 centrado
			XSSFCellStyle estiloEncabezado = libro.createCellStyle();
			estiloEncabezado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			estiloEncabezado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			estiloEncabezado.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setFont(fuenteNegrita8);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo tamaño 10 alineado a la derecha
			XSSFCellStyle estiloTitulo = libro.createCellStyle();
			estiloTitulo.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
			estiloTitulo.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			estiloTitulo.setFont(fuenteNegrita10);
			
			
			XSSFCell celda=fila.createCell((short)0);
			celda.setCellValue("Reporte Regulatorio Cartera por Tipo de Crédito");
			celda.setCellStyle(estiloTitulo);
			
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            0, //primera fila (0-based)
		            0, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            5  //ultima celda   (0-based)
		    ));
			
			fila= hoja.createRow(1);							
			celda = fila.createCell((short)0);
			celda.setCellValue("Subreporte: Cartera por Tipo de Crédito");
			celda.setCellStyle(estiloTitulo);	

			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            1, //primera fila (0-based)
		            1, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            5  //ultima celda   (0-based)
		    ));
			
			fila = hoja.createRow(2);
			celda = fila.createCell((short)0);
			celda.setCellValue("R04 A 0411");
			celda.setCellStyle(estiloTitulo);	
	
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            5  //ultima celda   (0-based)
		    ));
			
			fila = hoja.createRow(3);
			celda = fila.createCell((short)0);
			celda.setCellValue("Subreporte: Cartera por Tipo de Crédito");
			celda.setCellStyle(estiloSubtitulo);
			
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            3, //primera fila (0-based)
		            3, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            4  //ultima celda   (0-based)
		    ));
			
			fila = hoja.createRow(4);
			celda = fila.createCell((short)0);
			celda.setCellValue("Incluye: Moneda Nacional y Udis Valorizadas en Pesos");
			celda.setCellStyle(estiloSubtitulo);	
			
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            4, //primera fila (0-based)
		            4, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            4  //ultima celda   (0-based)
		    ));
			
			fila = hoja.createRow(5);
			celda = fila.createCell((short)0);
			celda.setCellValue("Cifras en Pesos");
			celda.setCellStyle(estiloSubtitulo);
			
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            5, //primera fila (0-based)
		            5, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            4  //ultima celda   (0-based)
		    ));
			
			//Inicio en la segunda fila y que el fila uno tiene los encabezados
			fila = hoja.createRow(7);
			celda = fila.createCell((short)0);
			celda.setCellValue("Concepto");
			celda.setCellStyle(estiloEncabezado);
			hoja.addMergedRegion(new CellRangeAddress(
		            7, //primera fila (0-based)
		            7, //ultima fila  (0-based)
		            0, //primer celda (0-based)
		            0  //ultima celda   (0-based)
		    ));
			
			celda = fila.createCell((short)1);
			celda.setCellValue("Saldo del Capital \nal Cierre del Mes \n(a)");
			celda.setCellStyle(estiloEncabezado);
			hoja.addMergedRegion(new CellRangeAddress(
		            7, //primera fila (0-based)
		            7, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            1  //ultima celda   (0-based)
		    ));
			
			celda = fila.createCell((short)2);
			celda.setCellValue("Saldo  de los \nIntereses \nDevengados no \nCobrados al \nCierre del Mes \n(b)");
			celda.setCellStyle(estiloEncabezado);
			hoja.addMergedRegion(new CellRangeAddress(
		            7, //primera fila (0-based)
		            7, //ultima fila  (0-based)
		            2, //primer celda (0-based)
		            2  //ultima celda   (0-based)
		    ));
			
			celda = fila.createCell((short)3);
			celda.setCellValue("Saldo total al \nCierre del mes\n(c) = a + b");
			celda.setCellStyle(estiloEncabezado);
			hoja.addMergedRegion(new CellRangeAddress(
		            7, //primera fila (0-based)
		            7, //ultima fila  (0-based)
		            2, //primer celda (0-based)
		            2  //ultima celda   (0-based)
		    ));
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Intereses del Mes */");
			celda.setCellStyle(estiloEncabezado);
			hoja.addMergedRegion(new CellRangeAddress(
		            7, //primera fila (0-based)
		            7, //ultima fila  (0-based)
		            2, //primer celda (0-based)
		            2  //ultima celda   (0-based)
		    ));
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Comisiones del Mes */");
			celda.setCellStyle(estiloEncabezado);
			hoja.addMergedRegion(new CellRangeAddress(
		            7, //primera fila (0-based)
		            7, //ultima fila  (0-based)
		            2, //primer celda (0-based)
		            2  //ultima celda   (0-based)
		    ));
			
			
			fila = hoja.createRow(8);
			
			int i=9;		
			for(CarteraPorTipoA0411Bean A0411Bean : listaCartera2013 ){
	
				fila=hoja.createRow(i);
				celda=fila.createCell((short)0);
				celda.setCellValue(A0411Bean.getDescripcion());
				if(A0411Bean.getNegrita().equals(Constantes.STRING_SI)){
					celda.setCellStyle(estiloNeg8);
				}else{
					celda.setCellStyle(estilo8);
				}
				
				celda=fila.createCell((short)1);
				celda.setCellValue(Utileria.convierteDoble(A0411Bean.getSaldoCapital()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)2);
				celda.setCellValue(Utileria.convierteDoble(A0411Bean.getSaldoInteres()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)3);
				celda.setCellValue(Utileria.convierteDoble(A0411Bean.getSaldoTotal()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)4);
				celda.setCellValue(Utileria.convierteDoble(A0411Bean.getInteresMes()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)5);
				celda.setCellValue(Utileria.convierteDoble(A0411Bean.getComisionMes()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				i++;
			}
			
			
			hoja.autoSizeColumn((short)0);
			hoja.autoSizeColumn((short)1);
			hoja.autoSizeColumn((short)2);
			hoja.autoSizeColumn((short)3);
			hoja.autoSizeColumn((short)4);
			hoja.autoSizeColumn((short)5);
			hoja.autoSizeColumn((short)6);
			
			fila=hoja.createRow(70);			
			celda=fila.createCell((short)0);
			celda.setCellValue("*/ Se refiere a los montos de los intereses y comisiones cobrados en el mes por concepto de cartera de crédito, y registrados en los conceptos de resultados.");	
			celda.setCellStyle(estilo8);
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
		
		}catch(Exception e){
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte regulatorio socap A0411(2013): " + e.getMessage());
			e.printStackTrace();
		}
	}
	return listaCartera2013;
}
		
	/**
	 * Generacion del reporte para SOFIPO
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List<CarteraPorTipoA0411Bean> reporteRegulatorioA0411XLSX_SOFIPO(int tipoLista,CarteraPorTipoA0411Bean reporteBean,  HttpServletResponse response) throws IOException
	{
		List<CarteraPorTipoA0411Bean> listaRegulatorioA0411Bean = null;
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		mesEnLetras		= RegulatorioInsServicio.descripcionMes(reporteBean.getFecha().substring(5,7));
		anio = reporteBean.getFecha().substring(0,4);
		
		nombreArchivo 	= "R04_A_0411_"+mesEnLetras+"_"+anio; 
		
		listaRegulatorioA0411Bean = regulatorioA0411DAO.reporteRegulatorioA2610Sofipo(reporteBean,tipoLista);
		
		if(listaRegulatorioA0411Bean != null){
			try {
				
			XSSFWorkbook libro = new XSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 
			XSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Arial");
			fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			//Se crea una Fuente Negrita con tamaño 8 
			XSSFFont fuenteNegrita= libro.createFont();
			fuenteNegrita.setFontHeightInPoints((short)10);
			fuenteNegrita.setFontName("Arial");
			fuenteNegrita.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
			
			//Se crea una Fuente tamaño 10 
			XSSFFont fuentetamanio10= libro.createFont();
			fuentetamanio10.setFontHeightInPoints((short)10);
			fuentetamanio10.setFontName("Arial");
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo tamaño 10 alineado a la derecha
			XSSFCellStyle estiloTituloDer = libro.createCellStyle();
			estiloTituloDer.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
			estiloTituloDer.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			estiloTituloDer.setFont(fuenteNegrita10);
			
			//Estilo negrita tamaño 10
			XSSFCellStyle estiloEncabezado = libro.createCellStyle();
			estiloEncabezado.setFont(fuenteNegrita10);
			estiloEncabezado.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
			estiloEncabezado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			estiloEncabezado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			estiloEncabezado.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);

			//Estilo negrita tamaño 10
			XSSFCellStyle estiloEncabezadoIni = libro.createCellStyle();
			estiloEncabezadoIni.setFont(fuenteNegrita10);
			estiloEncabezadoIni.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			estiloEncabezadoIni.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			estiloEncabezadoIni.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezadoIni.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezadoIni.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
	
			//Estilo negrita tamaño 10
			XSSFCellStyle estiloEncabezadoLinDel = libro.createCellStyle();
			estiloEncabezadoLinDel.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
			estiloEncabezadoLinDel.setFont(fuenteNegrita10);
			estiloEncabezadoLinDel.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			estiloEncabezadoLinDel.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			estiloEncabezadoLinDel.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezadoLinDel.setBorderRight((short)XSSFCellStyle.BORDER_THIN);
			
			//Estilo negrita tamaño 10
			XSSFCellStyle estiloEncabezadoLin = libro.createCellStyle();
			estiloEncabezadoLin.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
			estiloEncabezadoLin.setFont(fuenteNegrita10);
			estiloEncabezadoLin.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			estiloEncabezadoLin.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			estiloEncabezadoLin.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezadoLin.setBorderRight((short)XSSFCellStyle.BORDER_THIN);
			estiloEncabezadoLin.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);

			//Estilo tamaño 10 alineado a la izquierda
			XSSFCellStyle estiloConceptos = libro.createCellStyle();
			estiloConceptos.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
			estiloConceptos.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloConceptos.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloConceptos.setFont(fuentetamanio10);
	
			//Estilo tamaño 10 alineado a la izquierda
			XSSFCellStyle estiloConceptosFin = libro.createCellStyle();
			estiloConceptosFin.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
			estiloConceptosFin.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloConceptosFin.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloConceptosFin.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloConceptosFin.setFont(fuentetamanio10);
			
			//Solo celda con borde inferior, izquierdo y derecho
			XSSFCellStyle estiloUltimaCelda = libro.createCellStyle();
			estiloUltimaCelda.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
			
			XSSFDataFormat format = libro.createDataFormat();
			XSSFCellStyle estiloSaldosDecimal = libro.createCellStyle();
			estiloSaldosDecimal.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
			estiloSaldosDecimal.setBorderRight((short)XSSFCellStyle.BORDER_THIN);
			estiloSaldosDecimal.setDataFormat(format.getFormat("#,##0.0000"));
			estiloSaldosDecimal.setFont(fuentetamanio10);
			
			XSSFCellStyle estiloSaldosDecimalFin = libro.createCellStyle();
			estiloSaldosDecimalFin.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
			estiloSaldosDecimalFin.setBorderRight((short)XSSFCellStyle.BORDER_THIN);
			estiloSaldosDecimalFin.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloSaldosDecimalFin.setDataFormat(format.getFormat("#,##0.0000"));
			estiloSaldosDecimalFin.setFont(fuentetamanio10);
			
			XSSFCellStyle estiloSaldosGrisDecimal = libro.createCellStyle();
			estiloSaldosGrisDecimal.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
			estiloSaldosGrisDecimal.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloSaldosGrisDecimal.setDataFormat(format.getFormat("#,##0.0000"));
			estiloSaldosGrisDecimal.setFont(fuentetamanio10);
			
			XSSFCellStyle estiloSaldosCenDecimal = libro.createCellStyle();
			estiloSaldosCenDecimal.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
			estiloSaldosCenDecimal.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloSaldosCenDecimal.setDataFormat(format.getFormat("#,##0.0000"));
			estiloSaldosCenDecimal.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloSaldosCenDecimal.setFont(fuentetamanio10);
			
			XSSFCellStyle estiloSaldosUltDecimal = libro.createCellStyle();
			estiloSaldosUltDecimal.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
			estiloSaldosUltDecimal.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloSaldosUltDecimal.setDataFormat(format.getFormat("#,##0.0000"));
			estiloSaldosUltDecimal.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloSaldosUltDecimal.setFont(fuentetamanio10);
			
			XSSFCellStyle estiloSaldosUltCenDecimal = libro.createCellStyle();
			estiloSaldosUltCenDecimal.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
			estiloSaldosUltCenDecimal.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloSaldosUltCenDecimal.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloSaldosUltCenDecimal.setDataFormat(format.getFormat("#,##0.0000"));
			estiloSaldosUltCenDecimal.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
			estiloSaldosUltCenDecimal.setFont(fuentetamanio10);		
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo tamaño 10 alineado a la derecha
			XSSFCellStyle estiloTituloIzq = libro.createCellStyle();
			estiloTituloIzq.setFont(fuenteNegrita);
			estiloTituloIzq.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
			
			// Creacion de hoja					
			XSSFSheet hoja = libro.createSheet("A 0411");	
			
			XSSFRow fila= hoja.createRow(0);
			XSSFCell celda=fila.createCell((short)1);
			celda.setCellValue("Sociedades Financieras Populares");
			celda.setCellStyle(estiloTituloDer);
			
			//funcion para unir celdas	
			hoja.addMergedRegion(new CellRangeAddress(
		            0, //primera fila (0-based)
		            0, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            21  //ultima celda   (0-based)
		    ));
			
			fila= hoja.createRow(1);
			celda=fila.createCell((short)1);
			hoja.addMergedRegion(new CellRangeAddress(1, 1, 1, 21));
			
			fila= hoja.createRow(2);
			celda=fila.createCell((short)1);
			celda.setCellValue("Serie R04 Cartera de crédito");
			celda.setCellStyle(estiloTituloDer);
			hoja.addMergedRegion(new CellRangeAddress(2, 2, 1, 21));
			
			fila= hoja.createRow(3);
			celda=fila.createCell((short)1);
			celda.setCellValue("Reporte A-0411 Cartera por tipo de crédito");
			celda.setCellStyle(estiloTituloDer);
			hoja.addMergedRegion(new CellRangeAddress(3, 3, 1, 21));
			
			fila= hoja.createRow(4);
			fila= hoja.createRow(5);
			celda=fila.createCell((short)1);
			celda.setCellValue("Incluye cifras en moneda nacional, moneda extranjera y UDIS valorizadas en pesos");
			celda.setCellStyle(estiloTituloIzq);
			hoja.addMergedRegion(new CellRangeAddress(5, 5, 1, 8));
			
			fila= hoja.createRow(6);
			celda=fila.createCell((short)1);
			celda.setCellValue("Cifras en pesos");
			celda.setCellStyle(estiloTituloIzq);
			hoja.addMergedRegion(new CellRangeAddress(6, 6, 1, 8));
			
			fila= hoja.createRow(7);
			fila= hoja.createRow(8);
			
			fila= hoja.createRow(9);
			celda=fila.createCell((short)1);
			celda.setCellValue("Concepto");
			celda.setCellStyle(estiloEncabezadoIni);
			hoja.addMergedRegion(new CellRangeAddress(9, 11, 1, 8));
			
			celda=fila.createCell((short)9);
			celda.setCellValue("Cartera Total");
			celda.setCellStyle(estiloEncabezadoIni);
			hoja.addMergedRegion(new CellRangeAddress(9, 11, 9, 9));
			
			celda=fila.createCell((short)10);
			celda.setCellValue("Cartera Vigente");
			celda.setCellStyle(estiloEncabezadoIni);
			hoja.addMergedRegion(new CellRangeAddress(9, 9, 10, 18));
			
			celda=fila.createCell((short)19);
			celda.setCellValue("Cartera Vencida");
			celda.setCellStyle(estiloEncabezadoIni);
			hoja.addMergedRegion(new CellRangeAddress(9, 9, 19, 21));
			
			celda=fila.createCell((short)22);	
			celda.setCellValue("");
			celda.setCellStyle(estiloUltimaCelda);
			
			fila= hoja.createRow(10);
			celda=fila.createCell((short)10);
			celda.setCellValue("Total Vigente");
			celda.setCellStyle(estiloEncabezadoIni);
			hoja.addMergedRegion(new CellRangeAddress(10, 10, 10, 12));
			
			celda=fila.createCell((short)13);
			celda.setCellValue("Créditos Sin Pagos Vencidos");
			celda.setCellStyle(estiloEncabezadoIni);
			hoja.addMergedRegion(new CellRangeAddress(10, 10, 13, 15));

			celda=fila.createCell((short)16);
			celda.setCellValue("Créditos Con Pagos Vencidos");
			celda.setCellStyle(estiloEncabezadoIni);
			hoja.addMergedRegion(new CellRangeAddress(10, 10, 16, 18));

			celda=fila.createCell((short)19);
			celda.setCellValue("Total");
			celda.setCellStyle(estiloEncabezadoLin);
			hoja.addMergedRegion(new CellRangeAddress(10, 11, 19, 19));
			
			celda=fila.createCell((short)20);
			celda.setCellValue("Principal");
			celda.setCellStyle(estiloEncabezadoLin);
			hoja.addMergedRegion(new CellRangeAddress(10, 11, 20, 20));
			
			celda=fila.createCell((short)21);
			celda.setCellValue("Intereses Devengados No Cobrados");
			celda.setCellStyle(estiloEncabezado);
			hoja.addMergedRegion(new CellRangeAddress(10, 11, 21, 21));
			
			fila= hoja.createRow(11);
			celda=fila.createCell((short)10);
			celda.setCellValue("Total");
			celda.setCellStyle(estiloEncabezadoLinDel);
			hoja.addMergedRegion(new CellRangeAddress(11, 11, 10, 10));
			
			celda=fila.createCell((short)11);
			celda.setCellValue("Principal");
			celda.setCellStyle(estiloEncabezadoLinDel);
			hoja.addMergedRegion(new CellRangeAddress(11, 11, 11, 11));
			
			celda=fila.createCell((short)12);
			celda.setCellValue("Intereses Devengados No Cobrados");
			celda.setCellStyle(estiloEncabezado);
			hoja.addMergedRegion(new CellRangeAddress(11, 11, 12, 12));
			
			celda=fila.createCell((short)13);
			celda.setCellValue("Total");
			celda.setCellStyle(estiloEncabezadoLinDel);
			hoja.addMergedRegion(new CellRangeAddress(11, 11, 13, 13));
			
			celda=fila.createCell((short)14);
			celda.setCellValue("Principal");
			celda.setCellStyle(estiloEncabezadoLinDel);
			hoja.addMergedRegion(new CellRangeAddress(11, 11, 14, 14));
			
			celda=fila.createCell((short)15);
			celda.setCellValue("Intereses Devengados No Cobrados");
			celda.setCellStyle(estiloEncabezado);
			hoja.addMergedRegion(new CellRangeAddress(11, 11, 15, 15));
			
			celda=fila.createCell((short)16);
			celda.setCellValue("Total");
			celda.setCellStyle(estiloEncabezadoLinDel);
			hoja.addMergedRegion(new CellRangeAddress(11, 11, 16, 16));
			
			celda=fila.createCell((short)17);
			celda.setCellValue("Principal");
			celda.setCellStyle(estiloEncabezadoLinDel);
			hoja.addMergedRegion(new CellRangeAddress(11, 11, 17, 17));
			
			celda=fila.createCell((short)18);
			celda.setCellValue("Intereses Devengados No Cobrados");
			celda.setCellStyle(estiloEncabezado);
			hoja.addMergedRegion(new CellRangeAddress(11, 11, 18, 18));
					
			int rowExcel = 12;
			int contador = 0;
			int limite= listaRegulatorioA0411Bean.size() -1;
						
			for(int x = 0; x< listaRegulatorioA0411Bean.size() ; x++ ){
				
				fila=hoja.createRow(rowExcel);

				if(contador==limite){
					celda=fila.createCell((short)1);
					celda.setCellValue(listaRegulatorioA0411Bean.get(x).getDescripcion());
					celda.setCellStyle(estiloConceptosFin);
					hoja.addMergedRegion(new CellRangeAddress(rowExcel, rowExcel, 1, 8));
					
					celda=fila.createCell((short)9);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getCarTotal()));
					celda.setCellStyle(estiloSaldosUltCenDecimal);
					
					celda=fila.createCell((short)10);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getToTalVigente()));
					celda.setCellStyle(estiloSaldosDecimalFin);
					
					celda=fila.createCell((short)11);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getPrincipalVigen()));
					celda.setCellStyle(estiloSaldosDecimalFin);
					
					celda=fila.createCell((short)12);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getInteresesVigen()));
					celda.setCellStyle(estiloSaldosUltDecimal);
					
					celda=fila.createCell((short)13);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getCredSinPagVen()));
					celda.setCellStyle(estiloSaldosDecimalFin);
					
					celda=fila.createCell((short)14);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getSinPagVenPrin()));
					celda.setCellStyle(estiloSaldosDecimalFin);
					
					celda=fila.createCell((short)15);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getSinPagVenInt()));
					celda.setCellStyle(estiloSaldosUltDecimal);
					
					celda=fila.createCell((short)16);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getCredConPagVen()));
					celda.setCellStyle(estiloSaldosDecimalFin);
					
					celda=fila.createCell((short)17);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getConPagVenPrin()));
					celda.setCellStyle(estiloSaldosDecimalFin);
					
					celda=fila.createCell((short)18);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getConPagVenInt()));
					celda.setCellStyle(estiloSaldosUltDecimal);
					
					celda=fila.createCell((short)19);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getCartVencida()));
					celda.setCellStyle(estiloSaldosDecimalFin);
					
					celda=fila.createCell((short)20);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getVenPrincipal()));
					celda.setCellStyle(estiloSaldosDecimalFin);
					
					celda=fila.createCell((short)21);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getVenInteres()));
					celda.setCellStyle(estiloSaldosUltDecimal);
				}else{
					
					celda=fila.createCell((short)1);
					celda.setCellValue(listaRegulatorioA0411Bean.get(x).getDescripcion());
					celda.setCellStyle(estiloConceptos);
					hoja.addMergedRegion(new CellRangeAddress(rowExcel, rowExcel, 1, 8));
					
					celda=fila.createCell((short)9);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getCarTotal()));
					celda.setCellStyle(estiloSaldosCenDecimal);
					
					celda=fila.createCell((short)10);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getToTalVigente()));
					celda.setCellStyle(estiloSaldosDecimal);
					
					celda=fila.createCell((short)11);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getPrincipalVigen()));
					celda.setCellStyle(estiloSaldosDecimal);
					
					celda=fila.createCell((short)12);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getInteresesVigen()));
					celda.setCellStyle(estiloSaldosGrisDecimal);
					
					celda=fila.createCell((short)13);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getCredSinPagVen()));
					celda.setCellStyle(estiloSaldosDecimal);
					
					celda=fila.createCell((short)14);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getSinPagVenPrin()));
					celda.setCellStyle(estiloSaldosDecimal);
					
					celda=fila.createCell((short)15);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getSinPagVenInt()));
					celda.setCellStyle(estiloSaldosGrisDecimal);
					
					celda=fila.createCell((short)16);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getCredConPagVen()));
					celda.setCellStyle(estiloSaldosDecimal);
					
					celda=fila.createCell((short)17);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getConPagVenPrin()));
					celda.setCellStyle(estiloSaldosDecimal);
					
					celda=fila.createCell((short)18);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getConPagVenInt()));
					celda.setCellStyle(estiloSaldosGrisDecimal);
					
					celda=fila.createCell((short)19);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getCartVencida()));
					celda.setCellStyle(estiloSaldosDecimal);
					
					celda=fila.createCell((short)20);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getVenPrincipal()));
					celda.setCellStyle(estiloSaldosDecimal);
					
					celda=fila.createCell((short)21);
					celda.setCellValue(Utileria.convierteDoble(listaRegulatorioA0411Bean.get(x).getVenInteres()));
					celda.setCellStyle(estiloSaldosGrisDecimal);
				}
				
				rowExcel++;
				contador++;
			}
			
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
			
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			libro.write(outputStream);
			outputStream.flush();
			outputStream.close();
			
		}catch(Exception e){
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte regulatorio sofipo A0411: " + e.getMessage());
				e.printStackTrace();
			}
		}
		return listaRegulatorioA0411Bean;
	}

	private List generarReporteRegulatorioA0411Sofipo(CarteraPorTipoA0411Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String mesEnLetras	= "";
		String anio		= "";
		String rutaArchivo = "",nombreArchivo="";
		List listaBeans = regulatorioA0411DAO.reporteRegulatorioA0411CsvSofipo(reporteBean, tipoReporte);
		
		mesEnLetras = RegulatorioInsServicio.descripcionMes(reporteBean.getFecha().substring(5,7));
		anio = reporteBean.getFecha().substring(0,4);
		
		nombreArchivo="R04_A0411"+mesEnLetras+" "+anio +".csv"; 
		// se inicia seccion para pintar el archivo csv
		try{
			CarteraPorTipoA0411Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (CarteraPorTipoA0411Bean) listaBeans.get(i);
					writer.write(bean.getValor());        
					writer.write("\r\n");	
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
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte regulatorio sofipo A0411: " + io.getMessage());
			io.printStackTrace();
		}
		return listaBeans;
	}

	public RegulatorioA0411DAO getRegulatorioA0411DAO() {
		return regulatorioA0411DAO;
	}

	public void setRegulatorioA0411DAO(RegulatorioA0411DAO regulatorioA0411DAO) {
		this.regulatorioA0411DAO = regulatorioA0411DAO;
	}

}
