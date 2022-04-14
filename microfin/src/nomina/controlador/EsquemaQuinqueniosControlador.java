package nomina.controlador;


import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.EsquemaQuinqueniosBean;
import nomina.servicio.EsquemaQuinqueniosServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.MensajeTransaccionBean;

 
public class EsquemaQuinqueniosControlador extends SimpleFormController {
	EsquemaQuinqueniosServicio esquemaQuinqueniosServicio = null;
	
	public EsquemaQuinqueniosControlador() {
		setCommandClass(EsquemaQuinqueniosBean.class);
		setCommandName("esquemaQuinqueniosBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?		
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
				
		EsquemaQuinqueniosBean esquemaQuinqueniosBean = (EsquemaQuinqueniosBean) command;
		
		MensajeTransaccionBean mensaje = null;
		
		esquemaQuinqueniosServicio.getEsquemaQuinqueniosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	
			
		mensaje = esquemaQuinqueniosServicio.grabaTransaccion(tipoTransaccion,esquemaQuinqueniosBean);

		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
	}

	// ============== GETTER & SETTER ============= //

	public EsquemaQuinqueniosServicio getEsquemaQuinqueniosServicio() {
		return esquemaQuinqueniosServicio;
	}

	public void setEsquemaQuinqueniosServicio(
			EsquemaQuinqueniosServicio esquemaQuinqueniosServicio) {
		this.esquemaQuinqueniosServicio = esquemaQuinqueniosServicio;
	}
}
