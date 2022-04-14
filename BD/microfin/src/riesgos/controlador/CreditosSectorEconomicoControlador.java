package riesgos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosSectorEconomicoServicio;

public class CreditosSectorEconomicoControlador extends SimpleFormController{
	CreditosSectorEconomicoServicio creditosSectorEconomicoServicio = null;
	
	public CreditosSectorEconomicoControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("creditosSectorEconomico");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
				
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosSectorEconomicoServicio getCreditosSectorEconomicoServicio() {
		return creditosSectorEconomicoServicio;
	}
	public void setCreditosSectorEconomicoServicio(
			CreditosSectorEconomicoServicio creditosSectorEconomicoServicio) {
		this.creditosSectorEconomicoServicio = creditosSectorEconomicoServicio;
	}
}
