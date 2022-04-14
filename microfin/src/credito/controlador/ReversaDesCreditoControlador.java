package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.ReversaDesCreditoBean;
import credito.servicio.ReversaDesembolsoCreditoServicio;



public class ReversaDesCreditoControlador extends SimpleFormController{
	
	ReversaDesembolsoCreditoServicio reversaDesembolsoCreditoServicio = null;
	
	public ReversaDesCreditoControlador(){
		setCommandClass(ReversaDesCreditoBean.class);
		setCommandName("reversaDesCreditoBean");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
					HttpServletResponse response,
					Object command,
					BindException errors) throws Exception{
		ReversaDesCreditoBean reversaDesBean = (ReversaDesCreditoBean) command;
		reversaDesembolsoCreditoServicio.getReversaDesCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
				
		MensajeTransaccionBean mensaje = null;
		mensaje = reversaDesembolsoCreditoServicio.grabaTransaccion(reversaDesBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	//--------------- SETTERS Y GETTERS --------------------------------------------------
	
	public ReversaDesembolsoCreditoServicio getReversaDesembolsoCreditoServicio() {
		return reversaDesembolsoCreditoServicio;
	}
	public void setReversaDesembolsoCreditoServicio(
			ReversaDesembolsoCreditoServicio reversaDesembolsoCreditoServicio) {
		this.reversaDesembolsoCreditoServicio = reversaDesembolsoCreditoServicio;
	}
	
	
}
