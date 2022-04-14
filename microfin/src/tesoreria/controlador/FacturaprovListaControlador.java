package tesoreria.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.FacturaprovBean;
import tesoreria.servicio.FacturaprovServicio;



public class FacturaprovListaControlador extends AbstractCommandController {
	
	FacturaprovServicio facturaprovServicio = null;

	public FacturaprovListaControlador(){
		setCommandClass(FacturaprovBean.class);
		setCommandName("facturaprovBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		String tp=request.getParameter("tipoLista");

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
       String controlID = request.getParameter("controlID");
       
       FacturaprovBean lineasCreditoBean = (FacturaprovBean) command;
                List facturas = facturaprovServicio.lista(tipoLista, lineasCreditoBean);
                
                List listaResultado = (List)new ArrayList();
                listaResultado.add(tipoLista);
                listaResultado.add(controlID);
                listaResultado.add(facturas);
		return new ModelAndView("tesoreria/facturasProveedorListaVista", "listaResultado", listaResultado);
	}

	public void setFacturaprovServicio(FacturaprovServicio facturaprovServicio) {
		this.facturaprovServicio = facturaprovServicio;
	}

	
} 
