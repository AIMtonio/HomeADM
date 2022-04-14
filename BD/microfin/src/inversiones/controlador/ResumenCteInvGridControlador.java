package inversiones.controlador;

import herramientas.Utileria;
import inversiones.bean.InversionBean;
import inversiones.servicio.InversionServicio;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;



public class ResumenCteInvGridControlador extends AbstractCommandController {
	InversionServicio inversionServicio = null;
	

	public ResumenCteInvGridControlador() {
		setCommandClass(InversionBean.class);
		setCommandName("resumCteInv");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		InversionBean inver = (InversionBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));

		List resumenCteInvList =inversionServicio.lista(tipoLista, inver);
		
		
				
		return new ModelAndView("inversiones/resumenCteInvGridVista", "resumCteInv", resumenCteInvList);
	}

	public InversionServicio getInversionServicio() {
		return inversionServicio;
	}

	public void setInversionServicio(InversionServicio inversionServicio) {
		this.inversionServicio = inversionServicio;
	}

	
	

}

