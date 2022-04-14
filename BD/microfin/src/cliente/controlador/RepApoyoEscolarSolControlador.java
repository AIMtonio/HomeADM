package cliente.controlador;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ApoyoEscolarSolBean;
import cliente.servicio.ApoyoEscolarSolServicio;

public class RepApoyoEscolarSolControlador extends SimpleFormController {
	
	ApoyoEscolarSolServicio apoyoEscolarSolServicio = null;

	public RepApoyoEscolarSolControlador() {
		setCommandClass(ApoyoEscolarSolBean.class);
		setCommandName("apoyoEscolarSolBean");
	}
		
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		apoyoEscolarSolServicio.getApoyoEscolarSolDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ApoyoEscolarSolBean solicitudAEBean = (ApoyoEscolarSolBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		int tipoActualizacion = 0;
		MensajeTransaccionBean mensaje = null;
		mensaje = apoyoEscolarSolServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion,solicitudAEBean);
												
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ApoyoEscolarSolServicio getApoyoEscolarSolServicio() {
		return apoyoEscolarSolServicio;
	}

	public void setApoyoEscolarSolServicio(
			ApoyoEscolarSolServicio apoyoEscolarSolServicio) {
		this.apoyoEscolarSolServicio = apoyoEscolarSolServicio;
	}
	
	

}


