package fira.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fira.bean.CatCadenaProductivaBean;
import fira.servicio.CatCadenaProductivaServicio;

public class CatCadenaProductivaControlador extends AbstractCommandController {

	CatCadenaProductivaServicio	catCadenaProductivaServicio	= null;

	public CatCadenaProductivaControlador() {
		setCommandClass(CatCadenaProductivaBean.class);
		setCommandName("catCadenaProductiva");
	}

	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		CatCadenaProductivaBean catCadenaProductivaBean = (CatCadenaProductivaBean) command;

		List<CatCadenaProductivaBean> cadenas = catCadenaProductivaServicio.lista(tipoLista, catCadenaProductivaBean);

		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(cadenas);

		return new ModelAndView("fira/catCadenaProductivaVista", "listaResultado", listaResultado);
	}

	public CatCadenaProductivaServicio getCatCadenaProductivaServicio() {
		return catCadenaProductivaServicio;
	}

	public void setCatCadenaProductivaServicio(CatCadenaProductivaServicio catCadenaProductivaServicio) {
		this.catCadenaProductivaServicio = catCadenaProductivaServicio;
	}

}
