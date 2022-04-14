package arrendamiento.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import arrendamiento.bean.ActivoArrendaBean;
import arrendamiento.servicio.ActivoArrendaServicio;



public class ActivosLigadosGridControlador  extends AbstractCommandController {

	ActivoArrendaServicio activoArrendaServicio = null;
	
	public ActivosLigadosGridControlador() {
		setCommandClass(ActivoArrendaBean.class);
		setCommandName("activoArrendaBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
				  HttpServletResponse response,
				  Object command,
				  BindException errors) throws Exception {	
			
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
					0;
		ActivoArrendaBean activoArrendaBean = (ActivoArrendaBean) command;
		// lista de amortizaciones
		List<ActivoArrendaBean> listaActivos = activoArrendaServicio.listaActivosArrendamiento(tipoLista, activoArrendaBean);
		
		return new ModelAndView("arrendamiento/activosLigadosGridVista", "listaResultado", listaActivos);
								
	}

	// GETTER Y SETTER
	public ActivoArrendaServicio getActivoArrendaServicio() {
		return activoArrendaServicio;
	}

	public void setActivoArrendaServicio(ActivoArrendaServicio activoArrendaServicio) {
		this.activoArrendaServicio = activoArrendaServicio;
	}
}

