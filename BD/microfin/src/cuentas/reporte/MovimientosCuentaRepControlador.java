package cuentas.reporte;

import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
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
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.ReporteMovimientosBean;
import cuentas.servicio.ReporteMovimientosServicio;
import cuentas.servicio.ReporteMovimientosServicio.Enum_Con_TipRepor;

public class MovimientosCuentaRepControlador extends AbstractCommandController{
	
	ReporteMovimientosServicio reporteMovimientosServicio = null;
	String nombreReporte = null;
	String successView = null;		   
	
	public MovimientosCuentaRepControlador() {
		setCommandClass(ReporteMovimientosBean.class);
		setCommandName("reporteMovimientos");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		ReporteMovimientosBean reporteMovimientosBean = (ReporteMovimientosBean) command;

 		int tipoConsulta =(request.getParameter("tipoConsulta")!=null)?
 								Integer.parseInt(request.getParameter("tipoConsulta")):
								0;
 		
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
		

		String htmlString = ""; 
		switch(tipoReporte){	
			case Enum_Con_TipRepor.ReporPantalla:				
				htmlString = reporteMovimientosServicio.reporteMovimientosCuenta(reporteMovimientosBean, getNombreReporte(),tipoConsulta);		
			break;
			case Enum_Con_TipRepor.ReporPDF:				
				ByteArrayOutputStream htmlStringPDF = reporteMovimientosCuentaPDF(reporteMovimientosBean, nombreReporte, response,tipoConsulta);
			break;
			case Enum_Con_TipRepor.ReporExcel:				
				List<ReporteMovimientosBean>listaReportes = reporteMovimientosCuentaExcel(tipoReporte, tipoConsulta,reporteMovimientosBean ,response);
			break;
		}
		if(tipoReporte ==Enum_Con_TipRepor.ReporPantalla ){
			return new ModelAndView(getSuccessView(), "reporte", htmlString);
		}else {
			return null;
		}	
	}
	
	public ByteArrayOutputStream reporteMovimientosCuentaPDF(ReporteMovimientosBean reporteMovimientosBean, String nombreReporte, 
			HttpServletResponse response,  int tipoConsulta){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = reporteMovimientosServicio.reporteMovimientosCuentaPDF(reporteMovimientosBean, getNombreReporte(),tipoConsulta);
			response.addHeader("Content-Disposition","inline; filename=movimientosCuenta.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	return htmlStringPDF;
	}
	
	public List<ReporteMovimientosBean> reporteMovimientosCuentaExcel(int tipoReporte,int tipoConsulta,ReporteMovimientosBean reporteMovimientosBean,  HttpServletResponse response){
		List<ReporteMovimientosBean> listaSolicitudes=null;
		List<ReporteMovimientosBean> listaEncabezado=null;
	
			listaSolicitudes = reporteMovimientosServicio.listaReporte(tipoReporte, reporteMovimientosBean, response);
			listaEncabezado = reporteMovimientosServicio.listaEncabezado(tipoConsulta, reporteMovimientosBean, response);
			
	     
		int regExport = 0;
		Calendar calendario = Calendar.getInstance();
		String nombreArchivo 		= "";
		
		nombreArchivo 	= "MovimientosCuenta"; 
		
		int contador = 1;
		if(listaSolicitudes != null){
					try {

						//////////////////////////////////////////////////////////////////////////////////////
						////////////////////// ENCABEZADO y CONFIGURACION DEL  EXCEL /////////////////////////////////////////
			
						Workbook libro = new SXSSFWorkbook();
				
//Crea un Fuente Negrita con tamaño 10			
						Font fuenteNegrita10= libro.createFont();
						fuenteNegrita10.setFontHeightInPoints((short)10);
						fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
						fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);
						
						Font fuenteNegrita10Izq= libro.createFont();
						fuenteNegrita10Izq.setFontHeightInPoints((short)10);
						fuenteNegrita10Izq.setFontName(HSSFFont.FONT_ARIAL);
						fuenteNegrita10Izq.setBoldweight(Font.BOLDWEIGHT_BOLD);
											
						//Crea un Fuente con tamaño 10
						Font fuente10Der= libro.createFont();
						fuente10Der.setFontHeightInPoints((short)10);
						fuente10Der.setFontName(HSSFFont.FONT_ARIAL);
						
						Font fuente10Izq= libro.createFont();
						fuente10Izq.setFontHeightInPoints((short)10);
						fuente10Izq.setFontName(HSSFFont.FONT_ARIAL);
						
						Font fuente10Cen= libro.createFont();
						fuente10Cen.setFontHeightInPoints((short)10);
						fuente10Cen.setFontName(HSSFFont.FONT_ARIAL);
						
						//Estilo negrita tamaño 10 centrado 
						CellStyle estiloNeg10Cen = libro.createCellStyle();
						estiloNeg10Cen.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
						estiloNeg10Cen.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
						estiloNeg10Cen.setFont(fuenteNegrita10);
						
						
						//Estilo negrita tamaño 10 izquierda
						CellStyle estiloNeg10Izq = libro.createCellStyle();
						estiloNeg10Izq.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
						estiloNeg10Izq.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
						estiloNeg10Izq.setFont(fuenteNegrita10Izq);
						
						//Estilo 10 Izquiera
						CellStyle estiloFormatoIzquierda = libro.createCellStyle();
						estiloFormatoIzquierda.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
						estiloFormatoIzquierda.setFont(fuente10Izq);
						
						//Estilo 10 centrado
						CellStyle estiloFormatoICentrado = libro.createCellStyle();
						estiloFormatoICentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
						estiloFormatoICentrado.setFont(fuente10Cen);
						
						//Estilo 10 Derecha
						CellStyle estiloFormatoDerecha = libro.createCellStyle();
						estiloFormatoDerecha.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
						estiloFormatoDerecha.setFont(fuente10Der);
						
						
						CellStyle formatoDecimal = libro.createCellStyle();
						DataFormat format = libro.createDataFormat();
						formatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
						
						
						// Creacion de hoja
						SXSSFSheet hoja = null;
						hoja = (SXSSFSheet) libro.createSheet("Reporte Movimientos por Cuenta");
						
						Row fila = hoja.createRow(0);
						Cell celda=fila.createCell((short)1);
						/////////////////////////////////////////////////////////////////////////////////////
						///////////////////////// FIN ENCABEZADO EXCEL //////////////////////////////////////
						//AGREGAR GRUPOS DE COLUMNAS
						//////////////////////////////////////////////////////////////////////////////
						fila = hoja.createRow(0);
						celda=fila.createCell((short)1);
						celda.setCellValue(reporteMovimientosBean.getNombreInstitucion());
						celda.setCellStyle(estiloNeg10Cen);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            0, //primera fila	(0-based)
					            0, //ultima fila  	(0-based)
					            1, //primer celda 	(0-based)
					            9  //ultima celda   (0-based)
					    ));	
						
						celda=fila.createCell((short)10);
						celda.setCellValue("Usuario:");
						celda.setCellStyle(estiloNeg10Izq);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            0, //primera fila	(0-based)
					            0, //ultima fila  	(0-based)
					            10,//primer celda 	(0-based)
					            10 //ultima celda   (0-based)
					    ));
						
						celda=fila.createCell((short)11);
						celda.setCellValue(reporteMovimientosBean.getUsuario().toUpperCase());
						celda.setCellStyle(estiloFormatoIzquierda);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            0, //primera fila	(0-based)
					            0, //ultima fila 	(0-based)
					            11,//primer celda 	(0-based)
					            11 //ultima celda   (0-based)
					    ));														
						
						fila = hoja.createRow(1);
						
						String mes;
						mes = reporteMovimientosBean.getMes();
						if(mes.equals("01")){
							mes = "Enero";
						}
						if(mes.equals("02")){
							mes = "Febrero";
						}
						if(mes.equals("03")){
							mes = "Marzo";
						}
						if(mes.equals("04")){
							mes = "Abril";
						}
						if(mes.equals("05")){
							mes = "Mayo";
						}
						if(mes.equals("06")){
							mes = "Junio";
						}
						if(mes.equals("07")){
							mes = "Julio";
						}
						if(mes.equals("08")){
							mes = "Agosto";
						}
						if(mes.equals("09")){
							mes = "Septiembre";
						}
						if(mes.equals("10")){
							mes = "Octubre";
						}
						if(mes.equals("11")){
							mes = "Noviembre";
						}
						if(mes.equals("12")){
							mes = "Diciembre";
						}
											
						celda=fila.createCell((short)0);
						celda.setCellValue("REPORTE DE MOVIMIENTOS DE LA CUENTA DEL MES DE " + mes.toUpperCase() + " DEL AÑO " + reporteMovimientosBean.getAnio());
						celda.setCellStyle(estiloNeg10Cen);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            1, //primera fila	(0-based)
					            1, //ultima fila  	(0-based)
					            0, //primer celda 	(0-based)
					            9 //ultima celda   	(0-based)
					    ));
						
						celda=fila.createCell((short)10);
						celda.setCellValue("Fecha:");
						celda.setCellStyle(estiloNeg10Izq);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            1, //primera fila	(0-based)
					            1, //ultima fila  	(0-based)
					            10,//primer celda 	(0-based)
					            10 //ultima celda   (0-based)
					    ));
						
						celda=fila.createCell((short)11);
						celda.setCellValue(reporteMovimientosBean.getFechaSistema());
						celda.setCellStyle(estiloFormatoIzquierda);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            1, //primera fila	(0-based)
					            1,  //ultima fila 	(0-based)
					            11, //primer celda 	(0-based)
					            11  //ultima celda  (0-based)
					    ));						
						
						fila = hoja.createRow(2);
												
						celda=fila.createCell((short)10);
						celda.setCellValue("Hora:");
						celda.setCellStyle(estiloNeg10Izq);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            2, //primera fila	(0-based)
					            2, //ultima fila  	(0-based)
					            10,//primer celda 	(0-based)
					            10 //ultima celda   (0-based)
					    ));
						
						celda=fila.createCell((short)11);						
						String horaVar="";
						
						 
						int hora =calendario.get(Calendar.HOUR_OF_DAY);
						int minutos = calendario.get(Calendar.MINUTE);
						int segundos = calendario.get(Calendar.SECOND);
						
						String h = Integer.toString(hora);
						String m = "";
						String s = "";
						if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
						if(segundos<10)s="0"+Integer.toString(segundos); else s=Integer.toString(segundos);
						
							 
						horaVar= h+":"+m+":"+s;
						celda.setCellValue(horaVar);
						celda.setCellStyle(estiloFormatoIzquierda);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            2,  //primera fila	(0-based)
					            2,  //ultima fila 	(0-based)
					            11, //primer celda 	(0-based)
					            11  //ultima celda  (0-based)
					    ));						
						
						fila = hoja.createRow(3);								
						fila = hoja.createRow(4);
						
						celda=fila.createCell((short)0);
						celda.setCellValue("Cliente: ");
						celda.setCellStyle(estiloNeg10Izq);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            4, //primera fila	(0-based)
					            4, //ultima fila  	(0-based)
					            0, //primer celda 	(0-based)
					            1  //ultima celda   (0-based)
					    ));
						celda=fila.createCell((short)2);
						
						
						celda.setCellValue(listaEncabezado.get(0).getClienteID()+" - "+listaEncabezado.get(0).getNombreCompleto());
						celda.setCellStyle(estiloFormatoIzquierda);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            4, //primera fila	(0-based)
					            4, //ultima fila  	(0-based)
					            2, //primer celda 	(0-based)
					            8  //ultima celda   (0-based)
					    ));
						
						celda=fila.createCell((short)9);
						celda.setCellValue("Cuenta: ");
						celda.setCellStyle(estiloNeg10Izq);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            4, //primera fila	(0-based)
					            4, //ultima fila  	(0-based)
					            9, //primer celda 	(0-based)
					            9  //ultima celda   (0-based)
					    ));
						celda=fila.createCell((short)10);
						celda.setCellValue(listaEncabezado.get(0).getCuentaAhoID());
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            4, //primera fila	(0-based)
					            4, //ultima fila  	(0-based)
					            10,//primer celda 	(0-based)
					            11 //ultima celda   (0-based)
					    ));
						fila = hoja.createRow(5);
						
						celda=fila.createCell((short)0);
						celda.setCellValue("Tipo Cuenta: ");
						celda.setCellStyle(estiloNeg10Izq);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            5, //primera fila	(0-based)
					            5, //ultima fila  	(0-based)
					            0, //primer celda 	(0-based)
					            1  //ultima celda   (0-based)
					    ));
						celda=fila.createCell((short)2);
						celda.setCellStyle(estiloFormatoIzquierda);
						celda.setCellValue(listaEncabezado.get(0).getTipoCuentaID()+" - "+listaEncabezado.get(0).getDescripcionTC());
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            5, //primera fila	(0-based)
					            5, //ultima fila  	(0-based)
					            2, //primer celda 	(0-based)
					            3  //ultima celda   (0-based)
					    ));
						
						celda=fila.createCell((short)4);
						celda.setCellValue("Moneda: ");
						celda.setCellStyle(estiloNeg10Izq);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            5, //primera fila	(0-based)
					            5, //ultima fila  	(0-based)
					            4, //primer celda 	(0-based)
					            5  //ultima celda   (0-based)
					    ));
						celda=fila.createCell((short)6);
						celda.setCellStyle(estiloFormatoIzquierda);
						celda.setCellValue(listaEncabezado.get(0).getMonedaID());
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            5, //primera fila	(0-based)
					            5, //ultima fila  	(0-based)
					            6, //primer celda 	(0-based)
					            6  //ultima celda   (0-based)
					    ));
						celda=fila.createCell((short)7);
						celda.setCellStyle(estiloFormatoIzquierda);
						celda.setCellValue(listaEncabezado.get(0).getDescripcionMo());
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            5, //primera fila	(0-based)
					            5, //ultima fila  	(0-based)
					            7, //primer celda 	(0-based)
					            7  //ultima celda   (0-based)
					    ));
								
						celda=fila.createCell((short)9);
						celda.setCellValue("Saldo:");
						celda.setCellStyle(estiloNeg10Izq);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            5, //primera fila	(0-based)
					            5, //ultima fila  	(0-based)
					            9, //primer celda 	(0-based)
					            9  //ultima celda   (0-based)
					    ));
						celda=fila.createCell((short)11);
						celda.setCellValue(listaEncabezado.get(0).getSaldo() == null ? "$0.00 " : "$"+listaEncabezado.get(0).getSaldo());
						celda.setCellStyle(estiloFormatoDerecha);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            5, //primera fila	(0-based)
					            5, //ultima fila  	(0-based)
					            11,//primer celda 	(0-based)
					            11 //ultima celda   (0-based)
					    ));
						
						
						fila = hoja.createRow(6);
						
						celda=fila.createCell((short)0);
						celda.setCellValue("Saldo Inicial Mes: ");
						celda.setCellStyle(estiloNeg10Izq);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            6, //primera fila	(0-based)
					            6, //ultima fila  	(0-based)
					            0, //primer celda 	(0-based)
					            1  //ultima celda   (0-based)
					    ));
						celda=fila.createCell((short)2);
						celda.setCellValue(listaEncabezado.get(0).getSaldoIniMes() == null ? "$0.00 " : "$"+listaEncabezado.get(0).getSaldoIniMes());
						celda.setCellStyle(estiloFormatoDerecha);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            6, //primera fila	(0-based)
					            6, //ultima fila  	(0-based)
					            2, //primer celda 	(0-based)
					            2  //ultima celda   (0-based)
					    ));
						
						celda=fila.createCell((short)4);
						celda.setCellValue("Abonos del Mes: ");
						celda.setCellStyle(estiloNeg10Izq);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            6, //primera fila	(0-based)
					            6, //ultima fila  	(0-based)
					            4, //primer celda 	(0-based)
					            5  //ultima celda   (0-based)
					    ));
						celda=fila.createCell((short)7);
						celda.setCellValue(listaEncabezado.get(0).getAbonosMes() == null ? "$0.00 " : "$"+listaEncabezado.get(0).getAbonosMes());
						celda.setCellStyle(estiloFormatoDerecha);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            6, //primera fila	(0-based)
					            6, //ultima fila  	(0-based)
					            7, //primer celda 	(0-based)
					            7  //ultima celda   (0-based)
					    ));
						
						celda=fila.createCell((short)9);
						celda.setCellValue("Cargos del Mes: ");
						celda.setCellStyle(estiloNeg10Izq);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            6, //primera fila	(0-based)
					            6, //ultima fila  	(0-based)
					            9, //primer celda 	(0-based)
					            10 //ultima celda   (0-based)
					    ));
						celda=fila.createCell((short)11);
						celda.setCellValue(listaEncabezado.get(0).getCargosMes() == null ? "$0.00 " : "$"+listaEncabezado.get(0).getCargosMes());
						celda.setCellStyle(estiloFormatoDerecha);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            6, //primera fila	(0-based)
					            6, //ultima fila  	(0-based)
					            11, //primer celda 	(0-based)
					            11 //ultima celda   (0-based)
					    ));
						
						fila = hoja.createRow(7);
						
						celda=fila.createCell((short)0);
						celda.setCellValue("Saldo Bloqueado: ");
						celda.setCellStyle(estiloNeg10Izq);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            7, //primera fila	(0-based)
					            7, //ultima fila  	(0-based)
					            0, //primer celda 	(0-based)
					            1 //ultima celda   	(0-based)
					    ));
						celda=fila.createCell((short)2);
						celda.setCellValue(listaEncabezado.get(0).getSaldoBloq() == null ? "$0.00 " : "$"+listaEncabezado.get(0).getSaldoBloq());
						celda.setCellStyle(estiloFormatoDerecha);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            7, //primera fila	(0-based)
					            7, //ultima fila  	(0-based)
					            2, //primer celda 	(0-based)
					            2  //ultima celda   (0-based)
					    ));
						
						celda=fila.createCell((short)4);
						celda.setCellValue("Saldo Disponible: ");
						celda.setCellStyle(estiloNeg10Izq);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            7, //primera fila	(0-based)
					            7, //ultima fila  	(0-based)
					            4, //primer celda 	(0-based)
					            5  //ultima celda   (0-based)
					    ));
						celda=fila.createCell((short)7);
						celda.setCellValue(listaEncabezado.get(0).getSaldoDispon() == null ? "$0.00 " : "$"+listaEncabezado.get(0).getSaldoDispon());
						celda.setCellStyle(estiloFormatoDerecha);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            7, //primera fila	(0-based)
					            7, //ultima fila  	(0-based)
					            7, //primer celda 	(0-based)
					            7  //ultima celda   (0-based)
					    ));
						
						celda=fila.createCell((short)9);
						celda.setCellValue("Saldo Buen Cobro: ");
						celda.setCellStyle(estiloNeg10Izq);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            7, //primera fila	(0-based)
					            7, //ultima fila  	(0-based)
					            9, //primer celda 	(0-based)
					            10 //ultima celda   (0-based)
					    ));
						celda=fila.createCell((short)11);
						celda.setCellValue(listaEncabezado.get(0).getSaldoSBC() == null ? "$0.00 " : "$"+listaEncabezado.get(0).getSaldoSBC());
						celda.setCellStyle(estiloFormatoDerecha);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            7,  //primera fila	 (0-based)
					            7,  //ultima fila  	 (0-based)
					            11, //primer celda 	 (0-based)
					            11  //ultima celda   (0-based)
					    ));
						
						
						fila = hoja.createRow(8);
						
						celda=fila.createCell((short)0);
						celda.setCellValue("Saldo Promedio: ");
						celda.setCellStyle(estiloNeg10Izq);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            8, //primera fila	(0-based)
					            8, //ultima fila  	(0-based)
					            0, //primer celda 	(0-based)
					            1 //ultima celda   	(0-based)
					    ));
						celda=fila.createCell((short)2);
						celda.setCellValue(listaEncabezado.get(0).getSaldoProm() == null ? "$0.00 " : "$"+listaEncabezado.get(0).getSaldoProm());
						celda.setCellStyle(estiloFormatoDerecha);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            8, //primera fila	(0-based)
					            8, //ultima fila  	(0-based)
					            2, //primer celda 	(0-based)
					            2 //ultima celda   	(0-based)
					    ));
						
						celda=fila.createCell((short)4);
						celda.setCellValue("Cargo Pendiente: ");
						celda.setCellStyle(estiloNeg10Izq);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            8, //primera fila	(0-based)
					            8, //ultima fila  	(0-based)
					            4, //primer celda 	(0-based)
					            5 //ultima celda   	(0-based)
					    ));
						celda=fila.createCell((short)7);
						celda.setCellValue(listaEncabezado.get(0).getSaldoCargosPend() == null ? "$0.00 " : "$"+listaEncabezado.get(0).getSaldoCargosPend());
						celda.setCellStyle(estiloFormatoDerecha);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            8, //primera fila	(0-based)
					            8, //ultima fila  	(0-based)
					            7,  //primer celda 	(0-based)
					            7   //ultima celda  (0-based)
					    ));
						
						celda=fila.createCell((short)9);
						celda.setCellValue("GAT Nominal: ");
						celda.setCellStyle(estiloNeg10Izq);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            8, //primera fila	(0-based)
					            8, //ultima fila  	(0-based)
					            9,  //primer celda 	(0-based)
					            10  //ultima celda  (0-based)
					    ));
						celda=fila.createCell((short)11);
						celda.setCellValue(listaEncabezado.get(0).getGat() == null ? "0.00 %" : listaEncabezado.get(0).getGat()+" %");
						celda.setCellStyle(estiloFormatoDerecha);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            8, //primera fila	(0-based)
					            8, //ultima fila  	(0-based)
					            11, //primer celda 	(0-based)
					            11  //ultima celda  (0-based)
					    ));
						fila = hoja.createRow(9);
						
						celda=fila.createCell((short)9);
						celda.setCellValue("GAT Real: ");
						celda.setCellStyle(estiloNeg10Izq);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            9, //primera fila	(0-based)
					            9, //ultima fila  	(0-based)
					            9,  //primer celda 	(0-based)
					            10  //ultima celda   (0-based)
					    ));
						celda=fila.createCell((short)11);
						celda.setCellValue(listaEncabezado.get(0).getGatReal() == null ? "0.00 %" : listaEncabezado.get(0).getGatReal()+" %");
						celda.setCellStyle(estiloFormatoDerecha);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            9, //primera fila	(0-based)
					            9, //ultima fila  	(0-based)
					            11, //primer celda 	(0-based)
					            11  //ultima celda  (0-based)
					    ));
						
						fila = hoja.createRow(10);
						fila = hoja.createRow(11);
						fila = hoja.createRow(12);
						////////////////////////////////////////////////////////////////////////////////
						//Titulos del Reporte
						
						celda=fila.createCell((short)0);
						celda.setCellValue("Fecha"); // Encabezado Fecha
						celda.setCellStyle(estiloNeg10Cen);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						12, //primera fila	(0-based)
						12, //ultima fila  	(0-based)
						0, //primer celda 	(0-based)
						0 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)1);
						celda.setCellValue("Descripción"); // Encabezado Descripción
						celda.setCellStyle(estiloNeg10Cen);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						12, //primera fila	(0-based)
						12, //ultima fila  	(0-based)
						1, //primer celda 	(0-based)
						4 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)5);
						celda.setCellValue("Referencia"); // Encabezado Referencia
						celda.setCellStyle(estiloNeg10Cen);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						12, //primera fila	(0-based)
						12, //ultima fila  	(0-based)
						5, //primer celda 	(0-based)
						7 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)8);
						celda.setCellValue("Cargos"); // Encabezado Referencia
						celda.setCellStyle(estiloNeg10Cen);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						12, //primera fila	(0-based)
						12, //ultima fila  	(0-based)
						8, //primer celda 	(0-based)
						9 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)10);
						celda.setCellValue("Abonos"); // Encabezado Referencia
						celda.setCellStyle(estiloNeg10Cen);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						12, //primera fila	(0-based)
						12, //ultima fila  	(0-based)
						10, //primer celda 	(0-based)
						11  //ultima celda  (0-based)
						));						
												
						celda=fila.createCell((short)12);
						celda.setCellValue("Saldo");// Encabezado Saldo
						celda.setCellStyle(estiloNeg10Cen);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						12, //primera fila	(0-based)
						12, //ultima fila  	(0-based)
						12, //primer celda 	(0-based)
						13  //ultima celda  (0-based)
						));
						
						fila = hoja.createRow(13);						
						
						celda=fila.createCell((short)0);
						celda.setCellStyle(estiloFormatoICentrado);
						celda.setCellValue(reporteMovimientosBean.getAnio()+"-"+reporteMovimientosBean.getMes()+"-"+"01");
						hoja.addMergedRegion(new CellRangeAddress(
					            13, //primera fila	(0-based)
					            13, //ultima fila  	(0-based)
					            0, //primer celda 	(0-based)
					            0 //ultima celda   	(0-based)
					    ));
						
						celda=fila.createCell((short)1);
						celda.setCellValue("SALDO INICIAL DEL MES");
						hoja.addMergedRegion(new CellRangeAddress(
					            13, //primera fila	(0-based)
					            13, //ultima fila  	(0-based)
					            1, //primer celda 	(0-based)
					            4 //ultima celda   	(0-based)
					    ));
						
						celda=fila.createCell((short)10);
						celda.setCellValue("$"+listaEncabezado.get(0).getSaldoIniMes());
						celda.setCellStyle(estiloFormatoDerecha);
						hoja.addMergedRegion(new CellRangeAddress(
					            13, //primera fila	(0-based)
					            13, //ultima fila  	(0-based)
					            10, //primer celda 	(0-based)
					            11 //ultima celda   (0-based)
					    ));
						
						celda=fila.createCell((short)12);
						celda.setCellValue("$"+listaEncabezado.get(0).getSaldoIniMes());
						celda.setCellStyle(estiloFormatoDerecha);
						hoja.addMergedRegion(new CellRangeAddress(
					            13, //primera fila	(0-based)
					            13, //ultima fila  	(0-based)
					            12, //primer celda 	(0-based)
					            13 //ultima celda   (0-based)
					    ));
												
						for(int celd=0; celd<=11; celd++){
							if(celd == 2 || celd == 3 || celd == 7 || celd == 11){
								hoja.setColumnWidth(celd, 3500);
							}
							else{
								hoja.autoSizeColumn((short)celd);
							}
						}	
						
						fila = hoja.createRow(14);							
						
						int rowExcel=14;
						contador=14;
						int tamanioLista = listaSolicitudes.size();
						
						if(tamanioLista >0){
							for(int x = 0; x< listaSolicitudes.size() ; x++ ){

								fila=hoja.createRow(rowExcel);
										
								//FECHA
								celda=fila.createCell((short)0);
								celda.setCellStyle(estiloFormatoICentrado);
								celda.setCellValue(listaSolicitudes.get(x).getFecha());
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            0, 		  //primer celda 	(0-based)
							            0 		  //ultima celda   	(0-based)
							    ));
									
								//DESCRIPCIÓN
								celda=fila.createCell((short)1);
								celda.setCellStyle(estiloFormatoIzquierda);
								celda.setCellValue(listaSolicitudes.get(x).getDescripcionMov());
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            1, 		  //primer celda 	(0-based)
							            4 		  //ultima celda   	(0-based)
							    ));
								
								//REFERENCIA
								celda=fila.createCell((short)5);
								celda.setCellStyle(estiloFormatoIzquierda);
								celda.setCellValue(listaSolicitudes.get(x).getReferenciaMov());
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            5, 		  //primer celda 	(0-based)
							            7 		  //ultima celda   	(0-based)
							    ));
								
								//CARGOS
								celda=fila.createCell((short)8);
								String NatMovimiento;
								NatMovimiento = listaSolicitudes.get(x).getNatMovimiento();
								if(NatMovimiento.equals("C")){
									celda.setCellValue("$"+listaSolicitudes.get(x).getCantidadMov());
								}else{
									celda.setCellValue("");
								}
								celda.setCellStyle(estiloFormatoDerecha);
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            8, 		  //primer celda 	(0-based)
							            9 		  //ultima celda   	(0-based)
							    ));	
																
								//ABONOS
								celda=fila.createCell((short)10);
								if(NatMovimiento.equals("A")){
									celda.setCellValue("$"+listaSolicitudes.get(x).getCantidadMov());
								}else{
									celda.setCellValue("");
								}
								celda.setCellStyle(estiloFormatoDerecha);
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            10, 	  //primer celda 	(0-based)
							            11 		  //ultima celda   	(0-based)
							    ));	
								
								//SALDO
								celda=fila.createCell((short)12);
								celda.setCellValue("$"+listaSolicitudes.get(x).getSaldo());
								celda.setCellStyle(estiloFormatoDerecha);
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            12, 	  //primer celda 	(0-based)
							            13 		  //ultima celda   	(0-based)
							    ));						
															
								rowExcel++;
								contador++;
							} 
							contador = contador+2;
							fila=hoja.createRow(contador);
							celda = fila.createCell((short)0);
							celda.setCellStyle(estiloNeg10Izq);							
							celda.setCellValue("Registros Exportados");
							
							contador = contador+1;
							fila=hoja.createRow(contador);
							celda=fila.createCell((short)0);
							celda.setCellValue(tamanioLista);
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
						
			return  listaSolicitudes;
			
			}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public void setReporteMovimientosServicio(
			ReporteMovimientosServicio reporteMovimientosServicio) {
		this.reporteMovimientosServicio = reporteMovimientosServicio;
	}	
}
