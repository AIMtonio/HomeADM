package pld.controlador;

import java.io.ByteArrayOutputStream;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClienteBean;

import pld.bean.OperLimExcedidosRepBean;
import pld.servicio.CuestionariosAdicionalesServicio;


public class CuestionariosAdicionalesControlador  extends SimpleFormController {
	public CuestionariosAdicionalesControlador(){
		setCommandClass(ClienteBean.class);
		setCommandName("cliente");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		MensajeTransaccionBean mensaje = null;
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
}
