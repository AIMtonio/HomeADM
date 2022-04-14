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
import regulatorios.bean.RegulatorioC0452Bean;
import regulatorios.dao.RegulatorioC0452DAO;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;


public class RegulatorioC0452Servicio extends BaseServicio {
	
	RegulatorioC0452DAO regulatorioC0452DAO = null;	
	
	
	public RegulatorioC0452Servicio() {
		super();
	}

	

	public List <RegulatorioC0452Bean>listaReporteRegulatorioC0452(int tipoLista,int tipoEntidad, RegulatorioC0452Bean reporteBean, HttpServletResponse response) throws IOException{
		List<RegulatorioC0452Bean> listaReportes=null;
		
				
		/*
		 * SOFIPOS
		 */
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch(tipoLista){
				case Enum_Lis_TipoReporte.excel:
					listaReportes = reporteRegulatorioC0452XLSXSOFIPO(Enum_Lis_TipoReporte.excel,reporteBean,response);
					break;
				case Enum_Lis_TipoReporte.csv:
					listaReportes = generarReporteRegulatorioC0452(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}else{
			switch(tipoLista){
				case Enum_Lis_TipoReporte.excel:
					listaReportes = reporteRegulatorioC0452XLSXSOFIPO(Enum_Lis_TipoReporte.excel,reporteBean,response);
					break;
				case Enum_Lis_TipoReporte.csv:
					listaReportes = generarReporteRegulatorioC0452(reporteBean, Enum_Lis_TipoReporte.csv,  response); 
					break;		
			}
		}
		
		return listaReportes;
		
	}
	
	
	/* ======================================  FUNCION PARA GENERAR REPORTE CSV  ========================================*/	
	
	private List generarReporteRegulatorioC0452(RegulatorioC0452Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans 		= regulatorioC0452DAO.reporteRegulatorioC452Csv(reporteBean, tipoReporte);
		String anio				= reporteBean.getAnio();
		String mesEnLetras		= RegulatorioInsServicio.descripcionMes(reporteBean.getMes());
		
		nombreArchivo="R04_C0452_"+mesEnLetras+"_"+anio+".csv"; 
		// se inicia seccion para pintar el archivo csv
		try{
			RegulatorioC0452Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioC0452Bean) listaBeans.get(i);
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
	 * Generacion del reporte SOFIPO
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List<RegulatorioC0452Bean> reporteRegulatorioC0452XLSXSOFIPO(int tipoLista,RegulatorioC0452Bean reporteBean, HttpServletResponse response) throws IOException
	{
		List<RegulatorioC0452Bean> listaRegulatorioC0452Bean = null;
		String mesEnLetras			= "";
		String anio					= "";
		String nombreArchivo 		= "";
		
		anio			= reporteBean.getAnio();
		mesEnLetras		= RegulatorioInsServicio.descripcionMes(reporteBean.getMes());
		nombreArchivo 	= "R04_C0452_"+mesEnLetras+"_"+anio; 
		
		listaRegulatorioC0452Bean =  regulatorioC0452DAO.reporteRegulatorioC0452Sofipo(reporteBean,tipoLista);
		int contador = 1;
		
		if(listaRegulatorioC0452Bean != null){
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
				hoja = (SXSSFSheet) libro.createSheet("C 0452");
				
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
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL CREDITO");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            3, //primer celda (0-based)
			            5 //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)6);
				celda.setCellValue("SECCIÓN SEGUIMIENTO DEL CRÉDITO CON DATOS A LA FECHA DE CORTE");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            6, //primer celda (0-based)
			            23  //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)24);
				celda.setCellValue("SECCIÓN SEGUIMIENTO DEL CRÉDITO CON DATOS AL CIERRE DEL PERIODO");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            24, //primer celda (0-based)
			            56  //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)57);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DE AVALES Y GARANTIAS");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            57, //primer celda (0-based)
			            67  //ultima celda   (0-based)
			    ));
				
				
				celda = fila.createCell((short)68);
				celda.setCellValue("SECCIÓN CÁLCULO DE LAS ESTIMACIONES PREVENTIVAS");
				celda.setCellStyle(estiloAgrupacion);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //primera fila (0-based)
			            0, //ultima fila  (0-based)
			            68, //primer celda (0-based)
			            86  //ultima celda   (0-based)
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
					
					celda=fila.createCell((short)2);
					celda.setCellValue("REPORTE");
					celda.setCellStyle(estiloEncabezado);
					
					/*
					 * ====== IDENTIFICADOR DEL CREDITO
					 */
					
					celda=fila.createCell((short)3);
					celda.setCellValue("IDENTIFICADOR DEL CRÉDITO ASIGNADO METODOLOGÍA CNBV");
					celda.setCellStyle(estiloEncabezado);
					
					
					celda=fila.createCell((short)4);
					celda.setCellValue("NÚMERO DE LA DISPOSICIÓN");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)5);
					celda.setCellValue("CLASIFICACIÓN CONTABLE (R01 CATÁLOGO MÍNIMO)");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)6);
					celda.setCellValue("FECHA DE CORTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)7);
					celda.setCellValue("SALDO INSOLUTO INICIAL A LA FECHA DE CORTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)8);
					celda.setCellValue("MONTO DISPUESTO EN LA FECHA DE CORTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)9);
					celda.setCellValue("MONTO DE INTERESES ORDINARIOS A LA FECHA DE CORTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)10);
					celda.setCellValue("MONTO DE INTERESES MORATORIOS A LA FECHA DE CORTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)11);
					celda.setCellValue("MONTO DE COMISIONES GENERADAS EN LA FECHA DE CORTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)12);
					celda.setCellValue("MONTO DEL IMPUESTO AL VALOR AGREGADO A LA FECHA DE CORTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)13);
					celda.setCellValue("MONTO DEL PAGO DE CAPITAL EXIGIBLE AL ACREDITADO A LA FECHA DE CORTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)14);
					celda.setCellValue("MONTO DEL PAGO DE INTERESES EXIGIBLE AL ACREDITADO A LA FECHA DE  CORTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)15);
					celda.setCellValue("MONTO DEL PAGO DE COMISIONES EXIGIBLE AL ACREDITADO A LA FECHA DE CORTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)16);
					celda.setCellValue("MONTO DE CAPITAL PAGADO EFECTIVAMENTE POR EL ACREDITADO A LA FECHA DE CORTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)17);
					celda.setCellValue("MONTO DE LOS INTERESES ORDINARIOS PAGADOS EFECTIVAMENTE POR EL ACREDITADO A LA FECHA DE CORTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)18);
					celda.setCellValue("MONTO DE LOS INTERESES ORDINARIOS PAGADOS EFECTIVAMENTE POR EL ACREDITADO A LA FECHA DE CORTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)19);
					celda.setCellValue("MONTO DE LAS COMISIONES PAGADAS EFECTIVAMENTE POR EL ACREDITADO A LA FECHA DE CORTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)20);
					celda.setCellValue("MONTO DE OTROS ACCESORIOS PAGADOS EFECTIVAMENTE POR EL ACREDITADO A LA FECHA DE CORTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)21);
					celda.setCellValue("TASA DE INTERÉS ANUAL ORDINARIA A LA FECHA DE CORTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)22);
					celda.setCellValue("TASA DE INTERÉS ANUAL MORATORIA A LA FECHA DE CORTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)23);
					celda.setCellValue("SALDO INSOLUTO DEL CRÉDITO A LA FECHA DE CORTE");
					celda.setCellStyle(estiloEncabezado);
					
					/*
					 * ==========  Seguimiento Credito == Cierre Periodo
					 */
					celda=fila.createCell((short)24);
					celda.setCellValue("FECHA DE LA ÚLTIMA DISPOSICIÓN DEL CRÉDITO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)25);
					celda.setCellValue("PLAZO AL VENCIMIENTO DE LA LÍNEA DE CRÉDITO ORIGINAL");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)26);
					celda.setCellValue("SALDO DEL PRINCIPAL AL INICIO DEL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)27);
					celda.setCellValue("MONTO DISPUESTO DE LA LÍNEA DE CRÉDITO EN EL MES");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)28);
					celda.setCellValue("CRÉDITO DISPONIBLE DE LA LÍNEA DE CRÉDITO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)29);
					celda.setCellValue("TASA INTERÉS ANUAL ORDINARIA EN EL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)30);
					celda.setCellValue("TASA DE INTERÉS ANUAL MORATORIA EN EL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)31);
					celda.setCellValue("MONTO DE INTERESES ORDINARIOS EN EL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)32);
					celda.setCellValue("MONTO DE INTERESES MORATORIOS EN EL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)33);
					celda.setCellValue("MONTO DE INTERESES REFINANCIADOS O RECAPITALIZADOS EN EL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)34);
					celda.setCellValue("MONTO DE INTERESES POR REVERSOS DE COBROS EN EL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)35);
					celda.setCellValue("SALDO BASE PARA EL CÁLCULO DE INTERESES EN EL PERIODO (SALDO PROMEDIO DIARIO)");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)36);
					celda.setCellValue("NÚMERO DE DÍAS UTILIZADOS PARA EL CÁLCULO DE INTERESES EN EL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)37);
					celda.setCellValue("COMISIONES GENERADAS EN EL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)38);
					celda.setCellValue("MONTO RECONOCIDO POR CONDONACIÓN EN EL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)39);
					celda.setCellValue("MONTO RECONOCIDO POR QUITA O CASTIGOS EN EL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)40);
					celda.setCellValue("MONTO BONIFICADO POR LA ENTIDAD FINANCIERA EN EL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)41);
					celda.setCellValue("MONTO RECONOCIDO POR DESCUENTOS EN EL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)42);
					celda.setCellValue("MONTO DE OTROS AUMENTOS O DECREMENTOS DEL PRINCIPAL EN EL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)43);
					celda.setCellValue("MONTO DE CAPITAL PAGADO EFECTIVAMENTE POR EL ACREDITADO EN EL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)44);
					celda.setCellValue("MONTO DE LOS INTERESES ORDINARIOS PAGADOS EFECTIVAMENTE POR EL ACREDITADO EN EL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)45);
					celda.setCellValue("MONTO DE LOS INTERESES MORATORIOS PAGADOS EFECTIVAMENTE POR EL ACREDITADO EN EL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)46);
					celda.setCellValue("MONTO DE LAS COMISIONES PAGADAS EFECTIVAMENTE POR EL ACREDITADO EN EL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)47);
					celda.setCellValue("MONTO DE OTROS ACCESORIOS PAGADOS EFECTIVAMENTE POR EL ACREDITADO EN EL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)48);
					celda.setCellValue("MONTO TOTAL PAGADO EFECTIVAMENTE POR EL ACREDITADO EN EL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)49);
					celda.setCellValue("SALDO DEL PRINCIPAL AL FINAL DEL PERIODO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)50);
					celda.setCellValue("SALDO INSOLUTO AL FINAL DEL PERIODO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)51);
					celda.setCellValue("SITUACIÓN DEL CRÉDITO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)52);
					celda.setCellValue("TIPO DE RECUPERACIÓN DEL CRÉDITO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)53);
					celda.setCellValue("NÚMERO DE DÍAS DE MORA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)54);
					celda.setCellValue("FECHA DEL ÚLTIMO PAGO COMPLETO EXIGIBLE REALIZADO POR EL ACREDITADO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)55);
					celda.setCellValue("MONTO DEL ÚLTIMO PAGO COMPLETO EXIGIBLE REALIZADO POR EL ACREDITADO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)56);
					celda.setCellValue("FECHA DE PRIMERA AMORTIZACIÓN NO CUBIERTA");
					celda.setCellStyle(estiloEncabezado);
					
					/*
					 *  === Seccion de las grantias ya avales
					 */
					
					celda=fila.createCell((short)57);
					celda.setCellValue("TIPO DE GARANTÍA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)58);
					celda.setCellValue("NÚMERO DE GARANTÍAS");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)59);
					celda.setCellValue("PROGRAMA DE CRÉDITO DEL GOBIERNO FEDERAL");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)60);
					celda.setCellValue("MONTO DE LA GARANTÍA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)61);
					celda.setCellValue("PORCENTAJE QUE REPRESENTA LA GARANTÍA DEL SALDO INSOLUTO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)62);
					celda.setCellValue("GRADO DE PRELACIÓN DE LA GARANTÍA ");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)63);
					celda.setCellValue("FECHA DE VALUACIÓN DE LA GARANTÍA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)64);
					celda.setCellValue("NÚMERO DE AVALES");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)65);
					celda.setCellValue("PORCENTAJE QUE GARANTIZA EL AVAL O AVALES");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)66);
					celda.setCellValue("NOMBRE DEL GARANTE O AVAL");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)67);
					celda.setCellValue("RFC DEL GARANTE O AVAL");
					celda.setCellStyle(estiloEncabezado);
					
					/*
					 *  === Calculo de la EPRC
					 */
					celda=fila.createCell((short)68);
					celda.setCellValue("TIPO DE CARTERA PARA FINES DE CALIFICACIÓN");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)69);
					celda.setCellValue("CALIFICACIÓN DE LA PARTE CUBIERTA CONFORME A LA METODOLOGÍA DE INSTITUCIONES DE CRÉDITO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)70);
					celda.setCellValue("CALIFICACIÓN DE LA PARTE EXPUESTA CONFORME A LA METODOLOGÍA DE INSTITUCIONES DE CRÉDITO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)71);
					celda.setCellValue("ZONA MARGINADA");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)72);
					celda.setCellValue("CLAVE DE PREVENCIÓN");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)73);
					celda.setCellValue("FUENTE DE FONDEO DEL CRÉDITO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)74);
					celda.setCellValue("PORCENTAJE DE ESTIMACIONES PREVENTIVAS A APLICAR PARA MONTO CUBIERTO");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)75);
					celda.setCellValue("MONTO DEL CRÉDITO CUBIERTO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)76);
					celda.setCellValue("MONTO DE ESTIMACIONES PREVENTIVAS PARTE CUBIERTA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)77);
					celda.setCellValue("PORCENTAJE DE ESTIMACIONES PREVENTIVAS A APLICAR PARA MONTO EXPUESTO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)78);
					celda.setCellValue("MONTO DEL CRÉDITO EXPUESTO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)79);
					celda.setCellValue("MONTO DE ESTIMACIONES PREVENTIVAS PARTE EXPUESTA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)80);
					celda.setCellValue("MONTO DE LAS ESTIMACIONES PREVENTIVAS TOTALES DERIVADAS DE LA CALIFICACIÓN");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)81);
					celda.setCellValue("MONTO DE LAS ESTIMACIONES PREVENTIVAS ADICIONALES POR RIESGOS OPERATIVOS (SIC)");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)82);
					celda.setCellValue("MONTO DE LAS ESTIMACIONES PREVENTIVAS ADICIONALES POR INTERESES DEVENGADOS NO COBRADOS DE CRÉDITOS VENCIDOS (EN BALANCE)");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)83);
					celda.setCellValue("MONTO DE LAS ESTIMACIONES PREVENTIVAS ADICIONALES ORDENADAS POR LA CNBV Y/O FEDERACIÓN");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)84);
					celda.setCellValue("MONTO DE LAS ESTIMACIONES PREVENTIVAS ADICIONALES TOTALES");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)85);
					celda.setCellValue("MONTO DE LAS ESTIMACIONES PREVENTIVAS ADICIONALES POR INTERESES DEVENGADOS NO COBRADOS DE CRÉDITOS VENCIDOS (CUENTAS DE ORDEN)");
					celda.setCellStyle(estiloEncabezado);
					
					celda=fila.createCell((short)86);
					celda.setCellValue("ESTIMACIONES PREVENTIVAS TOTALES DERIVADAS DE LA CALIFICACIÓN DEL MES INMEDIATO ANTERIOR");
					celda.setCellStyle(estiloEncabezado);
					
					
					
					int rowExcel=2;
					contador=2;
					RegulatorioA2611Bean regRegulatorioA2611Bean = null;
					
					for(int x = 0; x< listaRegulatorioC0452Bean.size() ; x++ ){
						
											
						
						fila=hoja.createRow(rowExcel);
								
						celda=fila.createCell((short)0);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getPeriodo());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)1);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getClaveEntidad());
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)2);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getReporte());
						celda.setCellStyle(estilo8);
						
						/*
						 * == Identificador del credito
						 * 
						 */
						
						celda=fila.createCell((short)3);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getIdencreditoCNBV());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)4);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getNumeroDisposicion());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)5);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getClasificacionConta());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)6);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getFechaCorte());
						celda.setCellStyle(estilo8);

						/*
						 * == Creditos a la fecha de corte
						 */
						
						celda=fila.createCell((short)7);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getSaldoInsolutoInicialFC()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)8);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoDispuestoFC()));
						celda.setCellStyle(estilo8);
							
						celda=fila.createCell((short)9);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getInteresOrdinarioFC()));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)10);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getInteresMoratorioFC()));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)11);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getComisionGeneFC()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)12);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoIVAFC()));
						celda.setCellStyle(estilo8);
							
						celda=fila.createCell((short)13);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getPagoCapitalExFC()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)14);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getPagoInteresExFC()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)15);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getPagoComisionExFC()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)16);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getCapitalPagEfecFC()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)17);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getPagoInteresOrdinarioFC()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)18);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getPagoInteresMoratoriFC()));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)19);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getPagoComisionGeneFC()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)20);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getPagoAccesoriosFC()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)21);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getTasaAnualFC());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)22);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getTasaMoratoriaFC());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)23);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getSaldoInsolutoFinalFC()));
						celda.setCellStyle(estilo8);

						/*
						 *  == creditos al cierre del periodo
						 */

						celda=fila.createCell((short)24);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getFechaUltimaDispoCP());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)25);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getPlazoVencimienLineaCP());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)26);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getSaldoPrincipalInicialCP()));
						celda.setCellStyle(estilo8);
							
						celda=fila.createCell((short)27);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoDispuestoCP()));
						celda.setCellStyle(estilo8);
							
						celda=fila.createCell((short)28);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getCredDisponibleLineaCP()));
						celda.setCellStyle(estilo8);
							
						celda=fila.createCell((short)29);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getTasaInteresOrdinariaCP());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)30);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getTasaInteresMoratoriaCP());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)31);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getInteresOrdinarioCP()));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)32);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getInteresMoratorioCP()));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)33);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getInteresRefinanciadoCP()));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)34);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getInteresReversoCobroCP()));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)35);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getSaldoBaseCobroCP()));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)36);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getNumeroDiasCalculoCP());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)37);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getComisionGeneCP()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)38);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoCondonacionCP()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)39);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoQuitasCP()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)40);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoBonificacionCP()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)41);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoDescuentosCP()));
						celda.setCellStyle(estilo8);
							
						celda=fila.createCell((short)42);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoAumentosDecreCP()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)43);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getCapitalPagEfecCP()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)44);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getPagoIntOrdinarioCP()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)45);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getPagoIntMoratorioCP()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)46);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getPagoComisionesCP()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)47);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getPagoAccesoriosCP()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)48);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getPagoTotalCP()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)49);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getSaldoPrincipalFinalCP()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)50);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getSaldoInsolutoCP()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)51);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getSituacionCreditoCP());
						celda.setCellStyle(estilo8);
							
						celda=fila.createCell((short)52);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getTipoRecuperacionCP());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)53);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getNumeroDiasMoraCP());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)54);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getFechaUltPagoCompleto());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)55);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoUltPagocompleto()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)56);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getFechaPrimAmortizacionNC());
						celda.setCellStyle(estilo8);

						/*
						 *  === Avales y garantias
						 */

						celda=fila.createCell((short)57);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getTipoGarantia());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)58);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getNumeroGarantias());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)59);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getProgCredGobierno());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)60);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoGarantia()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)61);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getPorcentajeGarSaldo());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)62);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getGradoPrelacionGar());
						celda.setCellStyle(estilo8);
							
						celda=fila.createCell((short)63);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getFechaValuacion());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)64);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getNumeroAvales());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)65);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getPorcentajeGarAvales());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)66);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getNombreGarante());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)67);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getRfcGarante());
						celda.setCellStyle(estilo8);

						/*
						 *  === Estimaciones preventivas
						 */

						celda=fila.createCell((short)68);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getTipoCartera());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)69);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getCalParteCubierta());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)70);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getCalParteExpuesta());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)71);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getZonaMarginada());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)72);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getClavePrevencion());
						celda.setCellStyle(estilo8);
							
						celda=fila.createCell((short)73);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getFuenteFondeo());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)74);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getPorcentajeCubierto());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)75);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoCubierto()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)76);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoEPRCCubierto()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)77);
						celda.setCellValue(listaRegulatorioC0452Bean.get(x).getPorcentajeExpuesto());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)78);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoExpuesto()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)79);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoEPRCExpuesto()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)80);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoEPRCTotales()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)81);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoEPRCAdiRiesgoOpe()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)82);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoEPRCAdiIntDevNC()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)83);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoEPRCAdiCNBV()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)84);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoEPRCAdiTotales()));
						celda.setCellStyle(estilo8);
						
						celda=fila.createCell((short)85);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoEPRCAdiCtaOrden()));
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)86);
						celda.setCellValue(Utileria.convierteDoble(listaRegulatorioC0452Bean.get(x).getMontoEPRCMesAnterior()));
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
		return listaRegulatorioC0452Bean;
	}



	public RegulatorioC0452DAO getRegulatorioC0452DAO() {
		return regulatorioC0452DAO;
	}



	public void setRegulatorioC0452DAO(RegulatorioC0452DAO regulatorioC0452DAO) {
		this.regulatorioC0452DAO = regulatorioC0452DAO;
	}


	

	
	
}
