package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.PorReservaPeriodoBean;
import credito.servicio.PorReservaPeriodoServicio;


public class ReservaDiasAtrasoControlador  extends SimpleFormController {

	PorReservaPeriodoServicio porReservaPeriodoServicio = null;
	
	public ReservaDiasAtrasoControlador(){
		setCommandClass(PorReservaPeriodoBean.class);
		setCommandName("porReservaPeriodoBean");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
					HttpServletResponse response,
					Object command,
					BindException errors) throws Exception{
		PorReservaPeriodoBean reservaPeriodo = (PorReservaPeriodoBean) command;
		porReservaPeriodoServicio.getPorReservaPeriodoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null)		?	Integer.parseInt(request.getParameter("tipoTransaccion"))  : 0;		
		MensajeTransaccionBean mensaje = null;
		
		String limInferiores = request.getParameter("limInferiores");
		String limSuperiores = request.getParameter("limSuperiores");
		String cartSReest = request.getParameter("cartSReest");
		String cartReest = request.getParameter("cartReest");

		mensaje = porReservaPeriodoServicio.grabaTransaccion(tipoTransaccion, reservaPeriodo, limInferiores, limSuperiores, cartSReest, cartReest );
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	public PorReservaPeriodoServicio getPorReservaPeriodoServicio() {
		return porReservaPeriodoServicio;
	}
	public void setPorReservaPeriodoServicio(
			PorReservaPeriodoServicio porReservaPeriodoServicio) {
		this.porReservaPeriodoServicio = porReservaPeriodoServicio;
	}
	
}