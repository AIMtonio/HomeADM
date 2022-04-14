package arrendamiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import arrendamiento.bean.CargoAbonoArrendaBean;
import arrendamiento.servicio.MovimientosCargoAbonoArrendaServicio;


public class MovimientosCAGridControlador  extends AbstractCommandController {

	MovimientosCargoAbonoArrendaServicio movimientosCargoAbonoArrendaServicio = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public MovimientosCAGridControlador() {
		setCommandClass(CargoAbonoArrendaBean.class);
		setCommandName("cargoAbonoArrendaBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
				  HttpServletResponse response,
				  Object command,
				  BindException errors) throws Exception {		
		String page = request.getParameter("page");
		String tipoPaginacion = "";
		
		int tipoLista =(request.getParameter("tipoLista")!=null)?Integer.parseInt(request.getParameter("tipoLista")):0;
				
		if(page== null){
			tipoPaginacion = "Completa";
		}
		
		if(tipoPaginacion.equalsIgnoreCase("Completa")){
			CargoAbonoArrendaBean movimiento = (CargoAbonoArrendaBean) command;
			// lista de movimientos de cargo y abono
			List<CargoAbonoArrendaBean> listaMovsCA = movimientosCargoAbonoArrendaServicio.lista(tipoLista, movimiento);
			List listaResultado = new ArrayList();
			
			PagedListHolder productList = new PagedListHolder(listaMovsCA);
			productList.setPageSize(10);	
			
			listaResultado.add(tipoLista);
			listaResultado.add(productList);
			if(listaMovsCA!=null && listaMovsCA.size()>=1){
				listaResultado.add("0");
				listaResultado.add("Lista de movimientos de cargos y abonos");
		    }else {
		    	listaResultado.add("999");
		    	listaResultado.add("Ocurrio un Error en la lista de movimientos de cargo y abono de arrendamiento.");
		    }
			request.getSession().setAttribute("GridMovimientos", listaResultado);
			return new ModelAndView("arrendamiento/movimientosGridVista", "listaResultado", listaResultado);
		}else{	
			PagedListHolder productList = null;
			List listaResultado = new ArrayList();
			
			if(request.getSession().getAttribute("GridMovimientos")!= null){
				listaResultado = (List) request.getSession().getAttribute("GridMovimientos");
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
			return new ModelAndView("arrendamiento/movimientosGridVista", "listaResultado", listaResultado);
		}						
	}

	// --------------------------------- GET Y SET--------------------------------------------------------------
	public MovimientosCargoAbonoArrendaServicio getMovimientosCargoAbonoArrendaServicio() {
		return movimientosCargoAbonoArrendaServicio;
	}

	public void setMovimientosCargoAbonoArrendaServicio(
			MovimientosCargoAbonoArrendaServicio movimientosCargoAbonoArrendaServicio) {
		this.movimientosCargoAbonoArrendaServicio = movimientosCargoAbonoArrendaServicio;
	}
	
}

