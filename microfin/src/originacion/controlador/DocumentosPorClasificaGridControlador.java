package originacion.controlador;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.servicio.ClasificaTipDocServicio;
import originacion.bean.ClasificaTipDocBean;

public class DocumentosPorClasificaGridControlador extends AbstractCommandController {
	ClasificaTipDocServicio clasificaTipDocServicio=null;
	
	public DocumentosPorClasificaGridControlador() {
		setCommandClass(ClasificaTipDocBean.class);
		setCommandName("clasificacion");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {			
		ClasificaTipDocBean clasificacion = (ClasificaTipDocBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		int clasificaDocID = Integer.parseInt(request.getParameter("clasificaDoc"));		
    
	    List listaResultadoDoc = (List)new ArrayList();

			List listaDocumentos = clasificaTipDocServicio.listaDocumentos(tipoLista, clasificaDocID);
			
			PagedListHolder documentosLis = new PagedListHolder(listaDocumentos);
			documentosLis.setPageSize(50);
			listaResultadoDoc.add(tipoLista);
			listaResultadoDoc.add(documentosLis);
	
			request.getSession().setAttribute("ConsultaClasificacionGridControlador", listaResultadoDoc);

			
		return new ModelAndView("originacion/documentosPorClasificaGridVista", "listaResultadoDoc", listaResultadoDoc);
	}
//---------setter-------
	public void setClasificaTipDocServicio(
			ClasificaTipDocServicio clasificaTipDocServicio) {
		this.clasificaTipDocServicio = clasificaTipDocServicio;
	}
}
