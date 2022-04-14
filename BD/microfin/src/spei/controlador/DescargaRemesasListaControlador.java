package spei.controlador;

	 import java.util.ArrayList;
	 import java.util.List;
	 import javax.servlet.http.HttpServletRequest;
	 import javax.servlet.http.HttpServletResponse;

	 import general.bean.MensajeTransaccionBean;

	 import org.springframework.validation.BindException;
	 import org.springframework.web.servlet.ModelAndView;
	 import org.springframework.web.servlet.mvc.AbstractCommandController;

	 import spei.bean.DescargaRemesasBean;
	 import spei.servicio.DescargaRemesasServicio;

	 public class DescargaRemesasListaControlador extends AbstractCommandController {

		 DescargaRemesasServicio descargaRemesasServicio = null;

	 	public DescargaRemesasListaControlador(){
	 		setCommandClass(DescargaRemesasBean.class);
	 		setCommandName("descargaRemesasBean");
	 	}

		protected ModelAndView handle(HttpServletRequest request,
				  HttpServletResponse response,
				  Object command,
				  BindException errors) throws Exception {

	 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	        String controlID = request.getParameter("controlID");
	        
	        DescargaRemesasBean descargaRemesasBean = (DescargaRemesasBean) command;
	                 List pagoremesas = descargaRemesasServicio.lista(tipoLista, descargaRemesasBean);
	                 
	                 List listaResultado = (List)new ArrayList();
	                 listaResultado.add(tipoLista);
	                 listaResultado.add(controlID);
	                 listaResultado.add(pagoremesas);
	 		return new ModelAndView("spei/descargaRemesasListaVista", "listaResultado", listaResultado);
	 	}

		public DescargaRemesasServicio getDescargaRemesasServicio() {
			return descargaRemesasServicio;
		}

		public void setDescargaRemesasServicio(
				DescargaRemesasServicio descargaRemesasServicio) {
			this.descargaRemesasServicio = descargaRemesasServicio;
		}

		

	 	
	 } 

