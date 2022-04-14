package nomina.controlador;
import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import nomina.bean.CondicionProductoNominaBean;
import nomina.servicio.CondicionProductoNominaServicio;

public class CondicionesProdNomCredGridControlador extends AbstractCommandController {
	CondicionProductoNominaServicio condicionProductoNominaServicio = null;
	private final int PAGE_SIZE = 6;

	public CondicionesProdNomCredGridControlador() {
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
			PagedListHolder listaCondicionesCred = new PagedListHolder(lista);
			listaCondicionesCred.setPageSize(PAGE_SIZE);
			request.getSession().setAttribute("CondicionesProdNomCredGridControlador_lista",listaCondicionesCred);
			return new ModelAndView("nomina/condicionesProdNomCredGridVista", "listaPaginada", listaCondicionesCred);
		} else {
			PagedListHolder listaCondicionesCredVacio = new PagedListHolder();
			return new ModelAndView("nomina/condicionesProdNomCredGridVista", "listaPaginada", listaCondicionesCredVacio);
		}
	} else {
		PagedListHolder listaCondicionesCred = null;
		if(request.getSession().getAttribute("CondicionesProdNomCredGridControlador_lista") != null) {
			listaCondicionesCred = (PagedListHolder) request.getSession().getAttribute("CondicionesProdNomCredGridControlador_lista");

			if ("next".equals(pagina)) {
				listaCondicionesCred.nextPage();
			} else if ("previous".equals(pagina)) {
				listaCondicionesCred.previousPage();
			} else {
				if(pagina.equals("0")) {
					paginaSiguiente = listaCondicionesCred.getPage();
				} else {
					paginaSiguiente = Utileria.convierteEntero(pagina);

					if(paginaSiguiente == 0) {
						paginaSiguiente = listaCondicionesCred.getPage();
					} else {
						paginaSiguiente -= 1;
					}
				}
				listaCondicionesCred.setPage(paginaSiguiente);
			}
		} else {
			listaCondicionesCred = null;
		}

		return new ModelAndView("nomina/condicionesProdNomCredGridVista", "listaPaginada", listaCondicionesCred);
		}
	}


	public CondicionProductoNominaServicio getCondicionProductoNominaServicio() {
		return condicionProductoNominaServicio;
	}

	public void setCondicionProductoNominaServicio(CondicionProductoNominaServicio condicionProductoNominaServicio) {
		this.condicionProductoNominaServicio = condicionProductoNominaServicio;
	}


}
