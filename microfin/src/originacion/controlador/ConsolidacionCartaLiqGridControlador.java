package originacion.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.ConsolidacionCartaLiqBean;
import originacion.servicio.ConsolidacionCartaLiqServicio;

public class ConsolidacionCartaLiqGridControlador extends AbstractCommandController{
	ConsolidacionCartaLiqServicio consolidaCartaLiqServicio;
	
	public ConsolidacionCartaLiqGridControlador (){
		setCommandClass(ConsolidacionCartaLiqBean.class);
		setCommandName("consolidaCartas");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	    String solicitudCreditoID=request.getParameter("solicitudCreditoID");

	    ConsolidacionCartaLiqBean consolidaBean = new ConsolidacionCartaLiqBean();
	    
	    consolidaBean.setSolicitudCreditoID(solicitudCreditoID);
     
		List consolidaCartaLista = consolidaCartaLiqServicio.lista(tipoLista, consolidaBean);
		List listaResultado = (List)new ArrayList();
		listaResultado.add(consolidaCartaLista);
              
		return new ModelAndView("originacion/asignaCartaLiqExternaGridVista", "listaResultado", listaResultado);
	}
	
	public ConsolidacionCartaLiqServicio getConsolidaCartaLiqServicio(){
		return consolidaCartaLiqServicio;
	}
	
	public void setConsolidaCartaLiqServicio(ConsolidacionCartaLiqServicio consolidaCartaLiqServicio){
		this.consolidaCartaLiqServicio = consolidaCartaLiqServicio;
	}
}
