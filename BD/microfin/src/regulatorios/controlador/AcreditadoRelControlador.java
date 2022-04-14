package regulatorios.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.AcreditadoRelBean;
import regulatorios.servicio.AcreditadoRelServicio;

public class AcreditadoRelControlador extends SimpleFormController{
	AcreditadoRelServicio acreditadoRelServicio = null;
	
	public AcreditadoRelControlador(){
		setCommandClass(AcreditadoRelBean.class);
		setCommandName("acreditadosRelBean");		
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		acreditadoRelServicio.getAcreditadoRelDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		AcreditadoRelBean bean = (AcreditadoRelBean)command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));				
		MensajeTransaccionBean mensaje = null;
		
		mensaje = acreditadoRelServicio.grabaTransaccion(tipoTransaccion, bean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public AcreditadoRelServicio getAcreditadoRelServicio() {
		return acreditadoRelServicio;
	}

	public void setAcreditadoRelServicio(AcreditadoRelServicio acreditadoRelServicio) {
		this.acreditadoRelServicio = acreditadoRelServicio;
	}
}
