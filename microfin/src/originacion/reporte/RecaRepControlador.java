
package originacion.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.SolicitudCreditoBean;
import originacion.servicio.SolicitudCreditoServicio;

public class RecaRepControlador extends AbstractCommandController{
	SolicitudCreditoServicio solicitudCreditoServicio = null;
	String nombreReporte = null;
	String successView = null;	
	
	public RecaRepControlador(){
		setCommandClass(SolicitudCreditoBean.class);
		setCommandName("solicitudCreditoBean");
	}

	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {	
			SolicitudCreditoBean solicitudCreditoBean =(SolicitudCreditoBean) command;
		// TODO Auto-generated method stub
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
				
				String htmlString= "";
				
				switch(tipoReporte){
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = repSolicitudCreditoPDF(solicitudCreditoBean, nombreReporte,response);
				break;
		
	}
				return null;
}
	private ByteArrayOutputStream repSolicitudCreditoPDF( SolicitudCreditoBean solicitudCreditoBean, String nombreReporte,
			HttpServletResponse response) {
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = solicitudCreditoServicio.reporteRecaPDF(solicitudCreditoBean, nombreReporte);
			response.addHeader("Content-Disposition","inline; filename=SolicitudDeCredito.pdf");
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
	
	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	public SolicitudCreditoServicio getSolicitudCreditoServicio() {
		return solicitudCreditoServicio;
	}
	public void setSolicitudCreditoServicio(
			SolicitudCreditoServicio solicitudCreditoServicio) {
		this.solicitudCreditoServicio = solicitudCreditoServicio;
	}
}

