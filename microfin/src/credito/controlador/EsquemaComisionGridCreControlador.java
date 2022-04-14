package credito.controlador;

import general.bean.MensajeTransaccionBean;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.EsquemaComisionCreBean;
import credito.servicio.EsquemaComisionCreServicio;



public class EsquemaComisionGridCreControlador extends AbstractCommandController{
	EsquemaComisionCreServicio esquemaComisionCreServicio = null;

	public EsquemaComisionGridCreControlador() {
		setCommandClass(EsquemaComisionCreBean.class);
		setCommandName("esquemaComisionCreBeanGrid");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {	
	
		EsquemaComisionCreBean esquemaComisionCreBean = (EsquemaComisionCreBean) command;
		
		//El controlador es para la Lista del Grid
	
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List esquemaComisionLis = esquemaComisionCreServicio.lista(tipoLista, esquemaComisionCreBean);
		
		return new ModelAndView("credito/esquemaComisionGridCredito", "esquemaComisionLis", esquemaComisionLis);
		
		}
		
	
	public void setEsquemaComisionCreServicio(
			EsquemaComisionCreServicio esquemaComisionCreServicio) {
		this.esquemaComisionCreServicio = esquemaComisionCreServicio;
	}

	
}
