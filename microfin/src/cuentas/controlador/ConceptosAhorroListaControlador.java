package cuentas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.ConceptosAhorroBean;
import cuentas.servicio.ConceptosAhorroServicio;

public class ConceptosAhorroListaControlador extends AbstractCommandController{
	
	ConceptosAhorroServicio conceptosAhorroServicio = null;
		
	public ConceptosAhorroListaControlador() {
			setCommandClass(ConceptosAhorroBean.class);
			setCommandName("conceptosAhorro");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	ConceptosAhorroBean conceptos = (ConceptosAhorroBean) command;
	List conceptosAhorro =	conceptosAhorroServicio.lista(tipoLista, conceptos);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(conceptosAhorro);
			
	return new ModelAndView("cuentas/conceptosAhorroListaVista", "listaResultado", listaResultado);
	}

	public void setConceptosAhorroServicio(
			ConceptosAhorroServicio conceptosAhorroServicio) {
		this.conceptosAhorroServicio = conceptosAhorroServicio;
	}

}
