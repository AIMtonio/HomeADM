package inversiones.controlador; 

import general.bean.MensajeTransaccionBean;
import inversiones.bean.DiasInversionBean;
import inversiones.servicio.DiasInversionServicio;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

 public class DiasInversionControlador extends SimpleFormController {

 	DiasInversionServicio diasInverServicio = null;

 	public DiasInversionControlador(){
 		setCommandClass(DiasInversionBean.class);
 		setCommandName("diasInversionBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		DiasInversionBean diasInversion = (DiasInversionBean) command;
 		
 		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
 		MensajeTransaccionBean mensaje;  		
 		
		String plazosInferior = request.getParameter("diasInferior");
		String plazosSuperior = request.getParameter("diasSuperior");
				
 		mensaje = diasInverServicio.grabaListaDiasInversion(tipoTransaccion, diasInversion,
 															  plazosInferior, plazosSuperior);
 		
 		
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}
 	

	public void setDiasInverServicio(DiasInversionServicio diasInverServicio) {
		this.diasInverServicio = diasInverServicio;
	}
 
 } 
