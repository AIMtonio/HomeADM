package cliente.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.NegocioAfiliadoBean;
import cliente.servicio.NegocioAfiliadoServicio;

public class NegocioAfiliadoControlador extends SimpleFormController {
	
	NegocioAfiliadoServicio negocioAfiliadoServicio = null;
 	private ParametrosSesionBean parametrosSesionBean = null;

	public NegocioAfiliadoControlador() {
		setCommandClass(NegocioAfiliadoBean.class);
		setCommandName("negocioAfiliado");
	}
		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		negocioAfiliadoServicio.getNegocioAfiliadoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		NegocioAfiliadoBean negocioAfiliado = (NegocioAfiliadoBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
					Integer.parseInt(request.getParameter("tipoActualizacion")):
					0;
						
		MensajeTransaccionBean mensaje = null;
		mensaje = negocioAfiliadoServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion, negocioAfiliado);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setNegocioAfiliadoServicio(NegocioAfiliadoServicio negocioAfiliadoServicio) {
		this.negocioAfiliadoServicio = negocioAfiliadoServicio;
	}


	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	
	
}
