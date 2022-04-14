package pld.controlador;

import general.bean.MensajeTransaccionBean;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import pld.bean.ParametrosegoperBean;

import pld.servicio.ParametrosegoperServicio;

public class ParametrosegoperControlador extends SimpleFormController {
	
	ParametrosegoperServicio parametrosegoperServicio = null;

	public ParametrosegoperControlador() {
		setCommandClass(ParametrosegoperBean.class);
		setCommandName("parametrosegoper");
	}
		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		parametrosegoperServicio.getParametrosegoperDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	
		ParametrosegoperBean parametrosegoper = (ParametrosegoperBean) command;
		int tipoTransaccion = (request.getParameter("tipoTransaccion")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		
	

		MensajeTransaccionBean mensaje = null;
		 mensaje = parametrosegoperServicio.grabaTransaccion(tipoTransaccion,parametrosegoper);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}


	
	//---------------setter----------------
	public void setParametrosegoperServicio(
			ParametrosegoperServicio parametrosegoperServicio) {
		this.parametrosegoperServicio = parametrosegoperServicio;
	}


}

