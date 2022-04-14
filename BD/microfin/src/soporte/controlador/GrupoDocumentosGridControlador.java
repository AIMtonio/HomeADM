package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.ClasificaGrpDoctosBean;
import soporte.bean.GrupoDocumentosBean;
import soporte.servicio.GrupoDocumentosServicio;

public class GrupoDocumentosGridControlador  extends AbstractCommandController {		 
	GrupoDocumentosServicio  grupoDocumentosServicio= null;
	public GrupoDocumentosGridControlador() {
		setCommandClass(ClasificaGrpDoctosBean.class);
		setCommandName("documentosGrid");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {	
		
		ClasificaGrpDoctosBean docRecibidosDetalle = (ClasificaGrpDoctosBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		int instrumento = Integer.parseInt(request.getParameter("instrumento"));
		int tipoInstrumento= Integer.parseInt(request.getParameter("tipoInstrumento"));
		List listaResultado = new ArrayList();
		List docEntregados = grupoDocumentosServicio.lista(tipoLista, tipoInstrumento,instrumento);
		
		 listaResultado.add(tipoLista);
		 listaResultado.add(docEntregados);
		 
		return new ModelAndView("soporte/grupoDocumentosGridVista", "listaResultado", listaResultado);

	
	
	}
	
	public void setGrupoDocumentosServicio(
			GrupoDocumentosServicio grupoDocumentosServicio) {
		this.grupoDocumentosServicio = grupoDocumentosServicio;
	}

}
