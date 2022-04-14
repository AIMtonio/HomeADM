package cedes.controlador; 

import general.bean.MensajeTransaccionBean;
import inversiones.bean.DiasInversionBean;
import inversiones.servicio.DiasInversionServicio;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cedes.bean.PlazosCedesBean;
import cedes.servicio.PlazosCedesServicio;

 public class PlazosCedesControlador extends SimpleFormController {

	 PlazosCedesServicio plazosCedesServicio = null;

 	public void setPlazosCedesServicio(PlazosCedesServicio plazosCedesServicio) {
		this.plazosCedesServicio = plazosCedesServicio;
	}

	public PlazosCedesControlador(){
 		setCommandClass(PlazosCedesBean.class);
 		setCommandName("plazosCedesBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		PlazosCedesBean plazos = (PlazosCedesBean) command;
 		
 		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
 		MensajeTransaccionBean mensaje;  		
 		
		String plazosInferior = request.getParameter("diasInferior");
		String plazosSuperior = request.getParameter("diasSuperior");
				
 		mensaje = plazosCedesServicio.grabaListaPlazosCedes(tipoTransaccion, plazos,
 															  plazosInferior, plazosSuperior);
 		
 		
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}
 	
 
	
 
 } 
