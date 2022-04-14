package seguimiento.controlador; 

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import seguimiento.bean.SegtoRealizadosBean;
import seguimiento.servicio.SegtoRealizadosServicio;

public class SegtoRealizadosControlador extends SimpleFormController {
	SegtoRealizadosServicio segtoRealizadosServicio = null;

 	public SegtoRealizadosControlador(){
 		setCommandClass(SegtoRealizadosBean.class);
 		setCommandName("segtoRealizadosBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {
 		segtoRealizadosServicio.getSegtoRealizadosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		SegtoRealizadosBean segtoRealizadosBean = (SegtoRealizadosBean) command;

 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
 								Integer.parseInt(request.getParameter("tipoTransaccion")):	0; 		
 		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
 								Integer.parseInt(request.getParameter("tipoActualizacion")): 0;
 		MensajeTransaccionBean mensaje = null;
 		mensaje = segtoRealizadosServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, segtoRealizadosBean, request);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

	public SegtoRealizadosServicio getSegtoRealizadosServicio() {
		return segtoRealizadosServicio;
	}

	public void setSegtoRealizadosServicio(
			SegtoRealizadosServicio segtoRealizadosServicio) {
		this.segtoRealizadosServicio = segtoRealizadosServicio;
	}
}