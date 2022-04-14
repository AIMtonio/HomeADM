package cliente.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import cliente.bean.PuntosConceptoBean;
import cliente.servicio.PuntosConceptoServicio;

public class PuntosConceptoGridControlador extends AbstractCommandController {

	PuntosConceptoServicio	puntosConceptoServicio=null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public PuntosConceptoGridControlador() {
		setCommandClass(PuntosConceptoBean.class);
		setCommandName("puntosConceptoBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {	
		
		PuntosConceptoBean puntosConceptoBean = (PuntosConceptoBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listaResultado = puntosConceptoServicio.lista(tipoLista, puntosConceptoBean);

		return new ModelAndView("cliente/puntosConceptoGridVista", "listaResultado", listaResultado);
	}

	
	/* ========= SET && GET ==============  */
	public PuntosConceptoServicio getPuntosConceptoServicio() {
		return puntosConceptoServicio;
	}

	public void setPuntosConceptoServicio(
			PuntosConceptoServicio puntosConceptoServicio) {
		this.puntosConceptoServicio = puntosConceptoServicio;
	}	
	
	
}
