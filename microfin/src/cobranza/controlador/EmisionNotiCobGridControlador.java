package cobranza.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cobranza.bean.EmisionNotiCobBean;
import cobranza.servicio.EmisionNotiCobServicio;

public class EmisionNotiCobGridControlador extends AbstractCommandController{
	private EmisionNotiCobServicio emisionNotiCobServicio = null;
	
	private EmisionNotiCobGridControlador(){
		setCommandClass(EmisionNotiCobBean.class);
		setCommandName("emisionNotiCobBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {	
		
		EmisionNotiCobBean emisionNotifica = (EmisionNotiCobBean)command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List listaResultado = new ArrayList();
		List listaCreditos = emisionNotiCobServicio.listaCreditosGrid(tipoLista,emisionNotifica);
		
		 listaResultado.add(tipoLista);
		 listaResultado.add(listaCreditos);
		
		return new ModelAndView("cobranza/emisionNotiCobGridVista", "listaResultado", listaResultado);
	}

	public EmisionNotiCobServicio getEmisionNotiCobServicio() {
		return emisionNotiCobServicio;
	}

	public void setEmisionNotiCobServicio(
			EmisionNotiCobServicio emisionNotiCobServicio) {
		this.emisionNotiCobServicio = emisionNotiCobServicio;
	}
	

}
