package fira.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fira.bean.RelActividadFIRABean;
import fira.servicio.RelActividadFIRAServicio;

public class RelActividadFIRAControlador extends AbstractCommandController {
	RelActividadFIRAServicio	relActividadFIRAServicio	= null;

	public RelActividadFIRAControlador() {
		setCommandClass(RelActividadFIRABean.class);
		setCommandName("relSubRamaFIRABean");
	}

	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		RelActividadFIRABean relacion = (RelActividadFIRABean) command;

		List<RelActividadFIRABean> relaciones = relActividadFIRAServicio.lista(tipoLista, relacion);

		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(relaciones);

		return new ModelAndView("fira/relActividadFIRAVista", "listaResultado", listaResultado);
	}

	public RelActividadFIRAServicio getRelActividadFIRAServicio() {
		return relActividadFIRAServicio;
	}

	public void setRelActividadFIRAServicio(RelActividadFIRAServicio relActividadFIRAServicio) {
		this.relActividadFIRAServicio = relActividadFIRAServicio;
	}

}
