package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.ParametrosEscalaBean;
import pld.bean.ParametrosOpRelBean;
import pld.servicio.ParametrosEscalaServicio;
import pld.servicio.ParametrosOpRelServicio;

public class ParametrosEscalaControlador  extends SimpleFormController {
	
	ParametrosEscalaServicio parametrosEscalaServicio = null;

	public ParametrosEscalaControlador() {
		setCommandClass(ParametrosEscalaBean.class);
		setCommandName("parametrosEscala");
	}
		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		parametrosEscalaServicio.getParametrosEscalaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	
		ParametrosEscalaBean parametrosEsc = (ParametrosEscalaBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = parametrosEscalaServicio.grabaTransaccion(tipoTransaccion,parametrosEsc);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}


	public void setParametrosEscalaServicio(
			ParametrosEscalaServicio parametrosEscalaServicio) {
		this.parametrosEscalaServicio = parametrosEscalaServicio;
	}



	
}
