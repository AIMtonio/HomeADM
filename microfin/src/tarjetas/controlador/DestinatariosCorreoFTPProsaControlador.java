package tarjetas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import com.google.gson.Gson;

import tarjetas.bean.DestinatariosCorreoFTPProsaBean;
import tarjetas.servicio.DestinatariosCorreoFTPProsaServicio;

public class DestinatariosCorreoFTPProsaControlador extends AbstractCommandController{
	DestinatariosCorreoFTPProsaServicio destinatariosCorreoFTPProsaServicio = null;
	public DestinatariosCorreoFTPProsaControlador() {
		setCommandClass(DestinatariosCorreoFTPProsaBean.class);
		setCommandName("destinatariosCorreoFTPProsaBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		DestinatariosCorreoFTPProsaBean bean =(DestinatariosCorreoFTPProsaBean) command;		
		List destinatarios = destinatariosCorreoFTPProsaServicio.lista(tipoLista, bean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		//listaResultado.add(controlID);
		listaResultado.add(destinatarios);
		listaResultado.add(destinatarios.size());
		
		return new ModelAndView("tarjetas/destinatariosCorreoProsaListaVista", "listaResultado",listaResultado);
		
	}

	public DestinatariosCorreoFTPProsaServicio getDestinatariosCorreoFTPProsaServicio() {
		return destinatariosCorreoFTPProsaServicio;
	}

	public void setDestinatariosCorreoFTPProsaServicio(
			DestinatariosCorreoFTPProsaServicio destinatariosCorreoFTPProsaServicio) {
		this.destinatariosCorreoFTPProsaServicio = destinatariosCorreoFTPProsaServicio;
	}
	
	

}
