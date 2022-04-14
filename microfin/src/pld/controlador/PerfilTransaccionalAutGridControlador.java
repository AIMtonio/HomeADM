package pld.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.PerfilTransaccionalBean;
import pld.servicio.PerfilTransaccionalServicio;

public class PerfilTransaccionalAutGridControlador extends AbstractCommandController {
	PerfilTransaccionalServicio	perfilTransaccionalServicio	= null;
	
	public PerfilTransaccionalAutGridControlador() {
		setCommandClass(PerfilTransaccionalBean.class);
		setCommandName("perfilTransaccional");
	}
	
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		PerfilTransaccionalBean bean = (PerfilTransaccionalBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		String pagina = request.getParameter("pagina");
		String tipoPaginacion ="";
		List listaResultado = (List) new ArrayList();
		List<PerfilTransaccionalBean> lista = null;
		PagedListHolder pageListHolder = null;
		
		if(pagina == null){
			tipoPaginacion= "Completa";
		}
		
		if(tipoPaginacion.equalsIgnoreCase("Completa")){
			lista = perfilTransaccionalServicio.lista(tipoLista, bean);
			 pageListHolder = new PagedListHolder(lista);
		}else{
			if (request.getSession().getAttribute("perfilTransaccional") != null) {
				listaResultado = (List) request.getSession().getAttribute("perfilTransaccional");
				pageListHolder = (PagedListHolder) listaResultado.get(1);
				
				
				if ("siguiente".equals(pagina)) {
					pageListHolder.nextPage();
				}
				else if ("anterior".equals(pagina)) {
					pageListHolder.previousPage();
				}
			}
		}
		
		pageListHolder.setPageSize(50);
		listaResultado.add(tipoLista);
		listaResultado.add(pageListHolder);
		request.getSession().setAttribute("perfilTransaccional", listaResultado);
		return new ModelAndView("pld/perfilTransaccionalAutGridVista", "listaResultado", listaResultado);
	}

	public PerfilTransaccionalServicio getPerfilTransaccionalServicio() {
		return perfilTransaccionalServicio;
	}

	public void setPerfilTransaccionalServicio(PerfilTransaccionalServicio perfilTransaccionalServicio) {
		this.perfilTransaccionalServicio = perfilTransaccionalServicio;
	}

}
