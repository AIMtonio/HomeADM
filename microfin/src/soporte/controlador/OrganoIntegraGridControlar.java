package soporte.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.OrganoIntegraBean;
import soporte.servicio.OrganoIntegraServicio;

public class OrganoIntegraGridControlar  extends AbstractCommandController {
	OrganoIntegraServicio   organoIntegraServicio   = null;
	
	public OrganoIntegraGridControlar() {
			setCommandClass(OrganoIntegraBean.class);
			setCommandName("organoIntegra");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
	OrganoIntegraBean organoIntegra = (OrganoIntegraBean) command;
	List listaOrganosIntegra =	organoIntegraServicio.lista(tipoLista, organoIntegra);
	
	return new ModelAndView("soporte/organosIntegraGridVista", "listaResultado", listaOrganosIntegra);
		
	
	}


	//---------- setter--------------
	public void setOrganoIntegraServicio(OrganoIntegraServicio organoIntegraServicio) {
		this.organoIntegraServicio = organoIntegraServicio;
	}

}
