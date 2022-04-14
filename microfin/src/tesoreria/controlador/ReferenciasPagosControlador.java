package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.ReferenciasPagosBean;
import tesoreria.servicio.ReferenciasPagosServicio;

public class ReferenciasPagosControlador extends SimpleFormController{
	
	ReferenciasPagosServicio referenciasPagosServicio;
	
	public ReferenciasPagosControlador(){
		setCommandClass(ReferenciasPagosBean.class);
		setCommandName("referenciasPagosBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		ReferenciasPagosBean referenciasPagosBean = (ReferenciasPagosBean) command;
		MensajeTransaccionBean mensaje = null;
		try{
			int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccion")) : 0;
			referenciasPagosServicio.getReferenciasPagosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			mensaje = referenciasPagosServicio.grabaTransaccion(tipoTransaccion, referenciasPagosBean, "");
		} catch(Exception ex){
			ex.printStackTrace();
		} finally {
			if(mensaje==null){
				mensaje=new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al Grabar las Referencias de Pago.");
			}
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ReferenciasPagosServicio getReferenciasPagosServicio() {
		return referenciasPagosServicio;
	}

	public void setReferenciasPagosServicio(
			ReferenciasPagosServicio referenciasPagosServicio) {
		this.referenciasPagosServicio = referenciasPagosServicio;
	}

}