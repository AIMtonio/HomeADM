package fira.controlador;

import fira.bean.CatFIRAProgEspBean;
import fira.servicio.CatFIRAProgEspServicio;
import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class CatFIRAProgEspControlador extends AbstractCommandController {

	CatFIRAProgEspServicio	catFIRAProgEspServicio	= null;

	public CatFIRAProgEspControlador() {
		setCommandClass(CatFIRAProgEspBean.class);
		setCommandName("catCadenaProductiva");
	}

	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		CatFIRAProgEspBean catCadenaProductivaBean = (CatFIRAProgEspBean) command;

		List<CatFIRAProgEspBean> cadenas = catFIRAProgEspServicio.lista(tipoLista, catCadenaProductivaBean);

		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(cadenas);

		return new ModelAndView("fira/catFIRAProgEspVista", "listaResultado", listaResultado);
	}

	public CatFIRAProgEspServicio getCatFIRAProgEspServicio() {
		return catFIRAProgEspServicio;
	}

	public void setCatFIRAProgEspServicio(CatFIRAProgEspServicio catFIRAProgEspServicio) {
		this.catFIRAProgEspServicio = catFIRAProgEspServicio;
	}

}