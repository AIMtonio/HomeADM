package riesgos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosMayor100Servicio;

public class CreditosMayor100Controlador extends SimpleFormController{
	CreditosMayor100Servicio creditosMayor100Servicio = null;
	
	public CreditosMayor100Controlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("pagosMayor100");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
				
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosMayor100Servicio getCreditosMayor100Servicio() {
		return creditosMayor100Servicio;
	}
	public void setCreditosMayor100Servicio(
			CreditosMayor100Servicio creditosMayor100Servicio) {
		this.creditosMayor100Servicio = creditosMayor100Servicio;
	}
	
}
