package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.SeguroClienteBean;
import cliente.servicio.SeguroClienteServicio;


public class SeguroClienteListaControlador extends AbstractCommandController {

	SeguroClienteServicio seguroClienteServicio=null;
	public SeguroClienteListaControlador(){
		setCommandClass(SeguroClienteBean.class);
		setCommandName("seguroClienteBean");
	}
	protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		SeguroClienteBean seguroClientes = (SeguroClienteBean) command;
		List seguroCliente =	seguroClienteServicio.lista(tipoLista, seguroClientes);

		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(seguroCliente);

		return new ModelAndView("cliente/seguroClienteListaVista", "listaResultado", listaResultado);
	}
	
	//-------------------setter-------------------
	public void setSeguroClienteServicio(SeguroClienteServicio seguroClienteServicio) {
		this.seguroClienteServicio = seguroClienteServicio;
	}
	
	
}
