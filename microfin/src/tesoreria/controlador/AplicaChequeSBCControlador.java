package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import ventanilla.bean.AbonoChequeSBCBean;
import ventanilla.servicio.AbonoChequeSBCServicio;


public class AplicaChequeSBCControlador extends SimpleFormController {
	AbonoChequeSBCServicio abonoChequeSBCServicio = null;
	public AplicaChequeSBCControlador() {
		setCommandClass(AbonoChequeSBCBean.class);
		setCommandName("SBC");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		abonoChequeSBCServicio.getAbonoChequeSBCDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		AbonoChequeSBCBean abonoChequeSBCBean = (AbonoChequeSBCBean) command;
		int tipoTransaccion = (request.getParameter("tipoTransaccion")!=null)?
							Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		
		MensajeTransaccionBean mensaje = null;
		mensaje = abonoChequeSBCServicio.grabaTransaccion(tipoTransaccion,abonoChequeSBCBean);										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	
	//----------setter --------------------
	public void setAbonoChequeSBCServicio(
			AbonoChequeSBCServicio abonoChequeSBCServicio) {
		this.abonoChequeSBCServicio = abonoChequeSBCServicio;
	}
	
	
}
