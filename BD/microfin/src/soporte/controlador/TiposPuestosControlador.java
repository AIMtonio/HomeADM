package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.TiposPuestosBean;
import soporte.servicio.TiposPuestosServicio;

public class TiposPuestosControlador extends AbstractCommandController  {

	
	TiposPuestosServicio tiposPuestosServicio = null;
	
	public TiposPuestosControlador() {
		setCommandClass(TiposPuestosBean.class);
		setCommandName("puestos");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	TiposPuestosBean puestos = (TiposPuestosBean) command;
	List listPuestos =	tiposPuestosServicio.listaCombo(tipoLista,puestos);
	
	List listaResultado = (List) new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(puestos);
			
	return new ModelAndView("", "listaResultado", listaResultado);
	}

	public TiposPuestosServicio getTiposPuestosServicio() {
		return tiposPuestosServicio;
	}

	public void setTiposPuestosServicio(TiposPuestosServicio tiposPuestosServicio) {
		this.tiposPuestosServicio = tiposPuestosServicio;
	}
	
}


