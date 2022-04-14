package guardaValores.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.MensajeTransaccionBean;
import guardaValores.bean.CatalogoAlmacenesBean;
import guardaValores.servicio.CatalogoAlmacenesServicio;

public class CatalogoAlmacenesControlador extends SimpleFormController {

	CatalogoAlmacenesServicio catalogoAlmacenesServicio = null;

	public CatalogoAlmacenesControlador() {
		setCommandClass(CatalogoAlmacenesBean.class);
		setCommandName("catalogoAlmacenesBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		catalogoAlmacenesServicio.getCatalogoAlmacenesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
		CatalogoAlmacenesBean catalogoAlmacenesBean = (CatalogoAlmacenesBean) command;
		MensajeTransaccionBean mensajeTransaccionBean = null;
		mensajeTransaccionBean = catalogoAlmacenesServicio.grabaTransaccion(tipoTransaccion, catalogoAlmacenesBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensajeTransaccionBean);
	}

	public CatalogoAlmacenesServicio getCatalogoAlmacenesServicio() {
		return catalogoAlmacenesServicio;
	}

	public void setCatalogoAlmacenesServicio(CatalogoAlmacenesServicio catalogoAlmacenesServicio) {
		this.catalogoAlmacenesServicio = catalogoAlmacenesServicio;
	}

}
