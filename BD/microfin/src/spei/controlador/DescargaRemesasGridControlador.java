	package spei.controlador;

	import java.util.ArrayList;
	import java.util.List;

	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;

	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.AbstractCommandController;

	import spei.bean.DescargaRemesasBean;
	import spei.servicio.DescargaRemesasServicio;



	public class DescargaRemesasGridControlador extends AbstractCommandController{

		DescargaRemesasServicio descargaRemesasServicio = null;

		public DescargaRemesasGridControlador() {
			setCommandClass(DescargaRemesasBean.class);
			setCommandName("descargaRemesasBean");
		}
		
		protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
			
			DescargaRemesasBean descargaRemesasBean = (DescargaRemesasBean) command;
			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
			List consultaSpeiList = descargaRemesasServicio.lista(tipoLista, descargaRemesasBean);
		
			List listaResultado = new ArrayList();
			listaResultado.add(tipoLista);
			listaResultado.add(consultaSpeiList);
			
			return new ModelAndView("spei/descargaRemesasGridVista", "listaResultado", listaResultado);
		
		}

		public DescargaRemesasServicio getDescargaRemesasServicio() {
			return descargaRemesasServicio;
		}

		public void setDescargaRemesasServicio(
				DescargaRemesasServicio descargaRemesasServicio) {
			this.descargaRemesasServicio = descargaRemesasServicio;
		}

		


		

	}


