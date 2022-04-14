package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.DestinosCreditoBean;
import credito.bean.ProspectosBean;
import credito.servicio.DestinosCreditoServicio;
import credito.servicio.ProspectosServicio;



public class DestinosCreditoListaControlador extends AbstractCommandController{

	
	DestinosCreditoServicio destinosCreditoServicio = null;
		
	public DestinosCreditoListaControlador() {
			setCommandClass(DestinosCreditoBean.class);
			setCommandName("destinos");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	DestinosCreditoBean destinosCreditoBean = (DestinosCreditoBean) command;
	List destinos =	destinosCreditoServicio.lista(tipoLista, destinosCreditoBean);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(destinos);
			
	return new ModelAndView("credito/destinosCreditoListaVista", "listaResultado", listaResultado);
	}


	public void setDestinosCreditoServicio(
			DestinosCreditoServicio destinosCreditoServicio) {
		this.destinosCreditoServicio = destinosCreditoServicio;
	}
	

	
}
