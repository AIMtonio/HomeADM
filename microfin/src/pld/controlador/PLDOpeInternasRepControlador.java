package pld.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.OpIntPreocupantesBean;
import pld.servicio.OpIntPreocupantesServicio;

public class PLDOpeInternasRepControlador  extends SimpleFormController{

	OpIntPreocupantesServicio opIntPreocupantesServicio = null;

	public PLDOpeInternasRepControlador() {
		setCommandClass(OpIntPreocupantesBean.class);
		setCommandName("opeInternas");
	}


	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		opIntPreocupantesServicio.getOpIntPreocupantesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		OpIntPreocupantesBean parametrosInternas = (OpIntPreocupantesBean) command;
		int tipoActualizacion = Utileria.convierteEntero(request.getParameter("tipoActualizacion"));

		MensajeTransaccionBean mensaje = null;
		String  datosOperInusuales = request.getParameter("datosOperInusuales");
		mensaje = opIntPreocupantesServicio.grabaTransaccion(tipoActualizacion,  parametrosInternas);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setOpIntPreocupantesServicio(
			OpIntPreocupantesServicio opIntPreocupantesServicio) {
		this.opIntPreocupantesServicio = opIntPreocupantesServicio;
	}
}
