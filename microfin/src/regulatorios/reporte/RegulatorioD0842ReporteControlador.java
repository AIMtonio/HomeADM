package regulatorios.reporte;

import herramientas.Utileria;

import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
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
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.RegulatorioI0391Bean;
import regulatorios.servicio.RegulatorioI0391Servicio;
import regulatorios.servicio.RegulatorioI0391Servicio.Enum_Lis_ReportesI0391;
import regulatorios.bean.RegulatorioD0842Bean;
import regulatorios.servicio.RegulatorioD0842Servicio;
import regulatorios.servicio.RegulatorioD0842Servicio.Enum_Lis_ReportesD0842;

public class RegulatorioD0842ReporteControlador extends AbstractCommandController{
	RegulatorioD0842Servicio regulatorioD0842Servicio = null;
	String successView = null;

	
	public RegulatorioD0842ReporteControlador () {
		setCommandClass(RegulatorioD0842Bean.class);
		setCommandName("regulatorioD0842Bean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		RegulatorioD0842Bean reporteBean = (RegulatorioD0842Bean) command;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")):0;
		
		switch(tipoReporte)	{
			case Enum_Lis_ReportesD0842.excel:		
				reporteRegulatorioD0842(tipoReporte,reporteBean,response);
				break;
			case Enum_Lis_ReportesD0842.csv:
				regulatorioD0842Servicio.listaReporteRegulatorioD0842(tipoReporte, reporteBean, response); ;
			case Enum_Lis_ReportesD0842.excelSofipo:		
				reporteRegulatorioD084203(tipoReporte,reporteBean,response);
				break;
			case Enum_Lis_ReportesD0842.csvSofipo:
				regulatorioD0842Servicio.listaReporteRegulatorioD0842(tipoReporte, reporteBean, response); ;
		}
		return null;	
	}


	/**
	 * Generacion de reporte D-0842 en Excel
	 * 
	 * @param tipoReporte
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	
	// Reporte a Excel
	public List<RegulatorioD0842Bean> reporteRegulatorioD084203(int tipoLista,RegulatorioD0842Bean D0842Bean, 
									HttpServletResponse response){
		List<RegulatorioD0842Bean> listaD0842Bean = null;
		String mesEnLetras	 = "";
		String anio			 = "";
		String nombreArchivo = "";
		
		mesEnLetras = regulatorioD0842Servicio.descripcionMes(D0842Bean.getMes());
		anio	= D0842Bean.getAnio();		
		
		nombreArchivo = "REG_D_0842_"+mesEnLetras +"_"+anio; 
		
		/*Se hace la llamada para obtener la lista para llenar el reporte*/
		
		listaD0842Bean = regulatorioD0842Servicio.listaReporteRegulatorioD0842(tipoLista, D0842Bean,response);
		
		if(listaD0842Bean != null){
	
			try {
				HSSFWorkbook libro = new HSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				HSSFFont fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				HSSFFont fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				HSSFFont fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)8);
				fuente8.setFontName(HSSFFont.FONT_ARIAL);
				
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				HSSFCellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				
				//Estilo negrita de 8  para encabezados del reporte
				HSSFCellStyle estiloNegro = libro.createCellStyle();
				estiloNegro.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setFont(fuenteNegrita8);
				
				//Estilo de 8  para Contenido
				HSSFCellStyle estiloNormal = libro.createCellStyle();
				HSSFDataFormat format = libro.createDataFormat();
				estiloNormal.setFont(fuente8);
				estiloNormal.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setDataFormat(format.getFormat("#,##0"));
				
				HSSFCellStyle estiloDerecha = libro.createCellStyle();
				format = libro.createDataFormat();
				estiloDerecha.setFont(fuente8);
				estiloDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
				estiloDerecha.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setDataFormat(format.getFormat("$#,##0"));
				
				HSSFCellStyle estiloPorcentaje = libro.createCellStyle();
				format = libro.createDataFormat();
				estiloPorcentaje.setFont(fuente8);
				estiloPorcentaje.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
				estiloPorcentaje.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloPorcentaje.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloPorcentaje.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloPorcentaje.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloPorcentaje.setDataFormat(format.getFormat("#,##0%"));
	
				//Estilo negrita tamaño 8 centrado
				HSSFCellStyle estiloEncabezado = libro.createCellStyle();
				estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				estiloEncabezado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setFont(fuenteNegrita8);
			
	
				//Estilo para una celda con dato con color de fondo gris
				HSSFCellStyle celdaGrisDato = libro.createCellStyle();
				HSSFDataFormat formato3 = libro.createDataFormat();
				celdaGrisDato.setFont(fuenteNegrita8);
				celdaGrisDato.setDataFormat(formato3.getFormat("#,##0"));
				celdaGrisDato.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				celdaGrisDato.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				celdaGrisDato.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				celdaGrisDato.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);


				
				// Creacion de hoja
				HSSFSheet hoja = libro.createSheet("Desg Pres Bancarios D-0842");
				
				
				HSSFRow fila= hoja.createRow(0);
				fila = hoja.createRow(0);

				//Encabezados
				HSSFRow filaTitulo= hoja.createRow(0);
				HSSFCell celda=filaTitulo.createCell((short)0);
	
				
				fila = hoja.createRow(1);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("INFORMACIÓN SOLICITADA");
				celda.setCellStyle(estiloEncabezado);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            43  //ultima celda   (0-based)
			    ));
				
				
				fila = hoja.createRow(2);				
				
				celda = fila.createCell((short)0);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL REPORTE");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)3);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL PRESTAMISTA");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            3, //primer celda (0-based)
			            5 //ultima celda   (0-based)
			    ));
				
				celda = fila.createCell((short)6);
				celda.setCellValue("SECCIÓN DATOS DE OPERACIÓN");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            6, //primer celda (0-based)
			            43 //ultima celda   (0-based)
			    ));
				
				fila = hoja.createRow(3);
				celda = fila.createCell((short)0);
				celda.setCellValue("PERIODO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("CLAVE DE LA ENTIDAD");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("REPORTE");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("IDENTIFICACIÓN DEL OTORGANTE DEL PRÉSTAMO");				
				celda.setCellStyle(estiloEncabezado);
					
				celda = fila.createCell((short)4);
				celda.setCellValue("TIPO DE PRESTAMISTA");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("PAÍS DEL ORGANISMO O ENTIDAD FINANCIERA EXTRANJERA");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("NÚMERO DE CUENTA ");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("NÚMERO DE CONTRATO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("CLASIFICACION CONTABLE ");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("FECHA DE CONTRATACION  O APERTURA");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)10);
				celda.setCellValue("FECHA DE VENCIMIENTO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("PLAZO AL VENCIMIENTO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)12);
				celda.setCellValue("PERIODICIDAD DEL PLAN DE PAGOS ACORDADO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)13);
				celda.setCellValue("MONTO INICIAL DEL PRÉSTAMO EN LA MONEDA DE ORIGEN");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)14);
				celda.setCellValue("MONTO INICIAL DEL PRÉSTAMO VALORIZADO EN PESOS");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)15);
				celda.setCellValue("TIPO DE TASA ");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)16);
				celda.setCellValue("VALOR DE LA TASA  ORIGINALMENTE PACTADA");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)17);
				celda.setCellValue("VALOR DE LA TASA DE INTERÉS APLICABLE EN EL PERÍODO ");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)18);
				celda.setCellValue("TASA DE INTERÉS DE REFERENCIA");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)19);
				celda.setCellValue("DIFERENCIAL SOBRE TASA DE REFERENCIA");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)20);
				celda.setCellValue("OPERACIÓN DE DIFERENCIAL SOBRE TASA DE REFERENCIA");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)21);
				celda.setCellValue("FRECUENCIA DE LA REVISIÓN DE LA TASA");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)22);
				celda.setCellValue("TIPO DE MONEDA");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)23);
				celda.setCellValue("PORCENTAJE DE LA COMISIÓN PACTADA");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)24);
				celda.setCellValue("IMPORTE DE LA COMISIÓN PACTADA");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)25);
				celda.setCellValue("PERIODICIDAD DEL PAGO DE LA COMISIÓN");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)26);
				celda.setCellValue("TIPO DE DISPOSICION DEL CRÉDITO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)27);
				celda.setCellValue("DESTINO DE LOS RECURSOS");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)28);
				celda.setCellValue("CLASIFICACIÓN DE CORTO O LARGO PLAZO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)29);
				celda.setCellValue("SALDO AL INICIO DEL PERÍODO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)30);
				celda.setCellValue("PAGOS REALIZADOS EN EL PERÍODO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)31);
				celda.setCellValue("COMISIONES PAGADAS EN EL PERÍODO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)32);
				celda.setCellValue("INTERÉSES PAGADOS EN EL PERÍODO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)33);
				celda.setCellValue("INTERÉSES DEVENGADOS NO PAGADOS");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)34);
				celda.setCellValue("SALDO AL CIERRE DEL PERIODO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)35);
				celda.setCellValue("PORCENTAJE DISPUESTO DE LA LÍNEA REVOLVENTE");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)36);
				celda.setCellValue("FECHA DEL ÚLTIMO PAGO REALIZADO AL PRÉSTAMO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)37);
				celda.setCellValue("PAGO ANTICIPADO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)38);
				celda.setCellValue("MONTO DEL ÚLTIMO PAGO REALIZADO AL PRÉSTAMO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)39);
				celda.setCellValue("FECHA DEL PAGO INMEDIATO SIGUIENTE");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)40);
				celda.setCellValue("MONTO DEL PAGO INMEDIATO SIGUIENTE");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)41);
				celda.setCellValue("TIPO DE GARANTÍA");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)42);
				celda.setCellValue("VALOR DE LA GARANTÍA");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)43);
				celda.setCellValue("FECHA DE VALUACIÓN DE LA GARANTÍA");
				celda.setCellStyle(estiloEncabezado);
								
				
				int i=4;		
				for(RegulatorioD0842Bean regD0842Bean : listaD0842Bean ){
		
					fila=hoja.createRow(i);
					
					celda=fila.createCell((short)0);
					celda.setCellValue(regD0842Bean.getPeriodoRep());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)1);
					celda.setCellValue(regD0842Bean.getClaveEntidad());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)2);
					celda.setCellValue(regD0842Bean.getFormulario());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)3);
					celda.setCellValue(regD0842Bean.getNumeroIden());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)4);
					celda.setCellValue(regD0842Bean.getTipoPrestamista());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)5);
					celda.setCellValue(regD0842Bean.getPaisEntidadExtranjera());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)6);
					celda.setCellValue(regD0842Bean.getNumeroCuenta());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)7);
					celda.setCellValue(regD0842Bean.getNumeroContrato());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)8);
					celda.setCellValue(regD0842Bean.getClasificaConta());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)9);
					celda.setCellValue(regD0842Bean.getFechaContra());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)10);
					celda.setCellValue(regD0842Bean.getFechaVencim());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)11);
					celda.setCellValue(regD0842Bean.getPlazo());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)12);
					celda.setCellValue(regD0842Bean.getPeriodo());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)13);
					celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getMontoRecibido()));
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)14);
					celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getMontoInicialPrestamo()));
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)15);
					celda.setCellValue(regD0842Bean.getTipoTasa());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)16);
					celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getValTasaOriginal()));
					celda.setCellStyle(estiloPorcentaje);
					
					celda=fila.createCell((short)17);
					celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getValTasaInt()));
					celda.setCellStyle(estiloPorcentaje);
					
					celda=fila.createCell((short)18);
					celda.setCellValue(regD0842Bean.getTasaIntReferencia());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)19);
					celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getDiferenciaTasaRef()));
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)20);
					celda.setCellValue(regD0842Bean.getOperaDifTasaRefe());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)21);
					celda.setCellValue(regD0842Bean.getFrecRevisionTasa());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)22);
					celda.setCellValue(regD0842Bean.getTipoMoneda());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)23);
					celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getPorcentajeComision()));
					celda.setCellStyle(estiloPorcentaje);
					
					celda=fila.createCell((short)24);
					celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getImporteComision()));
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)25);
					celda.setCellValue(regD0842Bean.getPeriodoPago());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)26);
					celda.setCellValue(regD0842Bean.getTipoDisposicionCredito());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)27);
					celda.setCellValue(regD0842Bean.getDestino());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)28);
					celda.setCellValue(regD0842Bean.getClasificaCortLarg());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)29);
					celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getSaldoInicio()));
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)30);
					celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getPagosRealizados()));
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)31);
					celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getComisionPagada()));
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)32);
					celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getInteresesPagados()));
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)33);
					celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getInteresesDevengados()));
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)34);
					celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getSaldoCierre()));
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)35);
					celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getPorcentajeLinRevolvente()));
					celda.setCellStyle(estiloPorcentaje);
					
					celda=fila.createCell((short)36);
					celda.setCellValue(regD0842Bean.getFechaUltPago());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)37);
					celda.setCellValue(regD0842Bean.getPagoAnticipado());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)38);
					celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getMontoUltimoPago()));
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)39);
					celda.setCellValue(regD0842Bean.getFechaPagoInmediato());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)40);
					celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getMontoPagoInmediato()));
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)41);
					celda.setCellValue(regD0842Bean.getTipoGarantia());
					celda.setCellStyle(estiloNormal);
					
					celda=fila.createCell((short)42);
					celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getMontoGarantia()));
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)43);
					celda.setCellValue(regD0842Bean.getFechaValuacionGaran());
					celda.setCellStyle(estiloNormal);
					
					i++;
				}
										
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
		}
		
		return listaD0842Bean;
	

	}
	
	// Reporte de Calificacion y Estimaciones a Excell
		public List<RegulatorioD0842Bean> reporteRegulatorioD0842(int tipoLista,RegulatorioD0842Bean i0391Bean, 
										HttpServletResponse response){
			List<RegulatorioD0842Bean> listaD0842Bean = null;
			String mesEnLetras	 = "";
			String anio			 = "";
			String nombreArchivo = "";
			
			mesEnLetras = regulatorioD0842Servicio.descripcionMes(i0391Bean.getMes());
			anio	= i0391Bean.getAnio();		
			
			nombreArchivo = "R03_D_0842_"+mesEnLetras +"_"+anio; 
			
			/*Se hace la llamada para obtener la lista para llenar el reporte*/
			
			listaD0842Bean = regulatorioD0842Servicio.listaReporteRegulatorioD0842(tipoLista, i0391Bean,response);
			
			if(listaD0842Bean != null){
		
				try {
					HSSFWorkbook libro = new HSSFWorkbook();
					//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
					HSSFFont fuenteNegrita10= libro.createFont();
					fuenteNegrita10.setFontHeightInPoints((short)10);
					fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
					fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
					
					//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
					HSSFFont fuenteNegrita8= libro.createFont();
					fuenteNegrita8.setFontHeightInPoints((short)8);
					fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
					fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
					
					//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
					HSSFFont fuente8= libro.createFont();
					fuente8.setFontHeightInPoints((short)8);
					fuente8.setFontName(HSSFFont.FONT_ARIAL);
					
					// La fuente se mete en un estilo para poder ser usada.
					//Estilo negrita de 10 para el titulo del reporte
					HSSFCellStyle estiloNeg10 = libro.createCellStyle();
					estiloNeg10.setFont(fuenteNegrita10);
					
					//Estilo negrita de 8  para encabezados del reporte
					HSSFCellStyle estiloNegro = libro.createCellStyle();
					estiloNegro.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
					estiloNegro.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
					estiloNegro.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
					estiloNegro.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
					estiloNegro.setFont(fuenteNegrita8);
					
					//Estilo de 8  para Contenido
					HSSFCellStyle estiloNormal = libro.createCellStyle();
					HSSFDataFormat format = libro.createDataFormat();
					estiloNormal.setFont(fuente8);
					estiloNormal.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
					estiloNormal.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
					estiloNormal.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
					estiloNormal.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
					estiloNormal.setDataFormat(format.getFormat("#,##0"));
					
					HSSFCellStyle estiloDerecha = libro.createCellStyle();
					format = libro.createDataFormat();
					estiloDerecha.setFont(fuente8);
					estiloDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
					estiloDerecha.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
					estiloDerecha.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
					estiloDerecha.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
					estiloDerecha.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
					estiloDerecha.setDataFormat(format.getFormat("#,##0"));
		
					//Estilo negrita tamaño 8 centrado
					HSSFCellStyle estiloEncabezado = libro.createCellStyle();
					estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
					estiloEncabezado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
					estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
					estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
					estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
					estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
					estiloEncabezado.setFont(fuenteNegrita8);
				
		
					//Estilo para una celda con dato con color de fondo gris
					HSSFCellStyle celdaGrisDato = libro.createCellStyle();
					HSSFDataFormat formato3 = libro.createDataFormat();
					celdaGrisDato.setFont(fuenteNegrita8);
					celdaGrisDato.setDataFormat(formato3.getFormat("#,##0"));
					celdaGrisDato.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
					celdaGrisDato.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
					celdaGrisDato.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
					celdaGrisDato.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
					celdaGrisDato.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
					celdaGrisDato.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
					celdaGrisDato.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);


					
					// Creacion de hoja
					HSSFSheet hoja = libro.createSheet("Desg Pres Bancarios D-0842");
					
					
					HSSFRow fila= hoja.createRow(0);
					fila = hoja.createRow(0);

					//Encabezados
					HSSFRow filaTitulo= hoja.createRow(0);
					HSSFCell celda=filaTitulo.createCell((short)0);
		
					
					fila = hoja.createRow(1);
					
					celda = fila.createCell((short)0);
					celda.setCellValue("INFORMACIÓN SOLICITADA");
					celda.setCellStyle(estiloEncabezado);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            1, //primera fila (0-based)
				            1, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            21  //ultima celda   (0-based)
				    ));
					
					
					fila = hoja.createRow(2);				
					
					celda = fila.createCell((short)0);
					celda.setCellValue("SECCIÓN IDENTIFICADOR DEL REPORTE");
					celda.setCellStyle(celdaGrisDato);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            2, //primera fila (0-based)
				            2, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            2  //ultima celda   (0-based)
				    ));
					
					celda = fila.createCell((short)3);
					celda.setCellValue("SECCIÓN IDENTIFICADOR DEL PRESTAMISTA");
					celda.setCellStyle(celdaGrisDato);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            2, //primera fila (0-based)
				            2, //ultima fila  (0-based)
				            3, //primer celda (0-based)
				            5 //ultima celda   (0-based)
				    ));
					
					celda = fila.createCell((short)6);
					celda.setCellValue("SECCIÓN DATOS DE OPERACIÓN");
					celda.setCellStyle(celdaGrisDato);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            2, //primera fila (0-based)
				            2, //ultima fila  (0-based)
				            6, //primer celda (0-based)
				            21 //ultima celda   (0-based)
				    ));
					
					fila = hoja.createRow(3);
					celda = fila.createCell((short)0);
					celda.setCellValue("PERIODO QUE SE REPORTA");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)1);
					celda.setCellValue("CLAVE DE LA ENTIDAD");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)2);
					celda.setCellValue("SUBREPORTE");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)3);
					celda.setCellValue("NUMERO DE LA IDENTIFICACION");				
					celda.setCellStyle(estiloEncabezado);
						
					celda = fila.createCell((short)4);
					celda.setCellValue("TIPO DE PRESTAMISTA");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)5);
					celda.setCellValue("CLAVE DEL PRESTAMISTA");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)6);
					celda.setCellValue("NUMERO DE CONTRATO ");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)7);
					celda.setCellValue("NUMERO DE CUENTA");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)8);
					celda.setCellValue("FECHA DE CONTRATACION");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)9);
					celda.setCellValue("FECHA DE VENCIMIENTO");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)10);
					celda.setCellValue("TASA ANUAL");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)11);
					celda.setCellValue("PLAZO");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)12);
					celda.setCellValue("PERIODICIDAD EL PLAN DE PAGOS REPORTADO");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)13);
					celda.setCellValue("MONTO ORIGINAL RECIBIDO");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)14);
					celda.setCellValue("TIPO DE CREDITO");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)15);
					celda.setCellValue("DESTINO");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)16);
					celda.setCellValue("TIPO DE GARANTIA");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)17);
					celda.setCellValue("MONTO DE LA GARANTIA");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)18);
					celda.setCellValue("FECHA DEL PAGO INMEDIATO");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)19);
					celda.setCellValue("MONTO DEL PAGO INMEDIATO");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)20);
					celda.setCellValue("CLASIFICACION DE CORTO O LARGO PLAZO");
					celda.setCellStyle(estiloEncabezado);
					
					celda = fila.createCell((short)21);
					celda.setCellValue("SALDO INSOLUTO DEL PRESTAMO");
					celda.setCellStyle(estiloEncabezado);
									
					
					int i=4;		
					for(RegulatorioD0842Bean regD0842Bean : listaD0842Bean ){
			
						fila=hoja.createRow(i);
						
						/* Columna 1 "Periodo" */
						celda=fila.createCell((short)0);
						celda.setCellValue(regD0842Bean.getPeriodo());
						celda.setCellStyle(estiloNormal);
						
						
						/* Columna 2 "Clave de la Entidad" */
						celda=fila.createCell((short)1);
						celda.setCellValue(regD0842Bean.getClaveEntidad());
						celda.setCellStyle(estiloNormal);
						
						/* Columna 3 "Subreporte" */
						celda=fila.createCell((short)2);
						celda.setCellValue(regD0842Bean.getFormulario());
						celda.setCellStyle(estiloNormal);
						
						/* Columna 4 "Numero de Identificacion" */
						celda=fila.createCell((short)3);
						celda.setCellValue(regD0842Bean.getNumeroIden());
						celda.setCellStyle(estiloNormal);
						
						/* Columna 5 "Tipo de Prestamista" */
						celda=fila.createCell((short)4);
						celda.setCellValue(regD0842Bean.getTipoPrestamista());
						celda.setCellStyle(estiloNormal);
						
						
						/* Columna 6 "Clave del Prestamista" */
						celda=fila.createCell((short)5);
						celda.setCellValue(regD0842Bean.getClavePrestamista());
						celda.setCellStyle(estiloNormal);
						
						/* Columna 7 "Numero de Contrato" */
						celda=fila.createCell((short)6);
						celda.setCellValue(regD0842Bean.getNumeroContrato());
						celda.setCellStyle(estiloNormal);
						
						/* Columna 8 "NUmero de Cuenta" */
						celda=fila.createCell((short)7);
						celda.setCellValue(regD0842Bean.getNumeroCuenta());
						celda.setCellStyle(estiloNormal);
						
						
						/* Columna 9 "Fecha Contratacion" */
						celda=fila.createCell((short)8);
						celda.setCellValue(regD0842Bean.getFechaContra());
						celda.setCellStyle(estiloNormal);
						
						/* Columna 10 "Fecha Vencimiento" */
						celda=fila.createCell((short)9);
						celda.setCellValue(regD0842Bean.getFechaVencim());
						celda.setCellStyle(estiloNormal);
						
						/* Columna 11 "Tasa Anual" */
						celda=fila.createCell((short)10);
						celda.setCellValue(regD0842Bean.getTasaAnual());
						celda.setCellStyle(estiloDerecha);
						
						
						/* Columna 12 "Plazo" */
						celda=fila.createCell((short)11);
						celda.setCellValue(regD0842Bean.getPlazo());
						celda.setCellStyle(estiloNormal);
						
						
						/* Columna 13 "Periodicidad Del Plan de Pagos" */
						celda=fila.createCell((short)12);
						celda.setCellValue(regD0842Bean.getPeriodoPago());
						celda.setCellStyle(estiloNormal);
						
						
						/* Columna 14 "Monto Original" */
						celda=fila.createCell((short)13);
						celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getMontoRecibido()));
						celda.setCellStyle(estiloDerecha);					
						
						/* Columna 15 "TIPO DE CREDITO" */
						celda=fila.createCell((short)14);
						celda.setCellValue(regD0842Bean.getTipoCredito());
						celda.setCellStyle(estiloNormal);
						
						/* Columna 16 "Destino" */
						celda=fila.createCell((short)15);
						celda.setCellValue(regD0842Bean.getDestino());
						celda.setCellStyle(estiloNormal);
						
						/* Columna 17 "Tipo de Garantia" */
						celda=fila.createCell((short)16);
						celda.setCellValue(regD0842Bean.getTipoGarantia());
						celda.setCellStyle(estiloNormal);
						
						/* Columna 18 "Monto o Valor de Garantia" */
						celda=fila.createCell((short)17);
						celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getMontoGarantia()));
						celda.setCellStyle(estiloDerecha);
						
						
						/* Columna 19 "Fecha del Pago Inmediato Siguiente" */
						celda=fila.createCell((short)18);
						celda.setCellValue(regD0842Bean.getFechaPago());
						celda.setCellStyle(estiloNormal);
						
						/* Columna 20 "Monto del Pago Inmediato Siguiente" */
						celda=fila.createCell((short)19);
						celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getMontoPago()));
						celda.setCellStyle(estiloDerecha);
						
						/* Columna 21 "Clasificacion Corto o Largo Plazo" */
						celda=fila.createCell((short)20);
						celda.setCellValue(regD0842Bean.getClasificaCortLarg());
						celda.setCellStyle(estiloNormal);
						

						/* Columna 22 "Saldo Insoluto del prestamo" */
						celda=fila.createCell((short)21);
						celda.setCellValue(Utileria.convierteDoble(regD0842Bean.getSalInsoluto()));
						celda.setCellStyle(estiloDerecha);
						
						i++;
					}
											
					hoja.autoSizeColumn(0);
					hoja.autoSizeColumn(1);
					hoja.autoSizeColumn(2);
					hoja.autoSizeColumn(3);
					hoja.autoSizeColumn(4);
					hoja.autoSizeColumn(5);
					hoja.autoSizeColumn(6);
					hoja.autoSizeColumn(7);
					hoja.autoSizeColumn(8);
					hoja.autoSizeColumn(9);
					hoja.autoSizeColumn(10);
					hoja.autoSizeColumn(11);
					hoja.autoSizeColumn(12);
					hoja.autoSizeColumn(13);
					hoja.autoSizeColumn(14);
					hoja.autoSizeColumn(15);
					hoja.autoSizeColumn(16);
					hoja.autoSizeColumn(17);
					hoja.autoSizeColumn(18);
					hoja.autoSizeColumn(19);
					hoja.autoSizeColumn(20);
					hoja.autoSizeColumn(21);
					
											
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
			}
			
			return listaD0842Bean;
		

		}


	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public RegulatorioD0842Servicio getRegulatorioD0842Servicio() {
		return regulatorioD0842Servicio;
	}

	public void setRegulatorioD0842Servicio(
			RegulatorioD0842Servicio regulatorioD0842Servicio) {
		this.regulatorioD0842Servicio = regulatorioD0842Servicio;
	}

	
}