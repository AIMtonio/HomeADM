package originacion.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.MonitorSolicitudesBean;
import originacion.servicio.MonitorSolicitudesServicio;

public class MonitorCantidadSolicitudesGridControlador extends AbstractCommandController{
	private MonitorSolicitudesServicio monitorSolicitudesServicio = null;
	
	private MonitorCantidadSolicitudesGridControlador(){
		setCommandClass(MonitorSolicitudesBean.class);
		setCommandName("monitorSolicitud");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {	
		
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String page = request.getParameter("page");
		String tipoPaginacion = "";
		
		List listaResultado = new ArrayList();
		
		if (page == null) {
			tipoPaginacion = "Completa";
		}
		
			if (tipoPaginacion.equalsIgnoreCase("Completa")) {

				MonitorSolicitudesBean cantidadSol = (MonitorSolicitudesBean)command;
				List listaSolicitudes = monitorSolicitudesServicio.listaCantidadSolGrid(tipoLista,cantidadSol);

				PagedListHolder amortList = new PagedListHolder(listaSolicitudes);
				amortList.setPageSize(20);
				listaResultado.add(tipoLista);
				listaResultado.add(amortList);

				request.getSession().setAttribute("ConsulSolCredGridControlador_solicitudCreditoList", listaResultado);

			} else {
				PagedListHolder amortList = null;

				if (request.getSession().getAttribute("ConsulSolCredGridControlador_solicitudCreditoList") != null) {
					listaResultado = (List) request.getSession().getAttribute("ConsulSolCredGridControlador_solicitudCreditoList");
					amortList = (PagedListHolder) listaResultado.get(1);

					if ("next".equals(page)) {
						amortList.nextPage();
					}
					else if ("previous".equals(page)) {
						amortList.previousPage();
						amortList.getPage();
					}
				} else {
					amortList = null;
				}

				listaResultado.add(tipoLista);
				listaResultado.add(amortList);

			}

		 return new ModelAndView("originacion/monitorCantidadSolicitudesGridVista", "listaResultado", listaResultado);
	}

	public MonitorSolicitudesServicio getMonitorSolicitudesServicio() {
		return monitorSolicitudesServicio;
	}

	public void setMonitorSolicitudesServicio(
			MonitorSolicitudesServicio monitorSolicitudesServicio) {
		this.monitorSolicitudesServicio = monitorSolicitudesServicio;
	}
	

}
