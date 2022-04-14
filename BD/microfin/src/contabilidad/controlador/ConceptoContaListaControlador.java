package contabilidad.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.ConceptoContableBean;
import contabilidad.servicio.ConceptoContableServicio;

public class ConceptoContaListaControlador extends AbstractCommandController {

	ConceptoContableServicio conceptoContableServicio = null;
	
	public ConceptoContaListaControlador() {
		setCommandClass(ConceptoContableBean.class);
		setCommandName("conceptoContable");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
			
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
	
		ConceptoContableBean conceptoContableBean = (ConceptoContableBean) command;
		List ocupaciones =	conceptoContableServicio.lista(tipoLista, conceptoContableBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(ocupaciones);
				
		return new ModelAndView("contabilidad/conceptoContableListaVista", "listaResultado", listaResultado);											  
	}

	public void setConceptoContableServicio(
			ConceptoContableServicio conceptoContableServicio) {
		this.conceptoContableServicio = conceptoContableServicio;
	}	
}