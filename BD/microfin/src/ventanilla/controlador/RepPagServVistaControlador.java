package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.RepPagServBean;

public class RepPagServVistaControlador  extends SimpleFormController{

	
	public RepPagServVistaControlador(){
 		setCommandClass(RepPagServBean.class);
 		setCommandName("repPagServBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {
 		RepPagServBean  catalogoServBean = (RepPagServBean) command; 		
 		
 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
 								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;
 	
 		MensajeTransaccionBean mensaje = null;
// 		mensaje = catalogoServServicio.grabaTransaccion(tipoTransaccion,catalogoServBean );
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

	
 	
	// ----------setter-----------

	
	
}
