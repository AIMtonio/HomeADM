package cuentas.controlador;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.BloqueoBean;
import tesoreria.servicio.BloqueoServicio;

public class SaldosBloqueadosGridControlador extends AbstractCommandController{
	BloqueoServicio bloqueoServicio;
	
	public SaldosBloqueadosGridControlador(){
		setCommandClass(BloqueoBean.class);
		setCommandName("bloqueoBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		BloqueoBean ctaAho = (BloqueoBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String page = request.getParameter("page");
	    String tipoPaginacion = "";
		  
	    
	    List listaResultado = (List)new ArrayList();
		if (page == null) {
			tipoPaginacion = "Completa";
		}
		
		if (tipoPaginacion.equalsIgnoreCase("Completa")) {

			List listaResul = bloqueoServicio.lista(tipoLista, ctaAho);
			
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
	
		
		return new ModelAndView("cuentas/saldosBloqueosGrid", "listaBloqueados", listaResultado);
	}

	public BloqueoServicio getBloqueoServicio() {
		return bloqueoServicio;
	}

	public void setBloqueoServicio(BloqueoServicio bloqueoServicio) {
		this.bloqueoServicio = bloqueoServicio;
	}

	
}
