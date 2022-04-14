	package spei.controlador;

	import java.util.ArrayList;
	import java.util.List;

	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;

	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.AbstractCommandController;

	import spei.bean.AutorizaEnvioSpeiBean;
	import spei.servicio.AutorizaEnvioSpeiServicio;



	public class AutorizaEnvioSpeiGridControlador extends AbstractCommandController{
		
		AutorizaEnvioSpeiServicio autorizaEnvioSpeiServicio = null;

		public AutorizaEnvioSpeiGridControlador() {
			setCommandClass(AutorizaEnvioSpeiBean.class);
			setCommandName("autorizaEnvioSpeiBean");
		}
		
		protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
			AutorizaEnvioSpeiBean pagoRemesaTraspasoBean = (AutorizaEnvioSpeiBean) command;
			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
			List autorizaSpeiList = autorizaEnvioSpeiServicio.lista(tipoLista, pagoRemesaTraspasoBean);
		
			List listaResultado = new ArrayList();
			listaResultado.add(tipoLista);
			listaResultado.add(autorizaSpeiList);
			
			return new ModelAndView("spei/autorizaEnvioSpeiGridVista", "listaResultado", listaResultado);
		
		}

		public AutorizaEnvioSpeiServicio getAutorizaEnvioSpeiServicio() {
			return autorizaEnvioSpeiServicio;
		}

		public void setAutorizaEnvioSpeiServicio(
				AutorizaEnvioSpeiServicio autorizaEnvioSpeiServicio) {
			this.autorizaEnvioSpeiServicio = autorizaEnvioSpeiServicio;
		}

	
	
		

	}

