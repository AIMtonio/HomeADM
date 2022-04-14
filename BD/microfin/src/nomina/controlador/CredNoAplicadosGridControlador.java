package nomina.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import nomina.bean.AplicaPagoInstBean;
import nomina.bean.PagoNominaBean;
import nomina.dao.AplicaPagoInstDAO;
import nomina.servicio.AplicaPagoInstServicio;
import nomina.servicio.PagoNominaServicio;

public class CredNoAplicadosGridControlador  extends AbstractCommandController{

	AplicaPagoInstServicio aplicaPagoInstServicio = null;
	
	public CredNoAplicadosGridControlador(){
		setCommandClass(AplicaPagoInstBean.class);
		setCommandName("pagoInstBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		int tipoLista = (request.getParameter("tipoLista")!=null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
		String page = request.getParameter("page");
		String tipoPaginacion = "";
		

		List listaAplicaPagoInstBean = null;
		List listaResultado = (List)new ArrayList();
		PagedListHolder listaPaginada = null;
				
		if (page == null) {
			tipoPaginacion = "Completa";
		}
		
		if (tipoPaginacion.equalsIgnoreCase("Completa")) {

			AplicaPagoInstBean pagosInst = (AplicaPagoInstBean) command;			
			listaAplicaPagoInstBean = aplicaPagoInstServicio.lista(tipoLista, pagosInst);
			listaPaginada = new PagedListHolder(listaAplicaPagoInstBean);
			
		}else{
			if (request.getSession().getAttribute("ListaPaginadaNoAplicado") != null) {
				// Agrego los objetos seleccionados
				listaResultado = (List) request.getSession().getAttribute("ListaPaginadaNoAplicado");
				listaPaginada = (PagedListHolder) listaResultado.get(1);
				List listaParametros = listaPaginada.getSource();
				
				listaPaginada.setSource(listaParametros);				
			}
			

			// Se guarda la paginacion
			listaAplicaPagoInstBean = (List) request.getSession().getAttribute("ListaPaginadaNoAplicado");
			listaPaginada = (PagedListHolder) listaAplicaPagoInstBean.get(1);
			listaPaginada.getSource();
			
			if ("next".equals(page)) {
				listaPaginada.nextPage();
			} else if ("previous".equals(page)) {
				listaPaginada.previousPage();
				listaPaginada.getPage();
			} else if("check".equals(page)){
				listaPaginada.getPage();
			} else {
				listaPaginada = null;
			}
		}
			
		// Seccion de pagina
		listaPaginada.setPageSize(50);
		listaResultado.add(tipoLista);
		listaResultado.add(listaPaginada);
		request.getSession().setAttribute("ListaPaginadaNoAplicado", listaResultado);
		
		return new ModelAndView("nomina/credNoAplicadosGrid",  "listaResultado", listaResultado);

		
	}
	// --------------- Getters y Setters -------------------

	public AplicaPagoInstServicio getAplicaPagoInstServicio() {
		return aplicaPagoInstServicio;
	}

	public void setAplicaPagoInstServicio(AplicaPagoInstServicio aplicaPagoInstServicio) {
		this.aplicaPagoInstServicio = aplicaPagoInstServicio;
	}
	
}
