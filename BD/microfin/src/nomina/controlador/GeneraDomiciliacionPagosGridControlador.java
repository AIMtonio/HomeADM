package nomina.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import nomina.bean.GeneraDomiciliacionPagosBean;
import nomina.servicio.GeneraDomiciliacionPagosServicio;

public class GeneraDomiciliacionPagosGridControlador extends AbstractCommandController {
	GeneraDomiciliacionPagosServicio generaDomiciliacionPagosServicio = null;
	
	public GeneraDomiciliacionPagosGridControlador() {		
		setCommandClass(GeneraDomiciliacionPagosBean.class);
		setCommandName("generaDomiciliacionPagosBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {			
		
		GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean = null;
		
		int tipoLista = 0;
		String page = request.getParameter("page");
		String tipoPaginacion = "";
		if(page== null){
			tipoPaginacion = "Completa";
		}
		if(tipoPaginacion.equalsIgnoreCase("Completa")){

			generaDomiciliacionPagosBean = (GeneraDomiciliacionPagosBean) command;
			tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
			
			List domiciliacionPagosList =  generaDomiciliacionPagosServicio.lista(tipoLista, generaDomiciliacionPagosBean);
			PagedListHolder domicialiaList = new PagedListHolder(domiciliacionPagosList);
			domicialiaList.setPageSize(20);	
			request.getSession().setAttribute("GeneraDomiciliacionPagosGridControlador_domiciliacionPagosList", domicialiaList);
			return new ModelAndView("nomina/domiciliacionPagosGridVista", "listaPaginada", domicialiaList);
		}else{		
			PagedListHolder domicialiaList = null;			
			if(request.getSession().getAttribute("GeneraDomiciliacionPagosGridControlador_domiciliacionPagosList")!= null){
				domicialiaList = (PagedListHolder) request.getSession().getAttribute("GeneraDomiciliacionPagosGridControlador_domiciliacionPagosList");
				if ("next".equals(page)) {
					domicialiaList.nextPage();
				}
				else if ("previous".equals(page)) {
					domicialiaList.previousPage();
				}	
			}else{
				domicialiaList = null;
			}
			
			return new ModelAndView("nomina/domiciliacionPagosGridVista", "listaPaginada", domicialiaList);
		}
	}

	// ============== GETTER & SETTER ===================

	public GeneraDomiciliacionPagosServicio getGeneraDomiciliacionPagosServicio() {
		return generaDomiciliacionPagosServicio;
	}
	
	public void setGeneraDomiciliacionPagosServicio(GeneraDomiciliacionPagosServicio generaDomiciliacionPagosServicio) {
		this.generaDomiciliacionPagosServicio = generaDomiciliacionPagosServicio;
	
	}
	
}