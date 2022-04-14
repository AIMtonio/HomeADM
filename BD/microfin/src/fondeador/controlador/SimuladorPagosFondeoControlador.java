package fondeador.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fondeador.bean.AmortizaFondeoBean;
import fondeador.bean.CreditoFondeoBean;
import fondeador.servicio.CreditoFondeoServicio;

public class SimuladorPagosFondeoControlador  extends AbstractCommandController {

	CreditoFondeoServicio creditoFondeoServicio = null;
	
	public SimuladorPagosFondeoControlador() {
		setCommandClass(CreditoFondeoBean.class);
		setCommandName("creditoFondeoBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
				  HttpServletResponse response,
				  Object command,
				  BindException errors) throws Exception {	
		String page = request.getParameter("page");
		String fechaV = request.getParameter("fechaV");
		String tipoPaginacion = "";
		
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
					0;
		if(page== null){
			tipoPaginacion = "Completa";
		}
		
		if(tipoPaginacion.equalsIgnoreCase("Completa")){
			
			CreditoFondeoBean creditoFondeo = (CreditoFondeoBean) command;
			List LisCreditos = creditoFondeoServicio.simuladorAmortizacionesFondeo(tipoLista, creditoFondeo);
			List listaResultado = new ArrayList();
			
			AmortizaFondeoBean amortizaFondeoBean = new AmortizaFondeoBean();
			AmortizaFondeoBean amortizacionFonRet = new AmortizaFondeoBean();
			amortizaFondeoBean = (AmortizaFondeoBean) LisCreditos.get(LisCreditos.size()-1);
			
			amortizacionFonRet.setFechaVencim(amortizaFondeoBean.getFechaVencim());
			PagedListHolder productList = new PagedListHolder(LisCreditos);
			productList.setPageSize(20);	
			
			listaResultado.add(tipoLista);
			listaResultado.add(amortizacionFonRet);
		    listaResultado.add(productList);
		        
			request.getSession().setAttribute("SimuladorPagosControlador_LisCreditos", listaResultado);
			
		
			return new ModelAndView("fondeador/simuladorPagosFondeoGridVista", "listaResultado", listaResultado);
		}else{		
			PagedListHolder productList = null;
			List listaResultado = new ArrayList();
			
			if(request.getSession().getAttribute("SimuladorPagosControlador_LisCreditos")!= null){
				listaResultado = (List) request.getSession().getAttribute("SimuladorPagosControlador_LisCreditos");
				productList = (PagedListHolder) listaResultado.get(2);
				
				if ("next".equals(page)) {
					productList.nextPage();
				}
				else if ("previous".equals(page)) {
					productList.previousPage();
					productList.getPage();
				}	
			}else{
				productList = null;
			}
			AmortizaFondeoBean amortizaBean = new AmortizaFondeoBean();
			amortizaBean.setFechaVencim(fechaV);
			
			listaResultado.add(tipoLista);
			listaResultado.add(amortizaBean);
		    listaResultado.add(productList);	
			return new ModelAndView("fondeador/simuladorPagosFondeoGridVista", "listaResultado", listaResultado);
		}
								
	}

	public CreditoFondeoServicio getCreditoFondeoServicio() {
		return creditoFondeoServicio;
	}

	public void setCreditoFondeoServicio(CreditoFondeoServicio creditoFondeoServicio) {
		this.creditoFondeoServicio = creditoFondeoServicio;
	}	
}

