package cuentas.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.bean.AportacionSocioBean;
import cuentas.bean.RepAportaSocioMovBean;
import cuentas.servicio.AportacionSocioServicio;


public class AportaSocioMovGridControlador  extends AbstractCommandController{
	AportacionSocioServicio aportacionSocioServicio = null;

 	public AportaSocioMovGridControlador(){
 		setCommandClass(RepAportaSocioMovBean.class);
 		setCommandName("aportacionSocio");
 	}

 	protected ModelAndView handle(HttpServletRequest request,
 								HttpServletResponse response,
 								Object command,
 								BindException errors) throws Exception {	
 		String page = request.getParameter("page");
 		String tipoPaginacion = "";
		if(page== null){
			tipoPaginacion = "Completa";
		}
 		RepAportaSocioMovBean aportaSocioBean = (RepAportaSocioMovBean) command;

		if(tipoPaginacion.equalsIgnoreCase("Completa")){

			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));			
			List listaResultadoMovimientos = aportacionSocioServicio.listaMovAportaSocio(tipoLista, aportaSocioBean);
			
			PagedListHolder movimientosList = new PagedListHolder(listaResultadoMovimientos);
			movimientosList.setPageSize(20);		
			request.getSession().setAttribute("ReporteMovimientosGridControlador_listaMovsCta", movimientosList);			
			
			return new ModelAndView("cuentas/aportaSocioMovGridVista", "listaPaginada", movimientosList);
		}else{
			PagedListHolder reporteMovimientosList = null;
			if(request.getSession().getAttribute("ReporteMovimientosGridControlador_listaMovsCta")!= null){
				reporteMovimientosList = (PagedListHolder) request.getSession().getAttribute("ReporteMovimientosGridControlador_listaMovsCta");
				if ("next".equals(page)) {
					reporteMovimientosList.nextPage();
				}
				else if ("previous".equals(page)) {
					reporteMovimientosList.previousPage();
				}	
			}else{
				reporteMovimientosList = null;
			}
							
			return new ModelAndView("cuentas/aportaSocioMovGridVista", "listaPaginada", reporteMovimientosList);
			
			
		}						
		
 	}



 	// ---------------  getter y setter -------------------- 
	public AportacionSocioServicio getAportacionSocioServicio() {
		return aportacionSocioServicio;
	}

	public void setAportacionSocioServicio(
			AportacionSocioServicio aportacionSocioServicio) {
		this.aportacionSocioServicio = aportacionSocioServicio;
	}
 } 