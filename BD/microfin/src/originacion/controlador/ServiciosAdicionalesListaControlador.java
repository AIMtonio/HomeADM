package originacion.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.ProductosCreditoBean;
import credito.servicio.LineasCreditoServicio;
import credito.servicio.ProductosCreditoServicio;

import originacion.bean.ServiciosAdicionalesBean;
import originacion.servicio.ServiciosAdicionalesServicio;

public class ServiciosAdicionalesListaControlador extends AbstractCommandController {

	ServiciosAdicionalesServicio servicio = null;

	public ServiciosAdicionalesListaControlador(){
		setCommandClass(ServiciosAdicionalesBean.class);
		setCommandName("serviciosAdicionales");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
       	ServiciosAdicionalesBean instance = (ServiciosAdicionalesBean) command;
	    List serviciosAdicionales = servicio.lista(instance,tipoLista);
	    
	    List listaResultado = (List)new ArrayList();
	    listaResultado.add(tipoLista);
	    listaResultado.add(controlID);
	    listaResultado.add(serviciosAdicionales);
		return new ModelAndView("originacion/serviciosAdicionalesListaVista", "listaResultado", listaResultado);
	}
	public void setServiciosAdicionalesServicio(ServiciosAdicionalesServicio servicio) {
		this.servicio = servicio;
	}

} 

