package credito.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.TasasBaseBean;
import credito.servicio.TasasBaseServicio;
@SuppressWarnings("deprecation")
public class TasasBaseControlador extends SimpleFormController{
	TasasBaseServicio tasasBaseServicio = null;

	public TasasBaseControlador(){
		setCommandClass(TasasBaseBean.class);
		setCommandName("tasasBaseBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		TasasBaseBean tasasBaseBean = (TasasBaseBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = tasasBaseServicio.grabaTransaccion(tipoTransaccion, tasasBaseBean);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setTasasBaseServicio(TasasBaseServicio tasasBaseServicio){
                    this.tasasBaseServicio = tasasBaseServicio;
	}

}
