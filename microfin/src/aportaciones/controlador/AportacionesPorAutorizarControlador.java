package aportaciones.controlador;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import aportaciones.bean.AportacionesBean;

public class AportacionesPorAutorizarControlador extends SimpleFormController{
	
	public ParametrosSesionBean parametrosSesionBean = null;
	public String nombreReporte = null;
	public String successView = null;
	
	public AportacionesPorAutorizarControlador(){
		setCommandClass(AportacionesBean.class);
		setCommandName("aportacionesBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	
	

}
