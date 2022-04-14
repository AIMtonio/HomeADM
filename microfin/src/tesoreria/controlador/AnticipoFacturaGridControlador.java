package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.AnticipoFacturaBean;
import tesoreria.servicio.AnticipoFacturaServicio;



public class AnticipoFacturaGridControlador extends AbstractCommandController{
	
	AnticipoFacturaServicio anticipoFacturaServicio = null;

	public AnticipoFacturaGridControlador() {
		setCommandClass(AnticipoFacturaBean.class);
		setCommandName("anticipoFacturaBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {
	
		AnticipoFacturaBean anticipoFacturaBean = (AnticipoFacturaBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List anticipoFacturaList = anticipoFacturaServicio.lista(tipoLista, anticipoFacturaBean);
	
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(anticipoFacturaList);
		
		return new ModelAndView("tesoreria/anticipoFacturaGridVista", "listaResultado", listaResultado);
	
	}

	public AnticipoFacturaServicio getAnticipoFacturaServicio() {
		return anticipoFacturaServicio;
	}

	public void setAnticipoFacturaServicio(
			AnticipoFacturaServicio anticipoFacturaServicio) {
		this.anticipoFacturaServicio = anticipoFacturaServicio;
	}
}