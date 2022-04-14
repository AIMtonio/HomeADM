package credito.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.EsquemaSeguroVidaBean;
import credito.servicio.EsquemaSeguroVidaServicio;

public class EsquemaSeguroControlador extends SimpleFormController {

	EsquemaSeguroVidaServicio esquemaSeguroVidaServicio = null;
	
	public EsquemaSeguroControlador() {
		setCommandClass(EsquemaSeguroVidaBean.class);
		setCommandName("esquemaSeguroVidaBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command,BindException errors) 
	throws Exception {

		esquemaSeguroVidaServicio.getEsquemaSeguroVidaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		EsquemaSeguroVidaBean esquemaSeguroVidaBean = (EsquemaSeguroVidaBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccionGrid")!=null) ?
					Integer.parseInt(request.getParameter("tipoTransaccionGrid")): 0;

		MensajeTransaccionBean mensaje = null;	

		esquemaSeguroVidaBean.setReqSeguroVida(request.getParameter("reqSeguroV"));
		esquemaSeguroVidaBean.setModalidad(request.getParameter("modalid"));

		mensaje = esquemaSeguroVidaServicio.grabaTransaccion(tipoTransaccion,esquemaSeguroVidaBean);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}//fin del onSubmit

	public EsquemaSeguroVidaServicio getEsquemaSeguroVidaServicio() {
		return esquemaSeguroVidaServicio;
	}

	public void setEsquemaSeguroVidaServicio(
			EsquemaSeguroVidaServicio esquemaSeguroVidaServicio) {
		this.esquemaSeguroVidaServicio = esquemaSeguroVidaServicio;
	}

	

}// fin de la clase
