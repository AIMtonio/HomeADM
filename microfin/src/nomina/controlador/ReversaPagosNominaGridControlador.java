package nomina.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.PagoNominaBean;
import nomina.bean.ReversaPagoNominaBean;
import nomina.servicio.ReversaPagoNominaServicio;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class ReversaPagosNominaGridControlador extends AbstractCommandController{
	ReversaPagoNominaServicio reversaPagoNominaServicio = null;
	
	public ReversaPagosNominaGridControlador(){
		setCommandClass(ReversaPagoNominaBean.class);
		setCommandName("reversaPagosNomina");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		ReversaPagoNominaBean respuestaBean = (ReversaPagoNominaBean)command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));	

		
		String page = request.getParameter("page");
	    String tipoPaginacion = "";
		  
	    
	    List listaResultado = (List)new ArrayList();
		if (page == null) {
			tipoPaginacion = "Completa";
		}
		
				
		if (tipoPaginacion.equalsIgnoreCase("Completa")) {

			List listaResul = reversaPagoNominaServicio.listaPagos(tipoLista,respuestaBean);
			
			PagedListHolder credNominaLis = new PagedListHolder(listaResul);
			credNominaLis.setPageSize(15);
			listaResultado.add(tipoLista);
			listaResultado.add(credNominaLis);			
	
			request.getSession().setAttribute("ConsultaMonitorGridControlador", listaResultado);

		} else {
			PagedListHolder credList = null;
	
			if (request.getSession().getAttribute("ConsultaMonitorGridControlador") != null) {
				listaResultado = (List) request.getSession().getAttribute("ConsultaMonitorGridControlador");
				credList = (PagedListHolder) listaResultado.get(1);

				if ("next".equals(page)) {
					credList.nextPage();
				}
				else if ("previous".equals(page)) {
					credList.previousPage();
					credList.getPage();
				}
			} else {
				credList = null;
			}
			listaResultado.add(tipoLista);
			listaResultado.add(credList);
			
	
		}
		
		return new ModelAndView("nomina/creditosNominaPagosGridVista", "listaResultado", listaResultado);
	}

	public ReversaPagoNominaServicio getReversaPagoNominaServicio() {
		return reversaPagoNominaServicio;
	}

	public void setReversaPagoNominaServicio(
			ReversaPagoNominaServicio reversaPagoNominaServicio) {
		this.reversaPagoNominaServicio = reversaPagoNominaServicio;
	}
	
	

}
