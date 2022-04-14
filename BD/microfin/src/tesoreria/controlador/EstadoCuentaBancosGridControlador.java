package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.ReporteMovimientosBean;

import tesoreria.bean.CuentaNostroBean;
import tesoreria.bean.EstadoCuentaBancosReporteBean;
import tesoreria.servicio.CuentaNostroServicio;
import tesoreria.servicio.EstadoCuentaBancosReporteServicio;
import tesoreria.servicio.TesoMovimientosServicio;

public class EstadoCuentaBancosGridControlador extends AbstractCommandController{
     
	EstadoCuentaBancosReporteServicio estadoCuentaBancosReporteServicio= null; 
	public EstadoCuentaBancosGridControlador(){
		setCommandClass(EstadoCuentaBancosReporteBean.class);
		setCommandName("tesoreriaMovsReporteBean");
	}
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		String controlID = request.getParameter("controlID");
	    
	    
		String page = request.getParameter("page");
		String tipoPaginacion = "";
		if(page== null){
			tipoPaginacion = "Completa";
		}
		
		if(tipoPaginacion.equalsIgnoreCase("Completa")){
			EstadoCuentaBancosReporteBean tesoreriaMovsReporteBean = (EstadoCuentaBancosReporteBean)command;
			
			List reporteMovimientosList = estadoCuentaBancosReporteServicio.lista(tesoreriaMovsReporteBean);
			PagedListHolder movimientosList = new PagedListHolder(reporteMovimientosList);
			movimientosList.setPageSize(30);		
			request.getSession().setAttribute("ReporteMovimientosGridControlador_listaMovs", movimientosList);
			return new ModelAndView("tesoreria/estadoCuentaBancosGridVista", "listaPaginada", movimientosList);
		}else{		
			PagedListHolder reporteMovimientosList = null;
			if(request.getSession().getAttribute("ReporteMovimientosGridControlador_listaMovs")!= null){
				reporteMovimientosList = (PagedListHolder) request.getSession().getAttribute("ReporteMovimientosGridControlador_listaMovs");
				if ("next".equals(page)) {
					reporteMovimientosList.nextPage();
				}
				else if ("previous".equals(page)) {
					reporteMovimientosList.previousPage();
				}	
			}else{
				reporteMovimientosList = null;
			}
							
	
			return new ModelAndView("tesoreria/estadoCuentaBancosGridVista", "listaPaginada", reporteMovimientosList);
		}
	}
	public EstadoCuentaBancosReporteServicio getEstadoCuentaBancosReporteServicio() {
		return estadoCuentaBancosReporteServicio;
	}
	public void setEstadoCuentaBancosReporteServicio(
			EstadoCuentaBancosReporteServicio estadoCuentaBancosReporteServicio) {
		this.estadoCuentaBancosReporteServicio = estadoCuentaBancosReporteServicio;
	}
	

}
