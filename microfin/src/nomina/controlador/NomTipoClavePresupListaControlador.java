package nomina.controlador;

import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.web.servlet.ModelAndView;
import java.util.List;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import nomina.bean.NomTipoClavePresupBean;
import nomina.servicio.NomTipoClavePresupServicio;

public class NomTipoClavePresupListaControlador extends AbstractCommandController{
	private NomTipoClavePresupServicio nomTipoClavePresupServicio = null;
	
	public NomTipoClavePresupListaControlador() {
		setCommandClass(NomTipoClavePresupBean.class);
		setCommandName("nomTipoClavePresupBean");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
	
		NomTipoClavePresupBean Bean = (NomTipoClavePresupBean) command;
		List listaConsulta =	nomTipoClavePresupServicio.lista( tipoLista, Bean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaConsulta);
				
		return new ModelAndView("nomina/tipoClavePresupListaVista", "listaResultado", listaResultado);
	}

	public NomTipoClavePresupServicio getNomTipoClavePresupServicio() {
		return nomTipoClavePresupServicio;
	}

	public void setNomTipoClavePresupServicio(
			NomTipoClavePresupServicio nomTipoClavePresupServicio) {
		this.nomTipoClavePresupServicio = nomTipoClavePresupServicio;
	}
	
}

