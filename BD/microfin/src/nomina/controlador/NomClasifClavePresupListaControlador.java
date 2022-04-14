package nomina.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.NomClasifClavePresupBean;
import nomina.servicio.NomClasifClavePresupServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class NomClasifClavePresupListaControlador extends AbstractCommandController{
	private NomClasifClavePresupServicio nomClasifClavePresupServicio = null;
	
	public NomClasifClavePresupListaControlador() {
		setCommandClass(NomClasifClavePresupBean.class);
		setCommandName("nomClasifClavePresupBean");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
	
		NomClasifClavePresupBean Bean = (NomClasifClavePresupBean) command;
		List listaConsulta =	nomClasifClavePresupServicio.lista( tipoLista, Bean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista); //0
		listaResultado.add(controlID); //1
		listaResultado.add(listaConsulta);//2
				
		return new ModelAndView("nomina/clasifClavePresupListaVista", "listaResultado", listaResultado);
	}

	
	public NomClasifClavePresupServicio getNomClasifClavePresupServicio() {
		return nomClasifClavePresupServicio;
	}

	public void setNomClasifClavePresupServicio(
			NomClasifClavePresupServicio nomClasifClavePresupServicio) {
		this.nomClasifClavePresupServicio = nomClasifClavePresupServicio;
	}

}

