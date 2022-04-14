package riesgos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosClasificacionServicio;

public class CreditosClasificacionControlador extends SimpleFormController{
	CreditosClasificacionServicio creditosClasificacionServicio = null;
	
	public CreditosClasificacionControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("creditosClasificacion");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
				
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosClasificacionServicio getCreditosClasificacionServicio() {
		return creditosClasificacionServicio;
	}
	public void setCreditosClasificacionServicio(
			CreditosClasificacionServicio creditosClasificacionServicio) {
		this.creditosClasificacionServicio = creditosClasificacionServicio;
	}
	
}
