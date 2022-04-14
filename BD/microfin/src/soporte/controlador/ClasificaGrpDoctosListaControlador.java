package soporte.controlador;

import guardaValores.bean.CatalogoAlmacenesBean;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.ClasificaGrpDoctosBean;
import soporte.servicio.ClasificaGrpDoctosServicio;

public class ClasificaGrpDoctosListaControlador extends AbstractCommandController {

	ClasificaGrpDoctosServicio  clasificaGrpDoctosServicio= null;

	public ClasificaGrpDoctosListaControlador() {
		setCommandClass(ClasificaGrpDoctosBean.class);
		setCommandName("clasificaGrpDoctosBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {	
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));	
		String controlID = request.getParameter("controlID");
		
		ClasificaGrpDoctosBean clasificaGrpDoctosBean = (ClasificaGrpDoctosBean) command;
		List listaGlasificaGrpDoctosBean = clasificaGrpDoctosServicio.lista(clasificaGrpDoctosBean,tipoLista);

		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
	 	listaResultado.add(controlID);
		listaResultado.add(listaGlasificaGrpDoctosBean);
		 
		return new ModelAndView("soporte/clasificaGrpDoctosListaVista", "listaResultado", listaResultado);

	}


	public ClasificaGrpDoctosServicio getClasificaGrpDoctosServicio() {
		return clasificaGrpDoctosServicio;
	}

	public void setClasificaGrpDoctosServicio(
			ClasificaGrpDoctosServicio clasificaGrpDoctosServicio) {
		this.clasificaGrpDoctosServicio = clasificaGrpDoctosServicio;
	}

}
