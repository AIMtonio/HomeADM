package riesgos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.PasivoCortoPlazoServicio;

public class PasivoCortoPlazoControlador extends SimpleFormController{
	PasivoCortoPlazoServicio pasivoCortoPlazoServicio = null;
	
	public PasivoCortoPlazoControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("pasivoCortoPlazo");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
				
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	/* ****************** GETTER Y SETTERS *************************** */
	public PasivoCortoPlazoServicio getPasivoCortoPlazoServicio() {
		return pasivoCortoPlazoServicio;
	}

	public void setPasivoCortoPlazoServicio(
			PasivoCortoPlazoServicio pasivoCortoPlazoServicio) {
		this.pasivoCortoPlazoServicio = pasivoCortoPlazoServicio;
	}

}
