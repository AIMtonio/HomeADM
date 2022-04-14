package cliente.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.servicio.ReporteFinancierosServicio;
import cliente.bean.ReportesFOCOOPBean;
import cliente.servicio.ReportesFOCOOPServicio;

public class ReportesFOCOOPControlador extends SimpleFormController{
	ReportesFOCOOPServicio reportesFOCOOPServicio=null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public ReportesFOCOOPControlador() {
		setCommandClass(ReportesFOCOOPBean.class);
		setCommandName("FOCOOPRep");
	}
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
	
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	
	public ReportesFOCOOPServicio getReportesFOCOOPServicio() {
		return reportesFOCOOPServicio;
	}
	public void setReportesFOCOOPServicio(
			ReportesFOCOOPServicio reportesFOCOOPServicio) {
		this.reportesFOCOOPServicio = reportesFOCOOPServicio;
	}
	
}
