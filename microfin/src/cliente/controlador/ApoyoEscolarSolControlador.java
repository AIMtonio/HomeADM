package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ApoyoEscolarSolBean;
import cliente.servicio.ApoyoEscolarSolServicio;
import soporte.bean.ParametrosCajaBean;
import soporte.servicio.ParametrosCajaServicio;

public class ApoyoEscolarSolControlador extends SimpleFormController {
	

	ApoyoEscolarSolServicio apoyoEscolarSolServicio = null;


	public ApoyoEscolarSolControlador() {
		setCommandClass(ApoyoEscolarSolBean.class); 
		setCommandName("apoyoEscolarSolBean");	
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command,BindException errors) 
	throws Exception {	

		apoyoEscolarSolServicio.getApoyoEscolarSolDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		ApoyoEscolarSolBean apoyoEscolarSolBean = (ApoyoEscolarSolBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ?
					Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
					
		int tipoActualizacion =(request.getParameter("tipoActualizacion")!=null) ?
					Integer.parseInt(request.getParameter("tipoActualizacion")): 0;

		MensajeTransaccionBean mensaje = null;		
		mensaje = apoyoEscolarSolServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion,apoyoEscolarSolBean);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}//fin del onSubmit


	
	
	//* ============== GETTER & SETTER =============  //*
	public ApoyoEscolarSolServicio getApoyoEscolarSolServicio() {
		return apoyoEscolarSolServicio;
	}


	public void setApoyoEscolarSolServicio(
			ApoyoEscolarSolServicio apoyoEscolarSolServicio) {
		this.apoyoEscolarSolServicio = apoyoEscolarSolServicio;
	}
	

}// fin de la clase
