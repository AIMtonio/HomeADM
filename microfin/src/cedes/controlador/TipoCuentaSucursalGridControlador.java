package cedes.controlador;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cedes.bean.TipoCuentaSucursalBean;
import cedes.servicio.TipoCuentaSucursalServicio;

public class TipoCuentaSucursalGridControlador extends AbstractCommandController{
	
	TipoCuentaSucursalServicio tipoCuentaSucursalServicio = null;

	public TipoCuentaSucursalGridControlador() {
		setCommandClass(TipoCuentaSucursalBean.class);
		setCommandName("tipoCuentaSucursalBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {
		
		TipoCuentaSucursalBean bean = (TipoCuentaSucursalBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listSucursales = tipoCuentaSucursalServicio.lista(tipoLista,bean);
		
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(listSucursales);
		
		return new ModelAndView("cedes/tipoCuentaSucursalGridVista", "listaResultado", listaResultado);
	
	}
	
	

	public TipoCuentaSucursalServicio getTipoCuentaSucursalServicio() {
		return tipoCuentaSucursalServicio;
	}
	public void setTipoCuentaSucursalServicio(
			TipoCuentaSucursalServicio tipoCuentaSucursalServicio) {
		this.tipoCuentaSucursalServicio = tipoCuentaSucursalServicio;
	}
} 
