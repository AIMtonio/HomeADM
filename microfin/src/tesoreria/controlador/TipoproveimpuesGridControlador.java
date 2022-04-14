package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.AsamGralUsuarioAutBean;
import tesoreria.bean.TipoproveimpuesBean;
import tesoreria.servicio.TipoproveimpuesServicio;

public class TipoproveimpuesGridControlador extends AbstractCommandController{
	
	TipoproveimpuesServicio tipoproveimpuesServicio = null;
	
	public TipoproveimpuesGridControlador() {
		setCommandClass(TipoproveimpuesBean.class);
		setCommandName("impuestosProveedor");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {	
		TipoproveimpuesBean tipoproveimpuesBean = (TipoproveimpuesBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String tipoProveedorID = request.getParameter("tipoProveedorID");
		List listaResultado = tipoproveimpuesServicio.listaImpuestos(tipoProveedorID, tipoLista, tipoproveimpuesBean);

		
		return new ModelAndView("tesoreria/impuestosProveedorGridVista", "listaResultado", listaResultado);
	}

	public TipoproveimpuesServicio getTipoproveimpuesServicio() {
		return tipoproveimpuesServicio;
	}

	public void setTipoproveimpuesServicio(
			TipoproveimpuesServicio tipoproveimpuesServicio) {
		this.tipoproveimpuesServicio = tipoproveimpuesServicio;
	}

	
	
}
