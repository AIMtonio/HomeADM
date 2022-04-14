package nomina.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import nomina.bean.GeneraDomiciliacionPagosBean;
import nomina.servicio.GeneraDomiciliacionPagosServicio;

public class GeneraDomiciliacionPagosListaControlador extends AbstractCommandController {
	
	GeneraDomiciliacionPagosServicio generaDomiciliacionPagosServicio = null;
	
	
	public GeneraDomiciliacionPagosListaControlador(){
		setCommandClass(GeneraDomiciliacionPagosBean.class);
		setCommandName("generaDomiciliacionPagosBean");
 	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	      String controlID = request.getParameter("controlID");
	      
	      GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean  = (GeneraDomiciliacionPagosBean) command;
	      
	      List domiciliacionPagos = generaDomiciliacionPagosServicio.lista(tipoLista, generaDomiciliacionPagosBean);
	      
	      List listaResultado = (List)new ArrayList();
	      listaResultado.add(tipoLista);
	      listaResultado.add(controlID);
	      listaResultado.add(domiciliacionPagos);
	      
	      return new ModelAndView("nomina/domiciliacionPagosListaVista", "listaResultado", listaResultado);
		
	}
	// ======== GETTER & SETTER ================== //

	public GeneraDomiciliacionPagosServicio getGeneraDomiciliacionPagosServicio() {
		return generaDomiciliacionPagosServicio;
	}

	public void setGeneraDomiciliacionPagosServicio(GeneraDomiciliacionPagosServicio generaDomiciliacionPagosServicio) {
		this.generaDomiciliacionPagosServicio = generaDomiciliacionPagosServicio;
	}
	
}
