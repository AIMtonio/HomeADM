package riesgos.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosPorProductoServicio;

public class CreditosPorProductoGridControlador extends AbstractCommandController{
	CreditosPorProductoServicio creditosPorProductoServicio = null;
	
	public CreditosPorProductoGridControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("creditosPorProducto");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		UACIRiesgosBean riesgosBean = (UACIRiesgosBean) command;
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listaCreditoProducto = creditosPorProductoServicio.lista(tipoLista, riesgosBean);
	
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(listaCreditoProducto);
		
		return new ModelAndView("riesgos/creditosPorProductoGridVista", "listaResultado", listaResultado);
	
	}
	/* ****************** GETTER Y SETTERS *************************** */

	public CreditosPorProductoServicio getCreditosPorProductoServicio() {
		return creditosPorProductoServicio;
	}

	public void setCreditosPorProductoServicio(
			CreditosPorProductoServicio creditosPorProductoServicio) {
		this.creditosPorProductoServicio = creditosPorProductoServicio;
	}

}
