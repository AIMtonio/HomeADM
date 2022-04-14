package fira.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import fira.bean.MinistracionCredAgroBean;
import fira.servicio.MinistraCredAgroServicio;

public class MinistraCredAgroGridControlador extends SimpleFormController {

	MinistraCredAgroServicio ministraCredAgroServicio;
	
	public MinistraCredAgroGridControlador() {
		setCommandClass(MinistracionCredAgroBean.class);
		setCommandName("ministracionCredAgroBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MinistracionCredAgroBean ministracionCredAgroBean = (MinistracionCredAgroBean) command;
		int tipoLista = Utileria.convierteEntero(ministracionCredAgroBean.getTipoLista());
		String esLineaCreditoAgro = (request.getParameter("esLineaCreditoAgro")!=null) ? request.getParameter("esLineaCreditoAgro") : "";
		
		List listaResultado = (List)new ArrayList();
		List<MinistracionCredAgroBean> lista = ministraCredAgroServicio.lista(tipoLista, ministracionCredAgroBean);
		listaResultado.add(lista);
		listaResultado.add(ministracionCredAgroBean.getFechaPagoMinis());
		listaResultado.add(tipoLista);
		listaResultado.add(esLineaCreditoAgro);
		return new ModelAndView(getSuccessView(), "listaResultado", listaResultado);
	}

	public MinistraCredAgroServicio getMinistraCredAgroServicio() {
		return ministraCredAgroServicio;
	}

	public void setMinistraCredAgroServicio(MinistraCredAgroServicio ministraCredAgroServicio) {
		this.ministraCredAgroServicio = ministraCredAgroServicio;
	}

}