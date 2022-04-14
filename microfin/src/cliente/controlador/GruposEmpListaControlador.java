package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.GruposEmpBean;
import cliente.servicio.GruposEmpServicio;
			 
public class GruposEmpListaControlador extends AbstractCommandController{
	
	GruposEmpServicio gruposEmpServicio = null;

	public GruposEmpListaControlador(){
		setCommandClass(GruposEmpBean.class);
		setCommandName("empresa");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		GruposEmpBean empresa = (GruposEmpBean) command;
		List empresas = gruposEmpServicio.lista(tipoLista, empresa);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(empresas);
		
		return new ModelAndView("cliente/gruposEmpListaVista", "listaResultado", listaResultado);
		
		
	}
		

	public void setGruposEmpServicio(GruposEmpServicio gruposEmpServicio) {
		this.gruposEmpServicio = gruposEmpServicio;
	}

}
