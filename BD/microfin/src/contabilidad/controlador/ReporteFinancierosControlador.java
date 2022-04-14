package contabilidad.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.ReporteFinancierosBean;
import contabilidad.servicio.ReporteFinancierosServicio;


public class ReporteFinancierosControlador extends SimpleFormController{
	

	ReporteFinancierosServicio reporteFinancierosServicio = null;
	
	public ReporteFinancierosControlador() {
		setCommandClass(ReporteFinancierosBean.class);
		setCommandName("reporteFinancierosBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
	
		ReporteFinancierosBean reporteFinancierosBean= (ReporteFinancierosBean) command;
		MensajeTransaccionBean mensaje = null;
			
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ReporteFinancierosServicio getReporteFinancierosServicio() {
		return reporteFinancierosServicio;
	}

	public void setReporteFinancierosServicio(
			ReporteFinancierosServicio reporteFinancierosServicio) {
		this.reporteFinancierosServicio = reporteFinancierosServicio;
	}

}
