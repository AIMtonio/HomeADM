package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.OrganoDecisionBean;
import soporte.servicio.OrganoDecisionServicio;

public class OrganoDecisionListaGridControlador extends AbstractCommandController{
	
	OrganoDecisionServicio   organoDecisionServicio   = null;
	
	public OrganoDecisionListaGridControlador() {
			setCommandClass(OrganoDecisionBean.class);
			setCommandName("institucion");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
	OrganoDecisionBean ornagoDecision = (OrganoDecisionBean) command;
	List listaOrganosDecision =	organoDecisionServicio.lista(tipoLista, ornagoDecision);
	
	return new ModelAndView("soporte/organosDecisionGridVista", "listaResultado", listaOrganosDecision);
		
	
	}

	//---------- setter--------------
	public void setOrganoDecisionServicio(
			OrganoDecisionServicio organoDecisionServicio) {
		this.organoDecisionServicio = organoDecisionServicio;
	}
	
	
	

}
