package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.OpIntPreocupantesBean;
import pld.bean.OpeInusualesBean;
import pld.servicio.OpIntPreocupantesServicio;
import pld.servicio.OpeInusualesServicio;

public class CapturaOpeInusualesControlador extends SimpleFormController{
	
	OpeInusualesServicio opeInusualesServicio = null;

	public CapturaOpeInusualesControlador() {
		setCommandClass(OpeInusualesBean.class);
		setCommandName("capturaOperacionInu");
}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
			//response.setContentType("text/html;charset=UTF-8");
			request.setCharacterEncoding("UTF-8");
		
		/*	HttpServletRequest newRequest=request;                
			newRequest.setCharacterEncoding("UTF-8");
			
			HttpServletResponse newResponse=response;
			newResponse.setContentType("text/html; charset=UTF-8");
			newResponse.setCharacterEncoding("UTF-8");*/

		
		opeInusualesServicio.getOpeInusualesDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		OpeInusualesBean opeInusuales = (OpeInusualesBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		String desplegado = request.getParameter("desplegado");
		opeInusuales.setOrigenDatos(desplegado);
		MensajeTransaccionBean mensaje = null;
		mensaje = opeInusualesServicio.grabaTransaccion(tipoTransaccion,opeInusuales);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
		
	}
		public void setOpeInusualesServicio(OpeInusualesServicio opeInusualesServicio) {
			this.opeInusualesServicio = opeInusualesServicio;
	}
}
