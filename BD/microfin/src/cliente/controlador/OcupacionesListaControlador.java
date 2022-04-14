package cliente.controlador;


import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.OcupacionesBean;
import cliente.servicio.OcupacionesServicio;


public class OcupacionesListaControlador extends AbstractCommandController{

	
	OcupacionesServicio ocupacionesServicio = null;
		
	public OcupacionesListaControlador() {
			setCommandClass(OcupacionesBean.class);
			setCommandName("ocupacion");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	OcupacionesBean ocupacion = (OcupacionesBean) command;
	List ocupaciones =	ocupacionesServicio.lista(tipoLista, ocupacion);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(ocupaciones);
			
	return new ModelAndView("cliente/ocupacionesListaVista", "listaResultado", listaResultado);
	}

	public void setOcupacionesServicio(OcupacionesServicio ocupacionesServicio) {
		this.ocupacionesServicio = ocupacionesServicio;
	}
		
		
	
}
