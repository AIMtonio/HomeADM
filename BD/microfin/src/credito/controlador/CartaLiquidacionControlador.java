package credito.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CartaLiquidacionBean;
import credito.servicio.CartaLiquidacionServicio;
import general.bean.MensajeTransaccionBean;

public class CartaLiquidacionControlador extends SimpleFormController {
	CartaLiquidacionServicio cartaLiquidacionServicio = null;


	public CartaLiquidacionControlador(){
		setCommandClass(CartaLiquidacionBean.class);
		setCommandName("cartaLiquidacionBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		cartaLiquidacionServicio.getCartaLiquidacionDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		CartaLiquidacionBean cartaLiquidacionBean = (CartaLiquidacionBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;
		
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
								Integer.parseInt(request.getParameter("tipoActualizacion")):
								0;
									
		MensajeTransaccionBean mensaje = null;
		mensaje = cartaLiquidacionServicio.grabaTransaccion(cartaLiquidacionBean, tipoTransaccion, tipoActualizacion);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CartaLiquidacionServicio getCartaLiquidacionServicio() {
		return cartaLiquidacionServicio;
	}

	public void setCartaLiquidacionServicio(CartaLiquidacionServicio cartaLiquidacionServicio) {
		this.cartaLiquidacionServicio = cartaLiquidacionServicio;
	}
}
