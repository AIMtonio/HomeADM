package tesoreria.reporte;

import herramientas.Utileria;

import java.util.Calendar;
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
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.RepBitacoraSolBean;
import cuentas.bean.ReporteMovimientosBean;
import tesoreria.bean.RepDIOTBean;
import tesoreria.servicio.RepDIOTServicio;
import tesoreria.servicio.RepDIOTServicio.Enum_Lis_ReportesDIOT;;

public class ReporteDIOTControlador extends AbstractCommandController{
	RepDIOTServicio repDIOTServicio = null;
	String successView = null;

	
	public ReporteDIOTControlador () {
		setCommandClass(RepDIOTBean.class);
		setCommandName("DIOTBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		RepDIOTBean reporteBean = (RepDIOTBean) command;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")):0;
				
		switch(tipoReporte)	{
			case Enum_Lis_ReportesDIOT.excel:		
				reporteDIOT(tipoReporte,reporteBean,response);
				break;
			case Enum_Lis_ReportesDIOT.csv:
				repDIOTServicio.listaReporteDIOT(tipoReporte, reporteBean, response); ;
		}
		return null;	
	}


	
	public List<RepDIOTBean> reporteDIOT(int tipoLista,RepDIOTBean DIOTBean, 
									HttpServletResponse response){
		String mesEnLetras	 = "";
		String anio			 = "";
		String nombreArchivo = "";	
	

		List<RepDIOTBean> listaDIOT=null;
	
		listaDIOT = repDIOTServicio.listaReporteDIOT(tipoLista, DIOTBean, response);
			
	     
		int regExport = 0;
		Calendar calendario = Calendar.getInstance();
		
		nombreArchivo 	= "ReporteDIOT"; 
		
		int contador = 1;
		if(listaDIOT != null){
					try {

						//////////////////////////////////////////////////////////////////////////////////////
						////////////////////// ENCABEZADO y CONFIGURACION DEL  EXCEL /////////////////////////////////////////
			
						Workbook libro = new SXSSFWorkbook();
						
						//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.						
						Font fuenteNegrita8Enc= libro.createFont();
						fuenteNegrita8Enc.setFontHeightInPoints((short)10);
						fuenteNegrita8Enc.setFontName("Negrita");
						fuenteNegrita8Enc.setBoldweight(Font.BOLDWEIGHT_BOLD);
						
						//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.						
						Font fuenteNegrita10= libro.createFont();
						fuenteNegrita10.setFontHeightInPoints((short)10);
						fuenteNegrita10.setFontName("Negrita");
						fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);
					
						//Crea un Fuente con tamaño 10 para informacion del reporte.
						Font fuente10= libro.createFont();
						fuente10.setFontHeightInPoints((short)10);
						
						//Estilo de 8  para Contenido
						CellStyle estilo10 = libro.createCellStyle();
						estilo10.setFont(fuente10);						
						
						
						//Estilo negrita tamaño 8 centrado (Titulo)
						CellStyle estiloTitulo = libro.createCellStyle();
						estiloTitulo.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
						estiloTitulo.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
						estiloTitulo.setFont(fuenteNegrita8Enc);
						
						//Estilo negrita tamaño 8 izquierda
						CellStyle estiloEncabezado = libro.createCellStyle();
						estiloEncabezado.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
						estiloEncabezado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
						estiloEncabezado.setFont(fuenteNegrita10);
						estiloEncabezado.setWrapText(true);
						
						
						//Estilo Formato Derecha
						CellStyle estiloFormatoDerecha= libro.createCellStyle();
						estiloFormatoDerecha.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);					
						
						DataFormat format = libro.createDataFormat();
						estiloFormatoDerecha.setDataFormat(format.getFormat("$#,##0.00"));
						
																
						
						// Creacion de hoja
						SXSSFSheet hoja = null;
						hoja = (SXSSFSheet) libro.createSheet("Reporte Movimientos por Cuenta");
						
						Row fila = hoja.createRow(0);
						Cell celda=fila.createCell((short)1);
						/////////////////////////////////////////////////////////////////////////////////////
						///////////////////////// FIN ENCABEZADO EXCEL //////////////////////////////////////
						
						fila = hoja.createRow(0);
						celda=fila.createCell((short)1);
						celda.setCellValue(DIOTBean.getNombreInstitucion());
						celda.setCellStyle(estiloTitulo);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            0, //primera fila	(0-based)
					            0, //ultima fila  	(0-based)
					            1, //primer celda 	(0-based)
					            9  //ultima celda   (0-based)
					    ));	
						
						celda=fila.createCell((short)10);
						celda.setCellValue("Usuario:");
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            0, //primera fila	(0-based)
					            0, //ultima fila  	(0-based)
					            10, //primer celda 	(0-based)
					            10 //ultima celda   	(0-based)
					    ));
						
						celda=fila.createCell((short)11);
						celda.setCellValue(DIOTBean.getUsuario());
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            0, //primera fila	(0-based)
					            0, //ultima fila 	(0-based)
					            11, //primer celda 	(0-based)
					            11  //ultima celda  (0-based)
					    ));														
						
						fila = hoja.createRow(1);
					
						celda=fila.createCell((short)10);
						celda.setCellValue("Fecha:");
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            1, //primera fila	(0-based)
					            1, //ultima fila  	(0-based)
					            10, //primer celda 	(0-based)
					            10 //ultima celda   	(0-based)
					    ));
						
						celda=fila.createCell((short)11);
						celda.setCellValue(DIOTBean.getFechaSistema());
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            1, //primera fila	(0-based)
					            1, //ultima fila 	(0-based)
					            11, //primer celda 	(0-based)
					            11  //ultima celda  (0-based)
					    ));						
						
						fila = hoja.createRow(2);
						celda=fila.createCell((short)0);
						celda.setCellValue("Declaración informativa de Operaciones con Terceros");
						celda.setCellStyle(estiloTitulo);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            2, //primera fila	(0-based)
					            2, //ultima fila  	(0-based)
					            0, //primer celda 	(0-based)
					            9 //ultima celda   	(0-based)
					    ));
						
						celda=fila.createCell((short)10);
						celda.setCellValue("Hora:");
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            2, //primera fila	(0-based)
					            2, //ultima fila  	(0-based)
					            10, //primer celda 	(0-based)
					            10 //ultima celda   	(0-based)
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
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            2, //primera fila	(0-based)
					            2, //ultima fila 	(0-based)
					            11, //primer celda 	(0-based)
					            11  //ultima celda  (0-based)
					    ));						
						
						fila = hoja.createRow(3);								
						fila = hoja.createRow(4);
										
						
						////////////////////////////////////////////////////////////////////////////////
						//Titulos del Reporte
						
						celda=fila.createCell((short)0);
						celda.setCellValue("Tipo de Tercero"); // Encabezado Fecha
						celda.setCellStyle(estiloEncabezado);						
						fila.setHeight((short) 2000);	
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						0, //primer celda 	(0-based)
						0 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)1);
						celda.setCellValue("Tipo de Operación"); // Encabezado Descripción
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						1, //primer celda 	(0-based)
						1 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)2);
						celda.setCellValue("RFC");// Encabezado Tipo
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						2, //primer celda 	(0-based)
						2 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)3);
						celda.setCellValue("Número de ID Fiscal"); // Encabezado Referencia
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						3, //primer celda 	(0-based)
						3 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)4);
						celda.setCellValue("Nombre del Extranjero");// Encabezado Monto
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						4, //primer celda 	(0-based)
						4 //ultima celda   	(0-based)
						));
						
						
						celda=fila.createCell((short)5);
						celda.setCellValue("País de Residencia");// Encabezado Saldo
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						5, //primer celda 	(0-based)
						5 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)6);
						celda.setCellValue("Nacionalidad");// Encabezado Saldo
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						6, //primer celda 	(0-based)
						6 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)7);
						celda.setCellValue("Actos Pagados Tasa 15% ó 16%");
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						7, //primer celda 	(0-based)
						7 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)8);
						celda.setCellValue("Actos Pagados Tasa 15%");
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						8, //primer celda 	(0-based)
						8 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)9);
						celda.setCellValue("IVA No Acreditable pagado al 15% ó 16%");
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						9, //primer celda 	(0-based)
						9 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)10);
						celda.setCellValue("Actos Pagados Tasa 10% u 11%");
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						10, //primer celda 	(0-based)
						10 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)11);
						celda.setCellValue("Actos Pagados Tasa 10%");
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						11, //primer celda 	(0-based)
						11 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)12);
						celda.setCellValue("IVA No Acreditable pagado al 10% u 11%");
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						12, //primer celda 	(0-based)
						12 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)13);
						celda.setCellValue("Actos Importación al 15% ó 16%");
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						13, //primer celda 	(0-based)
						13 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)14);
						celda.setCellValue("IVA No Acreditable pagado Importación 15% ó 16%");
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						14, //primer celda 	(0-based)
						14 //ultima celda   	(0-based)
						));
						
						
						celda=fila.createCell((short)15);
						celda.setCellValue("Actos Importación al 10% u 11%");
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						15, //primer celda 	(0-based)
						15 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)16);
						celda.setCellValue("IVA No Acreditable pagado Importación 10% u 11%");
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						16, //primer celda 	(0-based)
						16 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)17);
						celda.setCellValue("Actos Importación Exento");
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						17, //primer celda 	(0-based)
						17 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)18);
						celda.setCellValue("Actos Pagados Nacional 0%");
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						18, //primer celda 	(0-based)
						18 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)19);
						celda.setCellValue("Actos Pagados Nacional Exento");
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						19, //primer celda 	(0-based)
						19 //ultima celda   	(0-based)
						));
						
						
						celda=fila.createCell((short)20);
						celda.setCellValue("IVA Retenido");
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						20, //primer celda 	(0-based)
						20 //ultima celda   	(0-based)
						));
						
						celda=fila.createCell((short)21);
						celda.setCellValue("IVA de Devoluciones, Descuentos y Bonificaciones");
						celda.setCellStyle(estiloEncabezado);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
						4, //primera fila	(0-based)
						4, //ultima fila  	(0-based)
						21, //primer celda 	(0-based)
						21 //ultima celda   	(0-based)
						));
						
						fila = hoja.createRow(5);							
						
						int rowExcel=5;
						contador=5;
						int tamanioLista = listaDIOT.size();
						
						if(tamanioLista >0){
							for(RepDIOTBean repDIOT : listaDIOT){
						

								fila=hoja.createRow(rowExcel);
										
								celda=fila.createCell((short)0);
								celda.setCellValue(repDIOT.getTipoTercero());
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            0, //primer celda 	(0-based)
							            0 //ultima celda   	(0-based)
							    ));
								
								celda=fila.createCell((short)1);
								celda.setCellValue(repDIOT.getTipoOperacion());
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            1, //primer celda 	(0-based)
							            1 //ultima celda   	(0-based)
							    ));
								
								
								celda=fila.createCell((short)2);
								celda.setCellValue(repDIOT.getRfc());
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            2, //primer celda 	(0-based)
							            2 //ultima celda   	(0-based)
							    ));
								
								
								celda=fila.createCell((short)3);
								celda.setCellValue(repDIOT.getNumeroIDFiscal());
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            3, //primer celda 	(0-based)
							            3 //ultima celda   	(0-based)
							    ));
								
								celda=fila.createCell((short)4);
								celda.setCellValue(repDIOT.getNombreExtranjero());
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            4, //primer celda 	(0-based)
							            4 //ultima celda   	(0-based)
							    ));
										
								celda=fila.createCell((short)5);
								celda.setCellValue(repDIOT.getPaisResidencia());
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            5, //primer celda 	(0-based)
							            5 //ultima celda   	(0-based)
							    ));
								
								celda=fila.createCell((short)6);
								celda.setCellValue(repDIOT.getNacionalidad());
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            6, //primer celda 	(0-based)
							            6 //ultima celda   	(0-based)
							    ));
								
								celda=fila.createCell((short)7);
								celda.setCellValue(Double.parseDouble(repDIOT.getValAcPagQuincePorc()) );
								celda.setCellStyle(estiloFormatoDerecha);								
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            7, //primer celda 	(0-based)
							            7 //ultima celda   	(0-based)
							    ));								
								celda=fila.createCell((short)8);
								celda.setCellValue(Double.parseDouble(repDIOT.getActosPagQuince()));
								celda.setCellStyle(estiloFormatoDerecha);	
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            8, //primer celda 	(0-based)
							            8 //ultima celda   	(0-based)
							    ));																
								celda=fila.createCell((short)9);
								celda.setCellValue(Double.parseDouble(repDIOT.getMontIvaPagNAQuincePorc()));
								celda.setCellStyle(estiloFormatoDerecha);	
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            9, //primer celda 	(0-based)
							            9 //ultima celda   	(0-based)
							    ));
								
								
								celda=fila.createCell((short)10);
								celda.setCellValue(Double.parseDouble(repDIOT.getValAcPagDiezPorc()));
								celda.setCellStyle(estiloFormatoDerecha);	
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            10, //primer celda 	(0-based)
							            10 //ultima celda   	(0-based)
							    ));								
								celda=fila.createCell((short)11);
								celda.setCellValue(Double.parseDouble(repDIOT.getActosPagDiez()));
								celda.setCellStyle(estiloFormatoDerecha);	
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            11, //primer celda 	(0-based)
							            11 //ultima celda   	(0-based)
							    ));								
								celda=fila.createCell((short)12);
								celda.setCellValue(Double.parseDouble(repDIOT.getMontIvaPagNADiezPorc()));
								celda.setCellStyle(estiloFormatoDerecha);	
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            12, //primer celda 	(0-based)
							            12 //ultima celda   	(0-based)
							    ));
								celda=fila.createCell((short)13);
								celda.setCellValue(Double.parseDouble(repDIOT.getValAcPagImBienQuincePorc()) );
								celda.setCellStyle(estiloFormatoDerecha);	
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            13, //primer celda 	(0-based)
							            13 //ultima celda   	(0-based)
							    ));
								celda=fila.createCell((short)14);
								celda.setCellValue(Double.parseDouble(repDIOT.getMontIvaPagImpNAQuincePorc()));
								celda.setCellStyle(estiloFormatoDerecha);	
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            14, //primer celda 	(0-based)
							            14 //ultima celda   	(0-based)
							    ));
								celda=fila.createCell((short)15);
								celda.setCellValue(Double.parseDouble(repDIOT.getValAcPagImBienDiezPorc()));
								celda.setCellStyle(estiloFormatoDerecha);	
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            15, //primer celda 	(0-based)
							            15 //ultima celda   	(0-based)
							    ));								
								celda=fila.createCell((short)16);
								celda.setCellValue(Double.parseDouble(repDIOT.getMontIvaPagImpNADiezPorc()));
								celda.setCellStyle(estiloFormatoDerecha);	
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            16, //primer celda 	(0-based)
							            16 //ultima celda   	(0-based)
							    ));
								celda=fila.createCell((short)17);
								celda.setCellValue(Double.parseDouble(repDIOT.getValAcPagImpBienExento()));
								celda.setCellStyle(estiloFormatoDerecha);	
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            17, //primer celda 	(0-based)
							            17 //ultima celda   	(0-based)
							    ));
								celda=fila.createCell((short)18);
								celda.setCellValue(Double.parseDouble(repDIOT.getValActPagIVACeroPorc()));
								celda.setCellStyle(estiloFormatoDerecha);	
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            18, //primer celda 	(0-based)
							            18 //ultima celda   	(0-based)
							    ));
								celda=fila.createCell((short)19);
								celda.setCellValue(Double.parseDouble(repDIOT.getValActPagExentos()));
								celda.setCellStyle(estiloFormatoDerecha);	
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            19, //primer celda 	(0-based)
							            19 //ultima celda   	(0-based)
							    ));
								celda=fila.createCell((short)20);
								celda.setCellValue(Double.parseDouble(repDIOT.getIVARetenido()));
								celda.setCellStyle(estiloFormatoDerecha);	
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            20, //primer celda 	(0-based)
							            20 //ultima celda   	(0-based)
							    ));
								celda=fila.createCell((short)21);
								celda.setCellValue(Double.parseDouble(repDIOT.getIVADevDescBonif()));
								celda.setCellStyle(estiloFormatoDerecha);	
								hoja.addMergedRegion(new CellRangeAddress(
							            rowExcel, //primera fila	(0-based)
							            rowExcel, //ultima fila  	(0-based)
							            21, //primer celda 	(0-based)
							            21 //ultima celda   	(0-based)
							    ));
								
								
								
								rowExcel++;
								contador++;
							}
							contador = contador+2;
							fila=hoja.createRow(contador);
							celda = fila.createCell((short)0);
							celda.setCellStyle(estiloEncabezado);							
							celda.setCellValue("Registros Exportados");
							
							contador = contador+1;
							fila=hoja.createRow(contador);
							celda=fila.createCell((short)0);
							celda.setCellValue(tamanioLista);
						}
							
														
								hoja.setColumnWidth(0, 6000);
								hoja.setColumnWidth(1, 3000);
								hoja.setColumnWidth(2, 5000);
								hoja.setColumnWidth(3, 10000);
								hoja.setColumnWidth(4, 10000);
								hoja.setColumnWidth(5, 4000);
								hoja.setColumnWidth(6, 4000);
								
								for(int i=7; i<=21; i++){
								 hoja.setColumnWidth(i, 5500);
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
						
			return  listaDIOT;
			
			
		
	}


	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public RepDIOTServicio getRepDIOTServicio() {
		return repDIOTServicio;
	}

	public void setRepDIOTServicio(RepDIOTServicio repDIOTServicio) {
		this.repDIOTServicio = repDIOTServicio;
	}

	
	
}