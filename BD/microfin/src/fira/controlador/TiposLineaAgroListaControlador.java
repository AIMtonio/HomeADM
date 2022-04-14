package fira.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fira.bean.TiposLineasAgroBean;
import fira.servicio.TiposLineasAgroServicio;

public class TiposLineaAgroListaControlador extends AbstractCommandController {

	TiposLineasAgroServicio tiposLineasAgroServicio = null;

	public TiposLineaAgroListaControlador() {
		setCommandClass(TiposLineasAgroBean.class);
		setCommandName("tiposLineasAgroBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		TiposLineasAgroBean tiposLineasAgroBean = (TiposLineasAgroBean) command;
		List tiposLineasAgro = tiposLineasAgroServicio.lista(tipoLista,tiposLineasAgroBean);

		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(tiposLineasAgro);

		return new ModelAndView("fira/tiposLineaAgroListaVista", "listaResultado", listaResultado);
	}

	public TiposLineasAgroServicio getTiposLineasAgroServicio() {
		return tiposLineasAgroServicio;
	}

	public void setTiposLineasAgroServicio(TiposLineasAgroServicio tiposLineasAgroServicio) {
		this.tiposLineasAgroServicio = tiposLineasAgroServicio;
	}
}
