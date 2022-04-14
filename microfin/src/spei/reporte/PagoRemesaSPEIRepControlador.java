package spei.reporte;


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

import cliente.bean.ClienteExMenorBean;
	import spei.bean.RepPagoRemesaSPEIBean;
import spei.servicio.RepPagoRemesaSPEIServicio;


	   
	public class PagoRemesaSPEIRepControlador  extends AbstractCommandController{
					
		RepPagoRemesaSPEIServicio repPagoRemesaSPEIServicio = null;
		ParametrosAuditoriaBean parametrosAuditoriaBean = null;
		String nombreReporte= null;
		String successView = null;
		protected final Logger loggerSAFI = Logger.getLogger("SAFI");
		
		public static interface Enum_Con_TipRepor {
			  int  reportePDFResumen = 1;	
			  int  reportePDFDetalle = 2;	
			}
		
		
		public PagoRemesaSPEIRepControlador() {
			setCommandClass(RepPagoRemesaSPEIBean.class);
			setCommandName("repPagoRemesaSPEIBean");
		}

		
		protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors)throws Exception {
			
			RepPagoRemesaSPEIBean repPagoRemesaSPEIBean = (RepPagoRemesaSPEIBean) command;

		int tipoReporte =(request.getParameter("tipoReporte")!=null)? Integer.parseInt(request.getParameter("tipoReporte")): 0;

		switch(tipoReporte){	
			case Enum_Con_TipRepor.reportePDFResumen:
				ByteArrayOutputStream htmlStringPDF = reportePDFresum(repPagoRemesaSPEIBean, nombreReporte, response);
			break;
			
			case Enum_Con_TipRepor.reportePDFDetalle:
				ByteArrayOutputStream htmlStringPDF1 = reportePDFdetall(repPagoRemesaSPEIBean, nombreReporte, response);
			break;
	
		}	
			return null;	
		}

		
		/* Reporte PDF resumen */
		public ByteArrayOutputStream reportePDFresum(RepPagoRemesaSPEIBean repPagoRemesaSPEIBean, String nomReporte, HttpServletResponse response){
			ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = repPagoRemesaSPEIServicio.reportePagoRemesas(repPagoRemesaSPEIBean, nomReporte);
				response.addHeader("Content-Disposition","inline; filename=ReporteResumenPagoRemesasSPEI.pdf");
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
		
		
		/* Reporte PDF detallado*/
		public ByteArrayOutputStream reportePDFdetall(RepPagoRemesaSPEIBean repPagoRemesaSPEIBean, String nomReporte, HttpServletResponse response){
			ByteArrayOutputStream htmlStringPDF1 = null;
			try {
				htmlStringPDF1 = repPagoRemesaSPEIServicio.reportePagoRemesas(repPagoRemesaSPEIBean, nomReporte);
				response.addHeader("Content-Disposition","inline; filename=ReporteDetalladoPagoRemesasSPEI.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlStringPDF1.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
				

			} catch (Exception e) {
				e.printStackTrace();
			}
		return htmlStringPDF1;
		}// reporte PDF
		


		public String getSuccessView() {
			return successView;
		}
		
		public void setSuccessView(String successView) {
			this.successView = successView;
		}


		public RepPagoRemesaSPEIServicio getRepPagoRemesaSPEIServicio() {
			return repPagoRemesaSPEIServicio;
		}


		public void setRepPagoRemesaSPEIServicio(
				RepPagoRemesaSPEIServicio repPagoRemesaSPEIServicio) {
			this.repPagoRemesaSPEIServicio = repPagoRemesaSPEIServicio;
		}


		public String getNombreReporte() {
			return nombreReporte;
		}


		public void setNombreReporte(String nombreReporte) {
			this.nombreReporte = nombreReporte;
		}


		public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
			return parametrosAuditoriaBean;
		}


		public void setParametrosAuditoriaBean(
				ParametrosAuditoriaBean parametrosAuditoriaBean) {
			this.parametrosAuditoriaBean = parametrosAuditoriaBean;
		}
		

	}
