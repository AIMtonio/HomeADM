package pld.controlador;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.servicio.ClienteArchivosServicio;
import cliente.bean.ClienteArchivosBean;

public class OpeEscalamientoInternoFileUploadGridControlador extends AbstractCommandController {
	ClienteArchivosServicio clienteArchivosServicio = null;
	
	public OpeEscalamientoInternoFileUploadGridControlador() {
		setCommandClass(ClienteArchivosBean.class);
		setCommandName("clienteArchivo");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		ClienteArchivosBean clientArchivo = (ClienteArchivosBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		// se asigna valor para saber si se requiere mostrar opcion eliminar o no .
		int opcionElimina  = Integer.parseInt(request.getParameter("opcionElimina")); 

		List clienteArchivoList =	clienteArchivosServicio.listaArchivosCliente(tipoLista, clientArchivo);
		List listaResultado = (List)new ArrayList();
        listaResultado.add(opcionElimina);
        listaResultado.add(clienteArchivoList);
		
		return new ModelAndView("pld/opeEscalamientoIntFileUploadGridVista", "listaResultado", listaResultado);
	}

	public ClienteArchivosServicio getClienteArchivosServicio() {
		return clienteArchivosServicio;
	}

	public void setClienteArchivosServicio(
			ClienteArchivosServicio clienteArchivosServicio) {
		this.clienteArchivosServicio = clienteArchivosServicio;
	}
	
	
}
