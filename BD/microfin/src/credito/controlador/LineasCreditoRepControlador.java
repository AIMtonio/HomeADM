package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.LineasCreditoBean;
import credito.servicio.LineasCreditoServicio;

public class LineasCreditoRepControlador  extends SimpleFormController {

	LineasCreditoServicio lineasCreditoServicio = null;

	public LineasCreditoRepControlador(){
		setCommandClass(LineasCreditoBean.class);
		setCommandName("lineasCredito");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
	
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	//Getter y Setter
	public LineasCreditoServicio getLineasCreditoServicio() {
		return lineasCreditoServicio;
	}

	public void setLineasCreditoServicio(LineasCreditoServicio lineasCreditoServicio) {
		this.lineasCreditoServicio = lineasCreditoServicio;
	}

} 
