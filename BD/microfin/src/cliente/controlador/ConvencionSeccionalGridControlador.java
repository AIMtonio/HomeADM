package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ConvencionSeccionalBean;
import cliente.servicio.ConvencionSeccionalServicio;

public class ConvencionSeccionalGridControlador extends AbstractCommandController {
	
	ConvencionSeccionalServicio convencionSeccionalServicio= null;
	
	public ConvencionSeccionalGridControlador(){
		setCommandClass(ConvencionSeccionalBean.class);
		setCommandName("paramConvenSeccional");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {	
		ConvencionSeccionalBean convencionSeccionalBean = (ConvencionSeccionalBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listaResultado = convencionSeccionalServicio.lista(tipoLista, convencionSeccionalBean);

		
		return new ModelAndView("cliente/convencionSeccionalGridVista", "listaResultado", listaResultado);
		}

	
	// -------- setter y getter----------------------
	public ConvencionSeccionalServicio getConvencionSeccionalServicio() {
		return convencionSeccionalServicio;
	}

	public void setConvencionSeccionalServicio(
			ConvencionSeccionalServicio convencionSeccionalServicio) {
		this.convencionSeccionalServicio = convencionSeccionalServicio;
	}
	
	
	

}
