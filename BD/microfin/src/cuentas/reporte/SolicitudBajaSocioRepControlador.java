package cuentas.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import cuentas.bean.RepAportaSocioMovBean;
import cuentas.servicio.AportacionSocioServicio;

public class SolicitudBajaSocioRepControlador extends AbstractCommandController{
	
	AportacionSocioServicio aportacionSocioServicio = null;
	String nombreReporte = null;
	String successView = null;	

	public SolicitudBajaSocioRepControlador() {
		setCommandClass(RepAportaSocioMovBean.class);
		setCommandName("RepAportaSocioMovBean");
	}
	
	public static interface Enum_Con_TipRepor {
		  int  ReportePDF= 1;
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		RepAportaSocioMovBean repAportaSocioMov = (RepAportaSocioMovBean) command;

		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):0;
			
			String htmlString= "";
			
		switch(tipoReporte){
			case Enum_Con_TipRepor.ReportePDF:
				ByteArrayOutputStream htmlStringPDF = SolicitudBajaSocioRepPDF(repAportaSocioMov, nombreReporte, response);
				break;
		}
		return null;
	}
	// Reporte de Solicitud de Baja del Socio en PDF
	public ByteArrayOutputStream SolicitudBajaSocioRepPDF(RepAportaSocioMovBean repAportaSocioMov, String nombreReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = aportacionSocioServicio.repSolicitudBajaSocioPDF(repAportaSocioMov, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=SolicitudBajaSocio.pdf");
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
	
	// Getter y Setter
	public AportacionSocioServicio getAportacionSocioServicio() {
		return aportacionSocioServicio;
	}
	public void setAportacionSocioServicio(
			AportacionSocioServicio aportacionSocioServicio) {
		this.aportacionSocioServicio = aportacionSocioServicio;
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
