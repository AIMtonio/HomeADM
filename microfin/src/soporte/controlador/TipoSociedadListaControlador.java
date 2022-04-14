package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.TipoSociedadBean;
import soporte.servicio.TipoSociedadServicio;


public class TipoSociedadListaControlador extends AbstractCommandController {

	TipoSociedadServicio tipoSociedadServicio = null;
	
	public TipoSociedadListaControlador() {
		setCommandClass(TipoSociedadBean.class);
		setCommandName("tipoSociedad");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		TipoSociedadBean tipoSoc = (TipoSociedadBean) command;
		List tipoSociedad =	tipoSociedadServicio.lista(tipoLista, tipoSoc);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(tipoSociedad);
		
		return new ModelAndView("soporte/tipoSociedadListaVista", "listaResultado",listaResultado);
	}

	public void setTipoSociedadServicio(TipoSociedadServicio tipoSociedadServicio) {
		this.tipoSociedadServicio = tipoSociedadServicio;
	}
	
}
