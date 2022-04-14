package riesgos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.SumaAhorroInversionServicio;

public class SumaAhorroInversionControlador extends SimpleFormController {
	SumaAhorroInversionServicio sumaAhorroInversionServicio = null;
	
	public SumaAhorroInversionControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("sumaAhorroInversion");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
				
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	/* ****************** GETTER Y SETTERS *************************** */
	public SumaAhorroInversionServicio getSumaAhorroInversionServicio() {
		return sumaAhorroInversionServicio;
	}

	public void setSumaAhorroInversionServicio(
			SumaAhorroInversionServicio sumaAhorroInversionServicio) {
		this.sumaAhorroInversionServicio = sumaAhorroInversionServicio;
	}

}
