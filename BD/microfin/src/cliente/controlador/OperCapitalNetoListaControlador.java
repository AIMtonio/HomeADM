package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.OperacionesCapitalNetoBean;
import cliente.servicio.OperacionesCapitalNetoServicio;

public class OperCapitalNetoListaControlador extends AbstractCommandController{
	
	OperacionesCapitalNetoServicio operacionesCapitalNetoServicio= null;
	
	public OperCapitalNetoListaControlador() {
		setCommandClass(OperacionesCapitalNetoBean.class);
		setCommandName("operacionesCapitalNetoBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		OperacionesCapitalNetoBean operCapitalNetoBean = (OperacionesCapitalNetoBean) command;
		List apoyoEscolarSol =	operacionesCapitalNetoServicio.lista(tipoLista, operCapitalNetoBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(apoyoEscolarSol);
		
		return new ModelAndView("cliente/operCapNetaListaVista", "listaResultado",listaResultado);
	}

	public OperacionesCapitalNetoServicio getOperacionesCapitalNetoServicio() {
		return operacionesCapitalNetoServicio;
	}

	public void setOperacionesCapitalNetoServicio(OperacionesCapitalNetoServicio operacionesCapitalNetoServicio) {
		this.operacionesCapitalNetoServicio = operacionesCapitalNetoServicio;
	}

	
	
	
}