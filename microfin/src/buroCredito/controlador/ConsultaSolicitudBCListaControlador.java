package buroCredito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.SolicitudCreditoBean;
import originacion.servicio.SolicitudCreditoServicio;

public class ConsultaSolicitudBCListaControlador extends AbstractCommandController{
	SolicitudCreditoServicio solicitudCreditoServicio  = null;
	
	public ConsultaSolicitudBCListaControlador(){
		setCommandClass(SolicitudCreditoBean.class);
		setCommandName("solicitudCreditoBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		SolicitudCreditoBean solicitudCreditoBean = (SolicitudCreditoBean) command;
		List solicitudCreditoList = solicitudCreditoServicio.lista(tipoLista, solicitudCreditoBean);

		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(solicitudCreditoList);
		return new ModelAndView("originacion/solicitudCreditoListaVista", "listaResultado", listaResultado);
	}

	public SolicitudCreditoServicio getSolicitudCreditoServicio() {
		return solicitudCreditoServicio;
	}

	public void setSolicitudCreditoServicio(
			SolicitudCreditoServicio solicitudCreditoServicio) {
		this.solicitudCreditoServicio = solicitudCreditoServicio;
	}
	
	
}
