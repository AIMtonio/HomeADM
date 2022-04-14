package ventanilla.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.CajasVentanillaBean;
import ventanilla.servicio.CajasVentanillaServicio;

public class CajasVentanillaListaControlador extends AbstractCommandController {
	CajasVentanillaServicio cajasVentanillaServicio = null;
	
	public CajasVentanillaListaControlador(){
		setCommandClass(CajasVentanillaBean.class);
		setCommandName("cajasVentanillaBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");
	String sucursalOrigen;
	CajasVentanillaBean cajasVentanilla = (CajasVentanillaBean) command;
	sucursalOrigen = request.getParameter("sucursalOrigen");
	List cajasVentanillaList = cajasVentanillaServicio.lista(tipoLista, cajasVentanilla, sucursalOrigen);

	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(cajasVentanillaList);

	return new ModelAndView("ventanilla/cajasVentanillaListaVista", "listaResultado", listaResultado);
}

	public CajasVentanillaServicio getCajasVentanillaServicio() {
		return cajasVentanillaServicio;
	}

	public void setCajasVentanillaServicio(
			CajasVentanillaServicio cajasVentanillaServicio) {
		this.cajasVentanillaServicio = cajasVentanillaServicio;
	}
	
	
}