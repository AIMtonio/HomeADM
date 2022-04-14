package riesgos.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.ParametrosRiesgosServicio;

public class ParametrosRiesgosControlador extends SimpleFormController{
	ParametrosRiesgosServicio parametrosRiesgosServicio = null;
	
	public ParametrosRiesgosControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("parametrosRiesgos");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
				
		parametrosRiesgosServicio.getParametrosRiesgosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());		
		
		UACIRiesgosBean riesgosBean= (UACIRiesgosBean) command;	
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ?
				Integer.parseInt(request.getParameter("tipoTransaccion")): 0;

		
		MensajeTransaccionBean mensaje = null;
			
		mensaje = parametrosRiesgosServicio.grabaTransaccion(tipoTransaccion,riesgosBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	/* ****************** GETTER Y SETTERS *************************** */
	public ParametrosRiesgosServicio getParametrosRiesgosServicio() {
		return parametrosRiesgosServicio;
	}
	public void setParametrosRiesgosServicio(
			ParametrosRiesgosServicio parametrosRiesgosServicio) {
		this.parametrosRiesgosServicio = parametrosRiesgosServicio;
	}

}
