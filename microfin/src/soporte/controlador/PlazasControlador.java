package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.PlazasBean;
import soporte.servicio.PlazasServicio;


public class PlazasControlador extends SimpleFormController {

	PlazasServicio plazasServicio = null;
	
	public PlazasControlador() {
		setCommandClass(PlazasBean.class);
		setCommandName("plaza");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		PlazasBean plazas = (PlazasBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = plazasServicio.grabaTransaccion(tipoTransaccion,plazas);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setPlazasServicio(PlazasServicio plazasServicio) {
		this.plazasServicio = plazasServicio;
	}
		
}
