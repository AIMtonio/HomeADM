package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.PromotoresBean;
import cliente.servicio.PromotoresServicio;

public class PromotoresListaControlador extends AbstractCommandController{

	
	PromotoresServicio promotoresServicio = null;
		
	public PromotoresListaControlador() {
			setCommandClass(PromotoresBean.class);
			setCommandName("promotor");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	PromotoresBean promotor = (PromotoresBean) command;
	List promotores =	promotoresServicio.lista(tipoLista, promotor);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(promotores);
			
	return new ModelAndView("cliente/promotoresListaVista", "listaResultado", listaResultado);
	}

	public void setPromotoresServicio(PromotoresServicio promotoresServicio) {
		this.promotoresServicio = promotoresServicio;
	}
		
		
	
}
