package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.AdicionalPersonaMoralBean;
import cliente.servicio.AdicionalPersonaMoralServicio;


public class AdicionalPersonaMoralListaControlador extends AbstractCommandController {
	
	AdicionalPersonaMoralServicio adicionalPersonaMoralServicio = null;
	
	public AdicionalPersonaMoralListaControlador(){
 		setCommandClass(AdicionalPersonaMoralBean.class);
 		setCommandName("adicionalPersonaMoralLista");
 	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));		
		String controlID = request.getParameter("controlID");
    
		AdicionalPersonaMoralBean limiteOperClienteBean = (AdicionalPersonaMoralBean) command;
        List directivos = adicionalPersonaMoralServicio.lista(tipoLista, limiteOperClienteBean);
             
	    List listaResultado = (List)new ArrayList();
	    listaResultado.add(tipoLista);
	    listaResultado.add(controlID);
	    listaResultado.add(directivos);
		return new ModelAndView("cliente/adicionalPersonaMoralListaVista", "listaResultado", listaResultado);
	}

	public AdicionalPersonaMoralServicio getAdicionalPersonaMoralServicio() {
		return adicionalPersonaMoralServicio;
	}

	public void setAdicionalPersonaMoralServicio(
			AdicionalPersonaMoralServicio adicionalPersonaMoralServicio) {
		this.adicionalPersonaMoralServicio = adicionalPersonaMoralServicio;
	}

	

	

}
