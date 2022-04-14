package tarjetas.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tarjetas.bean.TarDebAclaraBean;
import tarjetas.reporte.ReporteTarDebAclaraControlador.Enum_Con_TipRepor;
import tarjetas.servicio.TarDebAclaraServicio;

public class ReportePDFResolucionAclaracionControlador extends AbstractCommandController{
	TarDebAclaraServicio  aclaracionServicio= null;
	String nomReporte= null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReportePDF = 1;

		}
	public ReportePDFResolucionAclaracionControlador () {
		setCommandClass(TarDebAclaraBean.class);
		setCommandName("tarDebAclaraBean");
	}
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		TarDebAclaraBean tarDebAclaraBean = (TarDebAclaraBean) command;

	int tipoReporte =(request.getParameter("tipoReporte")!=null)?
			Integer.parseInt(request.getParameter("tipoReporte")):
		0;
	String htmlString= "";
			
		switch(tipoReporte){
			
			case Enum_Con_TipRepor.ReportePDF:
				ByteArrayOutputStream htmlStringPDF = ResolucionAclaracionRepPDF(tarDebAclaraBean, nomReporte, response);
			break;
	
		}
			return null;
		}
		// Reporte de Solicitud de Aclaracion
		public ByteArrayOutputStream ResolucionAclaracionRepPDF(TarDebAclaraBean tarDebAclaraBean, String nomReporte, HttpServletResponse response){
			ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = aclaracionServicio.creaReporteResolucionAclaracionPDF(tarDebAclaraBean, nomReporte);
				response.addHeader("Content-Disposition","inline; filename=ReporteResolucionAclaracion.pdf");
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
		public TarDebAclaraServicio getAclaracionServicio() {
			return aclaracionServicio;
		}
		public void setAclaracionServicio(TarDebAclaraServicio aclaracionServicio) {
			this.aclaracionServicio = aclaracionServicio;
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
