package credito.controlador;

import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import credito.bean.CreditosMovsBean;
import credito.servicio.AmortizacionCreditoServicio;
import credito.servicio.CreditosMovsServicio;

public class CreditosMovGridControlador extends AbstractCommandController {
	
	
	CreditosMovsServicio creditosMovsServicio = null;
	
	public CreditosMovGridControlador() 
	{
		setCommandClass(CreditosMovsBean.class);
		setCommandName("creditosMovsBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		CreditosMovsBean creditosMovsBean = null;
		
		int tipoLista = 0;
		String page = request.getParameter("page");
		String tipoPaginacion = "";
		if(page== null){
			tipoPaginacion = "Completa";
		}
		
		if(tipoPaginacion.equalsIgnoreCase("Completa")){
			creditosMovsBean = (CreditosMovsBean) command;
			tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
			
			List creditosMovsBeanList = creditosMovsServicio.lista(tipoLista, creditosMovsBean);
			PagedListHolder productList = new PagedListHolder(creditosMovsBeanList);
			productList.setPageSize(20);		
			request.getSession().setAttribute("CreditosMovGridControlador_listaMovsCre", productList);
			return new ModelAndView("credito/creditoConsulMovsGridVista", "listaPaginada", productList);
		}else{		
			PagedListHolder productList = null;
			if(request.getSession().getAttribute("CreditosMovGridControlador_listaMovsCre")!= null){
				productList = (PagedListHolder) request.getSession().getAttribute("CreditosMovGridControlador_listaMovsCre");
				if ("next".equals(page)) {
					productList.nextPage();
				}
				else if ("previous".equals(page)) {
					productList.previousPage();
				}	
			}else{
				productList = null;
			}
						
			return new ModelAndView("credito/creditoConsulMovsGridVista", "listaPaginada", productList);
		}
		
		
	
		
	}

	public void setCreditosMovsServicio(CreditosMovsServicio creditosMovsServicio) {
		this.creditosMovsServicio = creditosMovsServicio;
	}
}
