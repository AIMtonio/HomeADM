package soporte.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.ParametrosCajaBean;
import soporte.servicio.ParametrosCajaServicio;;

public class ParametrosCajaControlador extends SimpleFormController {
	

	ParametrosCajaServicio parametrosCajaServicio = null;


	public ParametrosCajaControlador() {
		setCommandClass(ParametrosCajaBean.class); 
		setCommandName("parametrosCajaBean");	
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command,BindException errors) 
	throws Exception {
	

		parametrosCajaServicio.getParametrosCajaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		ParametrosCajaBean parametrosCajaBean = (ParametrosCajaBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ?
					Integer.parseInt(request.getParameter("tipoTransaccion")): 0;

		MensajeTransaccionBean mensaje = null;		
		mensaje = parametrosCajaServicio.grabaTransaccion(tipoTransaccion,parametrosCajaBean);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}//fin del onSubmit


	public void setParametrosCajaServicio(ParametrosCajaServicio parametrosCajaServicio) {
		this.parametrosCajaServicio = parametrosCajaServicio;
	}


}// fin de la clase
