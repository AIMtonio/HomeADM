package contabilidad.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.PeriodoContableBean;
import contabilidad.servicio.PeriodoContableServicio;

public class PeriodoContableGridControlador extends AbstractCommandController {

	PeriodoContableServicio periodoContableServicio = null;
	
	public PeriodoContableGridControlador() {
		setCommandClass(PeriodoContableBean.class);
		setCommandName("periodoContable");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
			
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		PeriodoContableBean periodoContableBean = (PeriodoContableBean) command;
		List periodosList = periodoContableServicio.lista(tipoLista, periodoContableBean);
		
		return new ModelAndView("contabilidad/periodosContaGridVista", "listaResultado", periodosList);
													  
	}

	public void setPeriodoContableServicio(PeriodoContableServicio periodoContableServicio) {
		this.periodoContableServicio = periodoContableServicio;
	}
	
	
	
}
