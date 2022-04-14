package aportaciones.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import aportaciones.bean.MontosAportacionesBean;
import aportaciones.servicio.MontosAportacionesServicio;

public class MontosAportacionesControlador extends SimpleFormController {
	
	MontosAportacionesServicio montosAportacionesServicio = null;

 	public MontosAportacionesControlador(){
 		setCommandClass(MontosAportacionesBean.class);
 		setCommandName("montoAportacionesBean");
 	}
 	
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		MontosAportacionesBean montoAportaciones = (MontosAportacionesBean) command;
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje;  		
		
		String montosInferior = request.getParameter("montosInferior");
		String montosSuperior = request.getParameter("montosSuperior");		
		
		mensaje = montosAportacionesServicio.grabaListaMontosAportaciones(
							tipoTransaccion, montoAportaciones,
							montosInferior, montosSuperior);
		
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public MontosAportacionesServicio getMontosAportacionesServicio() {
		return montosAportacionesServicio;
	}

	public void setMontosAportacionesServicio(
			MontosAportacionesServicio montosAportacionesServicio) {
		this.montosAportacionesServicio = montosAportacionesServicio;
	}

}
