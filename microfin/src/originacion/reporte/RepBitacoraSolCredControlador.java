
package originacion.reporte;

import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
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






import originacion.bean.RepBitacoraSolBean;
import originacion.servicio.RepBitacoraSolServicio;


public class RepBitacoraSolCredControlador extends AbstractCommandController{

	public static interface Enum_Con_TipRepor {
		  int  excel= 1 ;
	}
	RepBitacoraSolServicio repBitacoraSolServicio = null;
	
	String nombreReporte = null;
	String successView = null;
	
	public RepBitacoraSolCredControlador(){
		setCommandClass(RepBitacoraSolBean.class);
		setCommandName("repBitacoraSolBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		RepBitacoraSolBean repBitacoraSolBean = (RepBitacoraSolBean) command;
		int tipoReporte =(request.getParameter("tipoRep")!=null)?
				Integer.parseInt(request.getParameter("tipoRep")):0;
	
			
		String htmlString= "";
		
		switch(tipoReporte){	
		case Enum_Con_TipRepor.excel:	
			 List<RepBitacoraSolBean>listaReportes = listaReporte(tipoReporte, repBitacoraSolBean ,response);
			 break;
			 
		}
		return null;	
	}
	
	public List<RepBitacoraSolBean> listaReporte(int tipoReporte,RepBitacoraSolBean repBitacoraSolBean,  HttpServletResponse response){
		List<RepBitacoraSolBean> listaSolicitudes=null;
		
		if(tipoReporte ==1){
			listaSolicitudes = repBitacoraSolServicio.listaReporte(1, repBitacoraSolBean, response);
		}	
		
	     
		int regExport = 0;
		Calendar calendario = Calendar.getInstance();
		
		if(listaSolicitudes != null){
					try {
						Workbook libro = new SXSSFWorkbook();
						//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
						Font fuenteNegrita10= libro.createFont();
						fuenteNegrita10.setFontHeightInPoints((short)10);
						fuenteNegrita10.setFontName("Negrita");
						fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);						
						
						//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
						Font fuenteNegrita8= libro.createFont();
						fuenteNegrita8.setFontHeightInPoints((short)10);
						fuenteNegrita8.setFontName("Negrita");
						fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
						
						//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
						Font fuenteNegritaGroup= libro.createFont();
						fuenteNegritaGroup.setFontHeightInPoints((short)10);
						fuenteNegritaGroup.setFontName("Negrita");
						fuenteNegritaGroup.setBoldweight(Font.BOLDWEIGHT_BOLD);
						
						Font fuenteNegrita= libro.createFont();
						fuenteNegrita.setFontHeightInPoints((short)10);
						fuenteNegrita.setFontName("Negrita");
						fuenteNegrita.setBoldweight(Font.BOLDWEIGHT_BOLD);

						
						
						// La fuente se mete en un estilo para poder ser usada.
						//Estilo negrita de 10 para el titulo del reporte
						CellStyle estiloNeg10 = libro.createCellStyle();
						estiloNeg10.setFont(fuenteNegrita10);
						estiloNeg10.setAlignment(CellStyle.ALIGN_CENTER);			

			
						
						//Estilo negrita de 8  para encabezados del reporte
						CellStyle estiloNeg8 = libro.createCellStyle();
						estiloNeg8.setFont(fuenteNegrita8);
												
					
						
						//Estilo negrita de 8  y color de fondo
						CellStyle estiloColor = libro.createCellStyle();
						estiloColor.setFont(fuenteNegrita8);
						estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
						estiloColor.setFillPattern(CellStyle.SOLID_FOREGROUND);
						
						CellStyle estiloDerecha = libro.createCellStyle();
						estiloDerecha.setFont(fuenteNegrita);
						estiloDerecha.setAlignment(CellStyle.ALIGN_LEFT);	
						
						
						//Encabezado agrupaciones
						CellStyle estiloAgrupacion = libro.createCellStyle();
						estiloAgrupacion.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
						estiloAgrupacion.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
						estiloAgrupacion.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
						estiloAgrupacion.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
						estiloAgrupacion.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
						estiloAgrupacion.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
						estiloAgrupacion.setFont(fuenteNegritaGroup);
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
						
						//Estilo negrita tamaño 8 centrado
						CellStyle estiloSaltoLinea = libro.createCellStyle();
						estiloSaltoLinea.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
						estiloSaltoLinea.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
						estiloSaltoLinea.setBorderTop((short)XSSFCellStyle.BORDER_MEDIUM);
						estiloSaltoLinea.setBorderBottom((short)XSSFCellStyle.BORDER_MEDIUM);
						estiloSaltoLinea.setBorderRight((short)XSSFCellStyle.BORDER_MEDIUM);
						estiloSaltoLinea.setBorderLeft((short)XSSFCellStyle.BORDER_MEDIUM);
						estiloSaltoLinea.setFont(fuenteNegrita8);
						estiloSaltoLinea.setWrapText(true);
						
						
						SXSSFSheet hoja = null;
						hoja = (SXSSFSheet) libro.createSheet("Bitácora de Solicitud de Crédito");
						Row fila = hoja.createRow(0);
						Cell celda=fila.createCell((short)1);		

						
						if(tipoReporte == 1) {	
								
							
						celda=fila.createCell((short)1);
						celda.setCellStyle(estiloNeg10);
						celda.setCellValue(repBitacoraSolBean.getNombreInstitucion());
						CellRangeAddress region = new CellRangeAddress(0,(short)0,1,(short)4);
						hoja.addMergedRegion(region);
						
					            
						celda = fila.createCell((short)5);
						celda.setCellStyle(estiloDerecha);
						celda.setCellValue("Usuario:");				// Usuario que genera el reporte		
						
						celda = fila.createCell((short)6);
						celda.setCellValue(repBitacoraSolBean.getNomUsuario());
						celda.setCellStyle(estiloDerecha);					
						
						fila = hoja.createRow(1);						

						celda=fila.createCell((short)5);
						celda.setCellStyle(estiloDerecha);
						celda.setCellValue("Fecha: ");
						
						celda=fila.createCell((short)6);
						celda.setCellStyle(estiloDerecha);
						celda.setCellValue(repBitacoraSolBean.getFechaSistema());	// Fecha de Emisión del Reporte
						
						fila = hoja.createRow(2);	
						
						celda = fila.createCell	((short)1);
						celda.setCellStyle(estiloNeg10);
						celda.setCellValue("BITÁCORA DE SOLICITUDES DE CRÉDITO "+repBitacoraSolBean.getFechaInicio()+" AL "+repBitacoraSolBean.getFechaFin());
						hoja.addMergedRegion(new CellRangeAddress(
					            2, //primera fila 
					            2, //ultima fila 
					            1, //primer celda
					            4 //ultima celda
					    ));										

						celda = fila.createCell((short)5);
						celda.setCellValue("Hora: ");
						celda.setCellStyle(estiloDerecha);
						celda = fila.createCell((short)6);
						
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
						celda.setCellStyle(estiloDerecha);				
									
					
						// Creacion de fila
						
						fila = hoja.createRow(3);					
						fila = hoja.createRow(4);
						
						celda=fila.createCell((short)0);
						celda.setCellStyle(estiloDerecha);
						celda.setCellValue("Sucursal: "); 
						
						celda=fila.createCell((short)1);
						celda.setCellStyle(estiloDerecha);
						celda.setCellValue(repBitacoraSolBean.getNombreSucursal()); 
						
						celda=fila.createCell((short)2);
						celda.setCellStyle(estiloDerecha);
						celda.setCellValue("Producto Crédito: ");
						
						celda=fila.createCell((short)3);
						celda.setCellStyle(estiloDerecha);
						celda.setCellValue(repBitacoraSolBean.getNombreProducto());
											

						celda=fila.createCell((short)4);
						celda.setCellStyle(estiloDerecha);
						celda.setCellValue("Promotor: ");	
						
						celda=fila.createCell((short)5);
						celda.setCellStyle(estiloDerecha);
						celda.setCellValue(repBitacoraSolBean.getNombrePromotor());
						
						fila = hoja.createRow(5);
						fila = hoja.createRow(6);						
						
						
						// GRUPOS DE COLUMNAS						
						celda=fila.createCell((short)0);
						celda.setCellValue("Datos Generales");
						celda.setCellStyle(estiloAgrupacion);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            6, //primera fila
					            6, //ultima fila  
					            0, //primer celda
					            5  //ultima celda 
					    ));
						
						celda=fila.createCell((short)6);
						celda.setCellValue("Solicitud-Inactiva");
						celda.setCellStyle(estiloAgrupacion);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            6, //primera fila 
					            6, //ultima fila 
					            6, //primer celda 
					            9 //ultima celda 
					    ));
						
						celda=fila.createCell((short)10);
						celda.setCellValue("Solicitud en Actualización");
						celda.setCellStyle(estiloAgrupacion);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            6, //primera fila 
					            6, //ultima fila 
					            10, //primer celda
					            13 //ultima celda
					    ));
						
						celda=fila.createCell((short)14);
						celda.setCellValue("Solicitud-Rechazada");
						celda.setCellStyle(estiloAgrupacion);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            6, //primera fila 
					            6, //ultima fila 
					            14, //primer celda
					            16 //ultima celda
					    ));
						
						celda=fila.createCell((short)17);
						celda.setCellValue("Solicitud-Liberada");
						celda.setCellStyle(estiloAgrupacion);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            6, //primera fila 
					            6, //ultima fila 
					            17, //primer celda
					            20 //ultima celda
					    ));
						
						celda=fila.createCell((short)21);
						celda.setCellValue("Solicitud-Autorizada");
						celda.setCellStyle(estiloAgrupacion);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            6, //primera fila 
					            6, //ultima fila 
					            21, //primer celda
					            24 //ultima celda
					    ));
						
						celda=fila.createCell((short)25);
						celda.setCellValue("Crédito-Inactivo");
						celda.setCellStyle(estiloAgrupacion);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            6, //primera fila 
					            6, //ultima fila 
					            25, //primer celda
					            28 //ultima celda
					    ));
						
						celda=fila.createCell((short)29);
						celda.setCellValue("Crédito-Condicionado");
						celda.setCellStyle(estiloAgrupacion);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            6, //primera fila 
					            6, //ultima fila 
					            29, //primer celda
					            32 //ultima celda
					    ));
						
						
						
						celda=fila.createCell((short)33);
						celda.setCellValue("Crédito-Autorizado");
						celda.setCellStyle(estiloAgrupacion);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            6, //primera fila 
					            6, //ultima fila 
					            33, //primer celda
					            36 //ultima celda
					    ));
						
						celda=fila.createCell((short)37);
						celda.setCellValue("Crédito-Cancelado");
						celda.setCellStyle(estiloAgrupacion);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            6, //primera fila 
					            6, //ultima fila 
					            37, //primer celda
					            39 //ultima celda
					    ));
						
						celda=fila.createCell((short)40);
						celda.setCellValue("Crédito-Desembolsado");
						celda.setCellStyle(estiloAgrupacion);
						//funcion para unir celdas
						hoja.addMergedRegion(new CellRangeAddress(
					            6, //primera fila 
					            6, //ultima fila 
					            40, //primer celda
					            42 //ultima celda
					    ));
						
						celda=fila.createCell((short)42);
						celda.setCellValue("Crédito-Desembolsado");
						celda.setCellStyle(estiloAgrupacion);
						
						
						fila = hoja.createRow(7);
						
						celda = fila.createCell((short)0);
						celda.setCellValue("Días");
						celda.setCellStyle(estiloSaltoLinea);
						fila.setHeight((short) 500);	
						
						celda = fila.createCell((short)1);
						celda.setCellValue("Núm. Solicitud");
						celda.setCellStyle(estiloSaltoLinea);
						fila.setHeight((short) 500);	
						
						
						celda = fila.createCell((short)2);
						celda.setCellValue("CreditoID");
						celda.setCellStyle(estiloSaltoLinea);
									

						celda = fila.createCell((short)3);
						celda.setCellValue("Nombre Cliente");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)4);
						celda.setCellValue("Nombre Promotor");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)5);
						celda.setCellValue("Estatus");
						celda.setCellStyle(estiloSaltoLinea);
						
						//Solicitud Registrada
						celda = fila.createCell((short)6);
						celda.setCellValue("Fecha");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)7);
						celda.setCellValue("Ejecutivo");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)8);
						celda.setCellValue("Último Comentario");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)9);
						celda.setCellValue("Tiempo en Estatus(Días)");
						celda.setCellStyle(estiloSaltoLinea);
						
						// Solicitud Actualizada
						celda = fila.createCell((short)10);
						celda.setCellValue("Fecha");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)11);
						celda.setCellValue("Ejecutivo");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)12);
						celda.setCellValue("Último Comentario");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)13);
						celda.setCellValue("Tiempo en Estatus(Días)");
						celda.setCellStyle(estiloSaltoLinea);
						
						// Solicitud Rechazada
						celda = fila.createCell((short)14);
						celda.setCellValue("Fecha");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)15);
						celda.setCellValue("Ejecutivo");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)16);
						celda.setCellValue("Último Comentario");
						celda.setCellStyle(estiloSaltoLinea);		
						
						// Solicitud Liberada
						celda = fila.createCell((short)17);
						celda.setCellValue("Fecha");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)18);
						celda.setCellValue("Ejecutivo");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)19);
						celda.setCellValue("Último Comentario");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)20);
						celda.setCellValue("Tiempo en Estatus(Días)");
						celda.setCellStyle(estiloSaltoLinea);
						
						// Solicitud Autorizada
						celda = fila.createCell((short)21);
						celda.setCellValue("Fecha");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)22);
						celda.setCellValue("Ejecutivo");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)23);
						celda.setCellValue("Último Comentario");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)24);
						celda.setCellValue("Tiempo en Estatus(Días)");
						celda.setCellStyle(estiloSaltoLinea);
						
						// Credito Registrado
						celda = fila.createCell((short)25);
						celda.setCellValue("Fecha");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)26);
						celda.setCellValue("Ejecutivo");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)27);
						celda.setCellValue("Último Comentario");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)28);
						celda.setCellValue("Tiempo en Estatus(Días)");
						celda.setCellStyle(estiloSaltoLinea);
						
						// Credito Condicionado
						celda = fila.createCell((short)29);
						celda.setCellValue("Fecha");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)30);
						celda.setCellValue("Ejecutivo");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)31);
						celda.setCellValue("Último Comentario");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)32);
						celda.setCellValue("Tiempo en Estatus(Días)");
						celda.setCellStyle(estiloSaltoLinea);
						
						// Credito Autorizado
						celda = fila.createCell((short)33);
						celda.setCellValue("Fecha");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)34);
						celda.setCellValue("Ejecutivo");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)35);
						celda.setCellValue("Último Comentario");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)36);
						celda.setCellValue("Tiempo en Estatus(Días)");
						celda.setCellStyle(estiloSaltoLinea);
						
						// Credito Cancelado
						celda = fila.createCell((short)37);
						celda.setCellValue("Fecha");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)38);
						celda.setCellValue("Ejecutivo");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)39);
						celda.setCellValue("Último Comentario");
						celda.setCellStyle(estiloSaltoLinea);
						
						
						// Credito Desembolsado
						celda = fila.createCell((short)40);
						celda.setCellValue("Fecha");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)41);
						celda.setCellValue("Ejecutivo");
						celda.setCellStyle(estiloSaltoLinea);
						
						celda = fila.createCell((short)42);
						celda.setCellValue("Último Comentario");
						celda.setCellStyle(estiloSaltoLinea);
						
					
						for (int celd = 0; celd <= 42; celd++){
							hoja.autoSizeColumn(celd, true);
						}
						int i=8;
						for(RepBitacoraSolBean bitacoraSol : listaSolicitudes ){
							fila=hoja.createRow(i);
							celda=fila.createCell((short)0);
							celda.setCellValue(bitacoraSol.getDias().equals(null) || bitacoraSol.getDias().equals("") ? "-" : bitacoraSol.getDias());
							
							celda=fila.createCell((short)1);
							celda.setCellValue(bitacoraSol.getSolicitudCreditoID().equals(null) || bitacoraSol.getSolicitudCreditoID().equals("") ? "-" : bitacoraSol.getSolicitudCreditoID());
							
							celda=fila.createCell((short)2);
							celda.setCellValue(bitacoraSol.getCreditoID().equals(null) || bitacoraSol.getCreditoID().equals("") ? "-" : bitacoraSol.getCreditoID());
						
							celda=fila.createCell((short)3);
							celda.setCellValue(bitacoraSol.getNombreCliente().equals(null) || bitacoraSol.getNombreCliente().equals("") ? "-" : bitacoraSol.getNombreCliente());
							
							celda=fila.createCell((short)4);
							celda.setCellValue(bitacoraSol.getNomPromotor().equals(null) || bitacoraSol.getNomPromotor().equals("") ? "-" : bitacoraSol.getNomPromotor());
							
							celda=fila.createCell((short)5);
							celda.setCellValue(bitacoraSol.getEstatus().equals(null) || bitacoraSol.getEstatus().equals("") ? "-" : bitacoraSol.getEstatus());
							
							// Registro Solicitud de Credito
							celda=fila.createCell((short)6);
							celda.setCellValue(bitacoraSol.getFechaSolRegistro().equals(null) || bitacoraSol.getFechaSolRegistro().equals("") ? "-" : bitacoraSol.getFechaSolRegistro());
							
							celda=fila.createCell((short)7);					
							celda.setCellValue(bitacoraSol.getNomUsuSolRegistro().equals(null) || bitacoraSol.getNomUsuSolRegistro().equals("") ? "-" : bitacoraSol.getNomUsuSolRegistro());
							
							celda=fila.createCell((short)8);
							celda.setCellValue(bitacoraSol.getComSolRegistro().equals(null) || bitacoraSol.getComSolRegistro().equals("") ? "-" : bitacoraSol.getComSolRegistro());
							
							celda=fila.createCell((short)9);
							celda.setCellValue(bitacoraSol.getTiempoEstRegistro().equals(null) || bitacoraSol.getTiempoEstRegistro().equals("") ? "-" : bitacoraSol.getTiempoEstRegistro());
							
							// Actualizacion de Datos Solicitud de Credito
							celda=fila.createCell((short)10);
							celda.setCellValue(bitacoraSol.getFechaSolActualiza().equals(null) || bitacoraSol.getFechaSolActualiza().equals("") ? "-" : bitacoraSol.getFechaSolActualiza());
							
							celda=fila.createCell((short)11);					
							celda.setCellValue(bitacoraSol.getNomUsuSolActualiza().equals(null) || bitacoraSol.getNomUsuSolActualiza().equals("") ? "-" : bitacoraSol.getNomUsuSolActualiza());
							
							celda=fila.createCell((short)12);
							celda.setCellValue(bitacoraSol.getComSolActualiza().equals(null) || bitacoraSol.getComSolActualiza().equals("") ? "-" : bitacoraSol.getComSolActualiza());
							
							
							celda=fila.createCell((short)13);
							celda.setCellValue(bitacoraSol.getTiempoEstActualiza().equals(null) || bitacoraSol.getTiempoEstActualiza().equals("") ? "-" : bitacoraSol.getTiempoEstActualiza());
							
							// Rechazo de Solicitud de Credito
							celda=fila.createCell((short)14);
							celda.setCellValue(bitacoraSol.getFechaSolRechaza().equals(null) || bitacoraSol.getFechaSolRechaza().equals("") ? "-" : bitacoraSol.getFechaSolRechaza());
							
							celda=fila.createCell((short)15);					
							celda.setCellValue(bitacoraSol.getNomUsuSolRechaza().equals(null) || bitacoraSol.getNomUsuSolRechaza().equals("") ? "-" : bitacoraSol.getNomUsuSolRechaza());
							
							celda=fila.createCell((short)16);
							celda.setCellValue(bitacoraSol.getComSolRechaza().equals(null) || bitacoraSol.getComSolRechaza().equals("") ? "-" : bitacoraSol.getComSolRechaza());
							
							// Liberacion de Solicitud de Credito
							celda=fila.createCell((short)17);
							celda.setCellValue(bitacoraSol.getFechaSolLibera().equals(null) || bitacoraSol.getFechaSolLibera().equals("") ? "-" : bitacoraSol.getFechaSolLibera());
							
							celda=fila.createCell((short)18);					
							celda.setCellValue(bitacoraSol.getNomUsuSolLibera().equals(null) || bitacoraSol.getNomUsuSolLibera().equals("") ? "-" : bitacoraSol.getNomUsuSolLibera());
							
							celda=fila.createCell((short)19);							
							celda.setCellValue(bitacoraSol.getComSolLibera().equals(null) || bitacoraSol.getComSolLibera().equals("") ? "-" : bitacoraSol.getComSolLibera());
							
							
							celda=fila.createCell((short)20);
							celda.setCellValue(bitacoraSol.getTiempoEstLibera().equals(null) || bitacoraSol.getTiempoEstLibera().equals("") ? "-" : bitacoraSol.getTiempoEstLibera());
							
							// Autorizacion de Solicitud de Credito
							celda=fila.createCell((short)21);
							celda.setCellValue(bitacoraSol.getFechaSolAutoriza().equals(null) || bitacoraSol.getFechaSolAutoriza().equals("") ? "-" : bitacoraSol.getFechaSolAutoriza());
							
							celda=fila.createCell((short)22);					
							celda.setCellValue(bitacoraSol.getNomUsuSolAutoriza().equals(null) || bitacoraSol.getNomUsuSolAutoriza().equals("") ? "-" : bitacoraSol.getNomUsuSolAutoriza());
							
							celda=fila.createCell((short)23);
							celda.setCellValue(bitacoraSol.getComSolAutoriza().equals(null) || bitacoraSol.getComSolAutoriza().equals("") ? "-" : bitacoraSol.getComSolAutoriza());
							
							celda=fila.createCell((short)24);
							celda.setCellValue(bitacoraSol.getTiempoEstAutoriza().equals(null) || bitacoraSol.getTiempoEstAutoriza().equals("") ? "-" : bitacoraSol.getTiempoEstAutoriza());
							
							// Alta de Credito
							celda=fila.createCell((short)25);
							celda.setCellValue(bitacoraSol.getFechaCreRegistro().equals(null) || bitacoraSol.getFechaCreRegistro().equals("") ? "-" : bitacoraSol.getFechaCreRegistro());
							
							celda=fila.createCell((short)26);					
							celda.setCellValue(bitacoraSol.getNomUsuCreRegistro().equals(null) || bitacoraSol.getNomUsuCreRegistro().equals("") ? "-" : bitacoraSol.getNomUsuCreRegistro());
							
							celda=fila.createCell((short)27);
							celda.setCellValue(bitacoraSol.getComCreRegistro().equals(null) || bitacoraSol.getComCreRegistro().equals("") ? "-" : bitacoraSol.getComCreRegistro());
							
							celda=fila.createCell((short)28);
							celda.setCellValue(bitacoraSol.getTiempoEstCreRegistro());
							celda.setCellValue(bitacoraSol.getTiempoEstCreRegistro().equals(null) || bitacoraSol.getTiempoEstCreRegistro().equals("") ? "-" : bitacoraSol.getTiempoEstCreRegistro());
							
							// Condicion de Credito
							celda=fila.createCell((short)29);
							celda.setCellValue(bitacoraSol.getFechaCreCondiciona().equals(null) || bitacoraSol.getFechaCreCondiciona().equals("") ? "-" : bitacoraSol.getFechaCreCondiciona());
							
							celda=fila.createCell((short)30);					
							celda.setCellValue(bitacoraSol.getNomUsuCreCondiciona());
							celda.setCellValue(bitacoraSol.getNomUsuCreCondiciona().equals(null) || bitacoraSol.getNomUsuCreCondiciona().equals("") ? "-" : bitacoraSol.getNomUsuCreCondiciona());
							
							celda=fila.createCell((short)31);
							celda.setCellValue(bitacoraSol.getComCreCondiciona().equals(null) || bitacoraSol.getComCreCondiciona().equals("") ? "-" : bitacoraSol.getComCreCondiciona());
							
							celda=fila.createCell((short)32);
							celda.setCellValue(bitacoraSol.getTiempoEstCreCondiciona().equals(null) || bitacoraSol.getTiempoEstCreCondiciona().equals("") ? "-" : bitacoraSol.getTiempoEstCreCondiciona());
							
							// Autorizacion de Credito
							celda=fila.createCell((short)33);
							celda.setCellValue(bitacoraSol.getFechaCreAutoriza().equals(null) || bitacoraSol.getFechaCreAutoriza().equals("") ? "-" : bitacoraSol.getFechaCreAutoriza());
							
							celda=fila.createCell((short)34);					
							celda.setCellValue(bitacoraSol.getNomUsuCreAutoriza().equals(null) || bitacoraSol.getNomUsuCreAutoriza().equals("") ? "-" : bitacoraSol.getNomUsuCreAutoriza());
							
							celda=fila.createCell((short)35);
							celda.setCellValue(bitacoraSol.getComCreAutoriza().equals(null) || bitacoraSol.getComCreAutoriza().equals("") ? "-" : bitacoraSol.getComCreAutoriza());
							
							celda=fila.createCell((short)36);
							celda.setCellValue(bitacoraSol.getTiempoEstCreAutoriza().equals(null) || bitacoraSol.getTiempoEstCreAutoriza().equals("") ? "-" : bitacoraSol.getTiempoEstCreAutoriza());
							
							// Cancelación de Crédito
							celda=fila.createCell((short)37);
							celda.setCellValue(bitacoraSol.getFechaCreCancela().equals(null) || bitacoraSol.getFechaCreCancela().equals("") ? "-" : bitacoraSol.getFechaCreCancela());
							
							celda=fila.createCell((short)38);					
							celda.setCellValue(bitacoraSol.getNomUsuCreCancela().equals(null) || bitacoraSol.getNomUsuCreCancela().equals("") ? "-" : bitacoraSol.getNomUsuCreCancela());
							
							celda=fila.createCell((short)39);
							celda.setCellValue(bitacoraSol.getComCreCancela().equals(null) || bitacoraSol.getComCreCancela().equals("") ? "-" : bitacoraSol.getComCreCancela());
							
							// Desembolso de Crédito
							celda=fila.createCell((short)40);
							celda.setCellValue(bitacoraSol.getFechaCreDesembolsa().equals(null) || bitacoraSol.getFechaCreDesembolsa().equals("") ? "-" : bitacoraSol.getFechaCreDesembolsa());
							
							celda=fila.createCell((short)41);					
							celda.setCellValue(bitacoraSol.getNomUsuCreDesembolsa().equals(null) || bitacoraSol.getNomUsuCreDesembolsa().equals("") ? "-" : bitacoraSol.getNomUsuCreDesembolsa());
							
							celda=fila.createCell((short)42);
							celda.setCellValue(bitacoraSol.getComCreDesembolsa().equals(null) || bitacoraSol.getComCreDesembolsa().equals("") ? "-" : bitacoraSol.getComCreDesembolsa());
							
												
							regExport 		= regExport + 1;

							i++;
						}					
						hoja.setColumnWidth(0, 2798);// Numero de Solicitud
						hoja.setColumnWidth(1, 2798);// Numero de Solicitud
						hoja.setColumnWidth(2, 3351);
						hoja.setColumnWidth(3, 8690);
						hoja.setColumnWidth(4, 8650);
						hoja.setColumnWidth(5, 6610);
						
						
						hoja.setColumnWidth(6, 4690);						
						hoja.setColumnWidth(7, 3392);
						hoja.setColumnWidth(8, 7325);
						hoja.setColumnWidth(9, 4000);

						hoja.setColumnWidth(10, 4690);						
						hoja.setColumnWidth(11, 3392);
						hoja.setColumnWidth(12, 7325);
						hoja.setColumnWidth(13, 4000);

						hoja.setColumnWidth(14, 4690);						
						hoja.setColumnWidth(15, 3392);
						hoja.setColumnWidth(16, 7325);
						
						hoja.setColumnWidth(17, 4690);	
						hoja.setColumnWidth(18, 3392);						
						hoja.setColumnWidth(19, 7325);
						hoja.setColumnWidth(20, 4000);
						
						hoja.setColumnWidth(21, 4690);						
						hoja.setColumnWidth(22, 3392);
						hoja.setColumnWidth(23, 7325);
						hoja.setColumnWidth(24, 4000);		
						
						hoja.setColumnWidth(25, 4690);						
						hoja.setColumnWidth(26, 3392);
						hoja.setColumnWidth(27, 7325);
						hoja.setColumnWidth(28, 4000);		
						
						hoja.setColumnWidth(29, 4690);						
						hoja.setColumnWidth(30, 3392);
						hoja.setColumnWidth(31, 7325);
						hoja.setColumnWidth(32, 4000);		
						
						hoja.setColumnWidth(33, 4690);						
						hoja.setColumnWidth(34, 3392);
						hoja.setColumnWidth(35, 7325);
						hoja.setColumnWidth(36, 4000);		
						
						hoja.setColumnWidth(37, 4690);						
						hoja.setColumnWidth(38, 3392);
						hoja.setColumnWidth(39, 7325);
						
						hoja.setColumnWidth(40, 4690);		
						hoja.setColumnWidth(41, 3392);						
						hoja.setColumnWidth(42, 7325);
						
						
						
						
					
															
									
					}					
				for (int celd = 0; celd <= 42; celd++){
					hoja.autoSizeColumn(celd, true);
				}

				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReporteBitacoraSolCred.xls");
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

	public RepBitacoraSolServicio getRepBitacoraSolServicio() {
		return repBitacoraSolServicio;
	}

	public void setRepBitacoraSolServicio(
			RepBitacoraSolServicio repBitacoraSolServicio) {
		this.repBitacoraSolServicio = repBitacoraSolServicio;
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
	
	

}

