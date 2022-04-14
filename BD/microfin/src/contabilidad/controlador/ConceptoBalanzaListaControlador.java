package contabilidad.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.ConceptoBalanzaBean;
import contabilidad.servicio.ConceptoBalanzaServicio;


public class ConceptoBalanzaListaControlador extends AbstractCommandController{
		
	ConceptoBalanzaServicio conceptoBalanzaServicio = null;

	public ConceptoBalanzaListaControlador() {
		setCommandClass(ConceptoBalanzaBean.class);
		setCommandName("conceptoBalanza");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		ConceptoBalanzaBean conceptoBalanza = (ConceptoBalanzaBean) command;
		List conceptoBalanzaList =	conceptoBalanzaServicio.lista(tipoLista, conceptoBalanza);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(conceptoBalanzaList);
		
		return new ModelAndView("contabilidad/conceptoBalanzaListaVista", "listaResultado", listaResultado);
	}
	
	
	public void setConceptoBalanzaServicio(
			ConceptoBalanzaServicio conceptoBalanzaServicio) {
		this.conceptoBalanzaServicio = conceptoBalanzaServicio;
	}

}
