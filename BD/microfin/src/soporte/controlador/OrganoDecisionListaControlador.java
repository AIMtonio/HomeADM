package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


import soporte.servicio.OrganoDecisionServicio;
import soporte.bean.OrganoDecisionBean;


public class OrganoDecisionListaControlador extends AbstractCommandController {


	private OrganoDecisionServicio organoDecisionServicio;
	
		public OrganoDecisionListaControlador() {
				setCommandClass(OrganoDecisionBean.class);
				setCommandName("organosDecision");
		}
				
		protected ModelAndView handle(HttpServletRequest request,
										  HttpServletResponse response,
										  Object command,
										  BindException errors) throws Exception {
				
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		OrganoDecisionBean organosDecision = (OrganoDecisionBean) command;
		List resiltadoOrganos =	organoDecisionServicio.lista(tipoLista, organosDecision);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(resiltadoOrganos);
			
		return new ModelAndView("soporte/organosDecisionListaVista", "listaResultado", listaResultado);
		}
				
		//-------------setter---------------------------
		public void setOrganoDecisionServicio(OrganoDecisionServicio organoDecisionServicio) {
			this.organoDecisionServicio = organoDecisionServicio;
		}

		
}


