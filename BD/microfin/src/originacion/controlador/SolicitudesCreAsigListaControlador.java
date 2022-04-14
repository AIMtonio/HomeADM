package originacion.controlador;


import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.SolicitudesCreAsigBean;
import originacion.servicio.SolicitudesCreAsigServicio;
import credito.bean.LineasCreditoBean;
import credito.servicio.LineasCreditoServicio;

public class SolicitudesCreAsigListaControlador extends AbstractCommandController {

	SolicitudesCreAsigServicio solicitudesCreAsigServicio = null;

	public SolicitudesCreAsigListaControlador(){
		setCommandClass(SolicitudesCreAsigBean.class);
		setCommandName("solicitudesCreAsig");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
       String controlID = request.getParameter("controlID");
       
       SolicitudesCreAsigBean solicitudesCreAsigBean = (SolicitudesCreAsigBean) command;
                List solicitudesCreAsig = solicitudesCreAsigServicio.lista(tipoLista, solicitudesCreAsigBean);
                
                List listaResultado = (List)new ArrayList();
                listaResultado.add(tipoLista);
                listaResultado.add(controlID);
                listaResultado.add(solicitudesCreAsig);
		return new ModelAndView("originacion/solicitudesCreAsigListaVista", "listaResultado", listaResultado);
	}
	public void setSolicitudesCreAsigServicio(
			SolicitudesCreAsigServicio solicitudesCreAsigServicio) {
		this.solicitudesCreAsigServicio = solicitudesCreAsigServicio;
	}

} 

