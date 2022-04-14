package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.AsamGralUsuarioAutBean;
import soporte.servicio.AsamGralUsuarioAutServicio;


public class AsamGralUsuarioAutGridControlador extends AbstractCommandController{
	AsamGralUsuarioAutServicio asamGralUsuarioAutServicio = null;
	
	public AsamGralUsuarioAutGridControlador() {
		setCommandClass(AsamGralUsuarioAutBean.class);
		setCommandName("asamGralUsuarioAut");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {	
		AsamGralUsuarioAutBean asamGralBean = (AsamGralUsuarioAutBean) command;	
		
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List usuariosList = asamGralUsuarioAutServicio.listaAsamGralUsuarioAut(tipoLista, asamGralBean);
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(usuariosList);
		
		return new ModelAndView("soporte/asamGralUsuarioAutGridVista", "listaResultado", listaResultado);
	}

	/* ****************** GETTER Y SETTERS *************************** */

	public AsamGralUsuarioAutServicio getAsamGralUsuarioAutServicio() {
		return asamGralUsuarioAutServicio;
	}

	public void setAsamGralUsuarioAutServicio(
			AsamGralUsuarioAutServicio asamGralUsuarioAutServicio) {
		this.asamGralUsuarioAutServicio = asamGralUsuarioAutServicio;
	}


}
