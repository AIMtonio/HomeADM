package cliente.controlador;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import cliente.bean.MunicipiosRepubBean;
import cliente.servicio.MunicipiosRepubServicio;



public class MunicipiosRepubListaControlador extends AbstractCommandController{
	
	MunicipiosRepubServicio municipiosServicio = null;
		
	public MunicipiosRepubListaControlador() {
			setCommandClass(MunicipiosRepubBean.class);
			setCommandName("municipios");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	MunicipiosRepubBean municipio = (MunicipiosRepubBean) command;
	List municipios=	municipiosServicio.lista(tipoLista, municipio);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(municipios);
			
	return new ModelAndView("cliente/municipiosRepubListaVista", "listaResultado", listaResultado);
	}

	public void setMunicipiosRepubServicio(MunicipiosRepubServicio municipiosServicio) {
		this.municipiosServicio = municipiosServicio;
	}		
	
}
