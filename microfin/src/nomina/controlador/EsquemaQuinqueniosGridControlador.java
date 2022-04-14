package nomina.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.EsquemaQuinqueniosBean;
import nomina.servicio.EsquemaQuinqueniosServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


public class EsquemaQuinqueniosGridControlador extends AbstractCommandController {
	
EsquemaQuinqueniosServicio esquemaQuinqueniosServicio = null;
	
	public EsquemaQuinqueniosGridControlador() {
		setCommandClass(EsquemaQuinqueniosBean.class);
		setCommandName("esquemaQuinqueniosBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		EsquemaQuinqueniosBean esquemaQuinqueniosBean = (EsquemaQuinqueniosBean) command;
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
					
		List listaResultado = esquemaQuinqueniosServicio.lista(tipoLista, esquemaQuinqueniosBean);
			
		return new ModelAndView("nomina/esquemaQuinqueniosGridGridVista", "listaResultado", listaResultado);
	}
	
	// ============== GETTER & SETTER ===================
	
	public EsquemaQuinqueniosServicio getEsquemaQuinqueniosServicio() {
		return esquemaQuinqueniosServicio;
	}

	public void setEsquemaQuinqueniosServicio(
			EsquemaQuinqueniosServicio esquemaQuinqueniosServicio) {
		this.esquemaQuinqueniosServicio = esquemaQuinqueniosServicio;
	}

}
