package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ServiFunFoliosBean;
import cliente.servicio.ServiFunFoliosServicio;

public class ServiFunFoliosListaControlador extends AbstractCommandController{
	
	ServiFunFoliosServicio serviFunFoliosServicio = null;
		
	public ServiFunFoliosListaControlador() {
			setCommandClass(ServiFunFoliosBean.class);
			setCommandName("serviFunFoliosBean");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");
	
	ServiFunFoliosBean serviFun = (ServiFunFoliosBean) command;
	List serviFunLista =	serviFunFoliosServicio.listaServiFun(tipoLista, serviFun);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(serviFunLista);
		
	return new ModelAndView("cliente/serviFunFoliosListaVista", "listaResultado", listaResultado);
	}
	
	//------------------setter 
	public void setServiFunFoliosServicio(
			ServiFunFoliosServicio serviFunFoliosServicio) {
		this.serviFunFoliosServicio = serviFunFoliosServicio;
	}

		
}
