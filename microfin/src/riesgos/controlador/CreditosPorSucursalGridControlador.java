package riesgos.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import riesgos.bean.UACIRiesgosBean;
import riesgos.servicio.CreditosPorSucursalServicio;

public class CreditosPorSucursalGridControlador extends AbstractCommandController{
	CreditosPorSucursalServicio creditosPorSucursalServicio = null;
	
	public CreditosPorSucursalGridControlador (){
		setCommandClass(UACIRiesgosBean.class);
		setCommandName("creditosSucursal");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		UACIRiesgosBean riesgosBean = (UACIRiesgosBean) command;
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listaSucursal = creditosPorSucursalServicio.lista(tipoLista, riesgosBean);
	
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(listaSucursal);
		
		return new ModelAndView("riesgos/creditosPorSucursalGridVista", "listaResultado", listaResultado);
	
	}
	/* ****************** GETTER Y SETTERS *************************** */

	public CreditosPorSucursalServicio getCreditosPorSucursalServicio() {
		return creditosPorSucursalServicio;
	}

	public void setCreditosPorSucursalServicio(
			CreditosPorSucursalServicio creditosPorSucursalServicio) {
		this.creditosPorSucursalServicio = creditosPorSucursalServicio;
	}

}
