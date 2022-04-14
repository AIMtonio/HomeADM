package arrendamiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import arrendamiento.bean.DepositoRefereArrendaBean;
import arrendamiento.servicio.DepositoRefereArrendaServicio;

public class DepositoRefeArrendaListaControlador extends AbstractCommandController {
	
	DepositoRefereArrendaServicio depositoRefereArrendaServicio = null;
	
	public DepositoRefeArrendaListaControlador() {
		setCommandClass(DepositoRefereArrendaBean.class);
		setCommandName("depositoRefereArrendaBean");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {

	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	DepositoRefereArrendaBean arrendamientos = (DepositoRefereArrendaBean) command;
	
	List lineaArrenda =	 depositoRefereArrendaServicio.lista(tipoLista, arrendamientos);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(lineaArrenda);
			
	return new ModelAndView("arrendamiento/depositoRefereArrendaListaVista", "listaResultado", listaResultado);
	}

	public DepositoRefereArrendaServicio getDepositoRefereArrendaServicio() {
		return depositoRefereArrendaServicio;
	}

	public void setDepositoRefereArrendaServicio(
			DepositoRefereArrendaServicio depositoRefereArrendaServicio) {
		this.depositoRefereArrendaServicio = depositoRefereArrendaServicio;
	}	
}
