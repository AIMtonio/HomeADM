package aportaciones.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import aportaciones.bean.TasasAportacionesBean;
import aportaciones.servicio.TasasAportacionesServicio;

public class TasasAportacionesGridControlador extends AbstractCommandController{
	
	TasasAportacionesServicio tasasAportacionesServicio = null;
	
	public TasasAportacionesGridControlador(){
		setCommandClass(TasasAportacionesBean.class);
 		setCommandName("tasasAportacionesBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {		
		TasasAportacionesBean tasasBean = (TasasAportacionesBean) command;
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String tasaFV=request.getParameter("tasaFV");
		String tipoInver=request.getParameter("tipoInversionID");
		
		List tasasLista = tasasAportacionesServicio.lista(tipoLista, tasasBean);
		
		List listaTasas = (List)new ArrayList();
		listaTasas.add(tasaFV);
		listaTasas.add(tipoInver);
		listaTasas.add(tasasLista);
				
		return new ModelAndView("aportaciones/tasasAportacionesGrid", "tasasLista", listaTasas);

	}

	public TasasAportacionesServicio getTasasAportacionesServicio() {
		return tasasAportacionesServicio;
	}

	public void setTasasAportacionesServicio(
			TasasAportacionesServicio tasasAportacionesServicio) {
		this.tasasAportacionesServicio = tasasAportacionesServicio;
	}
	
}
