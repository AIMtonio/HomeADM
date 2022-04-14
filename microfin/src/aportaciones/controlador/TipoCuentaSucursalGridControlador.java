package aportaciones.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import aportaciones.bean.TipoCuentaSucursalABean;
import aportaciones.servicio.TipoCuentaSucursalAServicio;

public class TipoCuentaSucursalGridControlador extends AbstractCommandController {
	
	TipoCuentaSucursalAServicio tipoCuentaSucursalAServicio = null;

	public TipoCuentaSucursalGridControlador() {
		setCommandClass(TipoCuentaSucursalABean.class);
		setCommandName("tipoCuentaSucursalBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {
		
		TipoCuentaSucursalABean bean = (TipoCuentaSucursalABean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listSucursales = tipoCuentaSucursalAServicio.lista(tipoLista,bean);
		
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(listSucursales);
		
		return new ModelAndView("aportaciones/tipoCuentaSucursalGridVista", "listaResultado", listaResultado);
	
	}

	public TipoCuentaSucursalAServicio getTipoCuentaSucursalAServicio() {
		return tipoCuentaSucursalAServicio;
	}

	public void setTipoCuentaSucursalAServicio(
			TipoCuentaSucursalAServicio tipoCuentaSucursalAServicio) {
		this.tipoCuentaSucursalAServicio = tipoCuentaSucursalAServicio;
	}
	
	

}
