package seguimiento.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import seguimiento.bean.CatSegtoCategoriasBean;
import seguimiento.servicio.CatSegtoCategoriasServicio;

public class CatSegtoCategoriasControlador extends SimpleFormController{
	
	CatSegtoCategoriasServicio catSegtoCategoriasServicio = null;
	public CatSegtoCategoriasControlador(){
		setCommandClass(CatSegtoCategoriasBean.class);
		setCommandName("catSegtoCategorias");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		CatSegtoCategoriasBean categoriasBean = (CatSegtoCategoriasBean)command;
		catSegtoCategoriasServicio.getCatSegtoCategoriasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = catSegtoCategoriasServicio.grabaTransaccion(tipoTransaccion, categoriasBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public CatSegtoCategoriasServicio getCatSegtoCategoriasServicio() {
		return catSegtoCategoriasServicio;
	}
	
	public void setCatSegtoCategoriasServicio(
			CatSegtoCategoriasServicio catSegtoCategoriasServicio) {
		this.catSegtoCategoriasServicio = catSegtoCategoriasServicio;
	}	
}