package contabilidad.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.ConceptoContableBean;
import contabilidad.servicio.ConceptoContableServicio;

public class ConceptoContableControlador extends SimpleFormController {

	ConceptoContableServicio conceptoContableServicio = null;
	
	public ConceptoContableControlador() {
		setCommandClass(ConceptoContableBean.class);
		setCommandName("conceptoContable");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
		
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		ConceptoContableBean conceptoContableBean = (ConceptoContableBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = conceptoContableServicio.grabaTransaccion(tipoTransaccion, conceptoContableBean);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setConceptoContableServicio(
			ConceptoContableServicio conceptoContableServicio) {
		this.conceptoContableServicio = conceptoContableServicio;
	}
	
}
