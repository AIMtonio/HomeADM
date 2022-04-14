package pld.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.ArchAdjuntosPLDBean;
import pld.bean.PerfilTransaccionalBean;
import pld.servicio.PerfilTransaccionalServicio;

public class PerfilTransaccionalGridControlador extends AbstractCommandController {
	PerfilTransaccionalServicio	perfilTransaccionalServicio	= null;
	
	public PerfilTransaccionalGridControlador() {
		setCommandClass(PerfilTransaccionalBean.class);
		setCommandName("perfilTransaccional");
	}
	
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		PerfilTransaccionalBean bean = (PerfilTransaccionalBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		List<PerfilTransaccionalBean> lista = perfilTransaccionalServicio.lista(tipoLista, bean);
		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(lista);
		return new ModelAndView("pld/perfilTransaccionalGridVista", "listaResultado", listaResultado);
	}

	public PerfilTransaccionalServicio getPerfilTransaccionalServicio() {
		return perfilTransaccionalServicio;
	}

	public void setPerfilTransaccionalServicio(PerfilTransaccionalServicio perfilTransaccionalServicio) {
		this.perfilTransaccionalServicio = perfilTransaccionalServicio;
	}

}
