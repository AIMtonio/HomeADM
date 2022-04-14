package arrendamiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import arrendamiento.bean.ActivoArrendaBean;
import arrendamiento.servicio.ActivoArrendaServicio;

public class CatalogoActivosListaControlador extends AbstractCommandController {
	
	ActivoArrendaServicio activoArrendaServicio = null;
	
	public CatalogoActivosListaControlador() {
		setCommandClass(ActivoArrendaBean.class);
		setCommandName("activoBean");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		ActivoArrendaBean activoBean = (ActivoArrendaBean) command;
	
		List listaActivos =	 activoArrendaServicio.lista(tipoLista, activoBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaActivos);
			
	return new ModelAndView("arrendamiento/catalogoActivosListaVista", "listaResultado", listaResultado);
	}

	//---------- Getter y Setters ------------------------------------------------------------------------
	public ActivoArrendaServicio getActivoArrendaServicio() {
		return activoArrendaServicio;
	}

	public void setActivoArrendaServicio(ActivoArrendaServicio activoArrendaServicio) {
		this.activoArrendaServicio = activoArrendaServicio;
	}	
}
