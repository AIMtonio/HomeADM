package seguimiento.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import seguimiento.bean.CatTiposGestionBean;
import seguimiento.servicio.CatTiposGestionServicio;

public class CatTiposGestionControlador extends SimpleFormController{
	
	CatTiposGestionServicio catTiposGestionServicio = null;
	public CatTiposGestionControlador(){
		setCommandClass(CatTiposGestionBean.class);
		setCommandName("catTiposGestores");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		CatTiposGestionBean seguimiento = (CatTiposGestionBean)command;
		catTiposGestionServicio.getCatTiposGestionDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = catTiposGestionServicio.grabaTransaccion(tipoTransaccion, seguimiento);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public CatTiposGestionServicio getCatTiposGestionServicio() {
		return catTiposGestionServicio;
	}
	
	public void setCatTiposGestionServicio(
			CatTiposGestionServicio catTiposGestionServicio) {
		this.catTiposGestionServicio = catTiposGestionServicio;
	}
	
}