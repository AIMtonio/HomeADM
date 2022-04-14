package ventanilla.controlador;

import herramientas.Constantes;

import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.CajasVentanillaBean;
import ventanilla.servicio.CajasVentanillaServicio;

public class TiraAuditoraGridControlador  extends AbstractCommandController{
	
	CajasVentanillaServicio cajasVentanillaServicio = null;
	
	public TiraAuditoraGridControlador() {
		setCommandClass(CajasVentanillaBean.class);
		setCommandName("CajasVentanillaBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {			
		CajasVentanillaBean cajasVentanilla= (CajasVentanillaBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List detalleMovimientos = cajasVentanillaServicio.lista(tipoLista, cajasVentanilla, Constantes.STRING_VACIO);
	
		return new ModelAndView("ventanilla/tiraAuditoraGridVista", "listaResultado", detalleMovimientos);
	}

	public void setCajasVentanillaServicio(
			CajasVentanillaServicio cajasVentanillaServicio) {
		this.cajasVentanillaServicio = cajasVentanillaServicio;
	}
	
	
}