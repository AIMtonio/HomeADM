package pld.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.CatTipoListaPLDBean;
import pld.servicio.CatTipoListaPLDServicio;

public class CatTipoListaPLDListaControlador extends AbstractCommandController {
	
	CatTipoListaPLDServicio	catTipoListaPLDServicio	= null;
	
	public CatTipoListaPLDListaControlador() {
		setCommandClass(CatTipoListaPLDBean.class);
		setCommandName("catTipoListaPLDBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		CatTipoListaPLDBean catTipoListaPLDBean = (CatTipoListaPLDBean) command;
		List<CatTipoListaPLDBean> catTipoListaPLDBeanList = catTipoListaPLDServicio.lista(tipoLista, catTipoListaPLDBean);
		
		List listaResultado = (List) new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(catTipoListaPLDBeanList);
		return new ModelAndView("pld/catTipoListaPLDListaVista", "listaResultado", listaResultado);
	}
	
	public CatTipoListaPLDServicio getCatTipoListaPLDServicio() {
		return catTipoListaPLDServicio;
	}
	
	public void setCatTipoListaPLDServicio(CatTipoListaPLDServicio catTipoListaPLDServicio) {
		this.catTipoListaPLDServicio = catTipoListaPLDServicio;
	}
	
}
