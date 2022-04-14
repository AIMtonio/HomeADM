package riesgos.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.ParametrosRiesgosServicio;

public class ParametrosRiesgosGridControlador extends AbstractCommandController{
	ParametrosRiesgosServicio parametrosRiesgosServicio = null;
	
	public ParametrosRiesgosGridControlador() {
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("parametrosRiesgos");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {	
		UACIRiesgosBean riesgosBean= (UACIRiesgosBean) command;	
		
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List parametrosList = parametrosRiesgosServicio.listaParametrosRiesgos(tipoLista, riesgosBean);
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(parametrosList);
		
		return new ModelAndView("riesgos/parametrosRiesgosGridVista", "listaResultado", listaResultado);
	}

	/* ****************** GETTER Y SETTERS *************************** */

	public ParametrosRiesgosServicio getParametrosRiesgosServicio() {
		return parametrosRiesgosServicio;
	}

	public void setParametrosRiesgosServicio(
			ParametrosRiesgosServicio parametrosRiesgosServicio) {
		this.parametrosRiesgosServicio = parametrosRiesgosServicio;
	}
}