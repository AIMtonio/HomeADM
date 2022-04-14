package fira.controlador;

import fira.bean.GarantiaFiraBean;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class ReporteCreditoAfectacionGarantiaControlador extends SimpleFormController {

	MensajeTransaccionBean mensajeTransaccionBean = null;
	
	public ReporteCreditoAfectacionGarantiaControlador () {
		setCommandClass(GarantiaFiraBean.class);
		setCommandName("garantiaFiraBean");

	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		return new ModelAndView(getSuccessView(), "mensaje", null);
		
	}
}
