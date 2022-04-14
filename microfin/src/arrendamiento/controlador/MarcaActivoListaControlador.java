package arrendamiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import arrendamiento.bean.MarcaActivoBean;
import arrendamiento.servicio.MarcaActivoServicio;

public class MarcaActivoListaControlador extends AbstractCommandController {
	
	MarcaActivoServicio marcaActivoServicio = null;
	
	public MarcaActivoListaControlador() {
		setCommandClass(MarcaActivoBean.class);
		setCommandName("marcaActivoBean");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		MarcaActivoBean marcaActivoBean = (MarcaActivoBean) command;
	
		List listaSubtipos = marcaActivoServicio.lista(tipoLista, marcaActivoBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaSubtipos);
			
	return new ModelAndView("arrendamiento/marcaActivoListaVista", "listaResultado", listaResultado);
	}

	//---------- Getter y Setters ------------------------------------------------------------------------
	public MarcaActivoServicio getMarcaActivoServicio() {
		return marcaActivoServicio;
	}

	public void setMarcaActivoServicio(MarcaActivoServicio marcaActivoServicio) {
		this.marcaActivoServicio = marcaActivoServicio;
	}
	
	
}
