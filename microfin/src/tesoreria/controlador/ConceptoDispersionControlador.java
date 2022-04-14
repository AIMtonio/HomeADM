package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.ConceptoDispersionBean;
import tesoreria.servicio.ConceptoDispersionServicio;

public class ConceptoDispersionControlador extends SimpleFormController{
	
	ConceptoDispersionServicio conceptoDispersionServicio = null;
	
	public ConceptoDispersionControlador() { 
		setCommandClass(ConceptoDispersionBean.class);
		setCommandName("conceptoDispersion"); 
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errores) throws Exception {
		
		conceptoDispersionServicio.getConceptoDispersionDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		ConceptoDispersionBean conceptoDispBean = (ConceptoDispersionBean) command;
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
		MensajeTransaccionBean mensaje = null;
		mensaje = conceptoDispersionServicio.grabaTransaccion(tipoTransaccion, conceptoDispBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public ConceptoDispersionServicio getConceptoDispersionServicio(){
		return conceptoDispersionServicio;
	}
	public void setConceptoDispersionServicio(ConceptoDispersionServicio conceptoDispersionServicio){
		this.conceptoDispersionServicio = conceptoDispersionServicio;
	}

}
