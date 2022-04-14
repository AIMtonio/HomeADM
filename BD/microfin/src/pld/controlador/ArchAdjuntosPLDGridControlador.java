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
import pld.servicio.ArchAdjuntosPLDServicio;

public class ArchAdjuntosPLDGridControlador extends AbstractCommandController {
	ArchAdjuntosPLDServicio	archAdjuntosPLDServicio	= null;
	
	public ArchAdjuntosPLDGridControlador() {
		setCommandClass(ArchAdjuntosPLDBean.class);
		setCommandName("archAdjuntosPLD");
	}
	
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		ArchAdjuntosPLDBean archAdjuntosPLDBean = (ArchAdjuntosPLDBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		List<ArchAdjuntosPLDBean> lista = archAdjuntosPLDServicio.lista(tipoLista, archAdjuntosPLDBean);
		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(lista);
		return new ModelAndView("pld/archAdjuntosPLDGridVista", "listaResultado", listaResultado);
	}
	
	public ArchAdjuntosPLDServicio getArchAdjuntosPLDServicio() {
		return archAdjuntosPLDServicio;
	}
	
	public void setArchAdjuntosPLDServicio(ArchAdjuntosPLDServicio archAdjuntosPLDServicio) {
		this.archAdjuntosPLDServicio = archAdjuntosPLDServicio;
	}
	
}