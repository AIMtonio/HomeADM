package soporte.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.ParamApoyoEscolarBean;
import soporte.servicio.ParamApoyoEscolarServicio;

public class ParamApoyoEscolarControlador extends SimpleFormController {

	ParamApoyoEscolarServicio paramApoyoEscolarServicio = null;
	
	public ParamApoyoEscolarControlador() {
		setCommandClass(ParamApoyoEscolarBean.class);
		setCommandName("paramApoyoEscolarBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command,BindException errors) 
	throws Exception {
	

		paramApoyoEscolarServicio.getParamApoyoEscolarDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		ParamApoyoEscolarBean paramApoyoEscolarBean = (ParamApoyoEscolarBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccionGrid")!=null) ?
					Integer.parseInt(request.getParameter("tipoTransaccionGrid")): 0;

		MensajeTransaccionBean mensaje = null;		
		mensaje = paramApoyoEscolarServicio.grabaTransaccion(tipoTransaccion,paramApoyoEscolarBean);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}//fin del onSubmit


	public void setParamApoyoEscolarServicio(ParamApoyoEscolarServicio paramApoyoEscolarServicio) {
		this.paramApoyoEscolarServicio = paramApoyoEscolarServicio;
	}


}// fin de la clase
