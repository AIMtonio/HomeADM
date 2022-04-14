package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.AmortizacionCreditoBean;
import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class SimuladorPagosControlador  extends AbstractCommandController {

	CreditosServicio creditosServicio = null;
	
	public SimuladorPagosControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditos");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
				  HttpServletResponse response,
				  Object command,
				  BindException errors) throws Exception {	
		
		String page = request.getParameter("page");
		String fechaV = request.getParameter("fechaV");
		String cobraAccesorios = request.getParameter("cobraAccesorios");
		String tipoPaginacion = "";
		
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
					0;
				
		if(page== null){
			tipoPaginacion = "Completa";
		}
		
		if(tipoPaginacion.equalsIgnoreCase("Completa")){
			
			
			CreditosBean creditos = (CreditosBean) command;
			List<AmortizacionCreditoBean> LisCreditos = creditosServicio.simuladorAmortizaciones(tipoLista, creditos);
			List listaResultado = new ArrayList();
			
			AmortizacionCreditoBean amortizacionCredito = new AmortizacionCreditoBean();
			AmortizacionCreditoBean amortizacionCredRet = new AmortizacionCreditoBean();
			amortizacionCredito = (AmortizacionCreditoBean) LisCreditos.get(LisCreditos.size()-1);
			
			amortizacionCredRet.setFechaVencim(amortizacionCredito.getFechaVencim());
			PagedListHolder productList = new PagedListHolder(LisCreditos);
			productList.setPageSize(20);	
			
			
			 listaResultado.add(tipoLista);
			 listaResultado.add(amortizacionCredRet);
		     listaResultado.add(productList);
		     if(LisCreditos!=null && LisCreditos.size()>=1){
		    	 String numeroError=LisCreditos.get(0).getCodigoError();
		    	 String messError=LisCreditos.get(0).getMensajeError();
		    	 String cobraSeguroCuota = LisCreditos.get(0).getCobraSeguroCuota();
			     listaResultado.add(numeroError);
			     listaResultado.add(messError);
			     listaResultado.add(cobraSeguroCuota);
			     listaResultado.add(cobraAccesorios);
		     } else {
		    	 listaResultado.add("999");
			     listaResultado.add("Ocurrio un Error al Simular.");
		     }

			request.getSession().setAttribute("SimuladorPagosControlador_LisCreditos", listaResultado);
			
		
			return new ModelAndView("credito/simuladorPagosGridVista", "listaResultado", listaResultado);
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
			AmortizacionCreditoBean amortizacionCredito = new AmortizacionCreditoBean();
			amortizacionCredito.setFechaVencim(fechaV);
			 listaResultado.add(tipoLista);
			 listaResultado.add(amortizacionCredito);
		     listaResultado.add(productList);
			 listaResultado.add("0");
		     listaResultado.add("");
			return new ModelAndView("credito/simuladorPagosGridVista", "listaResultado", listaResultado);
		}
								
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	

		
}

