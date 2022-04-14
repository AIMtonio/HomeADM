package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.CajasVentanillaBean;
import ventanilla.servicio.CajasVentanillaServicio;

public class CajasVentanillaCatalogoControlador extends SimpleFormController{

	CajasVentanillaServicio cajasVentanillaServicio= null;
	public CajasVentanillaCatalogoControlador(){
		setCommandClass(CajasVentanillaBean.class);
		setCommandName("cajasVentanillaBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception{
		
		CajasVentanillaBean cajasVentanilla = (CajasVentanillaBean) command;
		
		cajasVentanillaServicio.getCajasVentanillaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;
		if (cajasVentanilla.getUsuarioID() == ""){
			cajasVentanilla.setUsuarioID("0");
		}
		if (tipoTransaccion == 4){ //Activacion de Cajas 
			cajasVentanilla.setFechaAct(request.getParameter("fecha"));
			cajasVentanilla.setMotivoAct(request.getParameter("motivo"));
		}
		if (tipoTransaccion == 5){ //Cancelacion de Cajas 
			cajasVentanilla.setFechaCan(request.getParameter("fecha"));
			cajasVentanilla.setMotivoCan(request.getParameter("motivo"));
		}
		if (tipoTransaccion == 6){ //Inactivacion de Cajas 
			cajasVentanilla.setFechaInac(request.getParameter("fecha"));
			cajasVentanilla.setMotivoInac(request.getParameter("motivo"));
		}
		MensajeTransaccionBean mensaje = null;
		
		mensaje = cajasVentanillaServicio.grabaTransaccion(tipoTransaccion, cajasVentanilla, request );
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CajasVentanillaServicio getCajasVentanillaServicio() {
		return cajasVentanillaServicio;
	}

	public void setCajasVentanillaServicio(
			CajasVentanillaServicio cajasVentanillaServicio) {
		this.cajasVentanillaServicio = cajasVentanillaServicio;
	}
	
}
