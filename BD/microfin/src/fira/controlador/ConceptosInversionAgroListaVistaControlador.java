package fira.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ClienteBean;

import fira.bean.ConceptosInversionAgroBean;
import fira.servicio.ConceptosInversionAgroServicio;

public class ConceptosInversionAgroListaVistaControlador extends AbstractCommandController {
	
	ConceptosInversionAgroServicio conceptosInversionAgroServicio =null;
	
	public ConceptosInversionAgroListaVistaControlador() {
		// TODO Auto-generated constructor stub
		setCommandClass(ConceptosInversionAgroBean.class);
		setCommandName("conceptosInversionAgroBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		ConceptosInversionAgroBean bean = (ConceptosInversionAgroBean) command;
		List conceptos =	conceptosInversionAgroServicio.listaConceptosInversion(bean,tipoLista);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(conceptos);
		
		return new ModelAndView("fira/conceptosInvListaVista", "listaResultado",listaResultado);
	}

	public ConceptosInversionAgroServicio getConceptosInversionAgroServicio() {
		return conceptosInversionAgroServicio;
	}

	public void setConceptosInversionAgroServicio(
			ConceptosInversionAgroServicio conceptosInversionAgroServicio) {
		this.conceptosInversionAgroServicio = conceptosInversionAgroServicio;
	}

}
