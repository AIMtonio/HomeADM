package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.ConciliadoPagBean;
import credito.bean.PagosConciliadoBean;
import credito.servicio.CreditosServicio;

public class ConciliadoCobranzaGridControlador extends AbstractCommandController {
	
	CreditosServicio creditosServicio;
	
	public ConciliadoCobranzaGridControlador() {
		setCommandClass(PagosConciliadoBean.class);
		setCommandName("conciliacionCobranzaBean");
	}
	
	@Override
	@SuppressWarnings("unchecked")
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors)throws Exception {
		PagosConciliadoBean pagosConciliadoBean = (PagosConciliadoBean) command;
		
		List<ConciliadoPagBean> beans = creditosServicio.listaPagosConciliadosMov(pagosConciliadoBean);
		
		List<ConciliadoPagBean> beansMovil = new ArrayList<ConciliadoPagBean>();
		List<ConciliadoPagBean> beansSafi = new ArrayList<ConciliadoPagBean>();
		
		for(ConciliadoPagBean bean : beans) {
			if(bean.getOrigenPago().equals("M")) {
				beansMovil.add(bean);
			}else if(bean.getOrigenPago().equals("S")) {
				beansSafi.add(bean);
			}
		}
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.addObject("listaMovil", beansMovil);
		modelAndView.addObject("listaSafi", beansSafi);
		modelAndView.setViewName("credito/conciliadoCobranzaGridVista");
	
		return modelAndView;
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}
	
}
