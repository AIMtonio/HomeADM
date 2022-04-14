package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.DiasPasoVencidoBean;
import originacion.servicio.DiasPasoVencidoServicio;

public class DiasPasoVencidoControlador extends SimpleFormController{
	DiasPasoVencidoServicio	diasPasoVencidoServicio=null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public DiasPasoVencidoControlador(){
		setCommandClass(DiasPasoVencidoBean.class);
		setCommandName("diasPasoVencido");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		DiasPasoVencidoBean diasPasoVencidoBean = (DiasPasoVencidoBean) command;
		
		diasPasoVencidoServicio.getDiasPasoVencidoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		
					
		MensajeTransaccionBean mensaje = null;
		mensaje = diasPasoVencidoServicio.grabaTransaccion(tipoTransaccion,diasPasoVencidoBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);

	}

// ------ setter ------------------------
	public void setDiasPasoVencidoServicio(
			DiasPasoVencidoServicio diasPasoVencidoServicio) {
		this.diasPasoVencidoServicio = diasPasoVencidoServicio;
	}
	

}
