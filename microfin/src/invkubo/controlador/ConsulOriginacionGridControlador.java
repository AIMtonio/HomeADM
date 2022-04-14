package invkubo.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import invkubo.bean.FondeoSolicitudBean;
import invkubo.servicio.FondeoSolicitudServicio;

public class ConsulOriginacionGridControlador extends AbstractCommandController {


	FondeoSolicitudServicio fondeoSolicitudServicio = null;
	
	public ConsulOriginacionGridControlador() {
		// TODO Auto-generated constructor stub
		
		setCommandClass(FondeoSolicitudBean.class);
		setCommandName("solicitudCreditos");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {			
		FondeoSolicitudBean fondeoSolicitud = (FondeoSolicitudBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		fondeoSolicitud.setSolicitudCreditoID(request.getParameter("solicitudCreditoID"));

		List inversionistasCredito = fondeoSolicitudServicio.listaGrid(tipoLista, fondeoSolicitud);
		List listaResultado = (List)new ArrayList(); 
		listaResultado.add(inversionistasCredito);

		return new ModelAndView("invKubo/inversionesKuboGrid", "listaResultado", listaResultado);
	}

	public void setFondeoSolicitudServicio(FondeoSolicitudServicio fondeoSolicitudServicio) {
		this.fondeoSolicitudServicio = fondeoSolicitudServicio;
	}
}
