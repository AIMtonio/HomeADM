package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.OpeInusualesBean;

public class ReporteOpeInuPLDControlador extends SimpleFormController {

	public ReporteOpeInuPLDControlador() {
		setCommandClass(OpeInusualesBean.class);
		setCommandName("opeInusualesBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors) throws Exception {
		OpeInusualesBean opeInusualesBean = (OpeInusualesBean) command;
		MensajeTransaccionBean mensaje=new MensajeTransaccionBean();
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
}
