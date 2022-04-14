package pld.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.RevisionRemesasBean;
import pld.servicio.RevisionRemesasServicio;

public class RevisionRemesasCheckListGridControlador extends AbstractCommandController{
	
	RevisionRemesasServicio revisionRemesasServicio = null;
	
	public RevisionRemesasCheckListGridControlador(){
		setCommandClass(RevisionRemesasBean.class);
		setCommandName("revRemesasCheckListGrid");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {	
		
		RevisionRemesasBean revisionRemesasBean = (RevisionRemesasBean) command;
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List documentoList = revisionRemesasServicio.listaDocumentosRevRemesas(tipoLista, revisionRemesasBean);

		return new ModelAndView("pld/revisionRemesasCheckListGridVista", "listaResultado", documentoList);
	}
	
	// GETTER & SETTER 
	public RevisionRemesasServicio getRevisionRemesasServicio() {
		return revisionRemesasServicio;
	}

	public void setRevisionRemesasServicio(RevisionRemesasServicio revisionRemesasServicio) {
		this.revisionRemesasServicio = revisionRemesasServicio;
	}

}
