package pld.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.CatTipoListaPLDBean;
import pld.servicio.CatTipoListaPLDServicio;

public class CatTipoListaPLDControlador extends SimpleFormController {
	
	CatTipoListaPLDServicio	catTipoListaPLDServicio	= null;
	
	public CatTipoListaPLDControlador() {
		setCommandClass(CatTipoListaPLDBean.class);
		setCommandName("catTipoListaPLDBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		try {
			int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
			
			catTipoListaPLDServicio.getCatTipoListaPLDDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			CatTipoListaPLDBean catTipoListaPLDBean = (CatTipoListaPLDBean) command;
			
			mensaje = catTipoListaPLDServicio.grabaTransaccion(tipoTransaccion, catTipoListaPLDBean);
		} catch (Exception ex) {
			ex.printStackTrace();
			mensaje=new MensajeTransaccionBean();
			mensaje.setNumero(800);
			mensaje.setDescripcion("No se pudo realizar la operación ha ocurrido un error.");
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public CatTipoListaPLDServicio getCatTipoListaPLDServicio() {
		return catTipoListaPLDServicio;
	}
	
	public void setCatTipoListaPLDServicio(CatTipoListaPLDServicio catTipoListaPLDServicio) {
		this.catTipoListaPLDServicio = catTipoListaPLDServicio;
	}
}
