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

public class RegistroGrdValoresGridControlador extends AbstractCommandController {
	
	DocumentosGuardaValoresServicio documentosGuardaValoresServicio = null;

	public RegistroGrdValoresGridControlador() {
		setCommandClass(DocumentosGuardaValoresBean.class);
		setCommandName("documentosGuardaValoresBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors) throws Exception {
		// TODO Auto-generated method stub

		DocumentosGuardaValoresBean documentosGuardaValoresBean = (DocumentosGuardaValoresBean) command;
		int tipoLista = (request.getParameter("tipoLista")!=null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;

		List<DocumentosGuardaValoresBean> lista  = documentosGuardaValoresServicio.listaDocumento(tipoLista, documentosGuardaValoresBean);
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(lista);

		return new ModelAndView("guardaValores/registroGuardaValoresGridVista", "listaResultado", listaResultado);
	}
	
	public DocumentosGuardaValoresServicio getDocumentosGuardaValoresServicio() {
		return documentosGuardaValoresServicio;
	}
	
	public void setDocumentosGuardaValoresServicio(
			DocumentosGuardaValoresServicio documentosGuardaValoresServicio) {
		this.documentosGuardaValoresServicio = documentosGuardaValoresServicio;
	}

}
