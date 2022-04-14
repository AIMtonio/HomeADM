package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.CargaMasivaFacturasBean;
import tesoreria.servicio.CargaMasivaFacturasServicio;



public class CargaMasivaListaFacturasControlador extends AbstractCommandController{
	
	CargaMasivaFacturasServicio cargaMasivaFacturasServicio = null;
	
	public CargaMasivaListaFacturasControlador() {
		setCommandClass(CargaMasivaFacturasBean.class);
		setCommandName("cargaMasivaFacturasBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
			
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		CargaMasivaFacturasBean cargaMasivaFacturas = (CargaMasivaFacturasBean) command;

		List facturasList =	cargaMasivaFacturasServicio.lista(tipoLista, cargaMasivaFacturas);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(facturasList);
		
		return new ModelAndView("tesoreria/folioFacturasMasivasListaVista", "listaResultado",listaResultado);
	}

	
	
	public CargaMasivaFacturasServicio getCargaMasivaFacturasServicio() {
		return cargaMasivaFacturasServicio;
	}

	public void setCargaMasivaFacturasServicio(
			CargaMasivaFacturasServicio cargaMasivaFacturasServicio) {
		this.cargaMasivaFacturasServicio = cargaMasivaFacturasServicio;
	}

	

	
	
}
