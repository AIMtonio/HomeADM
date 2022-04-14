package cedes.controlador;

import inversiones.bean.InversionBean;
import inversiones.servicio.InversionServicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cedes.bean.CedesAnclajeBean;
import cedes.bean.CedesBean;
import cedes.servicio.CedesAnclajeServicio;
import cedes.servicio.CedesServicio;

public class CedesAnclajeListaControlador extends AbstractCommandController{

	
	CedesAnclajeServicio cedesAnclajeServicio = null;
	
	public CedesAnclajeListaControlador() {
		setCommandClass(CedesAnclajeBean.class);
		setCommandName("cedesAnclajeBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");
	
	CedesAnclajeBean cedesAnclajeBean = (CedesAnclajeBean) command;
	List cedes =	cedesAnclajeServicio.lista(tipoLista, cedesAnclajeBean);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(cedes);
	
	return new ModelAndView("cedes/cedesAnclajeListaVista", "listaResultado", listaResultado);
	}
	

	public CedesAnclajeServicio getCedesAnclajeServicio() {
		return cedesAnclajeServicio;
	}

	public void setCedesAnclajeServicio(CedesAnclajeServicio cedesAnclajeServicio) {
		this.cedesAnclajeServicio = cedesAnclajeServicio;
	} 
	
}
