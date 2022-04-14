package contabilidad.reporte;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.ReporteAnexoYFapBean;
import contabilidad.servicio.ReporteAnexoYFapServicio;


public class ReporteAnexoYFapReporteControlador extends AbstractCommandController{

	ReporteAnexoYFapServicio reporteAnexoYFapServicio = null;
	String successView = null;
	
	public ReporteAnexoYFapReporteControlador () {
		setCommandClass(ReporteAnexoYFapBean.class);
		setCommandName("reporteAnexoYFapBean");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors)throws Exception {
		try {
			MensajeTransaccionBean mensaje = null;
			ReporteAnexoYFapBean reporteAnexoYFapBean = (ReporteAnexoYFapBean) command;

			int tipoReporte = (request.getParameter("tipoReporte") != null)
					? Integer.parseInt(request.getParameter("tipoReporte"))
					: 0;
					
			int tipoEntidad = (request.getParameter("tipoEntidad") != null)
					? Integer.parseInt(request.getParameter("tipoEntidad"))
					: 0;
					
					reporteAnexoYFapServicio.listaReporteAnexoYFap(tipoReporte,tipoEntidad, reporteAnexoYFapBean, response);
	
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	public ReporteAnexoYFapServicio getReporteAnexoYFapServicio() {
		return reporteAnexoYFapServicio;
	}

	public void setReporteAnexoYFapServicio(
			ReporteAnexoYFapServicio reporteAnexoYFapServicio) {
		this.reporteAnexoYFapServicio = reporteAnexoYFapServicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

}
