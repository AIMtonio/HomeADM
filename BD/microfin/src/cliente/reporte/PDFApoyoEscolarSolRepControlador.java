
package cliente.reporte;

import herramientas.Utileria;

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

import cliente.bean.ReporteApoyoEscolarSolBean;
import cliente.servicio.ApoyoEscolarSolServicio;


   
public class PDFApoyoEscolarSolRepControlador  extends AbstractCommandController{

	ApoyoEscolarSolServicio apoyoEscolarSolServicio = null;
	String nomReporte= null;
	String successView = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public static interface Enum_Con_TipRepor {
		  int  reportePDF  = 1 ;
		  int reporteExcel= 2;
		
		}
	
	
	public PDFApoyoEscolarSolRepControlador () {
		setCommandClass(ReporteApoyoEscolarSolBean.class);
		setCommandName("reporteApoyoEscolarSolBean");
	}

	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		ReporteApoyoEscolarSolBean solicitudAEBean = (ReporteApoyoEscolarSolBean) command;

	int tipoReporte =(request.getParameter("tipoReporte")!=null)? Integer.parseInt(request.getParameter("tipoReporte")): 0;
	int tipoLista =(request.getParameter("tipoLista")!=null)? Integer.parseInt(request.getParameter("tipoLista")): 0;
	
	
	switch(tipoReporte){	
		case Enum_Con_TipRepor.reportePDF:
			ByteArrayOutputStream htmlStringPDF = apoyoEscolarRepPDF(tipoReporte,solicitudAEBean, nomReporte, response);
		break;
			
		case Enum_Con_TipRepor.reporteExcel:		
			 List listaReportes = apoyoEscolarRepExcel(tipoLista,solicitudAEBean,response);
		break;
	}	
				
		return null;	
	}

		
	/* Reporte de apoyo escolar en PDF */
	public ByteArrayOutputStream apoyoEscolarRepPDF(int tipoReporte,ReporteApoyoEscolarSolBean reporteApoyoEscolarSolBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = apoyoEscolarSolServicio.reporteApoyoEscolar(tipoReporte,reporteApoyoEscolarSolBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteApoyoEscolar.pdf");
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
	
	
	
	/* Reporte de apoyo escolar en Excel */
	public List  apoyoEscolarRepExcel(int tipoLista,ReporteApoyoEscolarSolBean solicitudAEBean,  HttpServletResponse response){
	List listaSolicitudesAE=null;
	listaSolicitudesAE = apoyoEscolarSolServicio.listaReporte(tipoLista,solicitudAEBean,response); 
	
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
		HSSFSheet hoja = libro.createSheet("Reporte Apoyo Escolar");
		
		HSSFRow fila= hoja.createRow(0);			
		HSSFCell nombInstitucion=fila.createCell((short)3);
		nombInstitucion.setCellStyle(estiloNeg10);
		nombInstitucion.setCellValue(solicitudAEBean.getNombreInstitucion());
		nombInstitucion.setCellStyle(estiloDatosCentrado);
		nombInstitucion.setCellStyle(estiloNeg8);	
		
		hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
	            0, //primera fila (0-based)
	            0, //ultima fila  (0-based)
	            3, //primer celda (0-based)
	            6  //ultima celda   (0-based)
	    ));
							
		
		fila = hoja.createRow(1);		
		HSSFCell celda=fila.createCell((short)3);
		celda.setCellStyle(estiloNeg10);
		celda.setCellValue("REPORTE APOYO ESCOLAR DEL "+solicitudAEBean.getFechaInicio()+" AL "+solicitudAEBean.getFechaFin());
		celda.setCellStyle(estiloDatosCentrado);
		celda.setCellStyle(estiloNeg8);	
		
		hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
	            1, //primera fila (0-based)
	            1, //ultima fila  (0-based)
	            3, //primer celda (0-based)
	            6  //ultima celda   (0-based)
	    ));
						
		fila = hoja.createRow(2);
		HSSFCell celdaFec=fila.createCell((short)1);
		celda = fila.createCell((short)10);
		celda.setCellValue("Usuario:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)11);
		celda.setCellValue(solicitudAEBean.getNombreUsuario());
		

		fila = hoja.createRow(3);
		celda = fila.createCell((short)10);
		celda.setCellValue("Fecha:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)11);
		celda.setCellValue(solicitudAEBean.getFechaSistema());
		
		String estado="";
		if(solicitudAEBean.getEstatus().equals("X"))
			estado="RECHAZADO";
		else if(solicitudAEBean.getEstatus().equals("R"))
			estado="REGISTRADO";
		else if(solicitudAEBean.getEstatus().equals("A"))
			estado="AUTORIZADO";
		else if(solicitudAEBean.getEstatus().equals("P"))
			estado="PAGADO";

		celda = fila.createCell((short)0);
		celda.setCellValue("Estatus Solicitud:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)1);
		celda.setCellValue((!solicitudAEBean.getEstatus().equals(""))? estado :"TODOS");
		
		celda = fila.createCell((short)4);
		celda.setCellValue("Sucursal Solicitud:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)5);
		celda.setCellValue((!solicitudAEBean.getSucursalRegistroID().equals("0")? solicitudAEBean.getNombreSucurs():"TODAS"));
				 		
		fila = hoja.createRow(4);	
		String horaVar="";
		
		int itera=0;
		ReporteApoyoEscolarSolBean bean = null;
		if(!listaSolicitudesAE.isEmpty()){
			for( itera=0; itera<1; itera ++){
				bean = (ReporteApoyoEscolarSolBean) listaSolicitudesAE.get(itera);
				horaVar= bean.getHoraEmision();				
			}
		}		
		
			HSSFCell celdaHora=fila.createCell((short)1);
			celdaHora = fila.createCell((short)10);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell((short)11);
			celdaHora.setCellValue(horaVar);
		
		fila = hoja.createRow(6);//NUEVA FILA	
			celda = fila.createCell((short)0);
			celda.setCellValue("Sucursal");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)1);
			celda.setCellValue("Cliente/Socio");
			celda.setCellStyle(estiloNeg8);
	
			celda = fila.createCell((short)2);
			celda.setCellValue("Solicitud");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)3);
			celda.setCellValue("Fecha");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Grado Escolar");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)5);
			celda.setCellValue("No. Grado");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)6);
			celda.setCellValue("Ciclo Escolar");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)7);
			celda.setCellValue("Promedio");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)8);
			celda.setCellValue("Edad");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)9);
			celda.setCellValue("Monto");
			celda.setCellStyle(estiloNeg8);	
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Estatus");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)11);
			celda.setCellValue("Usuario Registra");
			celda.setCellStyle(estiloNeg8);	
		
		
		int i=7,iter=0;
		int tamanioLista = listaSolicitudesAE.size();
		ReporteApoyoEscolarSolBean solicitudAE = null;
		for( iter=0; iter<tamanioLista; iter ++){
		 
			solicitudAE = (ReporteApoyoEscolarSolBean) listaSolicitudesAE.get(iter);
			fila=hoja.createRow(i);
				celda=fila.createCell((short)0);
				celda.setCellValue(solicitudAE.getSucursalRegistroID() + " - " + solicitudAE.getNombreSucurs());				
							
				celda=fila.createCell((short)1);
				celda.setCellValue(solicitudAE.getClienteID() + " - " + solicitudAE.getNombreCompleto());		 
	
				celda=fila.createCell((short)2);
				celda.setCellValue(solicitudAE.getApoyoEscSolID());	
			    celda.setCellStyle(estiloDatosCentrado);
			    
			    celda=fila.createCell((short)3);
				celda.setCellValue(solicitudAE.getFechaRegistro());	
			    			    
			    celda=fila.createCell((short)4);
				celda.setCellValue(solicitudAE.getNivelEscolar());	
			    
			    celda=fila.createCell((short)5);
				celda.setCellValue(solicitudAE.getGradoEscolar());	
			    celda.setCellStyle(estiloDatosCentrado);
			    
			    celda=fila.createCell((short)6);
				celda.setCellValue(solicitudAE.getCicloEscolar());	
			    
			    celda=fila.createCell((short)7);
				celda.setCellValue(Utileria.convierteDoble(solicitudAE.getPromedioEscolar()));
			    
			    celda=fila.createCell((short)8);
				celda.setCellValue(solicitudAE.getEdadCliente());	
			    celda.setCellStyle(estiloDatosCentrado);
			    
			    celda=fila.createCell((short)9);
				celda.setCellValue(Utileria.convierteDoble(solicitudAE.getMonto()));	
			    celda.setCellStyle(estiloFormatoDecimal);
			    
			    celda=fila.createCell((short)10);
				celda.setCellValue(solicitudAE.getEstatusDes());	
			    
			    celda=fila.createCell((short)11);
				celda.setCellValue(solicitudAE.getUsuarioRegistra());
				
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
		response.addHeader("Content-Disposition","inline; filename=ReporteApoyoEscolar.xls");
		response.setContentType("application/vnd.ms-excel");
		
		ServletOutputStream outputStream = response.getOutputStream();
		hoja.getWorkbook().write(outputStream);
		outputStream.flush();
		outputStream.close();
		
		}catch(Exception e){
			e.printStackTrace();
		}		
		
	return  listaSolicitudesAE;		
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

	public ApoyoEscolarSolServicio getApoyoEscolarSolServicio() {
		return apoyoEscolarSolServicio;
	}

	public void setApoyoEscolarSolServicio(
			ApoyoEscolarSolServicio apoyoEscolarSolServicio) {
		this.apoyoEscolarSolServicio = apoyoEscolarSolServicio;
	}
	
}