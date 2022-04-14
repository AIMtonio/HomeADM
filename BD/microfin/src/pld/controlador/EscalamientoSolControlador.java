package pld.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.EscalamientoSolBean;
import pld.servicio.EscalamientoSolServicio;

public class EscalamientoSolControlador extends SimpleFormController{
	
	EscalamientoSolServicio escalamientoSolServicio = null;

	public EscalamientoSolControlador() {
		setCommandClass(EscalamientoSolBean.class);
		setCommandName("escalaSol");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		escalamientoSolServicio.getEscalamientoSolDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		EscalamientoSolBean escalaSol = (EscalamientoSolBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
		MensajeTransaccionBean mensaje = null;
		mensaje = escalamientoSolServicio.grabaTransaccion(tipoTransaccion,escalaSol);
									
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
		public void setEscalamientoSolServicio(EscalamientoSolServicio escalamientoSolServicio) {
			this.escalamientoSolServicio = escalamientoSolServicio;
	}
	}
