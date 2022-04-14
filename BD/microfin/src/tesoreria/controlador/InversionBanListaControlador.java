package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.InvBancariaBean;
import tesoreria.servicio.InvBancariaServicio;


public class InversionBanListaControlador extends AbstractCommandController{
	
	InvBancariaServicio invBancariaServicio;

	public InversionBanListaControlador() {
		setCommandClass(InvBancariaBean.class);
		setCommandName("inversionBancaria");
	}
		
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		InvBancariaBean inv = (InvBancariaBean) command;
		List inversiones =	invBancariaServicio.lista(tipoLista, inv);
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
        listaResultado.add(controlID);
        listaResultado.add(inversiones);
		
		return new ModelAndView("tesoreria/inversionBancariaListaVista", "listaResultado",listaResultado);
	}

	public InvBancariaServicio getInvBancariaServicio() {
		return invBancariaServicio;
	}

	public void setInvBancariaServicio(InvBancariaServicio invBancariaServicio) {
		this.invBancariaServicio = invBancariaServicio;
	}
	

}
