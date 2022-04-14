package fondeador.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fondeador.bean.InstitutFondeoBean;
import fondeador.servicio.InstitutFondeoServicio;

public class InstitutFondeoListaControlador extends AbstractCommandController {
	
	InstitutFondeoServicio institutFondeoServicio = null;
	
	public InstitutFondeoListaControlador() {
		setCommandClass(InstitutFondeoBean.class);
		setCommandName("instFondeo");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {

	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	InstitutFondeoBean institutFondeo = (InstitutFondeoBean) command;
	
	List institutFon =	institutFondeoServicio.lista(tipoLista, institutFondeo);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(institutFon);
			
	return new ModelAndView("fondeador/instituFondeoListaVista", "listaResultado", listaResultado);
	}

	public void setInstitutFondeoServicio(
			InstitutFondeoServicio institutFondeoServicio) {
		this.institutFondeoServicio = institutFondeoServicio;
	}

	
	
}
