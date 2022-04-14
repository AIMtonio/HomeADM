package riesgos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.SumaTiposAhorroServicio;

public class SumasTiposAhorroControlador extends SimpleFormController{
	SumaTiposAhorroServicio sumaTiposAhorroServicio = null;
	
	public SumasTiposAhorroControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("sumaTiposAhorro");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
				
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	/* ****************** GETTER Y SETTERS *************************** */
	public SumaTiposAhorroServicio getSumaTiposAhorroServicio() {
		return sumaTiposAhorroServicio;
	}
	public void setSumaTiposAhorroServicio(
			SumaTiposAhorroServicio sumaTiposAhorroServicio) {
		this.sumaTiposAhorroServicio = sumaTiposAhorroServicio;
	}

}
