package crowdfunding.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import crowdfunding.bean.FondeoSolicitudBean;
import crowdfunding.servicio.FondeoSolicitudServicio;


public class ConsulInverCRWGridControlador extends AbstractCommandController {

	FondeoSolicitudServicio fondeoSolicitudServicio = null;

	public ConsulInverCRWGridControlador() {
		// TODO Auto-generated constructor stub

		setCommandClass(FondeoSolicitudBean.class);
		setCommandName("inversionistas");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {			
		FondeoSolicitudBean fondeoSolicitud = (FondeoSolicitudBean) command;
		fondeoSolicitudServicio.getFondeoSolicitudDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		fondeoSolicitud.setSolicitudCreditoID(request.getParameter("solicitudCreditoID"));

		List inversionistasCredito = fondeoSolicitudServicio.listaGrid(tipoLista, fondeoSolicitud);
		List listaResultado = (List)new ArrayList(); 
		listaResultado.add(inversionistasCredito);

		return new ModelAndView("crowdfunding/conInverCRWGridVista", "listaResultado", listaResultado);
	}

	public void setFondeoSolicitudServicio(FondeoSolicitudServicio fondeoSolicitudServicio) {
		this.fondeoSolicitudServicio = fondeoSolicitudServicio;
	}
}
