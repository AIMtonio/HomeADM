package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.LimiteOperClienteBean;
import cliente.servicio.LimiteOperClienteServicio;

public class LimiteOperClienteControlador extends SimpleFormController {
	
	LimiteOperClienteServicio limiteOperClienteServicio = null;

 	public LimiteOperClienteControlador(){
 		setCommandClass(LimiteOperClienteBean.class);
 		setCommandName("limiteOperClienteBean");
 	}
 	
 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		limiteOperClienteServicio.getLimiteOperClienteDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		LimiteOperClienteBean limiteOperClienteBean = (LimiteOperClienteBean) command;
 	
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
		Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
		
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
				Integer.parseInt(request.getParameter("tipoActualizacion")):0;		
		
		MensajeTransaccionBean mensaje = null;
		mensaje = limiteOperClienteServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion, limiteOperClienteBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);


	}
	// ---------------  getter y setter -------------------- 
	public LimiteOperClienteServicio getLimiteOperClienteServicio() {
		return limiteOperClienteServicio;
	}
	
	public void setLimiteOperClienteServicio(LimiteOperClienteServicio limiteOperClienteServicio) {
		this.limiteOperClienteServicio = limiteOperClienteServicio;
	}


}
