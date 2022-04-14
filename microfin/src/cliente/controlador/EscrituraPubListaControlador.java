package cliente.controlador;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.EscrituraPubBean;
import cliente.servicio.EscrituraPubServicio;



public class EscrituraPubListaControlador extends AbstractCommandController {
	
	EscrituraPubServicio escrituraServicio = null;
	
	public EscrituraPubListaControlador() {
		setCommandClass(EscrituraPubBean.class);
		setCommandName("escrituras");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	EscrituraPubBean escritura = (EscrituraPubBean) command;
	List escrituras =	escrituraServicio.lista(tipoLista, escritura);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(escrituras);
			
	return new ModelAndView("cliente/escrituraPubListaVista", "listaResultado", listaResultado);
	}

	public void setEscrituraPubServicio(EscrituraPubServicio escrituraServicio) {
		this.escrituraServicio = escrituraServicio;
	}
	
	
}
