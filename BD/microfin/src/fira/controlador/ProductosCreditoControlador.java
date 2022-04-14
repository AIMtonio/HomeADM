package fira.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.ProductosCreditoBean;
import fira.servicio.ProductosCreditoServicio;

public class ProductosCreditoControlador extends SimpleFormController {

	ProductosCreditoServicio productosCreditoServicio = null;

	public ProductosCreditoControlador(){
		setCommandClass(ProductosCreditoBean.class);
		setCommandName("productosCreditoBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		ProductosCreditoBean productosCreditoBean = (ProductosCreditoBean) command;

		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		productosCreditoBean.setMontoPolSegVida(request.getParameter("montoPol"));

		MensajeTransaccionBean mensaje = null;
		mensaje = productosCreditoServicio.grabaTransaccion(tipoTransaccion, productosCreditoBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ProductosCreditoServicio getProductosCreditoServicio() {
		return productosCreditoServicio;
	}

	public void setProductosCreditoServicio(
			ProductosCreditoServicio productosCreditoServicio) {
		this.productosCreditoServicio = productosCreditoServicio;
	}

} 
