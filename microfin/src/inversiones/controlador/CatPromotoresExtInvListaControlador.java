package inversiones.controlador;


import inversiones.bean.CatPromotoresExtInvBean;
import inversiones.servicio.CatPromotoresExtInvServicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class CatPromotoresExtInvListaControlador extends AbstractCommandController {

	CatPromotoresExtInvServicio catPromotoresExtInvServicio = null;
	
	public CatPromotoresExtInvListaControlador() {
		setCommandClass(CatPromotoresExtInvBean.class);
		setCommandName("catPromotoresExtInvBean");
		}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		CatPromotoresExtInvBean promotorInv = (CatPromotoresExtInvBean) command;
		List promotor =	catPromotoresExtInvServicio.lista(tipoLista, promotorInv);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(promotor);
		
		return new ModelAndView("inversiones/catPromotoresExtInvListaVista", "listaResultado",listaResultado);
	}

	public CatPromotoresExtInvServicio getBeneficiariosInverServicio() {
		return catPromotoresExtInvServicio;
	}

	public void setCatPromotoresExtInvServicio(
			CatPromotoresExtInvServicio catPromotoresExtInvServicio) {
		this.catPromotoresExtInvServicio = catPromotoresExtInvServicio;
	}

	
	
	
}
