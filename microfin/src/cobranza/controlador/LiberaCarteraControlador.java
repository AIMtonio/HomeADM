package cobranza.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cobranza.bean.LiberaCarteraBean;
import cobranza.servicio.LiberaCarteraServicio;

public class LiberaCarteraControlador extends SimpleFormController{
	private LiberaCarteraServicio liberaCarteraServicio = null;
	
	private LiberaCarteraControlador(){
		setCommandClass(LiberaCarteraBean.class);
		setCommandName("liberaCartera");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		liberaCarteraServicio.getLiberaCarteraDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		LiberaCarteraBean liberaCartera = (LiberaCarteraBean)command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		String  credLib = request.getParameter("listaGridCredLib");
		MensajeTransaccionBean mensaje = null;
		
		mensaje = liberaCarteraServicio.grabaTransaccion(tipoTransaccion, liberaCartera, credLib);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);			
	}

	public LiberaCarteraServicio getLiberaCarteraServicio() {
		return liberaCarteraServicio;
	}

	public void setLiberaCarteraServicio(LiberaCarteraServicio liberaCarteraServicio) {
		this.liberaCarteraServicio = liberaCarteraServicio;
	}

}
