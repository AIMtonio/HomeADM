package buroCredito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import buroCredito.bean.SolBuroCreditoBean;
import buroCredito.servicio.SolBuroCreditoServicio;

public class ReporteBCListaControlador extends AbstractCommandController {
	SolBuroCreditoServicio solBuroCreditoServicio = null;
	
	public ReporteBCListaControlador(){
		setCommandClass(SolBuroCreditoBean.class);
		setCommandName("solBuroCreditoBean");

	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");
	SolBuroCreditoBean solBuroCreditoBean = (SolBuroCreditoBean) command;
	List solBuroCreditoList = solBuroCreditoServicio.lista(tipoLista, solBuroCreditoBean);
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(solBuroCreditoList);

	return new ModelAndView("buroCredito/reporteBCListaVista", "listaResultado", listaResultado);
}

	public SolBuroCreditoServicio getSolBuroCreditoServicio() {
		return solBuroCreditoServicio;
	}

	public void setSolBuroCreditoServicio(
			SolBuroCreditoServicio solBuroCreditoServicio) {
		this.solBuroCreditoServicio = solBuroCreditoServicio;
	}
	
}
