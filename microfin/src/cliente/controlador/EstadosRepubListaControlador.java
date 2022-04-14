package cliente.controlador;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.EstadosRepubBean;
import cliente.servicio.EstadosRepubServicio;



public class EstadosRepubListaControlador extends AbstractCommandController{
	
	EstadosRepubServicio estadosRServicio = null;
		
	public EstadosRepubListaControlador() {
			setCommandClass(EstadosRepubBean.class);
			setCommandName("estados");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	EstadosRepubBean estado = (EstadosRepubBean) command;
	List estados =	estadosRServicio.lista(tipoLista, estado);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(estados);
			
	return new ModelAndView("cliente/estadosRepubListaVista", "listaResultado", listaResultado);
	}

	public void setEstadosRepubServicio(EstadosRepubServicio estadosRServicio) {
		this.estadosRServicio = estadosRServicio;
	}
		
		
	
}
