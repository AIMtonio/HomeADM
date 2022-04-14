package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.CancelacionOrdPagoBean;
import tesoreria.servicio.CancelacionOrdPagoServicio;

public class CancelacionOrdPagoControlador extends SimpleFormController{
	
	CancelacionOrdPagoServicio cancelacionOrdPagoServicio;
	
	public CancelacionOrdPagoControlador(){
		setCommandClass(CancelacionOrdPagoBean.class);
		setCommandName("cancelacionOrdPago");
	}
	
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		CancelacionOrdPagoBean cancelacionOrdPagoBean = (CancelacionOrdPagoBean) command;
		MensajeTransaccionBean mensaje = null;
		try{
			int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccion")) : 0;
			cancelacionOrdPagoServicio.getCancelacionOrdPagoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			mensaje = cancelacionOrdPagoServicio.grabaTransaccion(tipoTransaccion, cancelacionOrdPagoBean , "");
		} catch(Exception ex){
			ex.printStackTrace();
		} finally {
			if(mensaje==null){
				mensaje=new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al Grabar el Catalogo.");
			}
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}


	public CancelacionOrdPagoServicio getCancelacionOrdPagoServicio() {
		return cancelacionOrdPagoServicio;
	}


	public void setCancelacionOrdPagoServicio(
			CancelacionOrdPagoServicio cancelacionOrdPagoServicio) {
		this.cancelacionOrdPagoServicio = cancelacionOrdPagoServicio;
	}

}