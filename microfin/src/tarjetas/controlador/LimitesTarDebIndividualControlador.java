package tarjetas.controlador;

import java.io.IOException;

import general.bean.MensajeTransaccionBean;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.LimitesTarDebIndividualBean;
import tarjetas.servicio.LimiteTarCreIndividualServicio;
import tarjetas.servicio.LimitesTarDebIndividualServicio;
public class LimitesTarDebIndividualControlador extends  SimpleFormController {	
	
	LimitesTarDebIndividualServicio limitesTarDebIndividualServicio= null;
	LimiteTarCreIndividualServicio limitesTarCreIndividualServicio= null;
						

	public LimitesTarDebIndividualControlador(){
 		setCommandClass(LimitesTarDebIndividualBean.class);
 		setCommandName("limitesTarDebIndividualBean");
 	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		
		limitesTarDebIndividualServicio.getLimitesTarDebIndividualDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		LimitesTarDebIndividualBean limitesTarDebIndividualBean = (LimitesTarDebIndividualBean) command;
 		String tipoTarjeta = limitesTarDebIndividualBean.getTipoTarjeta();
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):0;
 		MensajeTransaccionBean mensaje = null;
 	if(tipoTarjeta.equals("D")){
 		mensaje = limitesTarDebIndividualServicio.grabaTransaccion(tipoTransaccion, limitesTarDebIndividualBean);
 	}else if(tipoTarjeta.equals("C")){
 		mensaje = limitesTarCreIndividualServicio.grabaTransaccion(tipoTransaccion, limitesTarDebIndividualBean);
 	}
 	
 		
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
	}

	public LimitesTarDebIndividualServicio getLimitesTarDebIndividualServicio() {
		return limitesTarDebIndividualServicio;
	}

	public void setLimitesTarDebIndividualServicio(
			LimitesTarDebIndividualServicio limitesTarDebIndividualServicio) {
		this.limitesTarDebIndividualServicio = limitesTarDebIndividualServicio;
	}

	public LimiteTarCreIndividualServicio getLimitesTarCreIndividualServicio() {
		return limitesTarCreIndividualServicio;
	}

	public void setLimitesTarCreIndividualServicio(
			LimiteTarCreIndividualServicio limitesTarCreIndividualServicio) {
		this.limitesTarCreIndividualServicio = limitesTarCreIndividualServicio;
	}

}