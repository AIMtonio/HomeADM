package aportaciones.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import aportaciones.bean.AportacionesBean;
import aportaciones.servicio.AportacionesServicio;

public class AportacionesControlador extends SimpleFormController{

	AportacionesServicio aportacionesServicio = null;

	public AportacionesControlador(){
		setCommandClass(AportacionesBean.class);
		setCommandName("aportacionesBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		aportacionesServicio.getAportacionesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		AportacionesBean aportacionesBean = (AportacionesBean) command;
		int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = aportacionesServicio.grabaTransaccion(tipoTransaccion, aportacionesBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public AportacionesServicio getAportacionesServicio() {
		return aportacionesServicio;
	}

	public void setAportacionesServicio(AportacionesServicio aportacionesServicio) {
		this.aportacionesServicio = aportacionesServicio;
	}

}