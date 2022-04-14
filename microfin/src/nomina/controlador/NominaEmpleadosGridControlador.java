package nomina.controlador;

import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.EmpleadoNominaBean;
import nomina.servicio.NominaEmpleadosServicio;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class NominaEmpleadosGridControlador extends AbstractCommandController {
	NominaEmpleadosServicio nominaEmpleadosServicio = null;

	public NominaEmpleadosGridControlador() {
		setCommandClass(EmpleadoNominaBean.class);
		setCommandName("empleadoNominaBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		EmpleadoNominaBean empleadoNominaBean = null;
		int paginaSiguiente = 0;
		int tipoLista = 0;
		String page = request.getParameter("page");
		String tipoPaginacion = "";
		if(page == null) {
			tipoPaginacion = "Completa";
		}

		if(tipoPaginacion.equalsIgnoreCase("Completa")) {
			empleadoNominaBean = (EmpleadoNominaBean) command;
			tipoLista = (request.getParameter("tipoLista") != null) ? Utileria.convierteEntero(request.getParameter("tipoLista")) : 0;
			List<?> lista = nominaEmpleadosServicio.lista(tipoLista, empleadoNominaBean);
			if(lista != null) {
				PagedListHolder productList = new PagedListHolder(lista);
				productList.setPageSize(25);
				request.getSession().setAttribute("NominaEmpleadosGridControlador_lista", productList);
				return new ModelAndView("nomina/relacionClientesEmpresaNominaGridVista", "listaPaginada", productList);
			} else {
				PagedListHolder productListVacio = new PagedListHolder();
				return new ModelAndView("nomina/relacionClientesEmpresaNominaGridVista", "listaPaginada", productListVacio);
			}
		} else {
			PagedListHolder productList = null;
			if(request.getSession().getAttribute("TipoDocNominaGridControlador_lista") != null) {
				productList = (PagedListHolder) request.getSession().getAttribute("NominaEmpleadosGridControlador_lista");

				if ("next".equals(page)) {
					productList.nextPage();
				} else if ("previous".equals(page)) {
					productList.previousPage();
				} else {
					if(page.equals("0")) {
						paginaSiguiente = productList.getPage();
					} else {
						paginaSiguiente = Utileria.convierteEntero(page);

						if(paginaSiguiente == 0) {
							paginaSiguiente = productList.getPage();
						} else {
							paginaSiguiente -= 1;
						}
					}
					productList.setPage(paginaSiguiente);
				}
			} else {
				productList = null;
			}

			return new ModelAndView("nomina/relacionClientesEmpresaNominaGridVista", "listaPaginada", productList);
		}
	}

	public NominaEmpleadosServicio getNominaEmpleadosServicio() {
		return nominaEmpleadosServicio;
	}

	public void setNominaEmpleadosServicio(
			NominaEmpleadosServicio nominaEmpleadosServicio) {
		this.nominaEmpleadosServicio = nominaEmpleadosServicio;
	}
}
