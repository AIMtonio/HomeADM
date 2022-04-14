package pld.controlador;

import herramientas.Utileria;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.PaisesGAFIPLDBean;
import pld.servicio.PaisesGAFIPLDServicio;

public class PaisesGAFIGridControlador extends SimpleFormController {

	PaisesGAFIPLDServicio paisesGAFIPLDServicio;
	
	public PaisesGAFIGridControlador() {
		setCommandClass(PaisesGAFIPLDBean.class);
		setCommandName("paisesGAFIPLDBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		PaisesGAFIPLDBean paisesBean = (PaisesGAFIPLDBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		List<PaisesGAFIPLDBean> lista = paisesGAFIPLDServicio.lista(tipoLista, paisesBean);
		return new ModelAndView(getSuccessView(), "listaResultado", lista);
	}

	public PaisesGAFIPLDServicio getPaisesGAFIPLDServicio() {
		return paisesGAFIPLDServicio;
	}

	public void setPaisesGAFIPLDServicio(PaisesGAFIPLDServicio paisesGAFIPLDServicio) {
		this.paisesGAFIPLDServicio = paisesGAFIPLDServicio;
	}

}