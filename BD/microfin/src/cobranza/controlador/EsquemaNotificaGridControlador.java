package cobranza.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cobranza.bean.EsquemaNotificaBean;
import cobranza.servicio.EsquemaNotificaServicio;

public class EsquemaNotificaGridControlador extends AbstractCommandController{
	EsquemaNotificaServicio esquemaNotificaServicio = null;
	
	public EsquemaNotificaGridControlador(){
		setCommandClass(EsquemaNotificaBean.class);
		setCommandName("esquemaNotificaBean");		
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		EsquemaNotificaBean esquemaBean = (EsquemaNotificaBean)command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));	

		List listaResultado = new ArrayList();
		List parametrosList = esquemaNotificaServicio.listaEsquemaNotifica(tipoLista, esquemaBean);
		
		listaResultado.add(tipoLista);
		listaResultado.add(parametrosList);
		
		return new ModelAndView("cobranza/esquemaNotificaGridVista", "listaResultado", listaResultado);
	}

	public EsquemaNotificaServicio getEsquemaNotificaServicio() {
		return esquemaNotificaServicio;
	}

	public void setEsquemaNotificaServicio(
			EsquemaNotificaServicio esquemaNotificaServicio) {
		this.esquemaNotificaServicio = esquemaNotificaServicio;
	}

}
