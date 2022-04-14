package bancaMovil.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import bancaMovil.bean.BAMCuentasOrigenBean;
import bancaMovil.servicio.BANProductosCreditoServicio;

@SuppressWarnings("deprecation")
public class BANProductosCreditoListaControlador extends AbstractCommandController {

	BANProductosCreditoServicio banProductosCreditoServicio = null;

	public BANProductosCreditoListaControlador() {
		setCommandClass(BAMCuentasOrigenBean.class);
		setCommandName("productosCredito");
	}

	@SuppressWarnings("rawtypes")
	@Override
	protected ModelAndView handle(HttpServletRequest arg0, HttpServletResponse arg1, Object arg2, BindException arg3)throws Exception {
		
		List lista = banProductosCreditoServicio.lista(BANProductosCreditoServicio.Enum_Lis_ProductosCreditos.principal);
		
		return new ModelAndView("bancaMovil/BANProductosCreditoListaVista", "productosCreditosLis", lista);
	}

	public BANProductosCreditoServicio getBanProductosCreditoServicio() {
		return banProductosCreditoServicio;
	}

	public void setBanProductosCreditoServicio(BANProductosCreditoServicio banProductosCreditoServicio) {
		this.banProductosCreditoServicio = banProductosCreditoServicio;
	}

}
