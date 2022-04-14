package originacion.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.DestinosCredProdBean;
import originacion.servicio.DestinosCredProdServicio;

public class DestinosCredProdControlador extends SimpleFormController {
	
	private DestinosCredProdServicio destinosCredProdServicio = null;
	private ParametrosSesionBean parametrosSesionBean = null;

	public DestinosCredProdControlador() {
		setCommandClass(DestinosCredProdBean.class);
		setCommandName("destinosCredProd");
	}
		
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		destinosCredProdServicio.getDestinosCredProdDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		DestinosCredProdBean destinosCred = (DestinosCredProdBean) command;
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		
		mensaje = destinosCredProdServicio.grabaTransaccion(tipoTransaccion,destinosCred);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public DestinosCredProdServicio getDestinosCredProdServicio() {
		return destinosCredProdServicio;
	}

	public void setDestinosCredProdServicio(
			DestinosCredProdServicio destinosCredProdServicio) {
		this.destinosCredProdServicio = destinosCredProdServicio;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
