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
import arrendamiento.servicio.ArrendaAmortiServicio;



public class AmortizacionesGridControlador  extends AbstractCommandController {

	ArrendaAmortiServicio arrendaAmortiServicio = null;
	
	public AmortizacionesGridControlador() {
		setCommandClass(ArrendaAmortiBean.class);
		setCommandName("arrendaAmortiBean");
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
			ArrendaAmortiBean arrendaAmorti = (ArrendaAmortiBean) command;
			// lista de amortizaciones
			List<ArrendaAmortiBean> listaAmorti = arrendaAmortiServicio.lista(tipoLista, arrendaAmorti);
			List listaResultado = new ArrayList();
			
			ArrendaAmortiBean amortizacionArrenda = new ArrendaAmortiBean();
			amortizacionArrenda = (ArrendaAmortiBean) listaAmorti.get(listaAmorti.size()-1);
			
			PagedListHolder productList = new PagedListHolder(listaAmorti);
			productList.setPageSize(25);	
			
			listaResultado.add(tipoLista);			// index 0
			listaResultado.add(productList);		// index 1
			if(listaAmorti!=null && listaAmorti.size()>=1){
				String numeroError=listaAmorti.get(0).getCodigoError();
				String messError=listaAmorti.get(0).getMensajeError();
				listaResultado.add(numeroError);	// index 2
				listaResultado.add(messError);		// index 3
		    }else {
		    	listaResultado.add("999");
		    	listaResultado.add("Ocurrio un Error en la lista de amortizaciones.");
		    }	

			request.getSession().setAttribute("GridAmortizaciones", listaResultado);
			return new ModelAndView("arrendamiento/amortizacionesGridVista", "listaResultado", listaResultado);
		}else{		
			PagedListHolder productList = null;
			List listaResultado = new ArrayList();
			
			if(request.getSession().getAttribute("GridAmortizaciones")!= null){
				listaResultado = (List) request.getSession().getAttribute("GridAmortizaciones");
				productList = (PagedListHolder) listaResultado.get(1);
				
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
			listaResultado.add(tipoLista);
			listaResultado.add(productList);
			listaResultado.add("0");
			listaResultado.add("");
			return new ModelAndView("arrendamiento/amortizacionesGridVista", "listaResultado", listaResultado);
		}
								
	}

	// GET Y SET
	public ArrendaAmortiServicio getArrendaAmortiServicio() {
		return arrendaAmortiServicio;
	}

	public void setArrendaAmortiServicio(ArrendaAmortiServicio arrendaAmortiServicio) {
		this.arrendaAmortiServicio = arrendaAmortiServicio;
	}
}

