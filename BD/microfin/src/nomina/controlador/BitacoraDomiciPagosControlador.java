package nomina.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import nomina.bean.BitacoraDomiciPagosBean;


public class BitacoraDomiciPagosControlador extends SimpleFormController{
	
	public BitacoraDomiciPagosControlador(){
		setCommandClass(BitacoraDomiciPagosBean.class);
		setCommandName("bitacoraDomiciPagosBean");
	}
	@Override
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,							
			BindException errors) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

}
