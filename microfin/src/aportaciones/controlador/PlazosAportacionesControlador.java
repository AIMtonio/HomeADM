package aportaciones.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import aportaciones.bean.PlazosAportacionesBean;
import aportaciones.servicio.PlazosAportacionesServicio;

public class PlazosAportacionesControlador extends SimpleFormController {
	
	PlazosAportacionesServicio plazosAportacionesServicio = null;
	
	public PlazosAportacionesControlador(){
 		setCommandClass(PlazosAportacionesBean.class);
 		setCommandName("plazosAportacionesBean");
 	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		PlazosAportacionesBean plazos = (PlazosAportacionesBean) command;
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje;  		
		
		String plazosInferior = request.getParameter("diasInferior");
		String plazosSuperior = request.getParameter("diasSuperior");
		
		mensaje = plazosAportacionesServicio.grabaListaPlazosAportaciones(tipoTransaccion, plazos,
												  plazosInferior, plazosSuperior);
		
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public PlazosAportacionesServicio getPlazosAportacionesServicio() {
		return plazosAportacionesServicio;
	}

	public void setPlazosAportacionesServicio(
			PlazosAportacionesServicio plazosAportacionesServicio) {
		this.plazosAportacionesServicio = plazosAportacionesServicio;
	}
	
	

}
