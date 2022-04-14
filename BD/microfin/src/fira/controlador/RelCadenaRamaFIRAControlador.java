package fira.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fira.bean.RelCadenaRamaFIRABean;
import fira.servicio.RelCadenaRamaFIRAServicio;

public class RelCadenaRamaFIRAControlador extends AbstractCommandController {

	RelCadenaRamaFIRAServicio	relCadenaRamaFIRAServicio	= null;

	public RelCadenaRamaFIRAControlador() {
		setCommandClass(RelCadenaRamaFIRABean.class);
		setCommandName("relCadenaRamaFIRA");
	}

	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		RelCadenaRamaFIRABean relCadenaRamaFIRABean = (RelCadenaRamaFIRABean) command;

		List<RelCadenaRamaFIRABean> relaciones = relCadenaRamaFIRAServicio.lista(tipoLista, relCadenaRamaFIRABean);

		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(relaciones);

		return new ModelAndView("fira/relCadenaRamaFIRAVista", "listaResultado", listaResultado);
	}

	public RelCadenaRamaFIRAServicio getRelCadenaRamaFIRAServicio() {
		return relCadenaRamaFIRAServicio;
	}

	public void setRelCadenaRamaFIRAServicio(RelCadenaRamaFIRAServicio relCadenaRamaFIRAServicio) {
		this.relCadenaRamaFIRAServicio = relCadenaRamaFIRAServicio;
	}

}
