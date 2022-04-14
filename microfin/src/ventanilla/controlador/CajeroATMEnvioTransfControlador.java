package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import ventanilla.bean.CajeroATMTransfBean;
import ventanilla.servicio.CajeroATMTransfServicio;

public class CajeroATMEnvioTransfControlador extends SimpleFormController{
	CajeroATMTransfServicio cajeroATMTransfServicio = null;

	public CajeroATMEnvioTransfControlador(){
		setCommandClass(CajeroATMTransfBean.class);
		setCommandName("cajeroATMTransfer");
	} 
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception{
		
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):	0;
		CajeroATMTransfBean cajeroATMTransfer = (CajeroATMTransfBean) command;
		cajeroATMTransfServicio.getCajeroATMTransfDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		MensajeTransaccionBean mensaje = null;
		mensaje = cajeroATMTransfServicio.grabaTransaccion(tipoTransaccion, cajeroATMTransfer, request );
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	
	//------------Setter ------------
	public CajeroATMTransfServicio getCajeroATMTransfServicio() {
		return cajeroATMTransfServicio;
	}

	public void setCajeroATMTransfServicio(
			CajeroATMTransfServicio cajeroATMTransfServicio) {
		this.cajeroATMTransfServicio = cajeroATMTransfServicio;
	}
	

}
