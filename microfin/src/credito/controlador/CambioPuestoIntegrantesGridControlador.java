package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CambioPuestoIntegrantesBean;
import credito.servicio.CambioPuestoIntegrantesServicio;

public class CambioPuestoIntegrantesGridControlador  extends AbstractCommandController{

CambioPuestoIntegrantesServicio cambioPuestoIntegrantesServicio = null;
	
	public CambioPuestoIntegrantesGridControlador(){
		setCommandClass(CambioPuestoIntegrantesBean.class);
		setCommandName("cambioPuestoIntegrantesBean");	
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {	
		
		CambioPuestoIntegrantesBean cambioPuestoIntegrantesBean =(CambioPuestoIntegrantesBean) command;
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List gruposList = cambioPuestoIntegrantesServicio.lista(tipoLista, cambioPuestoIntegrantesBean);
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(gruposList);
		
		return new ModelAndView("credito/cambioPuestoIntegrantesGridVista", "listaResultado", listaResultado);
	}

	/* Getter y Setter */
	public CambioPuestoIntegrantesServicio getCambioPuestoIntegrantesServicio() {
		return cambioPuestoIntegrantesServicio;
	}

	public void setCambioPuestoIntegrantesServicio(
			CambioPuestoIntegrantesServicio cambioPuestoIntegrantesServicio) {
		this.cambioPuestoIntegrantesServicio = cambioPuestoIntegrantesServicio;
	}
	
	
}
