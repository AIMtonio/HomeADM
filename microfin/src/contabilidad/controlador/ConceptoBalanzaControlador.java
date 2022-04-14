package contabilidad.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.ConceptoBalanzaBean;
import contabilidad.servicio.ConceptoBalanzaServicio;

public class ConceptoBalanzaControlador extends SimpleFormController{
	
	ConceptoBalanzaServicio conceptoBalanzaServicio = null;

	public ConceptoBalanzaControlador() {
		setCommandClass(ConceptoBalanzaBean.class);
		setCommandName("conceptoBalanza");
}
	

protected ModelAndView onSubmit(HttpServletRequest request,
		HttpServletResponse response,
		Object command,
		BindException errors) throws Exception {
	
	conceptoBalanzaServicio.getConceptoBalanzaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	
	ConceptoBalanzaBean conBalanza = (ConceptoBalanzaBean) command;
	int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
	

	MensajeTransaccionBean mensaje = null;
	mensaje = conceptoBalanzaServicio.grabaTransaccion(tipoTransaccion,conBalanza);
									
	return new ModelAndView(getSuccessView(), "mensaje", mensaje);
}
	public void setConceptoBalanzaServicio(ConceptoBalanzaServicio conceptoBalanzaServicio) {
		this.conceptoBalanzaServicio = conceptoBalanzaServicio;
}

}
