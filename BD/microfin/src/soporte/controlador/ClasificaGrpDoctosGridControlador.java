package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.ClasificaGrpDoctosBean;
import soporte.servicio.ClasificaGrpDoctosServicio;

public class ClasificaGrpDoctosGridControlador  extends AbstractCommandController {		 
	ClasificaGrpDoctosServicio  clasificaGrpDoctosServicio= null;
	public ClasificaGrpDoctosGridControlador() {
		setCommandClass(ClasificaGrpDoctosBean.class);
		setCommandName("documentosGrid");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {	
		
		ClasificaGrpDoctosBean docRecibidosDetalle = (ClasificaGrpDoctosBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));		
		List listaResultado = new ArrayList();
		List docEntregados = clasificaGrpDoctosServicio.lista(docRecibidosDetalle,tipoLista);
		
		 listaResultado.add(tipoLista);
		 listaResultado.add(docEntregados);
		 
		return new ModelAndView("soporte/clasificaGrpDoctosGridVista", "listaResultado", listaResultado);

	}

	public ClasificaGrpDoctosServicio getClasificaGrpDoctosServicio() {
		return clasificaGrpDoctosServicio;
	}

	public void setClasificaGrpDoctosServicio(
			ClasificaGrpDoctosServicio clasificaGrpDoctosServicio) {
		this.clasificaGrpDoctosServicio = clasificaGrpDoctosServicio;
	}

}
