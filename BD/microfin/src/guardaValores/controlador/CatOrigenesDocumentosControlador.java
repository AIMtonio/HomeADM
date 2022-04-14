package guardaValores.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import guardaValores.bean.CatOrigenesDocumentosBean;
import guardaValores.servicio.CatOrigenesDocumentosServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class CatOrigenesDocumentosControlador extends SimpleFormController {
	
	CatOrigenesDocumentosServicio catOrigenesDocumentosServicio = null;
	
	public CatOrigenesDocumentosControlador() {
		setCommandClass(CatOrigenesDocumentosBean.class);
		setCommandName("catOrigenesDocumentosBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		catOrigenesDocumentosServicio.getCatOrigenesDocumentosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
		
		CatOrigenesDocumentosBean catOrigenesDocumentosBean = (CatOrigenesDocumentosBean) command;
		MensajeTransaccionBean mensajeTransaccionBean = null;
		mensajeTransaccionBean = catOrigenesDocumentosServicio.grabaTransaccion(tipoTransaccion, catOrigenesDocumentosBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensajeTransaccionBean);
	}

	public CatOrigenesDocumentosServicio getCatOrigenesDocumentosServicio() {
		return catOrigenesDocumentosServicio;
	}

	public void setCatOrigenesDocumentosServicio(
			CatOrigenesDocumentosServicio catOrigenesDocumentosServicio) {
		this.catOrigenesDocumentosServicio = catOrigenesDocumentosServicio;
	}

}
