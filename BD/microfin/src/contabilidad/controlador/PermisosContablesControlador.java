package contabilidad.controlador;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.PermisosContablesBean;
import contabilidad.servicio.PermisosContablesServicio;

public class PermisosContablesControlador extends SimpleFormController {

 	PermisosContablesServicio permisosContablesServicio = null;

 	public PermisosContablesControlador(){
 		setCommandClass(PermisosContablesBean.class);
 		setCommandName("permisosContablesBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		PermisosContablesBean permisosContablesBean = (PermisosContablesBean) command;
 		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
 		MensajeTransaccionBean mensaje = null;
 		mensaje = permisosContablesServicio.grabaTransaccion(tipoTransaccion, permisosContablesBean);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

	public void setPermisosContablesServicio(
			PermisosContablesServicio permisosContablesServicio) {
		this.permisosContablesServicio = permisosContablesServicio;
	}

 	
 } 
