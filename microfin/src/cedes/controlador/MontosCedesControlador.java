package cedes.controlador;

import general.bean.MensajeTransaccionBean;
import inversiones.bean.MontoInversionBean;
import inversiones.servicio.MontoInversionServicio;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cedes.bean.MontosCedesBean;
import cedes.servicio.MontosCedesServicio;

public class MontosCedesControlador extends SimpleFormController  {

	MontosCedesServicio montosCedesServicio = null;

 	public MontosCedesControlador(){
 		setCommandClass(MontosCedesBean.class);
 		setCommandName("montoCedesBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		MontosCedesBean montoCedes = (MontosCedesBean) command;
 		
 		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
 		MensajeTransaccionBean mensaje;  		
 		
		String montosInferior = request.getParameter("montosInferior");
		String montosSuperior = request.getParameter("montosSuperior");		
		
 		mensaje = montosCedesServicio.grabaListaMontosCedes(
 										tipoTransaccion, montoCedes,
 										montosInferior, montosSuperior);
 		
 		
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

	public void setMontosCedesServicio(MontosCedesServicio montosCedesServicio) {
		this.montosCedesServicio = montosCedesServicio;
	}
	
} 
