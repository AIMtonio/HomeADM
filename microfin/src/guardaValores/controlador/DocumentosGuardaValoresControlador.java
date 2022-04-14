package guardaValores.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.MensajeTransaccionBean;
import guardaValores.bean.DocumentosGuardaValoresBean;
import guardaValores.servicio.DocumentosGuardaValoresServicio;

import org.springframework.web.servlet.mvc.SimpleFormController;

public class DocumentosGuardaValoresControlador extends SimpleFormController {
	
	DocumentosGuardaValoresServicio documentosGuardaValoresServicio = null;
	
	public DocumentosGuardaValoresControlador() {
		setCommandClass(DocumentosGuardaValoresBean.class);
		setCommandName("documentosGuardaValoresBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		documentosGuardaValoresServicio.getDocumentosGuardaValoresDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
		DocumentosGuardaValoresBean documentosGuardaValoresBean = (DocumentosGuardaValoresBean) command;
		MensajeTransaccionBean mensajeTransaccionBean = null;
		
		mensajeTransaccionBean = documentosGuardaValoresServicio.grabaTransaccion(tipoTransaccion, documentosGuardaValoresBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensajeTransaccionBean);
	}

	public DocumentosGuardaValoresServicio getDocumentosGuardaValoresServicio() {
		return documentosGuardaValoresServicio;
	}

	public void setDocumentosGuardaValoresServicio(DocumentosGuardaValoresServicio documentosGuardaValoresServicio) {
		this.documentosGuardaValoresServicio = documentosGuardaValoresServicio;
	}

}
