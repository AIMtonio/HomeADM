package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.CatalogoGastosAntBean;
import ventanilla.bean.ReversasOperCajaBean;
import ventanilla.servicio.CatalogoGastosAntServicio;
import ventanilla.servicio.ReversasOperCajaServicio;

public class ReversasOperCajaControlador  extends SimpleFormController{

	ReversasOperCajaServicio reversasOperCajaServicio =null;

	public ReversasOperCajaControlador(){
 		setCommandClass(ReversasOperCajaBean.class);
 		setCommandName("reversasOperCajaBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {
 		ReversasOperCajaBean  reversasOperCajaBean = (ReversasOperCajaBean) command; 		
 		reversasOperCajaServicio.getReversasOperCajaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
 								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;
 	
 		MensajeTransaccionBean mensaje = null;
 		//mensaje = catalogoGastosAntServicio.grabaTransaccion(tipoTransaccion,catalogoGastosAntBean );
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}		
 	
	// ----------setter-----------
	public void setReversasOperCajaServicio(ReversasOperCajaServicio reversasOperCajaServicio) {
		this.reversasOperCajaServicio = reversasOperCajaServicio;
	}
	
	
	
}
