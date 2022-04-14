package spei.controlador;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import spei.bean.PagoRemesasTraspasosSpeiBean;
import spei.servicio.PagoRemesasTraspasosSpeiServicio;

public class PagoRemesasTraspasosSpeiGridControlador extends AbstractCommandController{
	
	PagoRemesasTraspasosSpeiServicio pagoRemesasTraspasosSpeiServicio = null;

 	public PagoRemesasTraspasosSpeiGridControlador(){
 		setCommandClass(PagoRemesasTraspasosSpeiBean.class);
 		setCommandName("pagoRemesasTraspasosSpeiBean");
 	}
 	
 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		PagoRemesasTraspasosSpeiBean pagoRemesasTraspasosSpeiBean = (PagoRemesasTraspasosSpeiBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List pagoRemesaList = pagoRemesasTraspasosSpeiServicio.lista(tipoLista, pagoRemesasTraspasosSpeiBean);
		
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(pagoRemesaList);
		
		return new ModelAndView("spei/pagoRemesasTraspasosSpeiGridVista", "listaResultado", listaResultado);

 	}
 	
	
 // ---------------  getter y setter -------------------- 
 	public PagoRemesasTraspasosSpeiServicio getPagoRemesasTraspasosSpeiServicio() {
 		return pagoRemesasTraspasosSpeiServicio;
 	}

 	public void setPagoRemesasTraspasosSpeiServicio(
 			PagoRemesasTraspasosSpeiServicio pagoRemesasTraspasosSpeiServicio) {
 		this.pagoRemesasTraspasosSpeiServicio = pagoRemesasTraspasosSpeiServicio;
 	}


}
