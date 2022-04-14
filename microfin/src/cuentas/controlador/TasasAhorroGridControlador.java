package cuentas.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.TasasAhorroBean;
import cuentas.servicio.TasasAhorroServicio;

import java.util.List;

public class TasasAhorroGridControlador extends AbstractCommandController{
	TasasAhorroServicio tasasAhorroServicio = null;
	
	public TasasAhorroGridControlador(){
		setCommandClass(TasasAhorroBean.class);
 		setCommandName("tasasAhorroBeanGrid");
		}

	@Override	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {	
		// TODO Auto-generated method stublistaResultado		
		TasasAhorroBean tasasAhorroBean = (TasasAhorroBean) command;
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));		
		List tasaAhorroLista = tasasAhorroServicio.lista(tipoLista, tasasAhorroBean);
				
		return new ModelAndView("cuentas/tasasAhorroGrid", "tasaAhorroLista", tasaAhorroLista);
	}

	public void setTasasAhorroServicio(TasasAhorroServicio tasasAhorroServicio) {
		this.tasasAhorroServicio = tasasAhorroServicio;
	}

	public TasasAhorroServicio getTasasAhorroServicio() {
		return tasasAhorroServicio;
	}

}
