package formularioWeb.controlador;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import bancaMovil.bean.BAMParametrosBean;
import formularioWeb.bean.FWProductosCreditoBean;
import formularioWeb.servicio.FWProductosCreditosServicio;
import general.bean.MensajeTransaccionBean;
import herramientas.mapeaBean;

public class FWProductosCreditosControlador extends SimpleFormController {

	FWProductosCreditosServicio fwProductosCreditosServicio = null;

	public FWProductosCreditosControlador() {
		setCommandClass(FWProductosCreditoBean.class);
		setCommandName("productosCreditoFWBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws ServletException, IOException {

		fwProductosCreditosServicio.getFwProductosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		FWProductosCreditoBean parametrosBean = (FWProductosCreditoBean) command;

		parametrosBean = (FWProductosCreditoBean) mapeaBean.valoresDefaultABean(parametrosBean);

		MensajeTransaccionBean mensaje = fwProductosCreditosServicio.grabaTransaccion(FWProductosCreditosServicio.Enum_Tra_Productos.modificacion, parametrosBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public FWProductosCreditosServicio getFwProductosCreditosServicio() {
		return fwProductosCreditosServicio;
	}

	public void setFwProductosCreditosServicio(FWProductosCreditosServicio fwProductosCreditosServicio) {
		this.fwProductosCreditosServicio = fwProductosCreditosServicio;
	}
	
	
	
}
