package originacion.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.AsignaCartaLiqBean;
import originacion.servicio.AsignaCartaLiqServicio;

public class AsignaCartaLiqGridControlador extends AbstractCommandController{
	AsignaCartaLiqServicio asignaCartaLiqServicio;
	
	public AsignaCartaLiqGridControlador() {
		setCommandClass(AsignaCartaLiqBean.class);
		setCommandName("asignaCarta");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista 				= Integer.parseInt(request.getParameter("tipoLista"));
	    String solicitudCreditoID	= request.getParameter("solicitudCreditoID");
	    String consolidacionCartaID = request.getParameter("consolidacionCartaID");
	    String recurso				= request.getParameter("recurso");

	    AsignaCartaLiqBean asignaBean = new AsignaCartaLiqBean();
	    
	    asignaBean.setSolicitudCreditoID(solicitudCreditoID);
	    asignaBean.setConsolidacionID(consolidacionCartaID);
	    asignaBean.setRecurso(recurso);
	    
		List asignaCartaLista = asignaCartaLiqServicio.lista(tipoLista, asignaBean);
		List listaResultado = (List)new ArrayList();
		listaResultado.add(asignaCartaLista);
		
        if(tipoLista == 2 || tipoLista == 4) {
        	return new ModelAndView("originacion/asignaCartaLiqInternaGridVista", "listaResultado", listaResultado);
        }
		return new ModelAndView("originacion/asignaCartaLiqExternaGridVista", "listaResultado", listaResultado);
	}
	
	
	public AsignaCartaLiqServicio getAsignaCartaLiqServicio(){
		return asignaCartaLiqServicio;
	}
	
	public void setAsignaCartaLiqServicio(AsignaCartaLiqServicio asignaCartaLiqServicio){
		this.asignaCartaLiqServicio = asignaCartaLiqServicio;
	}

}
