package cuentas.controlador;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.ReporteMovimientosBean;
import cuentas.servicio.ReporteMovimientosServicio;


public class ReporteMovimientosGridControlador extends AbstractCommandController{
		
	ReporteMovimientosServicio reporteMovimientosServicio = null;
	public ReporteMovimientosGridControlador() {
		setCommandClass(ReporteMovimientosBean.class);
		setCommandName("reporteMovimientos");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {				
		int tipoLista = 0;
		String page = request.getParameter("page");
		String tipoPaginacion = "";
		if(page== null){
			tipoPaginacion = "Completa";
		}

		if(tipoPaginacion.equalsIgnoreCase("Completa")){
			ReporteMovimientosBean reporteMovimientos = (ReporteMovimientosBean) command;
			tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
			
			List reporteMovimientosList = reporteMovimientosServicio.lista(tipoLista, reporteMovimientos);
			PagedListHolder movimientosList = new PagedListHolder(reporteMovimientosList);
			movimientosList.setPageSize(20);		
			request.getSession().setAttribute("ReporteMovimientosGridControlador_listaMovsCta", movimientosList);
			return new ModelAndView("cuentas/reporteMovimientosGridVista", "listaPaginada", movimientosList);
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
							
			return new ModelAndView("cuentas/reporteMovimientosGridVista", "listaPaginada", reporteMovimientosList);
		}
	}

	public void setReporteMovimientosServicio(
			ReporteMovimientosServicio reporteMovimientosServicio) {
		this.reporteMovimientosServicio = reporteMovimientosServicio;
	}
}

