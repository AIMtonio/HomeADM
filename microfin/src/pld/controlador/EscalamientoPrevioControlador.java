package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.EscalamientoPrevioBean;
import pld.servicio.EscalamientoPrevioServicio;
import pld.servicio.EscalamientoSolServicio;

public class EscalamientoPrevioControlador extends SimpleFormController{
	
	EscalamientoPrevioServicio escalamientoPrevioServicio = null;

	public EscalamientoPrevioControlador() {
		setCommandClass(EscalamientoPrevioBean.class);
		setCommandName("escalamientoPrevio");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		escalamientoPrevioServicio.getEscalamientoPrevioDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		EscalamientoPrevioBean escalaPrev = (EscalamientoPrevioBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
		MensajeTransaccionBean mensaje = null;
		mensaje = escalamientoPrevioServicio.grabaTransaccion(tipoTransaccion,escalaPrev);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
		public void setEscalamientoPrevioServicio(EscalamientoPrevioServicio escalamientoPrevioServicio) {
			this.escalamientoPrevioServicio = escalamientoPrevioServicio;
	}
	}
