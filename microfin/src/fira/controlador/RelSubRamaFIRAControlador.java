package fira.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fira.bean.RelSubRamaFIRABean;
import fira.servicio.RelSubRamaFIRAServicio;

public class RelSubRamaFIRAControlador extends AbstractCommandController {

	RelSubRamaFIRAServicio	relSubRamaFIRAServicio	= null;

	public RelSubRamaFIRAControlador() {
		setCommandClass(RelSubRamaFIRABean.class);
		setCommandName("relSubRamaFIRABean");
	}

	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		RelSubRamaFIRABean relacion = (RelSubRamaFIRABean) command;

		List<RelSubRamaFIRABean> relaciones = relSubRamaFIRAServicio.lista(tipoLista, relacion);

		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(relaciones);

		return new ModelAndView("fira/relSubRamaFIRAVista", "listaResultado", listaResultado);
	}

	public RelSubRamaFIRAServicio getRelSubRamaFIRAServicio() {
		return relSubRamaFIRAServicio;
	}

	public void setRelSubRamaFIRAServicio(RelSubRamaFIRAServicio relSubRamaFIRAServicio) {
		this.relSubRamaFIRAServicio = relSubRamaFIRAServicio;
	}

}
