package arrendamiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import arrendamiento.bean.SubtipoActivoBean;
import arrendamiento.servicio.SubtipoActivoServicio;

public class SubtipoActivoListaControlador extends AbstractCommandController {
	
	SubtipoActivoServicio subtipoActivoServicio = null;
	
	public SubtipoActivoListaControlador() {
		setCommandClass(SubtipoActivoBean.class);
		setCommandName("subtipoActivoBean");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		SubtipoActivoBean subtipoActivoBean = (SubtipoActivoBean) command;
	
		List listaSubtipos = subtipoActivoServicio.lista(tipoLista, subtipoActivoBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaSubtipos);
			
	return new ModelAndView("arrendamiento/subtipoActivoListaVista", "listaResultado", listaResultado);
	}

	//---------- Getter y Setters ------------------------------------------------------------------------
	public SubtipoActivoServicio getSubtipoActivoServicio() {
		return subtipoActivoServicio;
	}

	public void setSubtipoActivoServicio(SubtipoActivoServicio subtipoActivoServicio) {
		this.subtipoActivoServicio = subtipoActivoServicio;
	}	
}
