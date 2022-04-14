package crowdfunding.controlador;

import crowdfunding.bean.CRWFondeoMovsBean;
import crowdfunding.servicio.CRWFondeoMovsServicio;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosMovsBean;
import credito.servicio.CreditosMovsServicio;

public class MovimCRWFondGridControlador extends AbstractCommandController {

	CRWFondeoMovsServicio crwFondeoMovsServicio = null;

	public MovimCRWFondGridControlador(){
		setCommandClass(CRWFondeoMovsBean.class);
		setCommandName("crwFondeoMovsBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		CRWFondeoMovsBean crwFondeoMovs = (CRWFondeoMovsBean) command;
		crwFondeoMovsServicio.getCrwFondeoMovsDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List fondeokuboMovsBeanList = crwFondeoMovsServicio.lista(tipoLista, crwFondeoMovs);
		return new ModelAndView("crowdfunding/crwFondeoConsulMovsGridVista", "listaResultado", fondeokuboMovsBeanList);
	}

	public void setCrwFondeoMovsServicio(
			CRWFondeoMovsServicio crwFondeoMovsServicio) {
		this.crwFondeoMovsServicio = crwFondeoMovsServicio;
	}

}