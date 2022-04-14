package riesgos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosMenor100Servicio;

public class CreditosMenor100Controlador extends SimpleFormController{
	CreditosMenor100Servicio creditosMenor100Servicio = null;
	
	public CreditosMenor100Controlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("pagosMenor100");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
				
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosMenor100Servicio getCreditosMenor100Servicio() {
		return creditosMenor100Servicio;
	}
	public void setCreditosMenor100Servicio(
			CreditosMenor100Servicio creditosMenor100Servicio) {
		this.creditosMenor100Servicio = creditosMenor100Servicio;
	}
	
}
