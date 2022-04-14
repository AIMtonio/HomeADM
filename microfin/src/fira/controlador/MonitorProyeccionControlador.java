package fira.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fira.bean.MonitorProyeccionBean;
import fira.servicio.MonitorProyeccionServicio;

public class MonitorProyeccionControlador extends SimpleFormController {
	MonitorProyeccionServicio monitorProyeccionServicio = null;
	
	public MonitorProyeccionControlador(){
		setCommandClass(MonitorProyeccionBean.class);
		setCommandName("monitorProyeccionBean");		
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		monitorProyeccionServicio.getMonitorProyeccionDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		MonitorProyeccionBean proyeccionBean = (MonitorProyeccionBean)command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		int anioLista = Integer.parseInt(request.getParameter("anioLista"));
				
		MensajeTransaccionBean mensaje = null;
		
		mensaje = monitorProyeccionServicio.grabaTransaccion(tipoTransaccion, anioLista, proyeccionBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public MonitorProyeccionServicio getMonitorProyeccionServicio() {
		return monitorProyeccionServicio;
	}

	public void setMonitorProyeccionServicio(
			MonitorProyeccionServicio monitorProyeccionServicio) {
		this.monitorProyeccionServicio = monitorProyeccionServicio;
	}

	
	
	
}
