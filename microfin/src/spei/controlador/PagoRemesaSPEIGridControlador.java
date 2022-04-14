	package spei.controlador;

	import java.util.ArrayList;
	import java.util.List;

	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;

	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.AbstractCommandController;

	import spei.bean.PagoRemesaSPEIBean;
	import spei.servicio.PagoRemesaSPEIServicio;



	public class PagoRemesaSPEIGridControlador extends AbstractCommandController{
		
		PagoRemesaSPEIServicio pagoRemesaSPEIServicio = null;

		public PagoRemesaSPEIGridControlador() {
			setCommandClass(PagoRemesaSPEIBean.class);
			setCommandName("pagoRemesaSPEIBean");
		}
		
		protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
			PagoRemesaSPEIBean pagoRemesaSPEIBean = (PagoRemesaSPEIBean) command;
			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
			List pagoRemesaList = pagoRemesaSPEIServicio.lista(tipoLista, pagoRemesaSPEIBean);
		
			List listaResultado = new ArrayList();
			listaResultado.add(tipoLista);
			listaResultado.add(pagoRemesaList);
			
			return new ModelAndView("spei/pagoRemesaSPEIGridVista", "listaResultado", listaResultado);
		
		}

		public PagoRemesaSPEIServicio getPagoRemesaSPEIServicio() {
			return pagoRemesaSPEIServicio;
		}

		public void setPagoRemesaSPEIServicio(
				PagoRemesaSPEIServicio pagoRemesaSPEIServicio) {
			this.pagoRemesaSPEIServicio = pagoRemesaSPEIServicio;
		}


	}
