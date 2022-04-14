package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.TransferBancoBean;
import ventanilla.servicio.TransferBancoServicio;

public class EnvioEfectivoBancoControlador  extends SimpleFormController{
	TransferBancoServicio transferBancoServicio = null;
	
	public EnvioEfectivoBancoControlador(){
		setCommandClass(TransferBancoBean.class);
		setCommandName("transferBancoBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception{
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;
		
		TransferBancoBean transferBanco = (TransferBancoBean) command;

		transferBancoServicio.getTransferBancoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		MensajeTransaccionBean mensaje = null;
		mensaje = transferBancoServicio.grabaTransaccion(tipoTransaccion, transferBanco, request);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public TransferBancoServicio getTransferBancoServicio() {
		return transferBancoServicio;
	}

	public void setTransferBancoServicio(TransferBancoServicio transferBancoServicio) {
		this.transferBancoServicio = transferBancoServicio;
	}
	
	
}