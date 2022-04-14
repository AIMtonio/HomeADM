package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.CatalogoServBean;
import ventanilla.servicio.CatalogoServServicio;

public class CatalogoServControlador  extends SimpleFormController{

	CatalogoServServicio catalogoServServicio =null;

	public CatalogoServControlador(){
 		setCommandClass(CatalogoServBean.class);
 		setCommandName("catalogoServBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {
 		CatalogoServBean  catalogoServBean = (CatalogoServBean) command; 		
 		catalogoServServicio.getCatalogoServDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
 								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;
 	
 		MensajeTransaccionBean mensaje = null;
 		mensaje = catalogoServServicio.grabaTransaccion(tipoTransaccion,catalogoServBean );
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}		
 	
	// ----------setter-----------
	public void setCatalogoServServicio(CatalogoServServicio catalogoServServicio) {
		this.catalogoServServicio = catalogoServServicio;
	}
	
	
	
}
