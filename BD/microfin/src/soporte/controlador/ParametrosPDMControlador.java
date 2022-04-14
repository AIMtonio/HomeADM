package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.ParametrosPDMBean;
import soporte.servicio.ParametrosPDMServicio;

public class ParametrosPDMControlador extends SimpleFormController{

	ParametrosPDMServicio parametrosPDMServicio = null;
	
	public ParametrosPDMControlador(){
 		setCommandClass(ParametrosPDMBean.class);
 		setCommandName("parametrosPDMBean"); 		
 	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		parametrosPDMServicio.getParametrosPDMDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		
		ParametrosPDMBean parametrosPademobileBean = (ParametrosPDMBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
		Integer.parseInt(request.getParameter("tipoTransaccion")):0;

		MensajeTransaccionBean mensaje = null;
		
		mensaje = parametrosPDMServicio.grabaTransaccion(tipoTransaccion, parametrosPademobileBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	// ---------------  GETTER y SETTER -------------------- 

	public ParametrosPDMServicio getParametrosPDMServicio() {
		return parametrosPDMServicio;
	}

	public void setParametrosPDMServicio(ParametrosPDMServicio parametrosPDMServicio) {
		this.parametrosPDMServicio = parametrosPDMServicio;
	}
	
}
