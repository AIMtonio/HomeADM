package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import tesoreria.bean.CuentaMayorCajasBean;
import tesoreria.servicio.GuiaContableCajasServicio;

public class GuiaContableCajasControlador extends SimpleFormController{
	
	GuiaContableCajasServicio guiaContableCajasServicio = null;
	public GuiaContableCajasControlador(){
		setCommandClass(CuentaMayorCajasBean.class);
		setCommandName("Cajas");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		MensajeTransaccionBean mensaje = null; 	
		CuentaMayorCajasBean guiaCuentaMayor = (CuentaMayorCajasBean) command;
	
		int  tipoTransaccionCM = (request.getParameter("tipoTransaccionCM")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccionCM")):0;
		guiaContableCajasServicio.getGuiaContableCajaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		mensaje = guiaContableCajasServicio.grabaTransaccion(tipoTransaccionCM,request);
		
	return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public GuiaContableCajasServicio getGuiaContableCajasServicio() {
		return guiaContableCajasServicio;
	}

	public void setGuiaContableCajasServicio(
			GuiaContableCajasServicio guiaContableCajasServicio) {
		this.guiaContableCajasServicio = guiaContableCajasServicio;
	}

	
	
	
}

