
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

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;

import regulatorios.bean.RegulatorioA2011Bean;
import regulatorios.dao.RegulatorioA2011DAO;


public class RegulatorioA2011Servicio  extends BaseServicio{
	RegulatorioA2011DAO regulatorioA2011DAO = null;	
	
    String[] meses = {"","ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"};
	
	public RegulatorioA2011Servicio() {
		super();
	}

	
	/* ================== Tipo de Lista para reportes regulatorios ============== */
	public static interface Enum_Lis_ReportesA2011{
		int excel	 = 1;
		int csv		 = 2;
	}	
	
	public static interface Enum_Lis_ReportesA2011Ver2015{
		int excel	 = 1;
		int csv		 = 2;
	}
	
	
	public List generaReporteRegulatorioA2011(int tipoLista,int tipoEntidad, RegulatorioA2011Bean reporteBean, HttpServletResponse response, int version){
		List<RegulatorioA2011Bean> listaReportes=null;
		
		/*
		 * SOCAPS
		 */
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			switch(version){
				case 2014:
					listaReportes = listaReporteRegulatorioA2011(tipoLista,reporteBean,response,version); // 
					break;
				case 2015:
					listaReportes = listaReporteRegulatorioA2011Version2015(tipoLista,reporteBean,response,version); 
					break;		
			}
		
		}
		
		
		/*
		 * SOFIPOS
		 */
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch(tipoLista){
				case Enum_Lis_ReportesA2011Ver2015.excel:
					listaReportes = reporteRegulatorioA2011XLSXSOFIPO(Enum_Lis_ReportesA2011Ver2015.excel,reporteBean,response,version); // 
					break;
				case Enum_Lis_ReportesA2011Ver2015.csv:
					listaReportes = generarReporteRegulatorioA2011CsvSofipo(reporteBean, Enum_Lis_ReportesA2011Ver2015.csv,  response,version); 
					break;		
			}
		}
		
		
		return listaReportes;
	}
	
	
	/* ============ case para listas de reportes regulatorios ===============*/
	public List <RegulatorioA2011Bean>listaReporteRegulatorioA2011(int tipoLista, RegulatorioA2011Bean reporteBean, HttpServletResponse response, int version){
		List<RegulatorioA2011Bean> listaReportes=null;
		switch(tipoLista){
			case Enum_Lis_ReportesA2011.excel:
				listaReportes = reporteRegulatorioA2011(tipoLista,reporteBean,response, version); 
				break;
			case Enum_Lis_ReportesA2011.csv:
				listaReportes = generarReporteRegulatorioA2011(reporteBean, Enum_Lis_ReportesA2011.csv,  response, version); 
				break;		
		}
		return listaReportes;
	}
	
	
	
	
	
	/**
	 * Generacion del reporte A 2011 Coeficiente Liquidez
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @param version
	 * @return
	 */
	public List <RegulatorioA2011Bean>listaReporteRegulatorioA2011Version2015(int tipoLista, RegulatorioA2011Bean reporteBean, HttpServletResponse response, int version){
		List<RegulatorioA2011Bean> listaReportes=null;
		switch(tipoLista){
			case Enum_Lis_ReportesA2011Ver2015.excel:
				listaReportes = reporteRegulatorioA2011Ver2015(Enum_Lis_ReportesA2011.excel,reporteBean,response , version); 
				break;
			case Enum_Lis_ReportesA2011Ver2015.csv:
				listaReportes = generarReporteRegulatorioA2011Ver2015(reporteBean, Enum_Lis_ReportesA2011.csv,  response, version); 
				break;		
		}
		return listaReportes;
	}
	
	
	
	private List<RegulatorioA2011Bean> reporteRegulatorioA2011XLSXSOFIPO(
			int tipoReporte, RegulatorioA2011Bean reporteBean,
			HttpServletResponse response,int version) {
		List listaRepote=null;
		
		listaRepote = regulatorioA2011DAO.reporteRegulatorioA2011Sofipo( reporteBean,tipoReporte, version); 	
		
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		
		anio			= reporteBean.getAnio();
		nombreArchivo 	= "R20_A_2011_"+descripcionMes(reporteBean.getMes())+"_"+reporteBean.getAnio(); 
		
		// Creacion de Libro
		try {
			HSSFWorkbook libro = new HSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 
			HSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Arial");
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			//Se crea una Fuente tamaño 10 
			HSSFFont fuentetamanio10= libro.createFont();
			fuentetamanio10.setFontHeightInPoints((short)10);
			fuentetamanio10.setFontName("Arial");
			
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo tamaño 10 alineado a la derecha
			HSSFCellStyle estiloTitulo = libro.createCellStyle();
			estiloTitulo.setFont(fuenteNegrita10);
			estiloTitulo.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo tamaño 10 alineado a la derecha
			HSSFCellStyle estiloTituloDer = libro.createCellStyle();
			estiloTituloDer.setFont(fuenteNegrita10);
			estiloTituloDer.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			
			//Estilo negrita tamaño 10
			HSSFCellStyle estiloEncabezado = libro.createCellStyle();
			estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
			estiloEncabezado.setFont(fuenteNegrita10);
			estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloEncabezado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			
			//Estilo tamaño 10 alineado a la izquierda
			HSSFCellStyle estiloConceptos = libro.createCellStyle();
			estiloConceptos.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
			estiloConceptos.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloConceptos.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloConceptos.setFont(fuenteNegrita10);
			
			//Solo celda con borde inferior, izquierdo y derecho
			HSSFCellStyle estiloUltimaCelda = libro.createCellStyle();
			estiloUltimaCelda.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloUltimaCelda.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloUltimaCelda.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
			
			HSSFDataFormat format = libro.createDataFormat();
			
			//Estilo tamaño 10 alineado a la derecha sin decimales
			HSSFCellStyle estiloSaldos = libro.createCellStyle();
			estiloSaldos.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			estiloSaldos.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloSaldos.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloSaldos.setDataFormat(format.getFormat("#,##0.00"));
			estiloSaldos.setFont(fuentetamanio10);
			
			HSSFCellStyle estiloSaldosProm = libro.createCellStyle();
			estiloSaldosProm.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			estiloSaldosProm.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloSaldosProm.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloSaldosProm.setDataFormat(format.getFormat("#,##0.0000"));
			estiloSaldosProm.setFont(fuentetamanio10);
						
			//Estilo tamaño 10 alineado a la derecha y con formato moneda y celda sombreada
			HSSFCellStyle estiloSaldosGris = libro.createCellStyle();
			estiloSaldosGris.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			estiloSaldosGris.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloSaldosGris.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloSaldosGris.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			estiloSaldosGris.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			estiloSaldosGris.setDataFormat(format.getFormat("#,##0"));
			estiloSaldosGris.setFont(fuentetamanio10);
			
			HSSFCellStyle estiloSaldosGrisDecimal = libro.createCellStyle();
			estiloSaldosGrisDecimal.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
			estiloSaldosGrisDecimal.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloSaldosGrisDecimal.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			estiloSaldosGrisDecimal.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
			estiloSaldosGrisDecimal.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			estiloSaldosGrisDecimal.setDataFormat(format.getFormat("#,##0.0000"));
			estiloSaldosGrisDecimal.setFont(fuentetamanio10);
			
			//Estilo tamaño 10 negrita alineado a la izquierda
			HSSFCellStyle estiloPie = libro.createCellStyle();
			estiloPie.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
			estiloPie.setFont(fuenteNegrita10);
			
											
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("A 2011");	
			
			
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
		            1, //primera fila (0-based)
		            1, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            3  //ultima celda (0-based)
		    ));
			
			hoja.addMergedRegion(new CellRangeAddress(
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            3  //ultima celda (0-based)
		    ));
					
			hoja.addMergedRegion(new CellRangeAddress(
		            3, //primera fila (0-based)
		            3, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            3  //ultima celda (0-based)
		    ));
					
					
			HSSFRow filaVacia= hoja.createRow(0);			
			HSSFRow filaTitulo= hoja.createRow(1);
			HSSFRow filaTit1= hoja.createRow(1);
			HSSFRow fila= hoja.createRow(2);
			HSSFRow filaTit2= hoja.createRow(2);
			HSSFRow filaTit3= hoja.createRow(3);



			//fila= hoja.createRow(3);
			fila= hoja.createRow(4);
			
			fila= hoja.createRow(5);
			HSSFCell celda=filaTitulo.createCell((short)0);	
			celda=filaTit1.createCell((short)1);
			celda.setCellValue("Reporte Regulatorio de Coeficiente de Liquidez");
			celda.setCellStyle(estiloTituloDer);
			
			celda=filaTit2.createCell((short)1);
			celda.setCellValue("Subreporte: Coeficiente de Liquidez");
			celda.setCellStyle(estiloTituloDer);
			
			celda=filaTit3.createCell((short)1);
			celda.setCellValue("R20 A 2011");
			celda.setCellStyle(estiloTituloDer);
								
			
			
			celda=fila.createCell((short)1);
			celda.setCellValue("Subreporte: Coeficiente de Liquidez");
			celda.setCellStyle(estiloTitulo);
			
			
			fila= hoja.createRow(6);
			celda=filaTitulo.createCell((short)0);	
			celda=fila.createCell((short)0);
			celda=fila.createCell((short)1);
			celda.setCellValue("Incluye: Moneda nacional y Udis valorizadas en pesos");
			celda.setCellStyle(estiloTitulo);
			
			
			fila= hoja.createRow(7);
			celda=filaTitulo.createCell((short)0);	
			celda=fila.createCell((short)0);
			celda=fila.createCell((short)1);
			celda.setCellValue("Cifras en pesos");
			celda.setCellStyle(estiloTitulo);
			

			fila = hoja.createRow(8);			
			fila = hoja.createRow(9);
			celda=fila.createCell((short)0);
			celda=fila.createCell((short)1);
			celda.setCellValue("Concepto");
			celda.setCellStyle(estiloEncabezado);
			celda=fila.createCell((short)2);
			celda.setCellValue("Saldo al cierre del mes");
			celda.setCellStyle(estiloEncabezado);	
			celda=fila.createCell((short)3);
			celda.setCellValue("Saldo diario \npromedio mensual \ndel balance");
			celda.setCellStyle(estiloEncabezado);	
			celda=fila.createCell((short)4);
			celda.setCellValue("Coeficiente \nLiquidez");
			celda.setCellStyle(estiloEncabezado);
			
			
			int numeroFila=10   ,iter=0;
			String formula="";
			int tamanioLista = listaRepote.size();
			RegulatorioA2011Bean reporteRegBean = null;
			
			for( iter=0; iter<tamanioLista; iter ++){
				reporteRegBean = (RegulatorioA2011Bean) listaRepote.get(iter);
				fila=hoja.createRow(numeroFila);
				
				celda=fila.createCell((short)0);
				celda=fila.createCell((short)1);
				celda.setCellValue(reporteRegBean.getConcepto());	
				if(reporteRegBean.getDescripcionEsNegrita().equalsIgnoreCase("S")){
					celda.setCellStyle(estiloConceptos);
				}					
					celda=fila.createCell((short)2);					
					if(!reporteRegBean.getFormulaSaldo().isEmpty()){
						formula = reporteRegBean.getFormulaSaldo();
						celda.setCellType(HSSFCell.CELL_TYPE_FORMULA);
						celda.setCellFormula(formula);
					}else{
						if(!reporteRegBean.getConcepto().isEmpty()){
							celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldo()));
						}						
					}
					
					
					if(reporteRegBean.getColorCeldaSaldo().equalsIgnoreCase("S")){
						if(iter==1){
							celda.setCellStyle(estiloSaldosGrisDecimal);	
						}else{
							celda.setCellStyle(estiloSaldosGris);
						}
					}else{
							celda.setCellStyle(estiloSaldos);
						
					}
					
					/* Valida si es el coeficiente de liquidez */
					if(Utileria.convierteEntero(reporteRegBean.getRegistroID()) == 1){
						celda.setCellValue("");
					}

					
					celda=fila.createCell((short)3);		
					if(!reporteRegBean.getFormulaSaldoProm().isEmpty()){
						formula = reporteRegBean.getFormulaSaldoProm();
						celda.setCellType(HSSFCell.CELL_TYPE_FORMULA);
						celda.setCellFormula(formula);
					}
					if(reporteRegBean.getColorCeldaSaldoProm().equalsIgnoreCase("S")){
						celda.setCellStyle(estiloSaldosGris);	
					}else{
						celda.setCellStyle(estiloSaldos);	
					}
					
					
					celda=fila.createCell((short)4);
					if(Utileria.convierteEntero(reporteRegBean.getRegistroID()) == 1){
						celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldo()));
						celda.setCellStyle(estiloSaldosProm);
					}else{
						celda.setCellStyle(estiloSaldosGris);	
					}

						
				numeroFila++;
			} 
			
			fila=hoja.createRow(numeroFila++);	
			celda=fila.createCell((short)1);
			celda.setCellStyle(estiloUltimaCelda);
			celda=fila.createCell((short)2);
			celda.setCellStyle(estiloUltimaCelda);
			celda=fila.createCell((short)3);
			celda.setCellStyle(estiloUltimaCelda);
			celda=fila.createCell((short)4);
			celda.setCellStyle(estiloUltimaCelda);
						
			fila=hoja.createRow(numeroFila++);
			
			fila=hoja.createRow(numeroFila++);
			celda=fila.createCell((short)0);
			celda=fila.createCell((short)1);
			celda.setCellValue("Nota:");
			celda.setCellStyle(estiloPie);	
			
			fila=hoja.createRow(numeroFila++);			
			celda=fila.createCell((short)0);
			celda=fila.createCell((short)1);
			celda.setCellValue("1/ El coeficiente de liquidez se debe presentar sin el signo '%', a 4 decimales y en base 100. Por ejemplo: 20% sería 20.0000");	
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
					numeroFila -1 , //primera fila (0-based)
					numeroFila -1 , //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            4  //ultima celda   (0-based)
		    ));
			
			fila=hoja.createRow(numeroFila++);
			celda=fila.createCell((short)0);
			celda=fila.createCell((short)1);
			celda.setCellValue("2/ Aplica sólo para las Sociedades Financieras Populares con Nivel de Operaciones  IV.");
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
					numeroFila -1 , //primera fila (0-based)
					numeroFila -1 , //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            4  //ultima celda   (0-based)
		    ));
			fila=hoja.createRow(numeroFila++);
			celda=fila.createCell((short)0);
			celda=fila.createCell((short)1);
			celda.setCellValue("3/ Los niveles de desagregación aplican sólo para las Sociedades Financieras Populares con nivel de operacion II,III,IV");
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
					numeroFila -1 , //primera fila (0-based)
					numeroFila -1 , //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            4  //ultima celda   (0-based)
		    ));
			fila=hoja.createRow(numeroFila++);
			celda=fila.createCell((short)0);
			celda=fila.createCell((short)1);
			celda.setCellValue("4/ El nivel sin desagregación sólo aplica para las Sociedades Financieras Populares con Niveles de Operación I.");
			//funcion para unir celdas
			hoja.addMergedRegion(new CellRangeAddress(
					numeroFila -1 , //primera fila (0-based)
					numeroFila -1 , //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            4  //ultima celda   (0-based)
		    ));
			

			for(int celd=0; celd<=18; celd++)
			hoja.autoSizeColumn((short)celd);
				
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
		}catch(Exception e){
			e.printStackTrace();
		}//Fin del catch
		return  listaRepote;
	}


	/* ======================================  FUNCIONES PARA GENERAR REPORTES CSV  ========================================*/	
	
	private List generarReporteRegulatorioA2011(RegulatorioA2011Bean reporteBean,int tipoReporte,HttpServletResponse response, int version){
		String nombreArchivo="";
		List listaBeans = regulatorioA2011DAO.reporteRegulatorioA2011Csv(reporteBean, tipoReporte, version);
		nombreArchivo="A_2011_Coeficiente_Liquidez.csv"; 
		// se inicia seccion para pintar el archivo csv
		try{
			RegulatorioA2011Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioA2011Bean) listaBeans.get(i);
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
	
	
	private List generarReporteRegulatorioA2011CsvSofipo(RegulatorioA2011Bean reporteBean,int tipoReporte,HttpServletResponse response, int version){
		List listaBeans = regulatorioA2011DAO.reporteRegulatorioA2011Csv(reporteBean, tipoReporte, version);
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		
		anio			= reporteBean.getAnio();
		nombreArchivo 	= "R20_A_2011_"+descripcionMes(reporteBean.getMes())+"_"+reporteBean.getAnio()+".csv"; 
		
		//nombreArchivo="A_2011_Coeficiente_Liquidez.csv"; 
		// se inicia seccion para pintar el archivo csv
		try{
			RegulatorioA2011Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioA2011Bean) listaBeans.get(i);
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
	 * Genera reporte regulatorio A 2011 Coeficiente Liquidez version 2015 formato CSV
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @param version
	 * @return
	 */
	private List generarReporteRegulatorioA2011Ver2015(RegulatorioA2011Bean reporteBean, int tipoReporte,HttpServletResponse response, int version) {
		String nombreArchivo = "";
		List listaBeans = regulatorioA2011DAO.reporteRegulatorioA2011CsvVersion2015(reporteBean,tipoReporte, version);

		nombreArchivo = "A_2011_Coeficiente_Liquidez.csv";

		// se inicia seccion para pintar el archivo csv
		try {
			RegulatorioA2011Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(
					nombreArchivo));
			if (!listaBeans.isEmpty()) {
				for (int i = 0; i < listaBeans.size(); i++) {
					bean = (RegulatorioA2011Bean) listaBeans.get(i);
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
			io.printStackTrace();
		}

		return listaBeans;
	}
	
	
	
	
	// Reporte Regulatorio De Coeficiente de Liquidez
		public List  reporteRegulatorioA2011(int tipoReporte,RegulatorioA2011Bean reporteBean,  HttpServletResponse response, int version){
			List listaRepote=null;
			listaRepote = regulatorioA2011DAO.reporteRegulatorioA2011( reporteBean, tipoReporte, version); 	
			
			// Creacion de Libro
			try {
				HSSFWorkbook libro = new HSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 
				HSSFFont fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setFontName("Arial");
				fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				
				//Se crea una Fuente tamaño 10 
				HSSFFont fuentetamanio10= libro.createFont();
				fuentetamanio10.setFontHeightInPoints((short)10);
				fuentetamanio10.setFontName("Arial");
				
				
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo tamaño 10 alineado a la derecha
				HSSFCellStyle estiloTitulo = libro.createCellStyle();
				estiloTitulo.setFont(fuenteNegrita10);
				estiloTitulo.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
				
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo tamaño 10 alineado a la derecha
				HSSFCellStyle estiloTituloDer = libro.createCellStyle();
				estiloTituloDer.setFont(fuenteNegrita10);
				estiloTituloDer.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
				
				//Estilo negrita tamaño 10
				HSSFCellStyle estiloEncabezado = libro.createCellStyle();
				estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
				estiloEncabezado.setFont(fuenteNegrita10);
				estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				estiloEncabezado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
				
				//Estilo tamaño 10 alineado a la izquierda
				HSSFCellStyle estiloConceptos = libro.createCellStyle();
				estiloConceptos.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
				estiloConceptos.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloConceptos.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloConceptos.setFont(fuenteNegrita10);
				
				//Solo celda con borde inferior, izquierdo y derecho
				HSSFCellStyle estiloUltimaCelda = libro.createCellStyle();
				estiloUltimaCelda.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloUltimaCelda.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloUltimaCelda.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
				
				HSSFDataFormat format = libro.createDataFormat();
				
				//Estilo tamaño 10 alineado a la derecha sin decimales
				HSSFCellStyle estiloSaldos = libro.createCellStyle();
				estiloSaldos.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
				estiloSaldos.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloSaldos.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloSaldos.setDataFormat(format.getFormat("#,##0"));
				estiloSaldos.setFont(fuentetamanio10);
							
				//Estilo tamaño 10 alineado a la derecha y con formato moneda y celda sombreada
				HSSFCellStyle estiloSaldosGris = libro.createCellStyle();
				estiloSaldosGris.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
				estiloSaldosGris.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloSaldosGris.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloSaldosGris.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				estiloSaldosGris.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				estiloSaldosGris.setDataFormat(format.getFormat("#,##0"));
				estiloSaldosGris.setFont(fuentetamanio10);
				
				HSSFCellStyle estiloSaldosGrisDecimal = libro.createCellStyle();
				estiloSaldosGrisDecimal.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
				estiloSaldosGrisDecimal.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloSaldosGrisDecimal.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloSaldosGrisDecimal.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				estiloSaldosGrisDecimal.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				estiloSaldosGrisDecimal.setDataFormat(format.getFormat("#,##0.0000"));
				estiloSaldosGrisDecimal.setFont(fuentetamanio10);
				
				//Estilo tamaño 10 negrita alineado a la izquierda
				HSSFCellStyle estiloPie = libro.createCellStyle();
				estiloPie.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
				estiloPie.setFont(fuenteNegrita10);
				
												
				// Creacion de hoja					
				HSSFSheet hoja = libro.createSheet("A 2011");	
				
				
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            3  //ultima celda (0-based)
			    ));
				
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            3  //ultima celda (0-based)
			    ));
						
				hoja.addMergedRegion(new CellRangeAddress(
			            3, //primera fila (0-based)
			            3, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            3  //ultima celda (0-based)
			    ));
						
						
				HSSFRow filaVacia= hoja.createRow(0);			
				HSSFRow filaTitulo= hoja.createRow(1);
				HSSFRow filaTit1= hoja.createRow(1);
				HSSFRow fila= hoja.createRow(2);
				HSSFRow filaTit2= hoja.createRow(2);
				HSSFRow filaTit3= hoja.createRow(3);



				//fila= hoja.createRow(3);
				fila= hoja.createRow(4);
				
				fila= hoja.createRow(5);
				HSSFCell celda=filaTitulo.createCell((short)0);	
				celda=filaTit1.createCell((short)1);
				celda.setCellValue("Reporte Regulatorio de Coeficiente de Liquidez");
				celda.setCellStyle(estiloTituloDer);
				
				celda=filaTit2.createCell((short)1);
				celda.setCellValue("Subreporte: Coeficiente de Liquidez");
				celda.setCellStyle(estiloTituloDer);
				
				celda=filaTit3.createCell((short)1);
				celda.setCellValue("R20 A 2011");
				celda.setCellStyle(estiloTituloDer);
									
				
				
				celda=fila.createCell((short)1);
				celda.setCellValue("Subreporte: Coeficiente de Liquidez");
				celda.setCellStyle(estiloTitulo);
				
				
				fila= hoja.createRow(6);
				celda=filaTitulo.createCell((short)0);	
				celda=fila.createCell((short)0);
				celda=fila.createCell((short)1);
				celda.setCellValue("Incluye: Moneda nacional y Udis valorizadas en pesos");
				celda.setCellStyle(estiloTitulo);
				
				
				fila= hoja.createRow(7);
				celda=filaTitulo.createCell((short)0);	
				celda=fila.createCell((short)0);
				celda=fila.createCell((short)1);
				celda.setCellValue("Cifras en pesos");
				celda.setCellStyle(estiloTitulo);
				

				fila = hoja.createRow(8);			
				fila = hoja.createRow(9);
				celda=fila.createCell((short)0);
				celda=fila.createCell((short)1);
				celda.setCellValue("Concepto");
				celda.setCellStyle(estiloEncabezado);
				celda=fila.createCell((short)2);
				celda.setCellValue("Saldo al cierre del mes");
				celda.setCellStyle(estiloEncabezado);	
				celda=fila.createCell((short)3);
				celda.setCellValue("Saldo diario \npromedio mensual \ndel balance 1/");
				celda.setCellStyle(estiloEncabezado);	
				
				
				int numeroFila=10   ,iter=0;
				String formula="";
				int tamanioLista = listaRepote.size();
				RegulatorioA2011Bean reporteRegBean = null;
				
				for( iter=0; iter<tamanioLista; iter ++){
					reporteRegBean = (RegulatorioA2011Bean) listaRepote.get(iter);
					fila=hoja.createRow(numeroFila);
					
					celda=fila.createCell((short)0);
					celda=fila.createCell((short)1);
					celda.setCellValue(reporteRegBean.getConcepto());	
					if(reporteRegBean.getDescripcionEsNegrita().equalsIgnoreCase("S")){
						celda.setCellStyle(estiloConceptos);
					}					
						celda=fila.createCell((short)2);					
						if(!reporteRegBean.getFormulaSaldo().isEmpty()){
							formula = reporteRegBean.getFormulaSaldo();
							celda.setCellType(HSSFCell.CELL_TYPE_FORMULA);
							celda.setCellFormula(formula);
						}else{
							if(!reporteRegBean.getConcepto().isEmpty()){
								celda.setCellValue(Double.parseDouble(reporteRegBean.getSaldo()));
							}						
						}
						if(reporteRegBean.getColorCeldaSaldo().equalsIgnoreCase("S")){
							if(iter==1){
								celda.setCellStyle(estiloSaldosGrisDecimal);	
							}else{
								celda.setCellStyle(estiloSaldosGris);
							}
						}else{
								celda.setCellStyle(estiloSaldos);
							
						}					

						
						celda=fila.createCell((short)3);		
						if(!reporteRegBean.getFormulaSaldoProm().isEmpty()){
							formula = reporteRegBean.getFormulaSaldoProm();
							celda.setCellType(HSSFCell.CELL_TYPE_FORMULA);
							celda.setCellFormula(formula);
						}
						if(reporteRegBean.getColorCeldaSaldoProm().equalsIgnoreCase("S")){
							celda.setCellStyle(estiloSaldosGris);	
						}else{
							celda.setCellStyle(estiloSaldos);	
						}

							
					numeroFila++;
				} 
				
				fila=hoja.createRow(numeroFila++);	
				celda=fila.createCell((short)1);
				celda.setCellStyle(estiloUltimaCelda);
				celda=fila.createCell((short)2);
				celda.setCellStyle(estiloUltimaCelda);
				celda=fila.createCell((short)3);
				celda.setCellStyle(estiloUltimaCelda);
							
				fila=hoja.createRow(numeroFila++);
				
				fila=hoja.createRow(numeroFila++);
				celda=fila.createCell((short)0);
				celda=fila.createCell((short)1);
				celda.setCellValue("Nota:");
				celda.setCellStyle(estiloPie);	
				
				fila=hoja.createRow(numeroFila++);			
				celda=fila.createCell((short)0);
				celda=fila.createCell((short)1);
				celda.setCellValue("1/ Sólo aplica para las Entidades con nivel prudencial IV. Resulta de calcular el promedio diario de la sumatoria del costo de adquisición, los intereses");	
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
						numeroFila -1 , //primera fila (0-based)
						numeroFila -1 , //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            4  //ultima celda   (0-based)
			    ));
				
				fila=hoja.createRow(numeroFila++);
				celda=fila.createCell((short)0);
				celda=fila.createCell((short)1);
				celda.setCellValue("2/ El coeficiente de liquidez se debe presentar sin el signo '%', a 4 decimales y en base 100. Por ejemplo: 20% sería 20.0000");
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
						numeroFila -1 , //primera fila (0-based)
						numeroFila -1 , //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            4  //ultima celda   (0-based)
			    ));
				fila=hoja.createRow(numeroFila++);
				celda=fila.createCell((short)0);
				celda=fila.createCell((short)1);
				celda.setCellValue("3/ Aplica sólo para las Entidades de Ahorro y Crédito Popular con Nivel de Operaciones  IV.");
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
						numeroFila -1 , //primera fila (0-based)
						numeroFila -1 , //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            4  //ultima celda   (0-based)
			    ));
				fila=hoja.createRow(numeroFila++);
				celda=fila.createCell((short)0);
				celda=fila.createCell((short)1);
				celda.setCellValue("4/ Títulos bancarios y valores gubernamentales.");
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
						numeroFila -1 , //primera fila (0-based)
						numeroFila -1 , //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            4  //ultima celda   (0-based)
			    ));
				fila=hoja.createRow(numeroFila++);
				celda=fila.createCell((short)0);
				celda=fila.createCell((short)1);
				celda.setCellValue("5/ El nivel de desagregación, no aplica para el Nivel  de Operaciones I.");
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
						numeroFila -1 , //primera fila (0-based)
						numeroFila -1 , //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            4  //ultima celda   (0-based)
			    ));
				fila=hoja.createRow(numeroFila++);
				celda=fila.createCell((short)0);
				celda=fila.createCell((short)1);
				celda.setCellValue("6/ Sólo aplica para Nivel de Operaciones I.");
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
						numeroFila -1 , //primera fila (0-based)
						numeroFila -1 , //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            4  //ultima celda   (0-based)
			    ));
				fila=hoja.createRow(numeroFila++);
				celda=fila.createCell((short)0);
				celda=fila.createCell((short)1);
				celda.setCellValue("Las celdas sombreadas representan celdas invalidadas para las cuales no aplica la información solicitada.");
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
						numeroFila -1 , //primera fila (0-based)
						numeroFila -1 , //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            4  //ultima celda   (0-based)
			    ));

				for(int celd=0; celd<=18; celd++)
				hoja.autoSizeColumn((short)celd);
					
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=A_2011_Coeficiente_Liquidez.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
			}catch(Exception e){
				e.printStackTrace();
			}//Fin del catch
			return  listaRepote;
		}
		
		/**
		 * Generación del reporte A2011 Version 2015 Excel
		 * @param tipoReporte
		 * @param reporteBean
		 * @param response
		 * @param version
		 * @return
		 */
		public List  reporteRegulatorioA2011Ver2015(int tipoReporte,RegulatorioA2011Bean reporteBean,  HttpServletResponse response, int version){
			List<RegulatorioA2011Bean> listaRepote = null;
			listaRepote = regulatorioA2011DAO.reporteRegulatorioA2011Version2015( reporteBean, tipoReporte, version); 	
			try {
				HSSFWorkbook libro = new HSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 
				HSSFFont fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setFontName("Arial");
				fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				
				//Se crea una Fuente tamaño 10 
				HSSFFont fuentetamanio10= libro.createFont();
				fuentetamanio10.setFontHeightInPoints((short)10);
				fuentetamanio10.setFontName("Arial");
				
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo tamaño 10 alineado a la derecha
				HSSFCellStyle estiloTitulo = libro.createCellStyle();
				estiloTitulo.setFont(fuenteNegrita10);
				estiloTitulo.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
				
				//Estilo negrita tamaño 10
				HSSFCellStyle estiloEncabezado = libro.createCellStyle();
				estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
				estiloEncabezado.setFont(fuenteNegrita10);
				estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				estiloEncabezado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
				
				//Estilo tamaño 10 alineado a la izquierda
				HSSFCellStyle estiloConceptos = libro.createCellStyle();
				estiloConceptos.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
				estiloConceptos.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloConceptos.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloConceptos.setFont(fuenteNegrita10);
				
				
				//Estilo tamaño 10 alineado a la izquierda
				HSSFCellStyle estiloConceptosB = libro.createCellStyle();
				estiloConceptosB.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
				estiloConceptosB.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloConceptosB.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
			
				//Solo celda con borde inferior, izquierdo y derecho
				HSSFCellStyle estiloUltimaCelda = libro.createCellStyle();
				estiloUltimaCelda.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloUltimaCelda.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloUltimaCelda.setBorderBottom((short)HSSFCellStyle.BORDER_MEDIUM);
				
				HSSFDataFormat format = libro.createDataFormat();
				
				//Estilo tamaño 10 alineado a la derecha sin decimales
				HSSFCellStyle estiloSaldos = libro.createCellStyle();
				estiloSaldos.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
				estiloSaldos.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloSaldos.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloSaldos.setDataFormat(format.getFormat("#,##0"));
				estiloSaldos.setFont(fuentetamanio10);
							
				//Estilo tamaño 10 alineado a la derecha y con formato moneda y celda sombreada
				HSSFCellStyle estiloSaldosGris = libro.createCellStyle();
				estiloSaldosGris.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
				estiloSaldosGris.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloSaldosGris.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloSaldosGris.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				estiloSaldosGris.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				estiloSaldosGris.setDataFormat(format.getFormat("#,##0"));
				estiloSaldosGris.setFont(fuentetamanio10);
				
				HSSFCellStyle estiloSaldosGrisDecimal = libro.createCellStyle();
				estiloSaldosGrisDecimal.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
				estiloSaldosGrisDecimal.setBorderRight((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloSaldosGrisDecimal.setBorderLeft((short)HSSFCellStyle.BORDER_MEDIUM);
				estiloSaldosGrisDecimal.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				estiloSaldosGrisDecimal.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				estiloSaldosGrisDecimal.setDataFormat(format.getFormat("#,##0.0000"));
				estiloSaldosGrisDecimal.setFont(fuentetamanio10);
				
				//Estilo tamaño 10 negrita alineado a la izquierda
				HSSFCellStyle estiloPie = libro.createCellStyle();
				estiloPie.setAlignment((short)HSSFCellStyle.ALIGN_LEFT);
				estiloPie.setFont(fuenteNegrita10);
															
				// Creacion de hoja					
				HSSFSheet hoja = libro.createSheet("A 2011");	
				HSSFRow fila= hoja.createRow(0);			
				fila= hoja.createRow(1);
				HSSFCell celda=fila.createCell((short)1);	
				celda.setCellValue("Sociedades cooperativas de ahorro y préstamo");
				celda.setCellStyle(estiloTitulo);
				
				fila= hoja.createRow(2);
				celda=fila.createCell((short)1);
				celda.setCellValue("Serie R20 Indicadores");
				celda.setCellStyle(estiloTitulo);
				
				fila= hoja.createRow(3);
				celda=fila.createCell((short)1);
				celda.setCellValue("Reporte A-2011 Desagregado del coeficiente de liquidez");
				celda.setCellStyle(estiloTitulo);
				
				fila= hoja.createRow(4);
				celda=fila.createCell((short)1);
				celda.setCellValue("Incluye cifras en moneda nacional y UDIS valorizadas en pesos");
				celda.setCellStyle(estiloTitulo);
				
				fila= hoja.createRow(5);
				celda=fila.createCell((short)1);
				celda.setCellValue("Cifras en pesos");
				celda.setCellStyle(estiloTitulo);
				
				fila= hoja.createRow(5);
				celda=fila.createCell((short)1);
				
				int numeroFila=6;
				String formula="";
				
				for(int iter=0;iter<listaRepote.size();iter++){
					if (iter == 0) {
						// ENCABEZADOS
						fila = hoja.createRow(6);
						celda = fila.createCell((short) 1);
						celda.setCellValue("Concepto");
						celda.setCellStyle(estiloEncabezado);

						celda = fila.createCell((short) 2);
						celda.setCellValue("Dato");
						celda.setCellStyle(estiloEncabezado);
					} 
					else if (iter == 2) {
						// ENCABEZADOS
						fila = hoja.createRow(8);
						fila = hoja.createRow(9);
						celda = fila.createCell((short) 1);
						celda.setCellValue("Concepto");
						celda.setCellStyle(estiloEncabezado);
						celda = fila.createCell((short) 2);
						celda.setCellValue("Saldo al cierre del mes");
						celda.setCellStyle(estiloEncabezado);
						numeroFila++;
						// FIN ENCABEZADOS
					} else {

						RegulatorioA2011Bean reporteRegBean = listaRepote.get(iter);
						fila = hoja.createRow(numeroFila);
						// CONCEPTO ----------------------------------------------
						celda = fila.createCell((short) 1);
						celda.setCellValue(reporteRegBean.getConcepto());
						if (reporteRegBean.getDescripcionEsNegrita()
								.equalsIgnoreCase("S")) {
							celda.setCellStyle(estiloConceptos);
						}else{
							celda.setCellStyle(estiloConceptosB);
						}
						// FORMULA -------------------------------------------------
						celda = fila.createCell((short) 2);
						if (!reporteRegBean.getFormulaSaldo().isEmpty()) {
							formula = reporteRegBean.getFormulaSaldo();
							celda.setCellType(HSSFCell.CELL_TYPE_FORMULA);
							celda.setCellFormula(formula);
						} else {
							if (!reporteRegBean.getConcepto().isEmpty()) {
								celda.setCellValue(Double
										.parseDouble(reporteRegBean.getSaldo()));
							}
						}
						if (reporteRegBean.getColorCeldaSaldo().equalsIgnoreCase(
								"S")) {
							if (iter == 1) {
								celda.setCellStyle(estiloSaldosGrisDecimal);
							} else {
								celda.setCellStyle(estiloSaldosGris);
							}
						} else {
							celda.setCellStyle(estiloSaldos);

						}
						// FIN SALDOS FORMULAs
					}
					numeroFila++;
				}
				
				fila=hoja.createRow(numeroFila++);	
				celda=fila.createCell((short)1);
				celda.setCellStyle(estiloUltimaCelda);
				celda=fila.createCell((short)2);
				celda.setCellStyle(estiloUltimaCelda);

							
				fila=hoja.createRow(numeroFila++);
				
				fila=hoja.createRow(numeroFila++);		
				celda=fila.createCell((short)1);
				celda.setCellValue("Sociedades cooperativas de ahorro y préstamo");	
				fila=hoja.createRow(numeroFila++);
				celda=fila.createCell((short)1);
				celda.setCellValue("Notas:");
				fila=hoja.createRow(numeroFila++);
				celda=fila.createCell((short)1);
				celda.setCellValue("1/ El coeficiente de liquidez se debe presentar sin el signo \"%\", a 4 decimales y en base 100. Por ejemplo: 20% sería 20.0000");
				fila=hoja.createRow(numeroFila++);
				celda=fila.createCell((short)1);
				celda.setCellValue("2/Valores Gubernamentales, bancarios y de sociedades de inversión en instrumentos de deuda en moneda nacional.");

				for(int celd=0; celd<=18; celd++)
				hoja.autoSizeColumn((short)celd);
					
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=A_2011_Coeficiente_Liquidez.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
			}catch(Exception e){
				e.printStackTrace();
			}//Fin del catch
			return  listaRepote;
		}
		

	
	
	
	
	
	
	
	
	
	
	
	public String descripcionMes(String meses){
		String mes = "";
		int mese = Integer.parseInt(meses);
        switch (mese) {
            case 1:  mes ="ENERO" ; break;
            case 2:  mes ="FEBRERO"; break;
            case 3:  mes ="MARZO"; break;
            case 4:  mes ="ABRIL"; break;
            case 5:  mes ="MAYO"; break;
            case 6:  mes ="JUNIO"; break;
            case 7:  mes ="JULIO"; break;
            case 8:  mes ="AGOSTO"; break;
            case 9:  mes ="SEPTIEMBRE"; break;
            case 10: mes ="OCTUBRE"; break;
            case 11: mes ="NOVIEMBRE"; break;
            case 12: mes ="DICIEMBRE"; break;
        }
        return mes;
	}
	/* ========================= GET  &&  SET  =========================*/
	
	public RegulatorioA2011DAO getRegulatorioA2011DAO() {
		return regulatorioA2011DAO;
	}

	public void setRegulatorioA2011DAO(RegulatorioA2011DAO regulatorioA2011DAO) {
		this.regulatorioA2011DAO = regulatorioA2011DAO;
	}

	public String[] getMeses() {
		return meses;
	}

	public void setMeses(String[] meses) {
		this.meses = meses;
	}
	

	
		
}
