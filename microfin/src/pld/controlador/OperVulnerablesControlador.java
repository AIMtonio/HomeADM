package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.OperVulnerablesBean;
import pld.servicio.OperVulnerablesServicio;
import soporte.servicio.ParametrosSisServicio;


public class OperVulnerablesControlador extends SimpleFormController{
	

	OperVulnerablesServicio operVulnerablesServicio = null;
	ParametrosSisServicio parametrosSisServicio = null;
	
	public OperVulnerablesControlador() {
		setCommandClass(OperVulnerablesBean.class);
		setCommandName("operVulnerablesBean");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		operVulnerablesServicio.getOperVulnerablesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		OperVulnerablesBean operVulnerablesBean = (OperVulnerablesBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = operVulnerablesServicio.grabaTransaccion(tipoTransaccion, operVulnerablesBean);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	
	
	public OperVulnerablesServicio getOperVulnerablesServicio() {
		return operVulnerablesServicio;
	}
	public void setOperVulnerablesServicio(
			OperVulnerablesServicio operVulnerablesServicio) {
		this.operVulnerablesServicio = operVulnerablesServicio;
	}
	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}
	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}	
	
}
