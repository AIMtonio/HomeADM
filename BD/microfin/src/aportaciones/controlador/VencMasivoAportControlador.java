package aportaciones.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import aportaciones.bean.AportacionesBean;
import aportaciones.servicio.AportacionesServicio;

public class VencMasivoAportControlador extends SimpleFormController{
	
	AportacionesServicio aportacionesServicio = null;

	public VencMasivoAportControlador(){
		setCommandClass(AportacionesBean.class);
		setCommandName("aportacionesBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		MensajeTransaccionBean mensaje = null;

		AportacionesBean aportacionesBean = (AportacionesBean) command;
		aportacionesServicio.getAportacionesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		mensaje = aportacionesServicio.vencimientoMasivoAportaciones(aportacionesBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public AportacionesServicio getAportacionesServicio() {
		return aportacionesServicio;
	}

	public void setAportacionesServicio(AportacionesServicio aportacionesServicio) {
		this.aportacionesServicio = aportacionesServicio;
	}

}