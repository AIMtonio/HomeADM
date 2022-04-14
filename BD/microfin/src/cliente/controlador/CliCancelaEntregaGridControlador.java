package cliente.controlador; 

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.CliCancelaEntregaBean;
import cliente.servicio.CliCancelaEntregaServicio;

 public class CliCancelaEntregaGridControlador extends AbstractCommandController {

	 CliCancelaEntregaServicio cliCancelaEntregaServicio = null;

 	public CliCancelaEntregaGridControlador(){
 		setCommandClass(CliCancelaEntregaBean.class);
 		setCommandName("cliCancelaEntregaBean");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        CliCancelaEntregaBean cliCancelaEntregaBean = (CliCancelaEntregaBean) command;
        List listaCliCancelaEntrega = cliCancelaEntregaServicio.lista(tipoLista, cliCancelaEntregaBean);
     
        List listaResultado = (List)new ArrayList();
        listaResultado.add(tipoLista);
        listaResultado.add(listaCliCancelaEntrega);
 		return new ModelAndView("cliente/cliCancelaEntregaGridVista", "listaResultado", listaResultado);
 	}

	public CliCancelaEntregaServicio getCliCancelaEntregaServicio() {
		return cliCancelaEntregaServicio;
	}

	public void setCliCancelaEntregaServicio(
			CliCancelaEntregaServicio cliCancelaEntregaServicio) {
		this.cliCancelaEntregaServicio = cliCancelaEntregaServicio;
	}

 	
 } 
