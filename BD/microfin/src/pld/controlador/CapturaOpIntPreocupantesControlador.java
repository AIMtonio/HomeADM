package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.OpIntPreocupantesBean;
import pld.servicio.OpIntPreocupantesServicio;


public class CapturaOpIntPreocupantesControlador extends SimpleFormController{
	
	OpIntPreocupantesServicio opIntPreocupantesServicio = null;

	public CapturaOpIntPreocupantesControlador() {
		setCommandClass(OpIntPreocupantesBean.class);
		setCommandName("capturaOperacion");
}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		opIntPreocupantesServicio.getOpIntPreocupantesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		OpIntPreocupantesBean opIntPreocupantes = (OpIntPreocupantesBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		opIntPreocupantes.setOrigenDatos(request.getParameter("desplegado"));

		MensajeTransaccionBean mensaje = null;
		mensaje = opIntPreocupantesServicio.grabaTransaccion(tipoTransaccion,opIntPreocupantes);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
		public void setOpIntPreocupantesServicio(OpIntPreocupantesServicio opIntPreocupantesServicio) {
			this.opIntPreocupantesServicio = opIntPreocupantesServicio;
	}
}
