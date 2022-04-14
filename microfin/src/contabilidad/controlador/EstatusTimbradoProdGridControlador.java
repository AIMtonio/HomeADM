package contabilidad.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.EstatusTimbradoProdBean;
import contabilidad.servicio.EstatusTimbradoProdServicio;


public class EstatusTimbradoProdGridControlador extends AbstractCommandController{

	EstatusTimbradoProdServicio estatusTimbradoProdServicio = null;
	  
	public EstatusTimbradoProdGridControlador() {
		setCommandClass(EstatusTimbradoProdBean.class);
		setCommandName("estatusTimbradoProdBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		EstatusTimbradoProdBean estatusTimbradoProd = (EstatusTimbradoProdBean) command;
		List listaEstatusTimProduc =estatusTimbradoProdServicio.lista(tipoLista, estatusTimbradoProd);
		
		return new ModelAndView("contabilidad/estatusTimbradoGridVista", "listaResultado", listaEstatusTimProduc);
	}

	
	public EstatusTimbradoProdServicio getEstatusTimbradoProdServicio() {
		return estatusTimbradoProdServicio;
	}

	public void setEstatusTimbradoProdServicio(
			EstatusTimbradoProdServicio estatusTimbradoProdServicio) {
		this.estatusTimbradoProdServicio = estatusTimbradoProdServicio;
	}
	
	
	
}
