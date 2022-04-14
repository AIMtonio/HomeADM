package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.EsquemaComAnualBean;
import originacion.servicio.EsquemaComAnualServicio;

public class EsquemaComAnualControlador extends SimpleFormController{
	
	private EsquemaComAnualServicio esquemaComAnualServicio;
	
	public EsquemaComAnualControlador(){
		setCommandClass(EsquemaComAnualBean.class);
		setCommandName("esquemaComAnual");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		EsquemaComAnualBean esquemaComAnualBean = (EsquemaComAnualBean) command;
		MensajeTransaccionBean mensaje = null;
		try{
			int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
			esquemaComAnualServicio.getEsquemaComAnualDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			mensaje = esquemaComAnualServicio.grabaTransaccion(tipoTransaccion,esquemaComAnualBean);
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

	public EsquemaComAnualServicio getEsquemaComAnualServicio() {
		return esquemaComAnualServicio;
	}

	public void setEsquemaComAnualServicio(EsquemaComAnualServicio esquemaComAnualServicio) {
		this.esquemaComAnualServicio = esquemaComAnualServicio;
	}
}
