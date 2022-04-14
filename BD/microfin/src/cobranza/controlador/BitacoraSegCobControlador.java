package cobranza.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cobranza.bean.BitacoraSegCobBean;
import cobranza.servicio.BitacoraSegCobServicio;

public class BitacoraSegCobControlador extends SimpleFormController{
	BitacoraSegCobServicio bitacoraSegCobServicio = null;
	
	public BitacoraSegCobControlador(){
		setCommandClass(BitacoraSegCobBean.class);
		setCommandName("bitacoraSegCobBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		bitacoraSegCobServicio.getBitacoraSegCobDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		BitacoraSegCobBean bitacoraSegCobBean =(BitacoraSegCobBean)command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));	
		MensajeTransaccionBean mensaje = null;		
		
		mensaje =  bitacoraSegCobServicio.grabaTransaccion(tipoTransaccion, bitacoraSegCobBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);	
	}

	public BitacoraSegCobServicio getBitacoraSegCobServicio() {
		return bitacoraSegCobServicio;
	}

	public void setBitacoraSegCobServicio(
			BitacoraSegCobServicio bitacoraSegCobServicio) {
		this.bitacoraSegCobServicio = bitacoraSegCobServicio;
	}
}
