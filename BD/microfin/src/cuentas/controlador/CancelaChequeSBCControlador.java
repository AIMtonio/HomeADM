package cuentas.controlador; 

 import javax.servlet.http.HttpServletRequest;
 import javax.servlet.http.HttpServletResponse;

 import general.bean.MensajeTransaccionBean;

 import org.springframework.validation.BindException;
 import org.springframework.web.servlet.ModelAndView;
 import org.springframework.web.servlet.mvc.SimpleFormController;




import cuentas.bean.CancelaChequeSBCBean;

import cuentas.dao.CancelaChequeSBCDAO;
import cuentas.servicio.CancelaChequeSBCServicio;


 public class CancelaChequeSBCControlador extends SimpleFormController {

		CancelaChequeSBCServicio cancelaChequeSBCServicio = null;

 

	public CancelaChequeSBCControlador(){
 		setCommandClass(CancelaChequeSBCBean.class);
 		setCommandName("cancelaCheques");
 	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception{
		
		cancelaChequeSBCServicio.getCancelaChequeSBCDAO().getParametrosAuditoriaBean().setNombrePrograma(
				request.getRequestURI().toString()
				);
		
		CancelaChequeSBCBean cancelaCheques = (CancelaChequeSBCBean) command;

		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
				
		MensajeTransaccionBean mensaje = null;
	
		mensaje = cancelaChequeSBCServicio.grabaTransaccion(tipoTransaccion, cancelaCheques );
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	
		// getter and setter 
	public CancelaChequeSBCServicio getCancelaChequeSBCServicio() {
		return cancelaChequeSBCServicio;
	}

	public void setCancelaChequeSBCServicio(
			CancelaChequeSBCServicio cancelaChequeSBCServicio) {
		this.cancelaChequeSBCServicio = cancelaChequeSBCServicio;
	}

}
