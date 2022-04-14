package soporte.controlador;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.ArrayList;
import java.util.List;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.TiposDocumentosBean;
import soporte.servicio.TiposDocumentosServicio;
public class TiposDocumentosListaControlador extends AbstractCommandController{
	
	TiposDocumentosServicio tiposDocumentosServicio = null;
	
	public TiposDocumentosListaControlador() {
		setCommandClass(TiposDocumentosBean.class);
		setCommandName("tiposDocumentosBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
	
		
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")): 0;
				
		String controlID = request.getParameter("controlID");
		
		TiposDocumentosBean tiposDocumentosBean = (TiposDocumentosBean) command;
	
		List grupodoctos =tiposDocumentosServicio.lista(tipoLista, tiposDocumentosBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(grupodoctos);
		
		return new ModelAndView("soporte/tiposDocumentosListaVista", "listaResultado",listaResultado);
	}

	public void setTiposDocumentosServicio(
			TiposDocumentosServicio tiposDocumentosServicio) {
		this.tiposDocumentosServicio = tiposDocumentosServicio;
	}

	

	
}
