package inversiones.controlador;

import inversiones.bean.InvGarantiaBean;
import inversiones.bean.InversionBean;
import inversiones.servicio.InvGarantiaServicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


public class InvGarantiaListaControlador extends AbstractCommandController {

	InvGarantiaServicio invGarantiaServicio = null;
	
	public InvGarantiaListaControlador() {
		setCommandClass(InvGarantiaBean.class);
		setCommandName("invGarantia");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
	
		InvGarantiaBean InvGarantia = (InvGarantiaBean) command;
		List inversiones =	invGarantiaServicio.lista(tipoLista, InvGarantia);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(inversiones);
				
		return new ModelAndView("inversiones/invGarantiaListaVista", "listaResultado", listaResultado);
		
	}

	public void setInvGarantiaServicio(InvGarantiaServicio invGarantiaServicio) {
		this.invGarantiaServicio = invGarantiaServicio;
	}

	public InvGarantiaServicio getInvGarantiaServicio() {
		return invGarantiaServicio;
	}


	
	
	
	
}
