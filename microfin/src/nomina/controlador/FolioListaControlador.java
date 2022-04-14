package nomina.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.ReversaPagoNominaBean;
import nomina.servicio.ReversaPagoNominaServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.InstitucionesBean;

public class FolioListaControlador extends AbstractCommandController{
	
	ReversaPagoNominaServicio reversaPagoNominaServicio = null;

	
	public FolioListaControlador() {
		setCommandClass(ReversaPagoNominaBean.class);
		setCommandName("reversaPagosNomina");

	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = "folioCargaID";

	ReversaPagoNominaBean reversaPagos = (ReversaPagoNominaBean) command;
	List lisFolios =	reversaPagoNominaServicio.lista(tipoLista, reversaPagos);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(lisFolios);
		
	return new ModelAndView("nomina/foliosNominaListaVista", "listaResultado", listaResultado);
	}

	public ReversaPagoNominaServicio getReversaPagoNominaServicio() {
		return reversaPagoNominaServicio;
	}

	public void setReversaPagoNominaServicio(
			ReversaPagoNominaServicio reversaPagoNominaServicio) {
		this.reversaPagoNominaServicio = reversaPagoNominaServicio;
	}
	
	

}
