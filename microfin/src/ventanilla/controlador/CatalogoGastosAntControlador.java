package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.CatalogoGastosAntBean;

import ventanilla.servicio.CatalogoGastosAntServicio;


public class CatalogoGastosAntControlador  extends SimpleFormController{

	CatalogoGastosAntServicio catalogoGastosAntServicio =null;

	public CatalogoGastosAntControlador(){
 		setCommandClass(CatalogoGastosAntBean.class);
 		setCommandName("catalogoGastosAntBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {
 		CatalogoGastosAntBean  catalogoGastosAntBean = (CatalogoGastosAntBean) command; 		
 		catalogoGastosAntServicio.getCatalogoGastosAntDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
 								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;
 	
 		MensajeTransaccionBean mensaje = null;
 		mensaje = catalogoGastosAntServicio.grabaTransaccion(tipoTransaccion,catalogoGastosAntBean );
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}		
 	
	// ----------setter-----------
	public void setCatalogoGastosAntServicio(CatalogoGastosAntServicio catalogoGastosAntServicio) {
		this.catalogoGastosAntServicio = catalogoGastosAntServicio;
	}
	
	
	
}
