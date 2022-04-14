package crowdfunding.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import crowdfunding.bean.CRWFondeoBean;
import crowdfunding.servicio.CRWFondeoServicio;

public class SaldosYpagosCRWFonGridControlador extends AbstractCommandController {

	CRWFondeoServicio crwFondeoServicio = null;

	public SaldosYpagosCRWFonGridControlador() {
		setCommandClass(CRWFondeoBean.class);
		setCommandName("crwFondeo");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		CRWFondeoBean crwFondeo = (CRWFondeoBean) command;
		crwFondeoServicio.getCrwFondeoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));

		List saldosYpagosInv = crwFondeoServicio.listaGrid(tipoLista, crwFondeo);
		List listaResultado = (List)new ArrayList();
		listaResultado.add(saldosYpagosInv);

		return new ModelAndView("crowdfunding/SaldosYpagosCRWGridVista", "listaResultado", listaResultado);
	}

	public void setCrwFondeoServicio(CRWFondeoServicio crwFondeoServicio) {
		this.crwFondeoServicio = crwFondeoServicio;
	}
}