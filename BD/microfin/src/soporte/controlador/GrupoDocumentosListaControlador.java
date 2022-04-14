package soporte.controlador;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.ArrayList;
import java.util.List;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.GrupoDocumentosBean;
import soporte.servicio.GrupoDocumentosServicio;;
public class GrupoDocumentosListaControlador extends AbstractCommandController{
	
	GrupoDocumentosServicio grupoDocumentosServicio = null;
	
	public GrupoDocumentosListaControlador() {
		setCommandClass(GrupoDocumentosBean.class);
		setCommandName("grupoDocumentosBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
	
		
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")): 0;
				
				String controlID = request.getParameter("controlID");
		
		GrupoDocumentosBean grupoDocumentosBean = (GrupoDocumentosBean) command;
		List grupodoctos =grupoDocumentosServicio.listaP(tipoLista, grupoDocumentosBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(grupodoctos);
		
		return new ModelAndView("soporte/grupoDocumentosListaVista", "listaResultado",listaResultado);
	}

	public void setGrupoDocumentosServicio(
			GrupoDocumentosServicio grupoDocumentosServicio) {
		this.grupoDocumentosServicio = grupoDocumentosServicio;
	}


	
}
