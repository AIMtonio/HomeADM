package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.AsignarChequeSucurBean;
import tesoreria.servicio.AsignarChequeSucurServicio;
import ventanilla.servicio.CancelacionChequesServicio;

public class CajasChequeraListaControlador extends AbstractCommandController {
	
	AsignarChequeSucurServicio asignarChequeSucurServicio = null;
	
	public CajasChequeraListaControlador() {
		setCommandClass(AsignarChequeSucurBean.class);		
		setCommandName("cancelacionCheques");
		
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		AsignarChequeSucurBean asignarChequeSucurBean = (AsignarChequeSucurBean) command;		
		List chequesLis =	asignarChequeSucurServicio.listaCuentasConChequera(tipoLista, asignarChequeSucurBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(chequesLis);
		
		return new ModelAndView("tesoreria/cajasChequeraListaVista", "listaResultado",listaResultado);
	}

	public AsignarChequeSucurServicio getAsignarChequeSucurServicio() {
		return asignarChequeSucurServicio;
	}

	public void setAsignarChequeSucurServicio(
			AsignarChequeSucurServicio asignarChequeSucurServicio) {
		this.asignarChequeSucurServicio = asignarChequeSucurServicio;
	}	
	
	
}


