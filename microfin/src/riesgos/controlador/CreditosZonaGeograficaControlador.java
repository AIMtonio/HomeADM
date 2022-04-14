package riesgos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosZonaGeograficaServicio;

public class CreditosZonaGeograficaControlador extends SimpleFormController{
	CreditosZonaGeograficaServicio creditosZonaGeograficaServicio = null;
	
	public CreditosZonaGeograficaControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("zonaGeografica");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
				
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosZonaGeograficaServicio getCreditosZonaGeograficaServicio() {
		return creditosZonaGeograficaServicio;
	}
	public void setCreditosZonaGeograficaServicio(
			CreditosZonaGeograficaServicio creditosZonaGeograficaServicio) {
		this.creditosZonaGeograficaServicio = creditosZonaGeograficaServicio;
	}
	
}
