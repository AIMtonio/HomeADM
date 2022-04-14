package invkubo.controlador;

import invkubo.bean.FondeoKuboMovsBean;
import invkubo.servicio.FondeoKuboMovsServicio;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosMovsBean;
import credito.servicio.CreditosMovsServicio;

public class MovimFondKuboGridControlador extends AbstractCommandController {
	
	
	FondeoKuboMovsServicio fondeoKuboMovsServicio = null;
	
	public MovimFondKuboGridControlador() 
	{
		setCommandClass(FondeoKuboMovsBean.class);
		setCommandName("fondeoKuboMovsBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		FondeoKuboMovsBean fondeoKuboMovs = (FondeoKuboMovsBean) command;
		fondeoKuboMovsServicio.getFondeoKuboMovsDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List fondeokuboMovsBeanList = fondeoKuboMovsServicio.lista(tipoLista, fondeoKuboMovs);
	
		return new ModelAndView("invKubo/fondeoKuboConsulMovsGridVista", "listaResultado", fondeokuboMovsBeanList);
	}

	public void setFondeoKuboMovsServicio(
			FondeoKuboMovsServicio fondeoKuboMovsServicio) {
		this.fondeoKuboMovsServicio = fondeoKuboMovsServicio;
	}

	

}

