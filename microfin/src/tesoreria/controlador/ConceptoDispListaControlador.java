package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.ConceptoDispersionBean;
import tesoreria.servicio.ConceptoDispersionServicio;

public class ConceptoDispListaControlador extends AbstractCommandController{

	ConceptoDispersionServicio conceptoDispersionServicio = null;
	
	public ConceptoDispListaControlador() { 
		setCommandClass(ConceptoDispersionBean.class);
		setCommandName("conceptoDispersion"); 
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {


	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	ConceptoDispersionBean conceptoDisp = (ConceptoDispersionBean) command;
	List conceptoDispList =	conceptoDispersionServicio.lista(tipoLista, conceptoDisp);

	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(conceptoDispList);

	return new ModelAndView("tesoreria/conceptoDispListaVista", "listaResultado", listaResultado);
	}
	
	public void setConceptoDispersionServicio(ConceptoDispersionServicio conceptoDispersionServicio){
		this.conceptoDispersionServicio = conceptoDispersionServicio;
	}

}
