package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.AdicionalPersonaMoralBean;
import cliente.servicio.AdicionalPersonaMoralServicio;


public class AdicionalPersonaMoralControlador extends SimpleFormController {
	
	AdicionalPersonaMoralServicio adicionalPersonaMoralServicio = null;

 	public AdicionalPersonaMoralControlador(){
 		setCommandClass(AdicionalPersonaMoralBean.class);
 		setCommandName("adicionalPersonaMoral");
 	}
 	
 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		adicionalPersonaMoralServicio.getAdicionalPersonaMoralDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		AdicionalPersonaMoralBean adicionalPersonaMoralBean = (AdicionalPersonaMoralBean) command;
 	
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
		Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
		
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
				Integer.parseInt(request.getParameter("tipoActualizacion")):0;		
		
		MensajeTransaccionBean mensaje = null;
		mensaje = adicionalPersonaMoralServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion, adicionalPersonaMoralBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);


	}
	// ---------------  getter y setter -------------------- 

	public AdicionalPersonaMoralServicio getAdicionalPersonaMoralServicio() {
		return adicionalPersonaMoralServicio;
	}

	public void setAdicionalPersonaMoralServicio(
			AdicionalPersonaMoralServicio adicionalPersonaMoralServicio) {
		this.adicionalPersonaMoralServicio = adicionalPersonaMoralServicio;
	}
	


}
