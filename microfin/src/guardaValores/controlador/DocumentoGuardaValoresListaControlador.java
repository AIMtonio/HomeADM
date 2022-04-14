package guardaValores.controlador;

import java.util.ArrayList;
import java.util.List;

import guardaValores.bean.DocumentosGuardaValoresBean;
import guardaValores.servicio.DocumentosGuardaValoresServicio;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class DocumentoGuardaValoresListaControlador extends AbstractCommandController {

	DocumentosGuardaValoresServicio documentosGuardaValoresServicio = null;
	
	public DocumentoGuardaValoresListaControlador() {
		setCommandClass(DocumentosGuardaValoresBean.class);
		setCommandName("documentosGuardaValoresBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		String campoArchivoID = "";

		if(tipoLista == DocumentosGuardaValoresServicio.Enum_Lis_Documento.lista_registro){
			campoArchivoID = request.getParameter("campoArchivoID");		
		}
		DocumentosGuardaValoresBean documentosGuardaValoresBean = (DocumentosGuardaValoresBean) command;
		List documento = documentosGuardaValoresServicio.listaDocumento(tipoLista, documentosGuardaValoresBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(documento);
		listaResultado.add(campoArchivoID);
		
		return new ModelAndView("guardaValores/documentosGuardaValoresListaVista", "listaResultado",listaResultado);
	}

	public DocumentosGuardaValoresServicio getDocumentosGuardaValoresServicio() {
		return documentosGuardaValoresServicio;
	}

	public void setDocumentosGuardaValoresServicio(DocumentosGuardaValoresServicio documentosGuardaValoresServicio) {
		this.documentosGuardaValoresServicio = documentosGuardaValoresServicio;
	}

}
