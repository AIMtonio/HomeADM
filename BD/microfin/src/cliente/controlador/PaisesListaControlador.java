package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.PaisesBean;
import cliente.servicio.PaisesServicio;

public class PaisesListaControlador extends AbstractCommandController{

	
	PaisesServicio paisesServicio = null;
		
	public PaisesListaControlador() {
			setCommandClass(PaisesBean.class);
			setCommandName("pais");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	PaisesBean pais = (PaisesBean) command;
	List paises =	paisesServicio.lista(tipoLista, pais);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(paises);
			
	return new ModelAndView("cliente/paisesListaVista", "listaResultado", listaResultado);
	}

	public void setPaisesServicio(PaisesServicio paisesServicio) {
		this.paisesServicio = paisesServicio;
	}
		
		
	
}
