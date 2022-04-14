package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.MonitorSolicitudesBean;
import tesoreria.bean.DispersionBean;
import tesoreria.bean.DispersionGridBean;
import tesoreria.bean.MovimientosGridBean;
import tesoreria.bean.TesoreriaMovsBean;
import tesoreria.servicio.MovimientosGridServicio;
import tesoreria.servicio.OperDispGridServicio;

public class OperDispGridControlador extends AbstractCommandController {
	OperDispGridServicio operDispGridServicio = null;

	public OperDispGridControlador() {
		setCommandClass( DispersionGridBean.class);
		setCommandName("DispersionGrid");
	} 
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
							HttpServletResponse response, 
							Object command, 
							BindException errors) throws Exception {
		
		DispersionBean dispersionBean = new DispersionBean();
       
		String  folio = (request.getParameter("folioOperacion")!=null) ? request.getParameter("folioOperacion") : "";
       int tipoConsulta = (request.getParameter("tipoConsulta")!=null) ? Integer.parseInt(request.getParameter("tipoConsulta")) : 0;
    		   
       
       String page = request.getParameter("page");
	   String tipoPaginacion = "";
       dispersionBean.setFolioOperacion(folio);
		
		
	
			
		List listaResultado = (List)new ArrayList();
		if (page == null) {
			tipoPaginacion = "Completa";
		}
		
		if (tipoPaginacion.equalsIgnoreCase("Completa")) {

			List listaResul = operDispGridServicio.DispersionList(dispersionBean, tipoConsulta);

			PagedListHolder amortList = new PagedListHolder(listaResul);
			amortList.setPageSize(500);
			listaResultado.add(amortList);

			request.getSession().setAttribute("ConsulSolCredGridControlador_solicitudCreditoList", listaResultado);

		} else {
			PagedListHolder amortList = null;

			if (request.getSession().getAttribute("ConsulSolCredGridControlador_solicitudCreditoList") != null) {
				listaResultado = (List) request.getSession().getAttribute("ConsulSolCredGridControlador_solicitudCreditoList");
				amortList = (PagedListHolder) listaResultado.get(0);

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

			listaResultado.add(amortList);

		}
		
		String paginaRegreso = null;
		
		if(tipoConsulta == 1){
			paginaRegreso = "tesoreria/operDispGridVista";
		}else if(tipoConsulta == 3){
			paginaRegreso = "tesoreria/operDispGridAutoriza";
		}		
		
		//Falta redireccionar a jsp de autoriza
		return new ModelAndView(paginaRegreso, "listaResultado", listaResultado);
	}

	public OperDispGridServicio getOperDispGridServicio() {
		return operDispGridServicio;
		     
	}
 
	public void setOperDispGridServicio(
			OperDispGridServicio operDispGridServicio) {
		this.operDispGridServicio = operDispGridServicio;
	}

	
}