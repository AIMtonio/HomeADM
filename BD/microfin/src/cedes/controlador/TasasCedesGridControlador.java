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

public class TasasCedesGridControlador extends AbstractCommandController{
	TasasCedesServicio tasasCedesServicio = null;
	
	public TasasCedesGridControlador(){
		setCommandClass(TasasCedesBean.class);
 		setCommandName("tasasCedesBean");
		}

	@Override	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {	
		// TODO Auto-generated method stublistaResultado		
		TasasCedesBean tasasBean = (TasasCedesBean) command;
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String tasaFV=request.getParameter("tasaFV");
		String tipoInver=request.getParameter("tipoInversionID");
		
		List tasasLista = tasasCedesServicio.lista(tipoLista, tasasBean);
		
		List listaTasas = (List)new ArrayList();
		listaTasas.add(tasaFV);
		listaTasas.add(tipoInver);
		listaTasas.add(tasasLista);
				
		return new ModelAndView("cedes/tasasCedesGrid", "tasasLista", listaTasas);

	}

	public TasasCedesServicio getTasasCedesServicio() {
		return tasasCedesServicio;
	}

	public void setTasasCedesServicio(TasasCedesServicio tasasCedesServicio) {
		this.tasasCedesServicio = tasasCedesServicio;
	}

 


}
