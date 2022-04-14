package originacion.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.EsquemaCargoDispBean;
import originacion.servicio.EsquemaCargoDispServicio;

public class EsquemaCargoDispControlador extends SimpleFormController{
	
	EsquemaCargoDispServicio esquemaCargoDispServicio;
	
	public EsquemaCargoDispControlador(){
		setCommandClass(EsquemaCargoDispBean.class);
		setCommandName("esquemaCargoDisp");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		EsquemaCargoDispBean esquemaCargoDispBean = (EsquemaCargoDispBean) command;
		MensajeTransaccionBean mensaje = null;
		try{
			int tipoTransaccion = Utileria.convierteEntero(request.getParameter("tipoTransaccion"));
			String detalles = "";
			esquemaCargoDispServicio.getEsquemaCargoDispDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
			mensaje = esquemaCargoDispServicio.grabaTransaccion(tipoTransaccion,esquemaCargoDispBean,detalles);
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

	public EsquemaCargoDispServicio getEsquemaCargoDispServicio() {
		return esquemaCargoDispServicio;
	}

	public void setEsquemaCargoDispServicio(EsquemaCargoDispServicio esquemaCargoDispServicio) {
		this.esquemaCargoDispServicio = esquemaCargoDispServicio;
	}

}