package riesgos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosEdadMayor55Servicio;

public class CreditosEdadMayor55Controlador extends SimpleFormController{
	CreditosEdadMayor55Servicio creditosEdadMayor55Servicio = null;
	
	public CreditosEdadMayor55Controlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("creditosEdadMayor55");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
				
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosEdadMayor55Servicio getCreditosEdadMayor55Servicio() {
		return creditosEdadMayor55Servicio;
	}
	public void setCreditosEdadMayor55Servicio(
			CreditosEdadMayor55Servicio creditosEdadMayor55Servicio) {
		this.creditosEdadMayor55Servicio = creditosEdadMayor55Servicio;
	}


}
