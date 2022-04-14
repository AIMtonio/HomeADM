package guardaValores.controlador;

import guardaValores.bean.DocumentosGuardaValoresBean;
import guardaValores.servicio.DocumentosGuardaValoresServicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class ExpedienteGuardaValoresListaControlador extends AbstractCommandController {

	DocumentosGuardaValoresServicio documentosGuardaValoresServicio = null;
	
	public ExpedienteGuardaValoresListaControlador() {
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
		String campoTipoPersona = "";

		if(tipoLista == DocumentosGuardaValoresServicio.Enum_Lis_Expediente.lista_foranea ){
			campoTipoPersona = request.getParameter("campoTipoPersona");		
		}
		
		DocumentosGuardaValoresBean documentosGuardaValoresBean = (DocumentosGuardaValoresBean) command;
		List documento = documentosGuardaValoresServicio.listaExpediente(tipoLista, documentosGuardaValoresBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(documento);
		listaResultado.add(campoTipoPersona);
		
		return new ModelAndView("guardaValores/expedienteGuardaValoresListaVista", "listaResultado",listaResultado);
	}

	public DocumentosGuardaValoresServicio getDocumentosGuardaValoresServicio() {
		return documentosGuardaValoresServicio;
	}

	public void setDocumentosGuardaValoresServicio(DocumentosGuardaValoresServicio documentosGuardaValoresServicio) {
		this.documentosGuardaValoresServicio = documentosGuardaValoresServicio;
	}

}

