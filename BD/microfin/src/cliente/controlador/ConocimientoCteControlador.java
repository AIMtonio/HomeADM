package cliente.controlador;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ConocimientoCteBean;
import cliente.servicio.ConocimientoCteServicio;


public class ConocimientoCteControlador extends SimpleFormController {

	ConocimientoCteServicio ConocimientoCteServicio = null;

 	public ConocimientoCteControlador(){
 		setCommandClass(ConocimientoCteBean.class);
 		setCommandName("ConocimientoCte");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		ConocimientoCteBean ConocimientoB = (ConocimientoCteBean) command;

 		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
 		MensajeTransaccionBean mensaje = null;
 		mensaje = ConocimientoCteServicio.grabaTransaccion(tipoTransaccion, ConocimientoB);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

	public void setConocimientoCteServicio(
			ConocimientoCteServicio conocimientoCteServicio) {
		ConocimientoCteServicio = conocimientoCteServicio;
	}

	
 
}
