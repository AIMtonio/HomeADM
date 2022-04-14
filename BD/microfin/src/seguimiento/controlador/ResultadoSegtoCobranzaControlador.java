package seguimiento.controlador;

import general.bean.MensajeTransaccionBean;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.EsquemaComPrepagoCreditoBean;
import credito.servicio.EsquemaComPrepagoCreditoServicio;

import seguimiento.bean.ResultadoSegtoCobranzaBean;
import seguimiento.servicio.ResultadoSegtoCobranzaServicio;

public class ResultadoSegtoCobranzaControlador extends SimpleFormController{
	
	ResultadoSegtoCobranzaServicio resultadoSegtoCobranzaServicio = null;

	public ResultadoSegtoCobranzaControlador() {
		setCommandClass(ResultadoSegtoCobranzaBean.class);
		setCommandName("resultadoSegtoCobranzaBean");
	}
		
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception{
		
		resultadoSegtoCobranzaServicio.getResultadoSegtoCobranzaDAO().getParametrosAuditoriaBean().setNombrePrograma(
				request.getRequestURI().toString()
				);
		
		ResultadoSegtoCobranzaBean resultadoSegtoCobranzaBean = (ResultadoSegtoCobranzaBean) command;

		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccionCob"));
				
		MensajeTransaccionBean mensaje = null;
	
		mensaje = resultadoSegtoCobranzaServicio.grabaTransaccion(tipoTransaccion, resultadoSegtoCobranzaBean );
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	//getter and setter
	

	public ResultadoSegtoCobranzaServicio getResultadoSegtoCobranzaServicio() {
		return resultadoSegtoCobranzaServicio;
	}

	public void setResultadoSegtoCobranzaServicio(
			ResultadoSegtoCobranzaServicio resultadoSegtoCobranzaServicio) {
		this.resultadoSegtoCobranzaServicio = resultadoSegtoCobranzaServicio;
	}
}
