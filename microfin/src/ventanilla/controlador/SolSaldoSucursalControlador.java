package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.SolSaldoSucursalBean;
import ventanilla.servicio.SolSaldoSucursalServicio;

public class SolSaldoSucursalControlador extends SimpleFormController{
	SolSaldoSucursalServicio solSaldoSucursalServicio = null;
	
	public SolSaldoSucursalControlador(){
		setCommandClass(SolSaldoSucursalBean.class);
		setCommandName("solSaldoSucursalBean");
	} 
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception{
		
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;
		SolSaldoSucursalBean solSaldoSucursalBean = (SolSaldoSucursalBean) command;
		solSaldoSucursalServicio.getSolSaldoSucursalDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		MensajeTransaccionBean mensaje = null;
		mensaje = solSaldoSucursalServicio.grabaTransaccion(tipoTransaccion, solSaldoSucursalBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public SolSaldoSucursalServicio getSolSaldoSucursalServicio() {
		return solSaldoSucursalServicio;
	}

	public void setSolSaldoSucursalServicio(
			SolSaldoSucursalServicio solSaldoSucursalServicio) {
		this.solSaldoSucursalServicio = solSaldoSucursalServicio;
	}
	
	
}
