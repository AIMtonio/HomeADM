package cedes.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cedes.bean.CedesBean;
import cedes.servicio.CedesServicio;

public class CedesListaControlador extends AbstractCommandController{
	
	CedesServicio cedesServicio = null;
	
	public CedesListaControlador() {
		setCommandClass(CedesBean.class);
		setCommandName("cedesBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		CedesBean cedesBean = (CedesBean) command;
		List cedes =	cedesServicio.lista(tipoLista, cedesBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(cedes); 
		
		return new ModelAndView("cedes/cedesListaVista", "listaResultado",listaResultado);
	}

	public CedesServicio getCedesServicio() {
		return cedesServicio;
	}

	public void setCedesServicio(CedesServicio cedesServicio) {
		this.cedesServicio = cedesServicio;
	}

	
	
	
}
