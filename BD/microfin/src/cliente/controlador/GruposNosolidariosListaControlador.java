package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ClienteBean;
import cliente.bean.GruposNosolidariosBean;
import cliente.servicio.GruposNosolidariosServicio;

public class GruposNosolidariosListaControlador extends AbstractCommandController {
	
	GruposNosolidariosServicio gruposNosolidariosServicio=null;

	public GruposNosolidariosListaControlador() {
		setCommandClass(GruposNosolidariosBean.class);
		setCommandName("gruposNosolidariosBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		GruposNosolidariosBean bean =(GruposNosolidariosBean) command;
		
		List grupos =	gruposNosolidariosServicio.lista(tipoLista, bean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(grupos);
		
		return new ModelAndView("cliente/gruposNosolidariosListaVista", "listaResultado",listaResultado);
		
	}

	public GruposNosolidariosServicio getGruposNosolidariosServicio() {
		return gruposNosolidariosServicio;
	}

	public void setGruposNosolidariosServicio(
			GruposNosolidariosServicio gruposNosolidariosServicio) {
		this.gruposNosolidariosServicio = gruposNosolidariosServicio;
	}
	

}
