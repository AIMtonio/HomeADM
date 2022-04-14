package nomina.controlador;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.TipoEmpleadosConvenioBean;
import nomina.servicio.TipoEmpleadosConvenioServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class TiposEmpleadosConvGridControlador extends AbstractCommandController{ 
	
	TipoEmpleadosConvenioServicio tipoEmpleadosConvenioServicio = null;
	
	public TiposEmpleadosConvGridControlador(){
		setCommandClass(TipoEmpleadosConvenioBean.class);
		setCommandName("tipoEmpleadoConv");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		TipoEmpleadosConvenioBean tipoEmpleadosConvenio = (TipoEmpleadosConvenioBean) command;
		int tipoLista = (request.getParameter("tipoLista")!=null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
		
		List tipoEmpleadosConvLis = tipoEmpleadosConvenioServicio.lista(tipoLista, tipoEmpleadosConvenio);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(tipoEmpleadosConvLis);
				
		return new ModelAndView("nomina/tipoEmpleadosConvGrid",  "listaResultado", listaResultado);
	}

	public TipoEmpleadosConvenioServicio getTipoEmpleadosConvenioServicio() {
		return tipoEmpleadosConvenioServicio;
	}

	public void setTipoEmpleadosConvenioServicio(
			TipoEmpleadosConvenioServicio tipoEmpleadosConvenioServicio) {
		this.tipoEmpleadosConvenioServicio = tipoEmpleadosConvenioServicio;
	}
	
	

}
