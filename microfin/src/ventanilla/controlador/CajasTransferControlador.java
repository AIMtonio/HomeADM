package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.CajasTransferBean;
import ventanilla.servicio.CajasTransferServicio;

public class CajasTransferControlador extends SimpleFormController{
	CajasTransferServicio cajasTransferServicio = null;
	
	public CajasTransferControlador(){
		setCommandClass(CajasTransferBean.class);
		setCommandName("cajasTransferBean");
	} 
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception{
		
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;
		CajasTransferBean cajasTransfer = (CajasTransferBean) command;
		cajasTransferServicio.getCajasTransferDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		MensajeTransaccionBean mensaje = null;
		mensaje = cajasTransferServicio.grabaTransaccion(tipoTransaccion, cajasTransfer, request );
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CajasTransferServicio getCajasTransferServicio() {
		return cajasTransferServicio;
	}

	public void setCajasTransferServicio(CajasTransferServicio cajasTransferServicio) {
		this.cajasTransferServicio = cajasTransferServicio;
	}

}
