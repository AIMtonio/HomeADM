package sms.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import sms.servicio.ParametrosSMSServicio;
import sms.bean.ParametrosSMSBean;


public class ParametrosSMSControlador extends SimpleFormController {
	ParametrosSMSServicio parametrosSMSServicio=null;

	public ParametrosSMSControlador(){
		setCommandClass(ParametrosSMSBean.class);
		setCommandName("parametrosSMS");
	}
	
	protected  ModelAndView onSubmit(HttpServletRequest request, 
									HttpServletResponse response, 
									Object command,
									BindException errors)throws Exception{
									
		ParametrosSMSBean parametrosSMSBean= (ParametrosSMSBean) command;
		parametrosSMSServicio.getParametrosSMSDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
					
		MensajeTransaccionBean mensaje = null;
		mensaje = parametrosSMSServicio.grabaTransaccion(tipoTransaccion,parametrosSMSBean);
				  
					return new ModelAndView(getSuccessView(), "mensaje", mensaje);								
	}
	
	
	//---------método set
	public void setParametrosSMSServicio(ParametrosSMSServicio parametrosSMSServicio) {
		this.parametrosSMSServicio = parametrosSMSServicio;
	}
	
	
	
}
