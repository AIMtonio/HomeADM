package aportaciones.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;

import aportaciones.bean.AportacionesBean;
import aportaciones.servicio.AportacionesServicio;

public class ReporteRenovacionAporControlador extends AbstractCommandController{
	AportacionesServicio aportacionesServicio = null;
	String successView = null;
	String nombreReporte = null;
	
	public static interface Enum_Con_TipRepor {
		int  Excel = 1 ;
		int  Pdf = 2 ;
	}

	public ReporteRenovacionAporControlador(){
		setCommandClass(AportacionesBean.class);
		setCommandName("aportacionesBean");		
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		AportacionesBean aportacionesBean = (AportacionesBean) command;
		
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):0;
		
		String htmlString= "";
				
		switch(tipoReporte){
			case Enum_Con_TipRepor.Excel:
				List listaReportes = listaReporteRenovacionAporExcel(tipoLista, aportacionesBean ,response);
			break;case Enum_Con_TipRepor.Pdf:
				ByteArrayOutputStream htmlStringPDF = reporteRenovacionPDF(aportacionesBean, nombreReporte, response);
			break;
		}
		return null;		
	}
	
	// método para crear el reporte en PDF
 	public ByteArrayOutputStream reporteRenovacionPDF(AportacionesBean aportacionesBean, String nombreReporte, HttpServletResponse response){
 		ByteArrayOutputStream htmlStringPDF = null;
 		try{
 			htmlStringPDF = aportacionesServicio.reporteRenovacionesPDF(aportacionesBean,nombreReporte);
 	 		response.addHeader("Content-Disposition", "inline; filename=Renovaciones.pdf");
 			response.setContentType("application/pdf");
 			
 			byte[] bytes = htmlStringPDF.toByteArray();
 			response.getOutputStream().write(bytes,0,bytes.length);
 			response.getOutputStream().flush();
 			response.getOutputStream().close();
 			
 		}catch (Exception e){
 			e.printStackTrace();
 		}
 	 return htmlStringPDF;
 	}
 	
 // REPORTE RENOVACIONES EN EXCEL
 	public List listaReporteRenovacionAporExcel(int tipoLista,AportacionesBean aportacionesBean,  HttpServletResponse response){
 		List listaBean = null;		
 		listaBean = aportacionesServicio.repRenovacion(tipoLista, aportacionesBean);
 				
 		if(listaBean != null){
 			try {
 				Workbook libro = new SXSSFWorkbook();
 				// Se crea una Fuente Negrita 	con tamaño 10 para el titulo del reporte
 				Font fuenteNegrita10= libro.createFont();
 				fuenteNegrita10.setFontHeightInPoints((short)10);
 				fuenteNegrita10.setFontName("Arial");
 				fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);
 				
 				// Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
 				Font fuenteNegrita8= libro.createFont();
 				fuenteNegrita8.setFontHeightInPoints((short)8);
 				fuenteNegrita8.setFontName("Arial");
 				fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
 				
 				Font fuenteNeg8= libro.createFont();
 				fuenteNeg8.setFontHeightInPoints((short)8);
 				fuenteNeg8.setFontName("Arial");
 				fuenteNeg8.setBoldweight(Font.BOLDWEIGHT_BOLD);
 				
 				// Estilo negrita de 10 para encabezados del reporte
 				XSSFCellStyle estiloNeg10 = (XSSFCellStyle) libro.createCellStyle();
 				estiloNeg10.setFont(fuenteNegrita10);
 				
 				// Estilo de datos centrado en la información del reporte
 				XSSFCellStyle estiloDatosCentrado = (XSSFCellStyle) libro.createCellStyle();
 				estiloDatosCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER); 
 				
 				// Estrilo centrado fuente negrita 10
 				XSSFCellStyle estiloCentrado10 = (XSSFCellStyle) libro.createCellStyle();			
 				estiloCentrado10.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
 				estiloCentrado10.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
 				estiloCentrado10.setFont(fuenteNegrita10);
 				
 				// Estilo centrado fuente negrita 8
 				XSSFCellStyle estiloCentrado = (XSSFCellStyle) libro.createCellStyle();
 				estiloCentrado.setFont(fuenteNegrita8);
 				estiloCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
 				estiloCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
 				estiloCentrado.setWrapText(true);
 				
 				// Estilo centrado fuente  8
 				XSSFCellStyle estiloCentra = (XSSFCellStyle) libro.createCellStyle();
 				estiloCentra.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
 				estiloCentra.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
 				estiloCentra.setWrapText(true);
 				
 				// Estilo negrita de 8 para encabezados del reporte
 				XSSFCellStyle estiloNeg8 = (XSSFCellStyle) libro.createCellStyle();
 				estiloNeg8.setFont(fuenteNegrita8);
 				
 				XSSFCellStyle estiloNegro8 = (XSSFCellStyle) libro.createCellStyle();
 				estiloNegro8.setFont(fuenteNeg8);
 				
 				// Estilo negrita de 8  y color de fondo
 				XSSFCellStyle estiloColor = (XSSFCellStyle) libro.createCellStyle();
 				estiloColor.setFont(fuenteNegrita8);
 				estiloColor.setFillForegroundColor(IndexedColors.CORNFLOWER_BLUE.index);
 				estiloColor.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
 				
 				// Estilo Formato decimal (0.00)
 				XSSFCellStyle estiloFormatoDecimal = (XSSFCellStyle) libro.createCellStyle();
 				DataFormat format = libro.createDataFormat();
 				estiloFormatoDecimal.setDataFormat(format.getFormat("$ #,##0.00"));
 				
 				//NUEVA HOJA DE EXCEL
 				SXSSFSheet hoja = (SXSSFSheet) libro.createSheet("Reporte Renovaciones");
 				
 				//PRIMER FILA
 				Row fila = hoja.createRow(0);

 				// Nombre Institucion	
 				Cell celdaInst=fila.createCell((short)1);
 				celdaInst.setCellValue(aportacionesBean.getNombreInstitucion());
 				celdaInst.setCellStyle(estiloCentrado10);				
 				hoja.addMergedRegion(new CellRangeAddress(
 		            0, //primera fila 
 		            0, //ultima fila 
 		            1, //primer celda
 		            8 //ultima celda
 			    ));	
 				
 				// Nombre Usuario
 				Cell celdaUsu=fila.createCell((short)9);
 				celdaUsu.setCellValue("Usuario:");
 				celdaUsu.setCellStyle(estiloNegro8);	
 				celdaUsu = fila.createCell((short)10);				
 				celdaUsu.setCellValue(aportacionesBean.getClaveUsuario());				
 					
 				// SEGUNDA FILA
 				fila = hoja.createRow(1);		
 				
 				// Titulo del Reporte
 				Cell celda=fila.createCell((short)1);
 				celda.setCellValue("REPORTE DE RENOVACIONES DEL " +aportacionesBean.getFechaInicial()+" AL "+aportacionesBean.getFechaFinal());
 				celda.setCellStyle(estiloCentrado10);					
 				hoja.addMergedRegion(new CellRangeAddress(
 		            1, //primera fila 
 		            1, //ultima fila 
 		            1, //primer celda
 		            8 //ultima celda
 			    ));	
 				
 				// Fecha en que se genera el reporte
 				Cell celdaFec=fila.createCell((short)9);
 				celdaFec.setCellValue("Fecha:");
 				celdaFec.setCellStyle(estiloNegro8);	
 				celdaFec = fila.createCell((short)10);
 				celdaFec.setCellValue(aportacionesBean.getFechaSistema());	
 				
 				// TERCER FILA
 				fila = hoja.createRow(2);
 								
 				// Hora en que se genera el reporte
 				Cell celdaHora=fila.createCell((short)9);
 				celdaHora.setCellValue("Hora:");
 				celdaHora.setCellStyle(estiloNegro8);	
 				celdaHora = fila.createCell((short)10);
 				
 				String horaVar="";
 				Calendar calendario = Calendar.getInstance();	 
 				int hora = calendario.get(Calendar.HOUR_OF_DAY);
 				int minutos = calendario.get(Calendar.MINUTE);
 				int segundos = calendario.get(Calendar.SECOND);
 				
 				String h = "";
 				String m = "";
 				String s = "";
 				if(hora<10)h="0"+Integer.toString(hora); else h=Integer.toString(hora);
 				if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
 				if(segundos<10)s="0"+Integer.toString(segundos); else s=Integer.toString(segundos);				 
 				horaVar= h+":"+m+":"+s;
 				
 				celdaHora.setCellValue(horaVar);					
 				
 				// CUARTA FILA SEPARADOR
 				fila = hoja.createRow(3);						
 				
 				// QUINTA FILA
 				fila = hoja.createRow(4);

 				celda = fila.createCell((short)0);
 				celda.setCellValue("Estatus:");										
 				celda.setCellStyle(estiloNegro8);	
 				celda = fila.createCell((short)1);
 				celda.setCellValue(aportacionesBean.getDescEstatus());
 				celda.setCellStyle(estiloCentra);
 				
 				celda = fila.createCell((short)2);
 				celda.setCellValue("Cliente:");										
 				celda.setCellStyle(estiloNegro8);	

 				celda = fila.createCell((short)3);
 				celda.setCellValue(aportacionesBean.getNombreCliente());
 				
 				
 				// SEXTA FILA SEPARADOR
 				fila = hoja.createRow(5);
 				
 				// SEPTIMA FILA
 				fila = hoja.createRow(6);

 				celda = fila.createCell((short)0);
 				celda.setCellValue("Aportación");
 				celda.setCellStyle(estiloCentrado);
 				
 				celda = fila.createCell((short)1);
 				celda.setCellValue("Número de Cliente");
 				celda.setCellStyle(estiloCentrado);
 				
 				celda = fila.createCell((short)2);
 				celda.setCellValue("Nombre del Cliente");
 				celda.setCellStyle(estiloCentrado);
 				
 				celda = fila.createCell((short)3);
 				celda.setCellValue("Plazo (Días)");
 				celda.setCellStyle(estiloCentrado);
 				
 				celda = fila.createCell((short)4);
 				celda.setCellValue("Fecha Inicio");
 				celda.setCellStyle(estiloCentrado);
 				
 				celda = fila.createCell((short)5);
 				celda.setCellValue("Fecha Vencimiento");
 				celda.setCellStyle(estiloCentrado);
 				
 				celda = fila.createCell((short)6);
 				celda.setCellValue("Monto Renovación");
 				celda.setCellStyle(estiloCentrado);
 				
 				celda = fila.createCell((short)7);
 				celda.setCellValue("Tasa");
 				celda.setCellStyle(estiloCentrado);
 				
 				celda = fila.createCell((short)8);
 				celda.setCellValue("Estatus");
 				celda.setCellStyle(estiloCentrado);
 				
 				celda = fila.createCell((short)9);
 				celda.setCellValue("Aportación Renovada");
 				celda.setCellStyle(estiloCentrado);
 				
 				celda = fila.createCell((short)10);
 				celda.setCellValue("Motivo");
 				celda.setCellStyle(estiloCentrado);
 				
 				celda = fila.createCell((short)11);
 				celda.setCellValue("Tipo Renovación");
 				celda.setCellStyle(estiloCentrado);

 				celda = fila.createCell((short)12);
 				celda.setCellValue("Tipo Documento");
 				celda.setCellStyle(estiloCentrado);

 				celda = fila.createCell((short)13);
 				celda.setCellValue("Tipo de Interés");
 				celda.setCellStyle(estiloCentrado);
 								
 				int i=7, iter=0;
 				int tamanioLista = listaBean.size();
 				AportacionesBean beanLis = null;
 				
 				for(iter=0; iter<tamanioLista; iter ++){
 					beanLis = (AportacionesBean) listaBean.get(iter);
 					
 					fila = hoja.createRow(i);
 					
 					celda = fila.createCell((short)0);
 					celda.setCellValue(beanLis.getAportacionID());
 					
 					celda = fila.createCell((short)1);
 					celda.setCellValue(beanLis.getClienteID());
 					
 					celda = fila.createCell((short)2);
 					celda.setCellValue(beanLis.getNombreCliente());
 					
 					celda = fila.createCell((short)3);
 					celda.setCellValue(beanLis.getPlazo());
 					celda.setCellStyle(estiloCentra);
 					
 					celda = fila.createCell((short)4);
 					celda.setCellValue(beanLis.getFechaInicio());
 					celda.setCellStyle(estiloCentra);
 					
 					celda = fila.createCell((short)5);
 					celda.setCellValue(beanLis.getFechaVencimiento());
 					celda.setCellStyle(estiloCentra);
 					
 					celda = fila.createCell((short)6);
 					celda.setCellValue(beanLis.getMonto());
 					celda.setCellStyle(estiloFormatoDecimal);
 					
 					celda = fila.createCell((short)7);
 					celda.setCellValue(beanLis.getTasa());
 					
 					celda = fila.createCell((short)8);
 					celda.setCellValue(beanLis.getEstatus());

 					celda = fila.createCell((short)9);
 					celda.setCellValue(beanLis.getAportRenovada());
 					celda.setCellStyle(estiloCentra);
 														
 					celda = fila.createCell((short)10);
 					celda.setCellValue(beanLis.getMotivo());
 					
 					celda = fila.createCell((short)11);
 					celda.setCellValue(beanLis.getTipoRenovacion());
 					
 					celda = fila.createCell((short)12);
 					celda.setCellValue(beanLis.getTipoDocumento());
 					
 					celda = fila.createCell((short)13);
 					celda.setCellValue(beanLis.getTipoInteres());
 					
 					i++;
 				}	
 				i = i+2;
 				fila=hoja.createRow(i);
 				celda = fila.createCell((short)0);
 				celda.setCellValue("Registros Exportados");
 				celda.setCellStyle(estiloNegro8);
 				celda=fila.createCell((short)1);
 				celda.setCellValue(tamanioLista);			

 				hoja.setColumnWidth(0, 15 * 256);
 				hoja.setColumnWidth(1, 15 * 256);
 				hoja.setColumnWidth(2, 30 * 256);
 				hoja.setColumnWidth(3, 15 * 256);
 				hoja.setColumnWidth(4, 15 * 256);
 				hoja.setColumnWidth(5, 15 * 256);
 				hoja.setColumnWidth(6, 15 * 256);
 				hoja.setColumnWidth(7, 10 * 256);
 				hoja.setColumnWidth(8, 10 * 256);
 				hoja.setColumnWidth(9, 20 * 256);
 				hoja.setColumnWidth(10, 50 * 256);
 				hoja.setColumnWidth(11, 16 * 256);
 				hoja.setColumnWidth(12, 16 * 256);
 				hoja.setColumnWidth(13, 14 * 256);

 				//Creo la cabecera
 				response.addHeader("Content-Disposition","inline; filename=ReporteRenovacion.xls");
 				response.setContentType("application/vnd.ms-excel");
 				
 				ServletOutputStream outputStream = response.getOutputStream();
 				libro.write(outputStream);
 				outputStream.flush();
 				outputStream.close();
 				
 				
 			}catch(Exception e){
 				
 				e.printStackTrace();
 			}//Fin del catch
 		}
 		return  listaBean;
 	}
 	
 	
 	

	public AportacionesServicio getAportacionesServicio() {
		return aportacionesServicio;
	}

	public void setAportacionesServicio(AportacionesServicio aportacionesServicio) {
		this.aportacionesServicio = aportacionesServicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
}