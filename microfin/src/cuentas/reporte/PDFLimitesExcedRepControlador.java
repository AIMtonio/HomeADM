package cuentas.reporte;


import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
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

import cuentas.bean.RepCtasLimitesExcedBean;
import cuentas.servicio.RepCtasLimitesExcedServicio;


   
public class PDFLimitesExcedRepControlador  extends AbstractCommandController{

	RepCtasLimitesExcedServicio repCtasLimitesExcedServicio = null;
	String nomReporte= null;
	String successView = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public static interface Enum_Con_TipRepor {
		  int reportePDF  = 1 ;
		  int reporteExcel= 2;
		
		}
	
	
	public PDFLimitesExcedRepControlador () {
		setCommandClass(RepCtasLimitesExcedBean.class);
		setCommandName("repCtasLimitesExcedBean");
	}

	
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors)throws Exception {
		RepCtasLimitesExcedBean repCtasLimitesExcedBean = (RepCtasLimitesExcedBean) command;

		int tipoReporte = (request.getParameter("tipoReporte") != null) ? Integer.parseInt(request.getParameter("tipoReporte")) : 0;
		int tipoLista = (request.getParameter("tipoLista") != null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;

		if (request.getParameter("descripcion") != null) {
			String descripcion = request.getParameter("descripcion");
			byte[] bytes = descripcion.getBytes("ISO-8859-1");
			descripcion = new String(bytes, "UTF-8");
			repCtasLimitesExcedBean.setDescripcion(descripcion);
		}
		switch (tipoReporte) {
		case Enum_Con_TipRepor.reportePDF:
			ByteArrayOutputStream htmlStringPDF = limitesExcedidosRepPDF(tipoReporte, repCtasLimitesExcedBean, nomReporte, response);
			break;
		case Enum_Con_TipRepor.reporteExcel:
			List listaReportes = limitesExcedidosRepExcel(tipoLista, repCtasLimitesExcedBean, response);
			break;
		}

		return null;
	}

		
	/* Reporte de cuentas limite excento en PDF */
	public ByteArrayOutputStream limitesExcedidosRepPDF(int tipoReporte,RepCtasLimitesExcedBean repCtasLimitesExcedBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = repCtasLimitesExcedServicio.reporteLimitesExced(tipoReporte,repCtasLimitesExcedBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteLimitesExcedidos.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
			

		} catch (Exception e) {
			e.printStackTrace();
		}
	return htmlStringPDF;
	}// reporte PDF
	
	
	
	/* Reporte de cuentas limite excento en Excel */
	public List  limitesExcedidosRepExcel(int tipoLista,RepCtasLimitesExcedBean repCtasLimitesExcedBean,  HttpServletResponse response){
	List listaLimitesExced=null;
	listaLimitesExced = repCtasLimitesExcedServicio.listaReporte(tipoLista,repCtasLimitesExcedBean,response); 
		
		try {
		HSSFWorkbook libro = new HSSFWorkbook();
		//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
		HSSFFont fuenteNegrita10= libro.createFont();
		fuenteNegrita10.setFontHeightInPoints((short)10);
		fuenteNegrita10.setFontName("Negrita");
		fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		
		
		//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
		HSSFFont fuenteNegrita8= libro.createFont();
		fuenteNegrita8.setFontHeightInPoints((short)8);
		fuenteNegrita8.setFontName("Negrita");
		fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		
		// La fuente se mete en un estilo para poder ser usada.
		//Estilo negrita de 10 para el titulo del reporte
		HSSFCellStyle estiloNeg10 = libro.createCellStyle();
		estiloNeg10.setFont(fuenteNegrita10);
		
		//Estilo negrita de 8  para encabezados del reporte
		HSSFCellStyle estiloNeg8 = libro.createCellStyle();
		estiloNeg8.setFont(fuenteNegrita8);
		
		HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
		estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
		
		HSSFCellStyle estiloCentrado = libro.createCellStyle();
		estiloCentrado.setFont(fuenteNegrita8);
		estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
		estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
		
		
		//Estilo negrita de 8  y color de fondo
		HSSFCellStyle estiloColor = libro.createCellStyle();
		estiloColor.setFont(fuenteNegrita8);
		estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
		estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		
		//Estilo Formato decimal (0.00)
		HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
		HSSFDataFormat format = libro.createDataFormat();
		estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
		
		/* Crea la hoja y el nombre cuando se descar */				
		HSSFSheet hoja = libro.createSheet("Reporte Límites Excedidos");
		
		HSSFRow fila= hoja.createRow(0);			
		HSSFCell nombInstitucion=fila.createCell((short)2);
		nombInstitucion.setCellStyle(estiloNeg10);
		nombInstitucion.setCellValue(repCtasLimitesExcedBean.getNombreInstitucion());
		nombInstitucion.setCellStyle(estiloDatosCentrado);
		nombInstitucion.setCellStyle(estiloNeg8);	
		
		hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
	            0, //primera fila (0-based)
	            0, //ultima fila  (0-based)
	            2, //primer celda (0-based)
	            5  //ultima celda   (0-based)
	    ));
							
		
		fila = hoja.createRow(1);		
		HSSFCell celda=fila.createCell((short)2);
		celda.setCellStyle(estiloNeg10);
		celda.setCellValue("Reporte de Cuentas con Límites Excedidos del "+repCtasLimitesExcedBean.getFechaInicio()+" al "+repCtasLimitesExcedBean.getFechaFin());
		celda.setCellStyle(estiloDatosCentrado);
		celda.setCellStyle(estiloNeg8);	
		
		hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
	            1, //primera fila (0-based)
	            1, //ultima fila  (0-based)
	            2, //primer celda (0-based)
	            5  //ultima celda   (0-based)
	    ));
						
		fila = hoja.createRow(2);
		HSSFCell celdaFec=fila.createCell((short)1);
		celda = fila.createCell((short)6);
		celda.setCellValue("Usuario:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)7);
		celda.setCellValue(repCtasLimitesExcedBean.getNombreUsuario().toUpperCase());
		

		fila = hoja.createRow(3);
		celda = fila.createCell((short)6);
		celda.setCellValue("Fecha:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)7);
		celda.setCellValue(repCtasLimitesExcedBean.getFechaSistema());
		

		Calendar calendario=new GregorianCalendar();
		int hora, minutos;
		hora =calendario.get(Calendar.HOUR_OF_DAY);
		minutos = calendario.get(Calendar.MINUTE);
		repCtasLimitesExcedBean.setHoraEmision(hora+":"+minutos);
		
		fila = hoja.createRow(4);
		HSSFCell celdaHora=fila.createCell((short)1);
		celdaHora = fila.createCell((short)6);
		celdaHora.setCellValue("Hora:");
		celdaHora.setCellStyle(estiloNeg8);	
		celdaHora = fila.createCell((short)7);
		celdaHora.setCellValue(repCtasLimitesExcedBean.getHoraEmision());
		
		
		String sucursal=String.valueOf(repCtasLimitesExcedBean.getSucursalID()) ;
		if(sucursal.equals("0")){
			sucursal = "TODAS";
		}else{ 
			sucursal = repCtasLimitesExcedBean.getNombreSucurs();		
		}

		fila = hoja.createRow(5);
		celda = fila.createCell((short)0);
		celda.setCellValue("Sucursal:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)1);
		celda.setCellValue(sucursal);
		
		
		String motivo=String.valueOf(repCtasLimitesExcedBean.getMotivo()) ;
		if(motivo.equals("0")){
			motivo = "TODOS";
		}

		if(motivo.equals("4")){
				motivo = "SUPERÓ EL SALDO MÁXIMO DE LA CUENTA";	
		}
			if(motivo.equals("3")){
				motivo = "SUPERÓ EL LÍMITE DE ABONOS PERMITIDOS EN EL MES";	
		}
			
		
		celda = fila.createCell((short)2);
		celda.setCellValue("Motivo:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)3);
		celda.setCellValue(motivo);
		//fila = hoja.createRow(5);	
	
		
		fila = hoja.createRow(7);//NUEVA FILA	
			celda = fila.createCell((short)0);
			celda.setCellValue("No. Cuenta");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)1);
			celda.setCellValue("Tipo de Cuenta");
			celda.setCellStyle(estiloNeg8);
	
			celda = fila.createCell((short)2);
			celda.setCellValue("Nombre del Cliente");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)3);
			celda.setCellValue("Sucursal");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Fecha de Reporte");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)5);
			celda.setCellValue("Motivo de Reporte");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)6);
			celda.setCellValue("Canal de Acceso");
			celda.setCellStyle(estiloNeg8);


		
		int i=8,iter=0;
		int tamanioLista = listaLimitesExced!=null?listaLimitesExced.size():0;
		RepCtasLimitesExcedBean limitesExcedBean = null;
		for( iter=0; iter<tamanioLista; iter ++){
		 
			limitesExcedBean = (RepCtasLimitesExcedBean) listaLimitesExced.get(iter);
			fila=hoja.createRow(i);
				celda=fila.createCell((short)0);
				celda.setCellValue(limitesExcedBean.getCuentaAhoID());				
							
				celda=fila.createCell((short)1);
				celda.setCellValue(limitesExcedBean.getDescripcion());		 
	
				celda=fila.createCell((short)2);
				celda.setCellValue(limitesExcedBean.getNombreCompleto());	
			    celda.setCellStyle(estiloDatosCentrado);
			    
			    celda=fila.createCell((short)3);
				celda.setCellValue(limitesExcedBean.getNombreSucurs());	
			    			    
			    celda=fila.createCell((short)4);
				celda.setCellValue(limitesExcedBean.getFecha());	
			    
			    celda=fila.createCell((short)5);
				celda.setCellValue(limitesExcedBean.getMotivo());	
			    celda.setCellStyle(estiloDatosCentrado);
			    
			    celda=fila.createCell((short)6);
				celda.setCellValue(limitesExcedBean.getCanal());	
			
				
			i++;
		}
		 
		i = i+2;
		
		fila=hoja.createRow(i);
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg8);
		
		i = i+1;
		fila=hoja.createRow(i);
			celda=fila.createCell((short)0);
			celda.setCellValue(tamanioLista);		

		for(int celd=0; celd<=18; celd++)
		hoja.autoSizeColumn((short)celd);	
						
		//Crea la cabecera
		response.addHeader("Content-Disposition","inline; filename=ReporteLimiteExcedido.xls");
		response.setContentType("application/vnd.ms-excel");
		
		ServletOutputStream outputStream = response.getOutputStream();
		hoja.getWorkbook().write(outputStream);
		outputStream.flush();
		outputStream.close();
		
		}catch(Exception e){
			e.printStackTrace();
		}		
		
	return  listaLimitesExced;		
	}// reporte Excel
	

	
	public String getNomReporte() {
		return nomReporte;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public RepCtasLimitesExcedServicio getRepCtasLimitesExcedServicio() {
		return repCtasLimitesExcedServicio;
	}

	public void setRepCtasLimitesExcedServicio(
			RepCtasLimitesExcedServicio repCtasLimitesExcedServicio) {
		this.repCtasLimitesExcedServicio = repCtasLimitesExcedServicio;
	}
	
}
