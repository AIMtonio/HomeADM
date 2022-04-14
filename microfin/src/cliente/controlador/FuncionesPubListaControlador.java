package cliente.controlador;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.FuncionesPubBean;
import cliente.servicio.FuncionesPubServicio;



public class FuncionesPubListaControlador extends AbstractCommandController{
	
	FuncionesPubServicio funcionesPubServicio = null;
		
	public FuncionesPubListaControlador() {
			setCommandClass(FuncionesPubBean.class);
			setCommandName("funciones");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	FuncionesPubBean funcion = (FuncionesPubBean) command;
	List funciones =	funcionesPubServicio.lista(tipoLista, funcion);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(funciones);
			
	return new ModelAndView("cliente/funcionesPubListaVista", "listaResultado", listaResultado);
	}

	public void setFuncionesPubServicio(FuncionesPubServicio funcionesPubServicio) {
		this.funcionesPubServicio = funcionesPubServicio;
	}



}
