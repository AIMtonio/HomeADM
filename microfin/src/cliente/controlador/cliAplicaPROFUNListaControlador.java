
package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.CliAplicaPROFUNBean;
import cliente.servicio.CliAplicaPROFUNServicio;

public class cliAplicaPROFUNListaControlador extends AbstractCommandController {
	
	CliAplicaPROFUNServicio cliAplicaPROFUNServicio = null;
	
	public cliAplicaPROFUNListaControlador() {
		setCommandClass(CliAplicaPROFUNBean.class);
		//setCommandName("clientePROFUN");
		setCommandName("ingresosOperaciones");
		
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		CliAplicaPROFUNBean cliAplicaPROFUN = (CliAplicaPROFUNBean) command;
		List clientesPROFUN =	cliAplicaPROFUNServicio.lista(tipoLista, cliAplicaPROFUN);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(clientesPROFUN);
		
		return new ModelAndView("cliente/cliAplicaPROFUNListaVista", "listaResultado",listaResultado);
	}

	public void setCliAplicaPROFUNServicio(CliAplicaPROFUNServicio cliAplicaPROFUNServicio) {
		this.cliAplicaPROFUNServicio = cliAplicaPROFUNServicio;
	}
	
	
}


