package fira.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fira.bean.MonitorExcedentesBean;
import fira.servicio.MonitorExcedentesServicio;

public class MonitorExcedentesControlador extends SimpleFormController{
	MonitorExcedentesServicio monitorExcedentesServicio = null;
	
	public MonitorExcedentesControlador(){
		setCommandClass(MonitorExcedentesBean.class);
		setCommandName("monitorExcedentesBean");		
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		monitorExcedentesServicio.getMonitorExcedentesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		MonitorExcedentesBean excedentesBean = (MonitorExcedentesBean)command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		String fecha = request.getParameter("fecha");
		
						
		MensajeTransaccionBean mensaje = null;
		
		mensaje = monitorExcedentesServicio.grabaTransaccion(tipoTransaccion, fecha, excedentesBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public MonitorExcedentesServicio getMonitorExcedentesServicio() {
		return monitorExcedentesServicio;
	}

	public void setMonitorExcedentesServicio(
			MonitorExcedentesServicio monitorExcedentesServicio) {
		this.monitorExcedentesServicio = monitorExcedentesServicio;
	}
}
