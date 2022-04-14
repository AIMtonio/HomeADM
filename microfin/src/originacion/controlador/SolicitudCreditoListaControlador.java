package originacion.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.SolicitudCreditoBean;
import originacion.servicio.SolicitudCreditoServicio;

import credito.bean.LineasCreditoBean;
import credito.servicio.LineasCreditoServicio;

public class SolicitudCreditoListaControlador extends AbstractCommandController {

	SolicitudCreditoServicio solicitudCreditoServicio = null;

	public SolicitudCreditoListaControlador(){
		setCommandClass(SolicitudCreditoBean.class);
		setCommandName("solicitudCredito");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		String tp=request.getParameter("tipoLista");
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
       String controlID = request.getParameter("controlID");
       
       SolicitudCreditoBean solicitudCreditoBean = (SolicitudCreditoBean) command;

                List solicitudesCredito = solicitudCreditoServicio.lista(tipoLista, solicitudCreditoBean);
                List listaResultado = (List)new ArrayList();
                listaResultado.add(tipoLista);
                listaResultado.add(controlID);
                listaResultado.add(solicitudesCredito);
                
		return new ModelAndView("originacion/solicitudCreditoListaVista", "listaResultado", listaResultado);
	}
	
	public void setSolicitudCreditoServicio(
			SolicitudCreditoServicio solicitudCreditoServicio) {
		this.solicitudCreditoServicio = solicitudCreditoServicio;
	}
	
} 
