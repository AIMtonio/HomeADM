package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.MonitorSolicitudesBean;
import originacion.servicio.MonitorSolicitudesServicio;
import originacion.servicio.MonitorSolicitudesServicio;

public class MonitorSolicitudesControlador extends SimpleFormController {
	MonitorSolicitudesServicio monitorSolicitudesServicio = null;
	String nombreReporte = null;
	String successView = null;		

 	public MonitorSolicitudesControlador(){
 		setCommandClass(MonitorSolicitudesBean.class);
 		setCommandName("monitorSolicitud");
 	}
   
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		MonitorSolicitudesBean monitorSolicitudesBean = (MonitorSolicitudesBean) command;
 		monitorSolicitudesServicio.getmonitorSolicitudesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):0;							
	  
										
		MensajeTransaccionBean mensaje = null;
		mensaje = monitorSolicitudesServicio.grabaTransaccion(tipoTransaccion,monitorSolicitudesBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}

 	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public MonitorSolicitudesServicio getMonitorSolicitudesServicio() {
		return monitorSolicitudesServicio;
	}


	public void setMonitorSolicitudesServicio(MonitorSolicitudesServicio monitorSolicitudesServicio) {
		this.monitorSolicitudesServicio = monitorSolicitudesServicio;
	}


}
