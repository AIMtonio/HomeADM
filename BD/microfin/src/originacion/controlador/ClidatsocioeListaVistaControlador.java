package originacion.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.ClidatsocioeBean;
import originacion.servicio.ClidatsocioeServicio;

public class ClidatsocioeListaVistaControlador extends AbstractCommandController {
	
	ClidatsocioeServicio clidatsocioeServicio=null;

	public ClidatsocioeListaVistaControlador() {
		setCommandClass(ClidatsocioeBean.class);
		setCommandName("clidatsocioeBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		ClidatsocioeBean bean =(ClidatsocioeBean) command;
		
		List gastos =	clidatsocioeServicio.lista(tipoLista, bean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(gastos);
		
		return new ModelAndView("originacion/clidatsocioeListaVista", "listaResultado",listaResultado);
		
	}

	public ClidatsocioeServicio getClidatsocioeServicio() {
		return clidatsocioeServicio;
	}

	public void setClidatsocioeServicio(
			ClidatsocioeServicio clidatsocioeServicio) {
		this.clidatsocioeServicio = clidatsocioeServicio;
	}
	

}
