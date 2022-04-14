package tesoreria.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.PresupuestoSucursalBean;
import tesoreria.servicio.PresupSucursalServicio;

public class PresupSucurListaControlador  extends AbstractCommandController {
	PresupSucursalServicio  presupSucursalServicio =null;

	public PresupSucurListaControlador(){
		setCommandClass(PresupuestoSucursalBean.class);
		setCommandName("partidaPresupuestoLista");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
      
        PresupuestoSucursalBean preSucBean = (PresupuestoSucursalBean) command;
                List partidaPresLis= presupSucursalServicio.listaPartidaPre(tipoLista, preSucBean);
                 		                
                List listaResultado = (List)new ArrayList();
                listaResultado.add(tipoLista);
                listaResultado.add(controlID);
                listaResultado.add(partidaPresLis);
		return new ModelAndView("tesoreria/partidaPresSucurLista", "listaResultado", listaResultado);
	}
	public void setPresupSucursalServicio(PresupSucursalServicio presupSucursalServicio) {
		this.presupSucursalServicio = presupSucursalServicio;
	}        
}
