package fira.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

import originacion.bean.SolicitudCreditoBean;
import originacion.servicio.SolicitudCreditoServicio;

import fira.bean.MinistracionCredAgroBean;
import fira.servicio.MinistraCredAgroServicio;

public class CredConGarSinFondeoGridControlador extends
SimpleFormController {

	CreditosServicio	creditosServicio	= null;
	
	public CredConGarSinFondeoGridControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		CreditosBean creditosBean = (CreditosBean) command;

		int tipoLista = (request.getParameter("tipoLista")!=null)? Utileria.convierteEntero(request.getParameter("tipoLista")): 0;
		
		List listaResultado = (List)new ArrayList();
		List<CreditosBean> lista = creditosServicio.lista(tipoLista, creditosBean);

		listaResultado.add(lista);
		
		return new ModelAndView(getSuccessView(), "listaResultado", listaResultado);
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	
	
	

}
