package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.GrupoMenuBean;
import soporte.bean.PlazasBean;
import soporte.servicio.GrupoMenuServicio;
import soporte.servicio.PlazasServicio;

public class GrupoMenuListaControlador extends AbstractCommandController {
	
	GrupoMenuServicio grupoMenuServicio = null;
	
	public GrupoMenuListaControlador() {
		setCommandClass(GrupoMenuBean.class);
		setCommandName("grupos");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	GrupoMenuBean grupo = (GrupoMenuBean) command;
	List grupos =	grupoMenuServicio.lista(tipoLista, grupo);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(grupos);
			
	return new ModelAndView("soporte/gruposMenuListaVista", "listaResultado", listaResultado);
	}

	
	public void setGrupoMenuServicio(GrupoMenuServicio grupoMenuServicio) {
		this.grupoMenuServicio = grupoMenuServicio;
	}

}


