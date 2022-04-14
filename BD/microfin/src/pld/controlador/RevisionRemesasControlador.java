package pld.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.MensajeTransaccionBean;
import pld.bean.RevisionRemesasBean;
import pld.servicio.RevisionRemesasServicio;

public class RevisionRemesasControlador extends SimpleFormController{
	
	RevisionRemesasServicio revisionRemesasServicio = null;
	
	public RevisionRemesasControlador() {
		setCommandClass(RevisionRemesasBean.class);
		setCommandName("revisionRemesasBean");
	}
		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		revisionRemesasServicio.getRevisionRemesasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	
		RevisionRemesasBean revisionRemesasBean = (RevisionRemesasBean) command;
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
	
		mensaje = revisionRemesasServicio.grabaTransaccion(tipoTransaccion,revisionRemesasBean);
		 																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	// GETTER && SETTER
	public RevisionRemesasServicio getRevisionRemesasServicio() {
		return revisionRemesasServicio;
	}

	public void setRevisionRemesasServicio(RevisionRemesasServicio revisionRemesasServicio) {
		this.revisionRemesasServicio = revisionRemesasServicio;
	}
}
