package cliente.controlador;

import general.bean.MensajeTransaccionBean;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.CuentasTransferBean;
import cliente.servicio.CuentasTransferServicio;

public class CuentasDestinoTranferControlador extends SimpleFormController {
	
	CuentasTransferServicio cuentasTransferServicio = null;

	public CuentasDestinoTranferControlador() {
		setCommandClass(CuentasTransferBean.class);
		setCommandName("cuentas");
	}
		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		cuentasTransferServicio.getCuentasTransferDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		CuentasTransferBean cuentas = (CuentasTransferBean) command;
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
						Integer.parseInt(request.getParameter("tipoActualizacion")):0;

		int tipoTransaccion =  (request.getParameter("tipoTransaccion")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		
		MensajeTransaccionBean mensaje = null;
		mensaje = cuentasTransferServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion,cuentas);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

//----------------------setter----------------------------------
	public void setCuentasTransferServicio(CuentasTransferServicio cuentasTransferServicio) {
			this.cuentasTransferServicio = cuentasTransferServicio;
	}

	

}
	