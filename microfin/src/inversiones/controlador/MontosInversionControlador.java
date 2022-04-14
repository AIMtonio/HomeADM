package inversiones.controlador;

import general.bean.MensajeTransaccionBean;
import inversiones.bean.MontoInversionBean;
import inversiones.servicio.MontoInversionServicio;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class MontosInversionControlador extends SimpleFormController  {

 	MontoInversionServicio montoInversionServicio = null;

 	public MontosInversionControlador(){
 		setCommandClass(MontoInversionBean.class);
 		setCommandName("montoInversionBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		MontoInversionBean montoInversion = (MontoInversionBean) command;
 		
 		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
 		MensajeTransaccionBean mensaje;  		
 		
		String montosInferior = request.getParameter("montosInferior");
		String montosSuperior = request.getParameter("montosSuperior");		
		
 		mensaje = montoInversionServicio.grabaListaMontosInversion(
 										tipoTransaccion, montoInversion,
 										montosInferior, montosSuperior);
 		
 		
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

	public void setMontoInversionServicio(
			MontoInversionServicio montoInversionServicio) {
		this.montoInversionServicio = montoInversionServicio;
	}
 	
 	
	
	
}
