package contabilidad.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.CuentasContablesBean;
import contabilidad.servicio.CuentasContablesServicio;


public class CuentasContablesListaControlador extends AbstractCommandController{
		
	CuentasContablesServicio cuentasContablesServicio = null;

	public CuentasContablesListaControlador() {
		setCommandClass(CuentasContablesBean.class);
		setCommandName("cuentasContables");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		CuentasContablesBean cuentasContables = (CuentasContablesBean) command;
		List cuentasContablesList =	cuentasContablesServicio.lista(tipoLista, cuentasContables);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(cuentasContablesList);
		
		return new ModelAndView("contabilidad/cuentasContablesListaVista", "listaResultado", listaResultado);
	}
	
	
	public void setCuentasContablesServicio(
			CuentasContablesServicio cuentasContablesServicio) {
		this.cuentasContablesServicio = cuentasContablesServicio;
	}

}
