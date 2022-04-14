package soporte.controlador;

import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.EdoCtaEnvioCorreoBean;
import soporte.servicio.EdoCtaEnvioCorreoServicio;

public class EdoCtaEnvioCorreoGridControlador extends AbstractCommandController {
	
	EdoCtaEnvioCorreoServicio edoCtaEnvioCorreoServicio = null;

	public EdoCtaEnvioCorreoGridControlador() 
	{
		setCommandClass(EdoCtaEnvioCorreoBean.class);
		setCommandName("edoCtaEnvioCorreoBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean = null;
		int paginaSiguiente=0;
		int tipoLista = 0;
		String page = request.getParameter("page");
		String tipoPaginacion = "";
		if(page== null){
			tipoPaginacion = "Completa";
		}
		
		if(tipoPaginacion.equalsIgnoreCase("Completa")){
			edoCtaEnvioCorreoBean = (EdoCtaEnvioCorreoBean) command;
			tipoLista = (request.getParameter("tipoLista")!=null)?
					Utileria.convierteEntero(request.getParameter("tipoLista")):
					0;
			List edoCtaEnvioCorreoBeanList = edoCtaEnvioCorreoServicio.lista(tipoLista, edoCtaEnvioCorreoBean);
			if(edoCtaEnvioCorreoBeanList != null){
				PagedListHolder productList = new PagedListHolder(edoCtaEnvioCorreoBeanList);
				productList.setPageSize(25);
				request.getSession().setAttribute("EdoCtaEnvioCorreoGridControlador_listaClientesEdoCta", productList);
				return new ModelAndView("soporte/edoCtaEnvioCorreoGridVista", "listaPaginada", productList);
			}else{
				PagedListHolder productListVacio = new PagedListHolder();
				return new ModelAndView("soporte/edoCtaEnvioCorreoGridVista", "listaPaginada",productListVacio);
			}
		}else{		
			PagedListHolder productList = null;
			if(request.getSession().getAttribute("EdoCtaEnvioCorreoGridControlador_listaClientesEdoCta")!= null){
				productList = (PagedListHolder) request.getSession().getAttribute("EdoCtaEnvioCorreoGridControlador_listaClientesEdoCta");
				
				if ("next".equals(page)) {
					productList.nextPage();
				}
				else if ("previous".equals(page)) {
					productList.previousPage();
				} else{
					if(page.equals("0")){
						paginaSiguiente = productList.getPage();
					}else{
					 	paginaSiguiente = Utileria.convierteEntero(page);
					 	
					 	if(paginaSiguiente == 0){
					 		paginaSiguiente = productList.getPage();
					 	} else{
					 		paginaSiguiente -= 1;
					 	}
					}
					productList.setPage(paginaSiguiente);
				}
			}else{
				productList = null;
			}
						
			return new ModelAndView("soporte/edoCtaEnvioCorreoGridVista", "listaPaginada", productList);
		}
	}

	public EdoCtaEnvioCorreoServicio getEdoCtaEnvioCorreoServicio() {
		return edoCtaEnvioCorreoServicio;
	}

	public void setEdoCtaEnvioCorreoServicio(
			EdoCtaEnvioCorreoServicio edoCtaEnvioCorreoServicio) {
		this.edoCtaEnvioCorreoServicio = edoCtaEnvioCorreoServicio;
	}
}
