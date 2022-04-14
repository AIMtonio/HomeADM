package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ApoyoEscolarSolBean;
import cliente.servicio.ApoyoEscolarSolServicio;

public class ApoyoEscolarSolListaControlador extends AbstractCommandController{
	
	ApoyoEscolarSolServicio apoyoEscolarSolServicio = null;
	
	public ApoyoEscolarSolListaControlador() {
		setCommandClass(ApoyoEscolarSolBean.class);
		setCommandName("apoyoEscolarSolBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		ApoyoEscolarSolBean solicitud = (ApoyoEscolarSolBean) command;
		List apoyoEscolarSol =	apoyoEscolarSolServicio.lista(tipoLista, solicitud);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(apoyoEscolarSol);
		
		return new ModelAndView("cliente/apoyoEscolarSolListaVista", "listaResultado",listaResultado);
	}

	public ApoyoEscolarSolServicio getApoyoEscolarSolServicio() {
		return apoyoEscolarSolServicio;
	}

	public void setApoyoEscolarSolServicio(
			ApoyoEscolarSolServicio apoyoEscolarSolServicio) {
		this.apoyoEscolarSolServicio = apoyoEscolarSolServicio;
	}

	
	
}
