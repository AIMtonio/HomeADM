package contabilidad.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.FrecTimbradoProducBean;
import contabilidad.servicio.FrecTimbradoProducServicio;

public class FrecTimbradoProducGridControlador  extends AbstractCommandController{

	FrecTimbradoProducServicio  frecTimbradoProducServicio= null;

	public FrecTimbradoProducGridControlador() {
		setCommandClass(FrecTimbradoProducBean.class);
		setCommandName("frecTimbradoProducBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {
	
		FrecTimbradoProducBean frecTimbradoProducBean = (FrecTimbradoProducBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listaResultado = frecTimbradoProducServicio.lista(tipoLista, frecTimbradoProducBean);
		
		return new ModelAndView("contabilidad/frecTimbradoProducGridVista", "listaResultado", listaResultado);
	}

	public FrecTimbradoProducServicio getFrecTimbradoProducServicio() {
		return frecTimbradoProducServicio;
	}

	public void setFrecTimbradoProducServicio(
			FrecTimbradoProducServicio frecTimbradoProducServicio) {
		this.frecTimbradoProducServicio = frecTimbradoProducServicio;
	}

	


}
