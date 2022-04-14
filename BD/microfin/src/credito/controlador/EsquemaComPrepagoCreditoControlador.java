package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import credito.bean.EsquemaComPrepagoCreditoBean;
import credito.servicio.EsquemaComPrepagoCreditoServicio;


public class EsquemaComPrepagoCreditoControlador  extends SimpleFormController {
	
	EsquemaComPrepagoCreditoServicio esquemaComPrepagoCreditoServicio = null;
	

	public EsquemaComPrepagoCreditoControlador() {
		setCommandClass(EsquemaComPrepagoCreditoBean.class);
		setCommandName("esquemaComPrepagoCredito");
	}
		
		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception{
		
		esquemaComPrepagoCreditoServicio.getEsquemaComPrepagoCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(
				request.getRequestURI().toString()
				);
		
		EsquemaComPrepagoCreditoBean esquemaComPrepagoCredito = (EsquemaComPrepagoCreditoBean) command;

		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
				
		MensajeTransaccionBean mensaje = null;
	
		mensaje = esquemaComPrepagoCreditoServicio.grabaTransaccion(tipoTransaccion, esquemaComPrepagoCredito );
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
		

//                      	---SETTERS---
	public void setEsquemaComPrepagoCreditoServicio(
			EsquemaComPrepagoCreditoServicio esquemaComPrepagoCreditoServicio) {
		this.esquemaComPrepagoCreditoServicio = esquemaComPrepagoCreditoServicio;
	}

}
