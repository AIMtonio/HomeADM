package contabilidad.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.FrecTimbradoProducBean;
import contabilidad.servicio.FrecTimbradoProducServicio;

public class FrecTimbradoProducListaControlador extends AbstractCommandController{
	FrecTimbradoProducServicio frecTimbradoProducServicio = null;
  
	public FrecTimbradoProducListaControlador() {
		setCommandClass(FrecTimbradoProducBean.class);
		setCommandName("frecTimbradoProducBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		FrecTimbradoProducBean frecTimbradoProducBean = (FrecTimbradoProducBean) command;
		List listafrecTimProduc =	frecTimbradoProducServicio.lista(tipoLista, frecTimbradoProducBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listafrecTimProduc);
		
		return new ModelAndView("contabilidad/frecTimbradoProducListaVista", "listaResultado", listaResultado);
		}

	public void setFrecTimbradoProducServicio(
			FrecTimbradoProducServicio frecTimbradoProducServicio) {
		this.frecTimbradoProducServicio = frecTimbradoProducServicio;
	}
	

}
