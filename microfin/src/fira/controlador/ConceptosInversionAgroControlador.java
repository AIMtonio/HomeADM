package fira.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fira.bean.ConceptosInversionAgroBean;
import fira.servicio.ConceptosInversionAgroServicio;
import general.bean.MensajeTransaccionBean;

public class ConceptosInversionAgroControlador extends SimpleFormController {
	
	ConceptosInversionAgroServicio conceptosInversionAgroServicio =null;

	public ConceptosInversionAgroControlador() {
		setCommandClass(ConceptosInversionAgroBean.class);
		setCommandName("conceptosInversionAgroBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
	
		
		conceptosInversionAgroServicio.getConceptosInversionAgroDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ConceptosInversionAgroBean conceptosInversion = (ConceptosInversionAgroBean)command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		String datosGrid = request.getParameter("datosGrid");
		String datosGridSol = request.getParameter("datosGridSol");
		String datosGridOF = request.getParameter("datosGridOF");
		
		MensajeTransaccionBean mensaje = null;
		
		mensaje = conceptosInversionAgroServicio.grabaTransaccion(tipoTransaccion, conceptosInversion, datosGrid, datosGridSol,datosGridOF);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ConceptosInversionAgroServicio getConceptosInversionAgroServicio() {
		return conceptosInversionAgroServicio;
	}

	public void setConceptosInversionAgroServicio(
			ConceptosInversionAgroServicio conceptosInversionAgroServicio) {
		this.conceptosInversionAgroServicio = conceptosInversionAgroServicio;
	}
	
	

}
