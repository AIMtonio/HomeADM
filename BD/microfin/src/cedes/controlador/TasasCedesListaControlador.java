package cedes.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cedes.bean.TasasCedesBean;
import cedes.servicio.TasasCedesServicio;

public class TasasCedesListaControlador extends AbstractCommandController{

	
	TasasCedesServicio tasasCedesServicio = null;
	


	public TasasCedesListaControlador() {
		setCommandClass(TasasCedesBean.class);
		setCommandName("tasasBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");
	
	TasasCedesBean tasasCedesBean = (TasasCedesBean) command;
	List tasas =	tasasCedesServicio.lista(tipoLista, tasasCedesBean);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(tasas);
	
	return new ModelAndView("cedes/tasasCedesListaVista", "listaResultado", listaResultado);
	}
	

	public TasasCedesServicio getTasasCedesServicio() {
		return tasasCedesServicio;
	}

	public void setTasasCedesServicio(TasasCedesServicio tasasCedesServicio) {
		this.tasasCedesServicio = tasasCedesServicio;
	}
	
} 
