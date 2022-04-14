package soporte.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;;

public class ParametrosSisControlador extends SimpleFormController {
	

	ParametrosSisServicio parametrosSisServicio = null;


	public ParametrosSisControlador() {
		setCommandClass(ParametrosSisBean.class); 
		setCommandName("parametrosSisBean");	
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,BindException errors) throws Exception {

		parametrosSisServicio.getParametrosSisDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		ParametrosSisBean parametrosSisBean = (ParametrosSisBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
		MensajeTransaccionBean mensaje = null;
		mensaje = parametrosSisServicio.grabaTransaccion(tipoTransaccion,parametrosSisBean);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}//protected


	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}


}// clase
