package nomina.controlador;

import herramientas.Constantes;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import nomina.bean.AplicaPagoInstBean;
import nomina.servicio.AplicaPagoInstServicio;

public class AplicaPagoInstGridControlador  extends AbstractCommandController{

	AplicaPagoInstServicio aplicaPagoInstServicio = null;
	
	public AplicaPagoInstGridControlador(){
		setCommandClass(AplicaPagoInstBean.class);
		setCommandName("pagoInstBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		
		int tipoLista = (request.getParameter("tipoLista")!=null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
		String pagina = request.getParameter("page");
		String tipoPaginacion = "";
		
		List listaAplicaPagoInstBean = null;
		List listaResultado = (List)new ArrayList();
		PagedListHolder listaPaginada = null;
		
		if (pagina == null) {
			tipoPaginacion = "Completa";
		}
		
		if (tipoPaginacion.equalsIgnoreCase("Completa")) {

			AplicaPagoInstBean pagosInst = (AplicaPagoInstBean) command;
			listaAplicaPagoInstBean = aplicaPagoInstServicio.lista(tipoLista, pagosInst);

			listaPaginada = new PagedListHolder(listaAplicaPagoInstBean);
		} else {
			if (request.getSession().getAttribute("ListaPaginadaPagoInstitucion") != null) {
				
				// Agrego los objetos seleccionados
				listaResultado = (List) request.getSession().getAttribute("ListaPaginadaPagoInstitucion");
				listaPaginada = (PagedListHolder) listaResultado.get(1);
				List listaParametros = listaPaginada.getSource();
				
				listaPaginada.setSource(listaParametros);
			}
			
			// Se guarda la paginacion
			listaAplicaPagoInstBean = (List) request.getSession().getAttribute("ListaPaginadaPagoInstitucion");
			listaPaginada = (PagedListHolder) listaAplicaPagoInstBean.get(1);
			listaPaginada.getSource();
			
			if ("next".equals(pagina)) {
				listaPaginada.nextPage();
			} else if ("previous".equals(pagina)) {
				listaPaginada.previousPage();
				listaPaginada.getPage();
			} else if("check".equals(pagina)){
				listaPaginada.getPage();
			} else {
				listaPaginada = null;
			}
		}
		
		// Seccion de pagina
		listaPaginada.setPageSize(50);
		listaResultado.add(tipoLista);
		listaResultado.add(listaPaginada);
		request.getSession().setAttribute("ListaPaginadaPagoInstitucion", listaResultado);
		
		return new ModelAndView("nomina/aplicaPagoInstGrid",  "listaResultado", listaResultado);
	}
	// --------------- Getters y Setters -------------------

	public AplicaPagoInstServicio getAplicaPagoInstServicio() {
		return aplicaPagoInstServicio;
	}

	public void setAplicaPagoInstServicio(AplicaPagoInstServicio aplicaPagoInstServicio) {
		this.aplicaPagoInstServicio = aplicaPagoInstServicio;
	}
	
}
