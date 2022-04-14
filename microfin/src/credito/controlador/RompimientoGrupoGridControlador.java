package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.RompimientoGrupoBean;
import credito.servicio.RompimientoGrupoServicio;

public class RompimientoGrupoGridControlador extends AbstractCommandController{
	
	RompimientoGrupoServicio rompimientoGrupoServicio  = null;
	
	public RompimientoGrupoGridControlador() {
		setCommandClass(RompimientoGrupoBean.class);
		setCommandName("rompimientoGrupoBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {			
		RompimientoGrupoBean bean = (RompimientoGrupoBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List listResultado = rompimientoGrupoServicio.lista(tipoLista, bean);
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(listResultado);

		return new ModelAndView("credito/rompimientoGrupoGridVista", "listaResultado", listaResultado);
	}


	public void setRompimientoGrupoServicio(RompimientoGrupoServicio rompimientoGrupoServicio) {
		this.rompimientoGrupoServicio = rompimientoGrupoServicio;
	}

}
