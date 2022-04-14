package pld.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.OpIntPreocupantesBean;
import pld.servicio.OpIntPreocupantesServicio;

public class PldOpeInterPreoListaControlador extends AbstractCommandController {
	
	OpIntPreocupantesServicio opIntPreocupantesServicio = null;
	
	public PldOpeInterPreoListaControlador() {
		setCommandClass(OpIntPreocupantesBean.class);
		setCommandName("opIntPreocupantesBean");
		
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		OpIntPreocupantesBean opIntPreocupantes = (OpIntPreocupantesBean) command;		
		List lisopIntPreocupantes =	opIntPreocupantesServicio.lista(tipoLista, opIntPreocupantes);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(lisopIntPreocupantes);
		
		return new ModelAndView("pld/pldOpeInterPreoListaVista", "listaResultado",listaResultado);
	}

	public OpIntPreocupantesServicio getOpIntPreocupantesServicio() {
		return opIntPreocupantesServicio;
	}

	public void setOpIntPreocupantesServicio(
			OpIntPreocupantesServicio opIntPreocupantesServicio) {
		this.opIntPreocupantesServicio = opIntPreocupantesServicio;
	}

	
}


