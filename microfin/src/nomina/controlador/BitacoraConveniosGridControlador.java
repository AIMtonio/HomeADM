package nomina.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import herramientas.Utileria;
import nomina.bean.ConvenioNominaBean;
//import nomina.bean.TipoDocNominaBean;
import nomina.servicio.BitacoraConveniosNominaServicio;

public class BitacoraConveniosGridControlador extends AbstractCommandController {
	
	private BitacoraConveniosNominaServicio bitacoraConveniosNominaServicio;
	
	public BitacoraConveniosGridControlador() {
		// TODO Auto-generated constructor stub
		setCommandClass(ConvenioNominaBean.class);
		setCommandName("convenioNominaBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		String institNominaID = request.getParameter("institNominaID");
		String convenioNominaID = request.getParameter("convenioNominaID");
		String fechaInicio = request.getParameter("fechaInicio");
		String fechaFin = request.getParameter("fechaFin");
		
		ConvenioNominaBean convenioNominaBean = null;
		int paginaSiguiente = 0;
		int tipoLista = 0;
		String page = request.getParameter("page");
		String tipoPaginacion = "";
		if(page == null) {
			tipoPaginacion = "Completa";
		}

		if(tipoPaginacion.equalsIgnoreCase("Completa")) {
			
			convenioNominaBean = (ConvenioNominaBean) command;
			tipoLista = (request.getParameter("tipoLista") != null) ? Utileria.convierteEntero(request.getParameter("tipoLista")) : 0;
			List<?> lista = bitacoraConveniosNominaServicio.lista(tipoLista, convenioNominaBean);
			
			if(lista != null) {
				PagedListHolder productList = new PagedListHolder(lista);
				productList.setPageSize(50);
				request.getSession().setAttribute("listaAfilia", productList);
				return new ModelAndView("nomina/bitacoraConveniosGridRepVista", "listaPaginada", productList);
			} else {
				PagedListHolder productListVacio = new PagedListHolder();
				return new ModelAndView("nomina/bitacoraConveniosGridRepVista", "listaPaginada", productListVacio);
			}
		
		
		} else {
			PagedListHolder productList = null;
			convenioNominaBean = (ConvenioNominaBean) command;

			if(request.getSession().getAttribute("listaAfilia") != null) {
				productList = (PagedListHolder) request.getSession().getAttribute("listaAfilia");

				if ("next".equals(page)) {
					productList.nextPage();
				} else if ("previous".equals(page)) {
					productList.previousPage();
					productList.getPage();

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

			return new ModelAndView("nomina/bitacoraConveniosGridRepVista", "listaPaginada", productList);
		}
	}

	public BitacoraConveniosNominaServicio getBitacoraConveniosNominaServicio() {
		return bitacoraConveniosNominaServicio;
	}

	public void setBitacoraConveniosNominaServicio(
			BitacoraConveniosNominaServicio bitacoraConveniosNominaServicio) {
		this.bitacoraConveniosNominaServicio = bitacoraConveniosNominaServicio;
	}

}