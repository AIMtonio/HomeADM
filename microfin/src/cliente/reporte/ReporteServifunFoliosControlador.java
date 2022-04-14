package cliente.reporte;

import general.bean.ParametrosAuditoriaBean;

import java.io.ByteArrayOutputStream;
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

import cliente.bean.ServifunFoliosRepBean;
import cliente.servicio.ServiFunFoliosServicio;

public class ReporteServifunFoliosControlador extends AbstractCommandController{
	
	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	ServiFunFoliosServicio serviFunFoliosServicio = null;
	
	String nomReporte= null;
	String successView = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
		  int  ReporExcel= 2 ;
	}
	public ReporteServifunFoliosControlador () {
		
		setCommandClass(ServifunFoliosRepBean.class);
		setCommandName("serviFunFoliosBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
								HttpServletResponse response,
								Object command,
								BindException errors)throws Exception {
		
		ServifunFoliosRepBean servifunFoliosRep = (ServifunFoliosRepBean) command;

			int tipoReporte =(request.getParameter("tipoReporte")!=null)?
							Integer.parseInt(request.getParameter("tipoReporte")):
							0;
			int tipoLista =(request.getParameter("tipoLista")!=null)?
							Integer.parseInt(request.getParameter("tipoLista")):
							0;
		
			String htmlString= "";
			loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Entra en controlador: "+ tipoReporte);
		switch(tipoReporte){			
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = servifunFolioPDF(servifunFoliosRep, nomReporte, response);
			break;
				
			case Enum_Con_TipRepor.ReporExcel:		
				 List listaReportes = listaReporteServifunExcel(tipoLista,servifunFoliosRep,response);
			break;
		}
		return null;
			
	}
	
	// Reporte de vencimientos en pdf
	public ByteArrayOutputStream servifunFolioPDF(ServifunFoliosRepBean servifunFoliosRepBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = serviFunFoliosServicio.creaReporteServifunFoliosPDF(servifunFoliosRepBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteServifun.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return htmlStringPDF;
	}

	// Reporte de saldos capital de credito en excel
	public List  listaReporteServifunExcel(int tipoLista,ServifunFoliosRepBean servifunFoliosRepBean,  HttpServletResponse response){
		List listaServifun=null;
		listaServifun = serviFunFoliosServicio.listaReporteSevifunExcel(tipoLista,servifunFoliosRepBean); 	
	 
		int regExport = 0;
	
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
		
		// Creacion de hoja					
		HSSFSheet hoja = libro.createSheet("Reporte SERVIFUN");
		HSSFRow fila= hoja.createRow(0);
		
		// inicio usuario,fecha y hora
		HSSFCell celdaUsu=fila.createCell((short)1);
		
		celdaUsu = fila.createCell((short)9);
		celdaUsu.setCellValue("Usuario:");
		celdaUsu.setCellStyle(estiloNeg8);	
		celdaUsu = fila.createCell((short)10);
		celdaUsu.setCellValue((!servifunFoliosRepBean.getClaveUsuario().isEmpty())?servifunFoliosRepBean.getClaveUsuario(): "TODOS");
		
		String horaVar="";
		String fechaVar=servifunFoliosRepBean.getFechaEmision();

		
		int itera=0;
		ServifunFoliosRepBean servifunHora = null;
		if(!listaServifun.isEmpty()){
			for( itera=0; itera<1; itera ++){
				servifunHora = (ServifunFoliosRepBean) listaServifun.get(itera);
				horaVar= servifunHora.getHoraEmision();				
			}
		}
		fila = hoja.createRow(1);
		HSSFCell celdaFec=fila.createCell((short)1);
		celdaFec.setCellStyle(estiloNeg10);
		celdaFec.setCellValue(servifunFoliosRepBean.getNombreInstitucion());
				
		celdaFec = fila.createCell((short)9);
		celdaFec.setCellValue("Fecha:");
		celdaFec.setCellStyle(estiloNeg8);	
		celdaFec = fila.createCell((short)10);
		celdaFec.setCellValue(fechaVar);
		 
		
		fila = hoja.createRow(2);
		HSSFCell celdaHora=fila.createCell((short)1);
		celdaHora = fila.createCell((short)9);
		celdaHora.setCellValue("Hora:");
		celdaHora.setCellStyle(estiloNeg8);	
		celdaHora = fila.createCell((short)10);
		celdaHora.setCellValue(horaVar);
		
		// Titulo del Reporte	
		HSSFCell celda=fila.createCell((short)1);
		celda.setCellStyle(estiloNeg10);
		celda.setCellValue("REPORTE DE SERVICIOS FUNERARIOS (SERVIFUN) DEL "+servifunFoliosRepBean.getFechaInicio()+" AL "+servifunFoliosRepBean.getFechaFin());
	
	   hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
	            2, //primera fila (0-based)
	            2, //ultima fila  (0-based)
	            1, //primer celda (0-based)
	            7  //ultima celda   (0-based)
	    ));
	    
		
		// Creacion de fila
		fila = hoja.createRow(3); // Fila vacia
		fila = hoja.createRow(4);// Campos
								

		celda = fila.createCell((short)1);
		celda.setCellValue("Socio");
		celda.setCellStyle(estiloNeg8);

		
		celda = fila.createCell((short)2);
		celda.setCellValue("Nombre del Socio");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)3);
		celda.setCellValue("Folio de Registro");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)4);
		celda.setCellValue("Estatus Folio");
		celda.setCellStyle(estiloNeg8);
	

		celda = fila.createCell((short)5);
		celda.setCellValue("Fecha Registro");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)6);
		celda.setCellValue("Fecha Autoriza");
		celda.setCellStyle(estiloNeg8);
						
		celda = fila.createCell((short)7);
		celda.setCellValue("Difunto");
		celda.setCellStyle(estiloNeg8);	
		
		celda = fila.createCell((short)8);
		celda.setCellValue("Nombre Difunto");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)9);
		celda.setCellValue("Acta Defunción");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)10);
		celda.setCellValue("Fecha Defunción");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)11);
		celda.setCellValue("Monto");
		celda.setCellStyle(estiloNeg8);
		
		celda = fila.createCell((short)12);
		celda.setCellValue("Fecha Pago");
		celda.setCellStyle(estiloNeg8);
/*		
	    hoja.addMergedRegion(new CellRangeAddress(
	    		 4, 4, 11, 13  
	    ));
	   
	    hoja.addMergedRegion(new CellRangeAddress(
	    		 4, 4, 14, 15 
	    ));	
*/
		// Recorremos la lista para la parte de los datos 	
		int i=6,iter=0;
		int tamanioLista = listaServifun.size();
		ServifunFoliosRepBean servifun = null;
		for( iter=0; iter<tamanioLista; iter ++){
		 
			servifun = (ServifunFoliosRepBean) listaServifun.get(iter);
			fila=hoja.createRow(i);

			celda=fila.createCell((short)1);
			celda.setCellValue(servifun.getClienteID());
			
			celda=fila.createCell((short)2);
			celda.setCellValue(servifun.getNombreCompleto());
			
			celda=fila.createCell((short)3); 
			celda.setCellValue(servifun.getServiFunFolioID());
			
			celda=fila.createCell((short)4);
			celda.setCellValue(servifun.getDesEstatus()); 
			
			celda=fila.createCell((short)5);
			celda.setCellValue(servifun.getFechaRegistro());
			celda.setCellStyle(estiloDatosCentrado);
			
			celda=fila.createCell((short)6);
			celda.setCellValue(servifun.getFechaAutoriza());
			celda.setCellStyle(estiloDatosCentrado);
			
			celda=fila.createCell((short)7);
			celda.setCellValue(servifun.getDesTipServicio());
			
			celda=fila.createCell((short)8);
			celda.setCellValue(servifun.getDifunNombreComp());
			
			celda=fila.createCell((short)9);
			celda.setCellValue(servifun.getNoCertificadoDefun());
			
			celda=fila.createCell((short)10);
			celda.setCellValue(servifun.getFechaCertifDefun());
			celda.setCellStyle(estiloDatosCentrado);
			
			celda=fila.createCell((short)11);
			celda.setCellValue(Double.parseDouble(servifun.getMontoApoyo()));
			celda.setCellStyle(estiloFormatoDecimal);
			
			celda=fila.createCell((short)12);
			celda.setCellValue(servifun.getFechaEntrega());
			celda.setCellStyle(estiloDatosCentrado);
			
			i++;
		}
		 
		i = i+2;
		fila=hoja.createRow(i); // Fila Registros Exportados
		celda = fila.createCell((short)0);
		celda.setCellValue("Registros Exportados");
		celda.setCellStyle(estiloNeg8);
		
		i = i+1;
		fila=hoja.createRow(i); // Fila Total de Registros Exportados
		celda=fila.createCell((short)0);
		celda.setCellValue(tamanioLista);
		

		for(int celd=0; celd<=15; celd++)
		hoja.autoSizeColumn((short)celd);
							
		//Creo la cabecera
		response.addHeader("Content-Disposition","inline; filename=RepServifunFolios.xls");
		response.setContentType("application/vnd.ms-excel");
		
		ServletOutputStream outputStream = response.getOutputStream();
		hoja.getWorkbook().write(outputStream);
		outputStream.flush();
		outputStream.close();
		
		loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Termina Reporte");
		}catch(Exception e){
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte: " + e.getMessage());
			e.printStackTrace();
		}//Fin del catch
	//} 				
	return  listaServifun;
	
	
	}
	
	
	

	public String getNomReporte() {
		return nomReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public ServiFunFoliosServicio getServiFunFoliosServicio() {
		return serviFunFoliosServicio;
	}

	public Logger getLoggerSAFI() {
		return loggerSAFI;
	}

	public void setServiFunFoliosServicio(
			ServiFunFoliosServicio serviFunFoliosServicio) {
		this.serviFunFoliosServicio = serviFunFoliosServicio;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
		
	
}
