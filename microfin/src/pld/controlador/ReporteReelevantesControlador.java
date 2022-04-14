package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.ReporteReelevantesBean;
import pld.servicio.ReporteReelevantesServicio;

public class ReporteReelevantesControlador extends SimpleFormController{
	

	private ReporteReelevantesServicio reporteReelevantesServicio;
	
	public ReporteReelevantesControlador() {
		setCommandClass(ReporteReelevantesBean.class);
		setCommandName("reporteReelevantes");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		reporteReelevantesServicio.getReporteReelevantesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ReporteReelevantesBean reporteReelevantes = (ReporteReelevantesBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = reporteReelevantesServicio.grabaTransaccion(tipoTransaccion, reporteReelevantes);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public ReporteReelevantesServicio getReporteReelevantesServicio() {
		return reporteReelevantesServicio;
	}
	public void setReporteReelevantesServicio(
			ReporteReelevantesServicio reporteReelevantesServicio) {
		this.reporteReelevantesServicio = reporteReelevantesServicio;
	}	
	
}
