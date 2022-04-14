package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.servicio.CuentasContablesServicio;

import soporte.bean.EdoCtaPerEjecutadoBean;
import soporte.servicio.EdoCtaPeriodoEjecutadoServicio;

public class EdoCtaPeriodoListaControlador extends AbstractCommandController {
	EdoCtaPeriodoEjecutadoServicio edoCtaPeriodoEjecutadoServicio = null;
	
	public EdoCtaPeriodoListaControlador(){
		setCommandClass(EdoCtaPerEjecutadoBean.class);
		setCommandName("edoCtaPerEjecutadoBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
     String controlID = request.getParameter("controlID");
     
     EdoCtaPerEjecutadoBean listaPeriodo = (EdoCtaPerEjecutadoBean) command;
              List listasPeriodo = edoCtaPeriodoEjecutadoServicio.lista( listaPeriodo,tipoLista);
              
              List listaResultado = (List)new ArrayList();
              listaResultado.add(tipoLista);
              listaResultado.add(controlID);
              listaResultado.add(listasPeriodo);
		return new ModelAndView("soporte/edoCtaPeriodoEjecutListaVista", "listaResultado", listaResultado);
	}

	public EdoCtaPeriodoEjecutadoServicio getEdoCtaPeriodoEjecutadoServicio() {
		return edoCtaPeriodoEjecutadoServicio;
	}

	public void setEdoCtaPeriodoEjecutadoServicio(
			EdoCtaPeriodoEjecutadoServicio edoCtaPeriodoEjecutadoServicio) {
		this.edoCtaPeriodoEjecutadoServicio = edoCtaPeriodoEjecutadoServicio;
	}
	

}
