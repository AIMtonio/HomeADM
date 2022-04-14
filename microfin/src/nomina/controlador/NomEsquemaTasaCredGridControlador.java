package nomina.controlador;

import herramientas.Utileria;
import nomina.bean.CondicionProductoNominaBean;
import nomina.servicio.CondicionProductoNominaServicio;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class NomEsquemaTasaCredGridControlador extends AbstractCommandController {
	CondicionProductoNominaServicio condicionProductoNominaServicio = null;
	private final int PAGE_SIZE = 10000;
	
	public NomEsquemaTasaCredGridControlador() {
		setCommandClass(CondicionProductoNominaBean.class);
		setCommandName("condicionProductoNominaBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		CondicionProductoNominaBean condicionProductoNominaBean = null;
		int paginaSiguiente = 0;
		int tipoLista = 0;
		int numeroLista = 0;
		String pagina = request.getParameter("page");
		String tipoPaginacion = "";
		if(pagina == null) {
			tipoPaginacion = "Completa";
		}

		if(tipoPaginacion.equalsIgnoreCase("Completa")) {
			condicionProductoNominaBean = (CondicionProductoNominaBean) command;
			tipoLista = (request.getParameter("tipoLista") != null) ? Utileria.convierteEntero(request.getParameter("tipoLista")) : 0;
			numeroLista = (request.getParameter("numeroLista") != null) ? Utileria.convierteEntero(request.getParameter("numeroLista")) : 0;
			List<?> lista = condicionProductoNominaServicio.lista(tipoLista, condicionProductoNominaBean);
			if(lista != null) {
				PagedListHolder listaEsquemasTasa = new PagedListHolder(lista);
				listaEsquemasTasa.setPageSize(PAGE_SIZE);
				request.getSession().setAttribute("NomEsquemaTasaCredGridControlador_lista",listaEsquemasTasa);
				return new ModelAndView("nomina/nomEsquemaTasaCredGridVista", "listaPaginada", listaEsquemasTasa);
			} else {
				PagedListHolder listaEsquemasTasaVacio = new PagedListHolder();
				return new ModelAndView("nomina/nomEsquemaTasaCredGridVista", "listaPaginada", listaEsquemasTasaVacio);
			}
		} else {
			PagedListHolder listaEsquemasTasa = null;
			if(request.getSession().getAttribute("NomEsquemaTasaCredGridControlador_lista") != null) {
				listaEsquemasTasa = (PagedListHolder) request.getSession().getAttribute("NomEsquemaTasaCredGridControlador_lista");

				if ("next".equals(pagina)) {
					listaEsquemasTasa.nextPage();
				} else if ("previous".equals(pagina)) {
					listaEsquemasTasa.previousPage();
				} else {
					if(pagina.equals("0")) {
						paginaSiguiente = listaEsquemasTasa.getPage();
					} else {
						paginaSiguiente = Utileria.convierteEntero(pagina);

						if(paginaSiguiente == 0) {
							paginaSiguiente = listaEsquemasTasa.getPage();
						} else {
							paginaSiguiente -= 1;
						}
					}
					listaEsquemasTasa.setPage(paginaSiguiente);
				}
			} else {
				listaEsquemasTasa = null;
			}

			return new ModelAndView("nomina/nomEsquemaTasaCredGridVista", "listaPaginada", listaEsquemasTasa);
		}
		
		
	}

	public CondicionProductoNominaServicio getCondicionProductoNominaServicio() {
		return condicionProductoNominaServicio;
	}

	public void setCondicionProductoNominaServicio(
			CondicionProductoNominaServicio condicionProductoNominaServicio) {
		this.condicionProductoNominaServicio = condicionProductoNominaServicio;
	}


}
