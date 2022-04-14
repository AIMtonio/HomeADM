package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.PuestosRelacionadoBean;
import soporte.servicio.PuestosRelacionadoServicio;




public class PuestosRelacionadoListaControlador extends AbstractCommandController {
	
	PuestosRelacionadoServicio puestosRelacionadoServicio = null;
	
	public PuestosRelacionadoListaControlador() {
		setCommandClass(PuestosRelacionadoBean.class);
		setCommandName("puestos");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	PuestosRelacionadoBean puesto = (PuestosRelacionadoBean) command;
	List cargos  =	puestosRelacionadoServicio.lista(tipoLista, puesto);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(cargos);
			
	return new ModelAndView("soporte/puestosRelacionadoListaVista", "listaResultado", listaResultado);
	}

	public PuestosRelacionadoServicio getPuestosRelacionadoServicio() {
		return puestosRelacionadoServicio;
	}

	public void setPuestosRelacionadoServicio(PuestosRelacionadoServicio puestosRelacionadoServicio) {
		this.puestosRelacionadoServicio = puestosRelacionadoServicio;
	}

	
	
}

