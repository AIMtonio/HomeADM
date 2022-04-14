package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CalPorRangoBean;
import credito.servicio.CalPorRangoServicio;

public class CalPorRangoReservaControlador extends SimpleFormController {

	CalPorRangoServicio calPorRangoServicio = null;
	
	public CalPorRangoReservaControlador(){
		setCommandClass(CalPorRangoBean.class);
		setCommandName("calPorRangoBean");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
					HttpServletResponse response,
					Object command,
					BindException errors) throws Exception{
		CalPorRangoBean reservaPeriodo = (CalPorRangoBean) command;
		calPorRangoServicio.getCalPorRangoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null)		?	Integer.parseInt(request.getParameter("tipoTransaccion"))  : 0;		
		MensajeTransaccionBean mensaje = null;
		
		String limInferiores = request.getParameter("limInferiores");
		String limSuperiores = request.getParameter("limSuperiores");
		String califica = request.getParameter("lisCalifica");

		mensaje = calPorRangoServicio.grabaTransaccion(tipoTransaccion, reservaPeriodo, limInferiores, limSuperiores, califica);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public CalPorRangoServicio getCalPorRangoServicio() {
		return calPorRangoServicio;
	}
	public void setCalPorRangoServicio(CalPorRangoServicio calPorRangoServicio) {
		this.calPorRangoServicio = calPorRangoServicio;
	}
}
