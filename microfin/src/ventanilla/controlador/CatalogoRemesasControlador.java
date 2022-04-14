package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.CatalogoRemesasBean;
import ventanilla.servicio.CatalogoRemesasServicio;

public class CatalogoRemesasControlador extends SimpleFormController {
	CatalogoRemesasServicio catalogoRemesasServicio = null;

	public CatalogoRemesasControlador(){
		setCommandClass(CatalogoRemesasBean.class);
		setCommandName("catalogoRemesasBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception{
		
		CatalogoRemesasBean catalogoRemesas = (CatalogoRemesasBean) command;
		catalogoRemesasServicio.getCatalogoRemesasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;
		MensajeTransaccionBean mensaje = null;
		mensaje = catalogoRemesasServicio.grabaTransaccion(tipoTransaccion, catalogoRemesas , request);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CatalogoRemesasServicio getCatalogoRemesasServicio() {
		return catalogoRemesasServicio;
	}

	public void setCatalogoRemesasServicio(
			CatalogoRemesasServicio catalogoRemesasServicio) {
		this.catalogoRemesasServicio = catalogoRemesasServicio;
	}

	
	
	
}
