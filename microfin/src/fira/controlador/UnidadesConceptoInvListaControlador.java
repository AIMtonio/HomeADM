package fira.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fira.bean.UniConceptosInvAgroBean;
import fira.servicio.UniConceptosInvAgroServicio;

public class UnidadesConceptoInvListaControlador extends AbstractCommandController {

	UniConceptosInvAgroServicio uniConceptosInvAgroServicio = null;

	public UnidadesConceptoInvListaControlador() {
		setCommandClass(UniConceptosInvAgroBean.class);
		setCommandName("uniConceptosInvAgroBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		UniConceptosInvAgroBean bean = (UniConceptosInvAgroBean) command;
		List conceptos = uniConceptosInvAgroServicio.lista(tipoLista,bean);

		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(conceptos);

		return new ModelAndView("fira/unidadesConceptoInvListaVista", "listaResultado", listaResultado);
	}

	public UniConceptosInvAgroServicio getUniConceptosInvAgroServicio() {
		return uniConceptosInvAgroServicio;
	}

	public void setUniConceptosInvAgroServicio(UniConceptosInvAgroServicio uniConceptosInvAgroServicio) {
		this.uniConceptosInvAgroServicio = uniConceptosInvAgroServicio;
	}


}
