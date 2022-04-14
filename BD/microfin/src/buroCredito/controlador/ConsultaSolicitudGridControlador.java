package buroCredito.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import buroCredito.bean.SolBuroCreditoBean;
import buroCredito.servicio.SolBuroCreditoServicio;

public class ConsultaSolicitudGridControlador extends AbstractCommandController {

	SolBuroCreditoServicio solBuroCreditoServicio = null;
	//AvalesPorSoliciServicio avalesPorSoliciServicio = null;
	public ConsultaSolicitudGridControlador() {
		setCommandClass(SolBuroCreditoBean.class);
		setCommandName("solBuroCreditoBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {
	
		SolBuroCreditoBean solicitudBean = (SolBuroCreditoBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		//List buroCreditoList = solicitudCreditoServicio.lista(tipoLista, solicitudBean);
		solicitudBean.setFolioConsulta(request.getParameter("solicitudCreditoID"));
		List buroCreditoList = solBuroCreditoServicio.lista(tipoLista, solicitudBean);
		
		return new ModelAndView("buroCredito/consultaSolicitudGridVista", "listaResultado", buroCreditoList);
	}

	public void setSolBuroCreditoServicio(
			SolBuroCreditoServicio solBuroCreditoServicio) {
		this.solBuroCreditoServicio = solBuroCreditoServicio;
	}

	public SolBuroCreditoServicio getSolBuroCreditoServicio() {
		return solBuroCreditoServicio;
	}
	
}