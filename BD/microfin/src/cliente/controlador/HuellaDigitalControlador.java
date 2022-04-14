package cliente.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClienteBean;
import cliente.bean.HuellaDigitalBean;
import cliente.servicio.ClienteServicio;
import cliente.servicio.HuellaDigitalServicio;

public class HuellaDigitalControlador extends SimpleFormController {
	
	HuellaDigitalServicio huellaDigitalServicio = null;
 	private ParametrosSesionBean parametrosSesionBean = null;

	public HuellaDigitalControlador() {
		setCommandClass(HuellaDigitalBean.class);
		setCommandName("huellaDigital");
	}
		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		huellaDigitalServicio.getHuellaDigitalDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		HuellaDigitalBean huella = (HuellaDigitalBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = huellaDigitalServicio.grabaTransaccion(tipoTransaccion,huella);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}




	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}


	public void setHuellaDigitalServicio(HuellaDigitalServicio huellaDigitalServicio) {
		this.huellaDigitalServicio = huellaDigitalServicio;
	}
	
	
}
