package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.NivelRiesgoPunBean;

public class RepNivelRiesgoPuntHisControlador extends SimpleFormController {

	public RepNivelRiesgoPuntHisControlador() {
		setCommandClass(NivelRiesgoPunBean.class);
		setCommandName("nivelRiesgoPunBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors) throws Exception {
		NivelRiesgoPunBean bean = (NivelRiesgoPunBean) command;
		MensajeTransaccionBean mensaje=new MensajeTransaccionBean();
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
}
