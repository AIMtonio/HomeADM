
package contabilidad.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.PeriodoContableBean;
import contabilidad.servicio.PeriodoContableServicio;

public class PeriodoContableListaControlador extends AbstractCommandController {

	PeriodoContableServicio periodoContableServicio = null;
	
	public PeriodoContableListaControlador() {
		setCommandClass(PeriodoContableBean.class);
		setCommandName("periodoContable");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
			
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
	
		PeriodoContableBean periodoContableBean = (PeriodoContableBean) command;
		List ocupaciones =	periodoContableServicio.lista(tipoLista, periodoContableBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(ocupaciones);
				
		return new ModelAndView("contabilidad/periodoContableListaVista", "listaResultado", listaResultado);											  
	}

	public void setPeriodoContableServicio(
			PeriodoContableServicio periodoContableServicio) {
		this.periodoContableServicio = periodoContableServicio;
	}	
}