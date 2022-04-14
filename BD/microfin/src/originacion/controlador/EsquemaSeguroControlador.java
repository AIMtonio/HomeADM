package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.EsquemaSeguroBean;
import originacion.servicio.EsquemaSeguroServicio;

public class EsquemaSeguroControlador extends SimpleFormController{
	
	EsquemaSeguroServicio esquemaSeguroServicio;
	
	public EsquemaSeguroControlador(){
		setCommandClass(EsquemaSeguroBean.class);
		setCommandName("esquemaSeguro");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		EsquemaSeguroBean esquemaSeguroBean = (EsquemaSeguroBean) command;
		MensajeTransaccionBean mensaje = null;
		try{
			int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
			String detalles = request.getParameter("detalle");
			esquemaSeguroServicio.getEsquemaSeguroDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
			mensaje = esquemaSeguroServicio.grabaTransaccion(tipoTransaccion,esquemaSeguroBean,detalles);
		} catch(Exception ex){
			ex.printStackTrace();
		} finally {
			if(mensaje==null){
				mensaje=new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al Realizar la Operación.");
			}
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public EsquemaSeguroServicio getEsquemaSeguroServicio() {
		return esquemaSeguroServicio;
	}

	public void setEsquemaSeguroServicio(EsquemaSeguroServicio esquemaSeguroServicio) {
		this.esquemaSeguroServicio = esquemaSeguroServicio;
	}

}
