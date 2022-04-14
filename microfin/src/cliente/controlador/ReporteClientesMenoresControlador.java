package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.RepoteClientesMenoresBean;
import cliente.servicio.ReporteClienteMenoresServicio;



public class ReporteClientesMenoresControlador extends SimpleFormController{
	

	ReporteClienteMenoresServicio reporteClienteMenoresServicio = null;
	
	public ReporteClientesMenoresControlador() {
		setCommandClass(RepoteClientesMenoresBean.class);
		setCommandName("repoteClientesMenoresBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
	
		RepoteClientesMenoresBean repoteClientesMenoresBean= (RepoteClientesMenoresBean) command;
		MensajeTransaccionBean mensaje = null;
			
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ReporteClienteMenoresServicio getReporteClienteMenoresServicio() {
		return reporteClienteMenoresServicio;
	}

	public void setReporteClienteMenoresServicio(
			ReporteClienteMenoresServicio reporteClienteMenoresServicio) {
		this.reporteClienteMenoresServicio = reporteClienteMenoresServicio;
	}



}
