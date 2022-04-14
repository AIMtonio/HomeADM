package aportaciones.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import aportaciones.bean.AportacionesAnclajeBean;
import aportaciones.servicio.AportacionesAnclajeServicio;

public class AportacionesAnclajeControlador extends SimpleFormController {

	AportacionesAnclajeServicio aportacionesAnclajeServicio = null;

	public AportacionesAnclajeControlador(){
		setCommandClass(AportacionesAnclajeBean.class);
		setCommandName("aportacionesAnclajeBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		aportacionesAnclajeServicio.getAportacionesAnclajeDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		AportacionesAnclajeBean aportacionesAnclajeBean = (AportacionesAnclajeBean) command;
		int tipoTransaccion =Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = aportacionesAnclajeServicio.grabaTransaccion(tipoTransaccion, aportacionesAnclajeBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);

	}

	public AportacionesAnclajeServicio getAportacionesAnclajeServicio() {
		return aportacionesAnclajeServicio;
	}

	public void setAportacionesAnclajeServicio(
			AportacionesAnclajeServicio aportacionesAnclajeServicio) {
		this.aportacionesAnclajeServicio = aportacionesAnclajeServicio;
	}

}