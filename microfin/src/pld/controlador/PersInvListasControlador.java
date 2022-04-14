package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.PersInvListasBean;

public class PersInvListasControlador extends SimpleFormController {

	public PersInvListasControlador() {
		setCommandClass(PersInvListasBean.class);
		setCommandName("PersInvListas");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors) throws Exception {
		PersInvListasBean persInvListasBean = (PersInvListasBean) command;
		MensajeTransaccionBean mensaje=new MensajeTransaccionBean();
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
}
