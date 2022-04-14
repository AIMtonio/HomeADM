package originacion.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import originacion.bean.CasasComercialesBean;
import originacion.servicio.CasasComercialesServicio;

public class CasasComercialesListaControlador extends AbstractCommandController{
	CasasComercialesServicio casasComercialesServicio = null;
	
	public CasasComercialesListaControlador() { 
		setCommandClass(CasasComercialesBean.class);
		setCommandName("casaComercial"); 
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {


	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");
	CasasComercialesBean casaComer = (CasasComercialesBean) command;
	List casaComercialList =	casasComercialesServicio.lista(tipoLista, casaComer);

	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(casaComercialList);

	return new ModelAndView("originacion/casaComercialListaVista", "listaResultado", listaResultado);
	}
	
	public CasasComercialesServicio getCasasComercialesServicio(){
		return casasComercialesServicio;
	}
	
	public void setCasasComercialesServicio(CasasComercialesServicio casasComercialesServicio){
		this.casasComercialesServicio = casasComercialesServicio;
	}
}
