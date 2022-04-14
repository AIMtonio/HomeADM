package credito.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.LineasCreditoBean;
import credito.servicio.LineasCreditoServicio;

public class LineasCreditoReporteControlador extends AbstractCommandController{
	
	public static interface Enum_Con_TipRepor {
		  int  ReportePDF= 1;
	}
	
	LineasCreditoServicio lineasCreditoServicio = null;
	String nomReporte = null;
	String successView = null;

	public LineasCreditoReporteControlador() {
		setCommandClass(LineasCreditoBean.class);
		setCommandName("lineasCredito");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		LineasCreditoBean lineasCreditoBean = (LineasCreditoBean) command;
		// TODO Auto-generated method stub
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):0;
			
			lineasCreditoServicio.getLineasCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

			String htmlString= "";
			
			switch(tipoReporte){
				case Enum_Con_TipRepor.ReportePDF:
					ByteArrayOutputStream htmlStringPDF = repLineasCreditoPDF(lineasCreditoBean, nomReporte, response);
				break;
			}
			return null;
		}
		
	// Reporte Lineas de Creditos en PDF
	private ByteArrayOutputStream repLineasCreditoPDF(LineasCreditoBean lineasCreditoBean, String nomReporte,
			HttpServletResponse response) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = lineasCreditoServicio.creaRepLineasCreditoPDF(lineasCreditoBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=LineasCredito.pdf");
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

	public LineasCreditoServicio getLineasCreditoServicio() {
		return lineasCreditoServicio;
	}

	public void setLineasCreditoServicio(LineasCreditoServicio lineasCreditoServicio) {
		this.lineasCreditoServicio = lineasCreditoServicio;
	}

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
}
	
	