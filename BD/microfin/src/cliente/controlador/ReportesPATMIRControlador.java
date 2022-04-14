package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClienteBean;
import cliente.bean.ReportesPATMIRBean;
import cliente.servicio.ReportesPATMIRServicio;

public class ReportesPATMIRControlador extends SimpleFormController{
	ReportesPATMIRServicio reportesPATMIRServicio=null;
				
	public ReportesPATMIRControlador() {
		setCommandClass(ReportesPATMIRBean.class);
		setCommandName("PATMIRRep");
	}
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	
	public ReportesPATMIRServicio getReportesPATMIRServicio() {
		return reportesPATMIRServicio;
	}

	public void setReportesPATMIRServicio(
			ReportesPATMIRServicio reportesPATMIRServicio) {
		this.reportesPATMIRServicio = reportesPATMIRServicio;
	}

}
