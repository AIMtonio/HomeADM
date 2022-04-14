package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.MonitorRiesgoComunBean;
import originacion.servicio.MonitorRiesgoComunServicio;


public class MonitorRiesgoComunControlador extends SimpleFormController{
	MonitorRiesgoComunServicio monitorRiesgoComunServicio = null;
	
	public MonitorRiesgoComunControlador(){
		setCommandClass(MonitorRiesgoComunBean.class);
		setCommandName("monitorRiesgoComun");		
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		monitorRiesgoComunServicio.getMonitorRiesgoComunDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		MonitorRiesgoComunBean riesgoComunBean = (MonitorRiesgoComunBean)command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));				
		MensajeTransaccionBean mensaje = null;
		
		mensaje = monitorRiesgoComunServicio.grabaTransaccion(tipoTransaccion, riesgoComunBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public MonitorRiesgoComunServicio getMonitorRiesgoComunServicio() {
		return monitorRiesgoComunServicio;
	}

	public void setMonitorRiesgoComunServicio(
			MonitorRiesgoComunServicio monitorRiesgoComunServicio) {
		this.monitorRiesgoComunServicio = monitorRiesgoComunServicio;
	}

	
	
	
}
