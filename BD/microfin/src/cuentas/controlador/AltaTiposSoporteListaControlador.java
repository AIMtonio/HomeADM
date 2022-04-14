package cuentas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.AltaTiposSoporteBean;
import cuentas.servicio.AltaTiposSoporteServicio;

public class AltaTiposSoporteListaControlador extends AbstractCommandController{
	
	AltaTiposSoporteServicio altaTiposSoporteServicio = null;
	
	public AltaTiposSoporteListaControlador() {
		setCommandClass(AltaTiposSoporteBean.class);
		setCommandName("altaTiposSoporteBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		
		int tipoLista =(request.getParameter("tipoLista")!=null)?
		Integer.parseInt(request.getParameter("tipoLista")): 0;
				
		String controlID = request.getParameter("controlID");
				
		AltaTiposSoporteBean altaTiposSoporteBean = (AltaTiposSoporteBean) command;
		List tiposSoporte = altaTiposSoporteServicio.lista(tipoLista, altaTiposSoporteBean);		
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(tiposSoporte);
		
		return new ModelAndView("cuentas/altaTiposSoporteListaVista", "listaResultado",listaResultado);
	}
	
	// ---------------  GETTER y SETTER -------------------- 
	
	public AltaTiposSoporteServicio getAltaTiposSoporteServicio() {
		return altaTiposSoporteServicio;
	}

	public void setAltaTiposSoporteServicio(
			AltaTiposSoporteServicio altaTiposSoporteServicio) {
		this.altaTiposSoporteServicio = altaTiposSoporteServicio;
	}

}
