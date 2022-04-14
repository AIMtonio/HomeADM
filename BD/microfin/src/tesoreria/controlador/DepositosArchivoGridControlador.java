package tesoreria.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.DepositosRefeBean;
import tesoreria.servicio.DepositosRefeServicio;

public class DepositosArchivoGridControlador extends AbstractCommandController{
	DepositosRefeServicio depositosRefeServicio = null;
	
	public DepositosArchivoGridControlador() {
		setCommandClass(DepositosRefeBean.class);
		setCommandName("depositosReferencia");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
			
		DepositosRefeBean depositosRefeBean = (DepositosRefeBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		
		List consultaDepositosList = depositosRefeServicio.lista(tipoLista, depositosRefeBean);
		
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(consultaDepositosList);
		
		return new ModelAndView("tesoreria/resultadoDepositoReferenciadoVista", "listaResultado", listaResultado);
	}

	//------------------ Setter y Getters --------------------------
	public DepositosRefeServicio getDepositosRefeServicio() {
		return depositosRefeServicio;
	}

	public void setDepositosRefeServicio(DepositosRefeServicio depositosRefeServicio) {
		this.depositosRefeServicio = depositosRefeServicio;
	}
}