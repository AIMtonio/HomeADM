package formularioWeb.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


import formularioWeb.bean.FwProductoCreditoBean;
import formularioWeb.servicio.FWProductosCreditosServicio;

public class FWProductosCreditoListaControlador extends AbstractCommandController {

	FWProductosCreditosServicio fwProductosCreditosServicio = null;

	public FWProductosCreditoListaControlador() {
		setCommandClass(FwProductoCreditoBean.class);
		setCommandName("productosCredito");
	}

	@SuppressWarnings("rawtypes")
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors)throws Exception {
		
		String page = request.getParameter("page");
		int numRegistros = Utileria.convierteEntero(request.getParameter("numRegistros"));
		
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
					0;
		
		if(page.equals("0")){
			List lista = fwProductosCreditosServicio.lista(tipoLista);
			List listaResultado = new ArrayList();
			
			PagedListHolder prodListPag = new PagedListHolder(lista);
			prodListPag.setPageSize(numRegistros);
			
			listaResultado.add(tipoLista);
			listaResultado.add(prodListPag);
			
			request.getSession().setAttribute("sesionGridControl_FwebProdlista", listaResultado);
			return new ModelAndView("formularioWeb/FWProductosCreditoListaVista", "listaResultado", listaResultado);
		}else{
			PagedListHolder prodListPag = null;
			List listaResultado = new ArrayList();
			if(request.getSession().getAttribute("sesionGridControl_FwebProdlista")!= null){
				listaResultado =(List) request.getSession().getAttribute("sesionGridControl_FwebProdlista");
				prodListPag = (PagedListHolder) listaResultado.get(1);
				
				if ("next".equals(page)) {
					prodListPag.nextPage();
				}
				else if ("previous".equals(page)) {
					prodListPag.previousPage();
					prodListPag.getPage();
				}
			}else{
				prodListPag = null;
			}
			listaResultado.add(tipoLista);
			listaResultado.add(prodListPag);
			listaResultado.add("0");
			listaResultado.add("");
			return new ModelAndView ("formularioWeb/FWProductosCreditoListaVista", "listaResultado", listaResultado);
		}
	}

	public FWProductosCreditosServicio getFwProductosCreditosServicio() {
		return fwProductosCreditosServicio;
	}

	public void setFwProductosCreditosServicio(FWProductosCreditosServicio fwProductosCreditosServicio) {
		this.fwProductosCreditosServicio = fwProductosCreditosServicio;
	}
	
}
