
package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.RepRiesgoComunBean;
import originacion.servicio.RepRiesgoComunServicio;


public class RepRiesgoComunControlador extends SimpleFormController{
	
	RepRiesgoComunServicio repRiesgoComunServicio = null;
	
	public RepRiesgoComunControlador() {
		setCommandClass(RepRiesgoComunBean.class);
		setCommandName("repRiesgoComunBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
	
		RepRiesgoComunBean repRiesgoComunBean = (RepRiesgoComunBean) command;
		MensajeTransaccionBean mensaje = null;
											
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public RepRiesgoComunServicio getRepRiesgoComunServicio() {
		return repRiesgoComunServicio;
	}

	public void setRepRiesgoComunServicio(
			RepRiesgoComunServicio repRiesgoComunServicio) {
		this.repRiesgoComunServicio = repRiesgoComunServicio;
	}


	

}
