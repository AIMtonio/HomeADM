package arrendamiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import arrendamiento.bean.AseguradoraActivoBean;
import arrendamiento.servicio.AseguradoraActivoServicio;

public class AseguradoraActivoListaVistaControlador extends AbstractCommandController {
	
	AseguradoraActivoServicio aseguradoraActivoServicio = null;
	
	public AseguradoraActivoListaVistaControlador() {
		setCommandClass(AseguradoraActivoBean.class);
		setCommandName("aseguradoraActivoBean");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		AseguradoraActivoBean aseguradoraActivoBean = (AseguradoraActivoBean) command;
	
		List listaSubtipos = aseguradoraActivoServicio.lista(tipoLista, aseguradoraActivoBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaSubtipos);
			
	return new ModelAndView("arrendamiento/aseguradoraActivoListaVista", "listaResultado", listaResultado);
	}

	//---------- Getter y Setters ------------------------------------------------------------------------
	public AseguradoraActivoServicio getAseguradoraActivoServicio() {
		return aseguradoraActivoServicio;
	}

	public void setAseguradoraActivoServicio(
			AseguradoraActivoServicio aseguradoraActivoServicio) {
		this.aseguradoraActivoServicio = aseguradoraActivoServicio;
	}
}
