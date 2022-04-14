package arrendamiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import arrendamiento.bean.ArrendaAmortiBean;
import arrendamiento.bean.ArrendamientosBean;
import arrendamiento.servicio.ArrendamientosServicio;



public class SimPagosArrendaListaControlador  extends AbstractCommandController {

	ArrendamientosServicio arrendamientosServicio = null;
	
	public SimPagosArrendaListaControlador() {
		setCommandClass(ArrendamientosBean.class);
		setCommandName("arrendamientosBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
				  HttpServletResponse response,
				  Object command,
				  BindException errors) throws Exception {	
		
		String page = request.getParameter("page");
		String tipoPaginacion = "";
		
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
					0;
				
		if(page== null){
			tipoPaginacion = "Completa";
		}
		
		if(tipoPaginacion.equalsIgnoreCase("Completa")){
			ArrendamientosBean arrenda = (ArrendamientosBean) command;
			List<ArrendaAmortiBean> listaSimArre = arrendamientosServicio.simuladorAmortizaciones(tipoLista, arrenda);
			List listaResultado = new ArrayList();
			
			ArrendaAmortiBean amortizacionArrenda = new ArrendaAmortiBean();
			ArrendaAmortiBean amortizacionCredRet = new ArrendaAmortiBean();
			amortizacionArrenda = (ArrendaAmortiBean) listaSimArre.get(listaSimArre.size()-1);
			
			amortizacionCredRet.setFechaVencim(amortizacionArrenda.getFechaVencim());
			PagedListHolder productList = new PagedListHolder(listaSimArre);
			productList.setPageSize(20);	
			
			listaResultado.add(tipoLista);
			listaResultado.add(amortizacionCredRet);
			listaResultado.add(productList);
			if(listaSimArre!=null && listaSimArre.size()>=1){
				String numeroError=listaSimArre.get(0).getCodigoError();
				String messError=listaSimArre.get(0).getMensajeError();
				listaResultado.add(numeroError);
				listaResultado.add(messError);
		    }else {
		    	listaResultado.add("999");
		    	listaResultado.add("Ocurrio un Error al Simular.");
		    }	

			request.getSession().setAttribute("SimuladorPagosControlador_LisArrenda", listaResultado);
			return new ModelAndView("arrendamiento/simPagosArrendaGridVista", "listaResultado", listaResultado);
		}else{		
			PagedListHolder productList = null;
			List listaResultado = new ArrayList();
			
			if(request.getSession().getAttribute("SimuladorPagosControlador_LisArrenda")!= null){
				listaResultado = (List) request.getSession().getAttribute("SimuladorPagosControlador_LisArrenda");
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
			arrendamiento.bean.ArrendaAmortiBean amortizacionArrenda = new ArrendaAmortiBean();
			listaResultado.add(tipoLista);
			listaResultado.add(amortizacionArrenda);
			listaResultado.add(productList);
			listaResultado.add("0");
			listaResultado.add("");
			return new ModelAndView("arrendamiento/simPagosArrendaGridVista", "listaResultado", listaResultado);
		}
								
	}

	public ArrendamientosServicio getArrendamientosServicio() {
		return arrendamientosServicio;
	}

	public void setArrendamientosServicio(
			ArrendamientosServicio arrendamientosServicio) {
		this.arrendamientosServicio = arrendamientosServicio;
	}

		
}

