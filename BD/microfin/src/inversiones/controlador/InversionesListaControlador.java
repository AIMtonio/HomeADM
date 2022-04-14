package inversiones.controlador;

import inversiones.bean.InversionBean;
import inversiones.servicio.InversionServicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


public class InversionesListaControlador extends AbstractCommandController {

	InversionServicio inversionServicio = null;
	
	public InversionesListaControlador() {
		setCommandClass(InversionBean.class);
		setCommandName("inversion");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
	
		InversionBean inversion = (InversionBean) command;
		List inversiones =	inversionServicio.lista(tipoLista, inversion);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(inversiones);
				
		return new ModelAndView("inversiones/inversionesListaVista", "listaResultado", listaResultado);
	}

	public void setInversionServicio(InversionServicio inversionServicio) {
		this.inversionServicio = inversionServicio;
	}

	
	
	
	
}
