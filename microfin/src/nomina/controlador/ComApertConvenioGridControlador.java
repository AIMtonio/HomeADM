package nomina.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.ComApertConvenioBean;
import nomina.servicio.ComApertConvenioServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


public class ComApertConvenioGridControlador extends AbstractCommandController {
	
ComApertConvenioServicio comApertConvenioServicio = null;
	
	public ComApertConvenioGridControlador() {
		setCommandClass(ComApertConvenioBean.class);
		setCommandName("comApertConvenioBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		ComApertConvenioBean comApertConvenioBean = (ComApertConvenioBean) command;
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String esqId = request.getParameter("esqComApertID");
		comApertConvenioBean.setEsqComApertID(esqId);
		List listaResultado = comApertConvenioServicio.lista(tipoLista, comApertConvenioBean);
			
		return new ModelAndView("nomina/comApertConvenioGridVista", "listaResultado", listaResultado);
	}
	
	// ============== GETTER & SETTER ===================
	
	public ComApertConvenioServicio getComApertConvenioServicio() {
		return comApertConvenioServicio;
	}

	public void setComApertConvenioServicio(
			ComApertConvenioServicio comApertConvenioServicio) {
		this.comApertConvenioServicio = comApertConvenioServicio;
	}
}
