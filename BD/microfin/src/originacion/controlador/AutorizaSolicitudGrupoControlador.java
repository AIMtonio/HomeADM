package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import originacion.bean.AutorizaSolicitudGrupoBean;
import originacion.servicio.AutorizaSolicitudGrupoServicio;

public class AutorizaSolicitudGrupoControlador  extends SimpleFormController {
	
	AutorizaSolicitudGrupoServicio autorizaSolicitudGrupoServicio = null;
	
	public AutorizaSolicitudGrupoControlador() {
		setCommandClass(AutorizaSolicitudGrupoBean.class);
		setCommandName("autorizaSolicitudGrupoBean");	
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, 
						HttpServletResponse response, Object command,
						BindException errors) 
	throws Exception {	
		
		autorizaSolicitudGrupoServicio.getAutorizaSolicitudGrupoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		AutorizaSolicitudGrupoBean autorizaSolicitudBean = (AutorizaSolicitudGrupoBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ?
					Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
					
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
				Integer.parseInt(request.getParameter("tipoActualizacion")):
				0;
		
		MensajeTransaccionBean mensaje = null;		
		mensaje = autorizaSolicitudGrupoServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion,autorizaSolicitudBean);
		
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}//fin del onSubmit
	
	//* ============== Getter & Setter =============  //*	
	
	public AutorizaSolicitudGrupoServicio getAutorizaSolicitudGrupoServicio() {
		return autorizaSolicitudGrupoServicio;
	}

	public void setAutorizaSolicitudGrupoServicio(
			AutorizaSolicitudGrupoServicio autorizaSolicitudGrupoServicio) {
		this.autorizaSolicitudGrupoServicio = autorizaSolicitudGrupoServicio;
	}
}
