package soporte.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.AsamGralUsuarioAutBean;
import soporte.servicio.AsamGralUsuarioAutServicio;



public class AsamGralUsuarioAutControlador extends SimpleFormController{
	AsamGralUsuarioAutServicio asamGralUsuarioAutServicio = null;
	
	public AsamGralUsuarioAutControlador() {
		setCommandClass(AsamGralUsuarioAutBean.class);
		setCommandName("asamGralUsuarioAutBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command,BindException errors) 
	throws Exception {
	
		asamGralUsuarioAutServicio.getAsamGralUsuarioAutDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		AsamGralUsuarioAutBean asamGralUsuarioAutBean = (AsamGralUsuarioAutBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccionGridPer")!=null) ?
					Integer.parseInt(request.getParameter("tipoTransaccionGridPer")): 0;

		MensajeTransaccionBean mensaje = null;		
		mensaje = asamGralUsuarioAutServicio.grabaTransaccion(tipoTransaccion,asamGralUsuarioAutBean);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}//fin del onSubmit

	public AsamGralUsuarioAutServicio getAsamGralUsuarioAutServicio() {
		return asamGralUsuarioAutServicio;
	}

	public void setAsamGralUsuarioAutServicio(AsamGralUsuarioAutServicio asamGralUsuarioAutServicio) {
		this.asamGralUsuarioAutServicio = asamGralUsuarioAutServicio;
	}





}
