package credito.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.PromotoresBean;
import cliente.servicio.PromotoresServicio;

import credito.bean.LineasCreditoBean;
import credito.bean.ProspectosBean;
import credito.servicio.LineasCreditoServicio;
import credito.servicio.ProspectosServicio;

public class ProspectosListaControlador extends AbstractCommandController{

	
	ProspectosServicio prospectosServicio = null;
		
	public ProspectosListaControlador() {
			setCommandClass(ProspectosBean.class);
			setCommandName("prospectos");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	ProspectosBean prospectosBean = (ProspectosBean) command;
	List prospectos =	prospectosServicio.lista(tipoLista, prospectosBean);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(prospectos);
			
	return new ModelAndView("credito/prospectosListaVista", "listaResultado", listaResultado);
	}

	
	public void setProspectosServicio(ProspectosServicio prospectosServicio) {
		this.prospectosServicio = prospectosServicio;
	}

	
}
