package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import tesoreria.bean.TesoMovsConciliaBean;
import tesoreria.servicio.TesoMovsConciliaServicio;

public class TesoMovsConciliaManualGridControlador  extends AbstractCommandController{

	TesoMovsConciliaServicio tesoMovsConciliaServicio = null;
	
	public TesoMovsConciliaManualGridControlador(){
		setCommandClass(TesoMovsConciliaBean.class);
		setCommandName("conciliacion");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		TesoMovsConciliaBean tesoMovsConciliaBean = (TesoMovsConciliaBean) command;
		int tipoLista = (request.getParameter("tipoLista")!=null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
		
		List movsNoConciliadosList = tesoMovsConciliaServicio.lista(tipoLista, tesoMovsConciliaBean);
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(movsNoConciliadosList);
				
		return new ModelAndView("tesoreria/tesoMovsConciliaManualGridVista",  "listaResultado", listaResultado);
	}


	public TesoMovsConciliaServicio getTesoMovsConciliaServicio() {
		return tesoMovsConciliaServicio;
	}


	public void setTesoMovsConciliaServicio(
			TesoMovsConciliaServicio tesoMovsConciliaServicio) {
		this.tesoMovsConciliaServicio = tesoMovsConciliaServicio;
	}


	
	
}
