package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.EsquemaTasasBean;
import originacion.servicio.EsquemaTasasServicio;

public class EsquemaTasasControlador extends SimpleFormController {

	EsquemaTasasServicio esquemaTasasServicio = null;

	public EsquemaTasasControlador(){
		setCommandClass(EsquemaTasasBean.class);
		setCommandName("esquemaTasas");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		EsquemaTasasBean esquemaTasasBean = (EsquemaTasasBean) command;
		
		esquemaTasasServicio.getEsquemaTasasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
								
		MensajeTransaccionBean mensaje = null;
		mensaje = esquemaTasasServicio.grabaTransaccion(tipoTransaccion,esquemaTasasBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setEsquemaTasasServicio(EsquemaTasasServicio esquemaTasasServicio) {
		this.esquemaTasasServicio = esquemaTasasServicio;
	}




	
	
} 
