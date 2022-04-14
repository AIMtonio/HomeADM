package fira.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fira.bean.ConceptosInversionAgroBean;
import fira.servicio.ConceptosInversionAgroServicio;

public class ConceptosInversionSolAgroGridControlador extends AbstractCommandController {
	
	ConceptosInversionAgroServicio conceptosInversionAgroServicio =null;

	public ConceptosInversionSolAgroGridControlador() {
		setCommandClass(ConceptosInversionAgroBean.class);
		setCommandName("conceptosInversionAgroBean");
	}
	

	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		ConceptosInversionAgroBean bean = (ConceptosInversionAgroBean)command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));	

		List listaResultado = new ArrayList();
		List parametrosList = conceptosInversionAgroServicio.listaConcetosInv(bean,tipoLista);
		
		listaResultado.add(tipoLista);
		listaResultado.add(parametrosList);
		
		return new ModelAndView("fira/concepInvSolicitaGridVista", "listaResultado", listaResultado);
	}


	public ConceptosInversionAgroServicio getConceptosInversionAgroServicio() {
		return conceptosInversionAgroServicio;
	}


	public void setConceptosInversionAgroServicio(
			ConceptosInversionAgroServicio conceptosInversionAgroServicio) {
		this.conceptosInversionAgroServicio = conceptosInversionAgroServicio;
	}	

	
}
