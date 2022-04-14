package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.LimiteOperClienteBean;
import cliente.servicio.LimiteOperClienteServicio;

public class LimiteOperClienteListaControlador extends AbstractCommandController {
	
	LimiteOperClienteServicio limiteOperClienteServicio = null;
	
	public LimiteOperClienteListaControlador(){
 		setCommandClass(LimiteOperClienteBean.class);
 		setCommandName("limiteOperClienteBean");
 	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));		
		String controlID = request.getParameter("controlID");
    
		LimiteOperClienteBean limiteOperClienteBean = (LimiteOperClienteBean) command;
        List usuario = limiteOperClienteServicio.lista(tipoLista, limiteOperClienteBean);
             
	    List listaResultado = (List)new ArrayList();
	    listaResultado.add(tipoLista);
	    listaResultado.add(controlID);
	    listaResultado.add(usuario);
		return new ModelAndView("cliente/limiteOperClienteListaVista", "listaResultado", listaResultado);
	}

	public LimiteOperClienteServicio getLimiteOperClienteServicio() {
		return limiteOperClienteServicio;
	}

	public void setLimiteOperClienteServicio(LimiteOperClienteServicio limiteOperClienteServicio) {
		this.limiteOperClienteServicio = limiteOperClienteServicio;
	}

	

}
