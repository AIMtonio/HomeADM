package nomina.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import nomina.bean.BitacoraPagoNominaBean;
import nomina.servicio.BitacoraPagoNominaServicio;

public class BitacoraPagoNominaControlador extends SimpleFormController{
	BitacoraPagoNominaServicio bitacoraPagoNominaServicio = null;

	public BitacoraPagoNominaControlador() {
		setCommandClass(BitacoraPagoNominaBean.class);
		setCommandName("bitacoraPagoNominaBean");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
			
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?		
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
	
		bitacoraPagoNominaServicio.getBitacoraPagoNominaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		BitacoraPagoNominaBean bitacoraPagoNominaBean = (BitacoraPagoNominaBean) command;
		MensajeTransaccionBean mensaje = null;
		mensaje = bitacoraPagoNominaServicio.grabaTransaccion(tipoTransaccion,bitacoraPagoNominaBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	/* Declaracion de getter y setters */
	public BitacoraPagoNominaServicio getBitacoraPagoNominaServicio() {
		return bitacoraPagoNominaServicio;
	}
	public void setBitacoraPagoNominaServicio(
			BitacoraPagoNominaServicio bitacoraPagoNominaServicio) {
		this.bitacoraPagoNominaServicio = bitacoraPagoNominaServicio;
	}
	
}
