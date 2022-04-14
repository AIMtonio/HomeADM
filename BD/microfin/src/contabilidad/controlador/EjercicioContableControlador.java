package contabilidad.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.EjercicioContableBean;
import contabilidad.servicio.EjercicioContableServicio;

public class EjercicioContableControlador extends SimpleFormController {

	EjercicioContableServicio ejercicioContableServicio = null;
	
	public EjercicioContableControlador() {
		setCommandClass(EjercicioContableBean.class);
		setCommandName("ejercicioContable");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
				
		EjercicioContableBean ejercicioContableBean = (EjercicioContableBean) command;
		String periodosIni = request.getParameter("listPeriodoIni");												   
		String periodosFin = request.getParameter("listPeriodoFin");
		MensajeTransaccionBean mensaje = null;
		mensaje = ejercicioContableServicio.grabaEjercicioYPeriodos(ejercicioContableBean,
																	periodosIni,
																	periodosFin);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	// ---------------------- Setters y Getters -------------------------------------------------------------
	public void setEjercicioContableServicio(
			EjercicioContableServicio ejercicioContableServicio) {
		this.ejercicioContableServicio = ejercicioContableServicio;
	}

	
	
}
