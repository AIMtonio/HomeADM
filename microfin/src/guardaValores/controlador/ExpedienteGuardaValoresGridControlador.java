package guardaValores.controlador;

import java.util.ArrayList;
import java.util.List;

import guardaValores.bean.DocumentosGuardaValoresBean;
import guardaValores.servicio.DocumentosGuardaValoresServicio;
import guardaValores.servicio.DocumentosGuardaValoresServicio.Enum_Lis_GridExpediente;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class ExpedienteGuardaValoresGridControlador extends AbstractCommandController {

	DocumentosGuardaValoresServicio documentosGuardaValoresServicio = null;

	public ExpedienteGuardaValoresGridControlador() {
		setCommandClass(DocumentosGuardaValoresBean.class);
		setCommandName("documentosGuardaValoresBean");
	}
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		// TODO Auto-generated method stub
		
		DocumentosGuardaValoresBean documentosGuardaValoresBean = (DocumentosGuardaValoresBean) command;
		int tipoLista   = (request.getParameter("tipoLista")!=null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
		int tipoReporte = (request.getParameter("tipoReporte")!=null) ? Integer.parseInt(request.getParameter("tipoReporte")) : 0;
		
		String pagina = request.getParameter("pagina");
		String nombreLista = request.getParameter("nombreLista");
		
		String tipoPaginacion = "";
		
		List listaDocumentosBean = null;
		List listaResultado = (List)new ArrayList();
		PagedListHolder listaExpedienteBean = null;
		
		if(pagina == null){
			tipoPaginacion= "Completa";
		}
		
		if(tipoPaginacion.equalsIgnoreCase("Completa")){

			listaDocumentosBean = documentosGuardaValoresServicio.listaExpedienteGrid(tipoLista, tipoReporte, documentosGuardaValoresBean);
			listaExpedienteBean = new PagedListHolder(listaDocumentosBean);

		} else {
		
			// Se guarda la paginacion
			listaDocumentosBean = (List) request.getSession().getAttribute(nombreLista);
			listaExpedienteBean = (PagedListHolder) listaDocumentosBean.get(1);
			listaExpedienteBean.getSource();
			
			if ("siguiente".equals(pagina)) {
				listaExpedienteBean.nextPage();
			}else if ("anterior".equals(pagina)) {
				listaExpedienteBean.previousPage();
			}else if("primero".equals(pagina)){
				listaExpedienteBean.setPage(0);
				listaExpedienteBean.getPage();
			}else if("ultimo".equals(pagina)){
				listaExpedienteBean.setPage(listaExpedienteBean.getPageCount()-1);
				listaExpedienteBean.getPage();
			}			
		}

		// Seccion de pagina
		switch(tipoReporte){
			case Enum_Lis_GridExpediente.lista_RegistroExpediente: 
				listaExpedienteBean.setPageSize(25);
			default:
				listaExpedienteBean.setPageSize(15);
			break;	
		}
		
		listaResultado.add(0,tipoLista);
		listaResultado.add(1,listaExpedienteBean);
		listaResultado.add(2,listaExpedienteBean.getPage()+1);
		listaResultado.add(3,listaExpedienteBean.getPageCount());
	
		request.getSession().setAttribute(nombreLista, listaResultado);

		return new ModelAndView("guardaValores/expedienteGuardaValoresGridVista", "listaResultado", listaResultado);
	}
	
	public DocumentosGuardaValoresServicio getDocumentosGuardaValoresServicio() {
		return documentosGuardaValoresServicio;
	}
	
	public void setDocumentosGuardaValoresServicio(
			DocumentosGuardaValoresServicio documentosGuardaValoresServicio) {
		this.documentosGuardaValoresServicio = documentosGuardaValoresServicio;
	}

}
