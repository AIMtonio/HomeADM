package cedes.controlador;

	import java.util.List;

	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;

	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.AbstractCommandController;

	import cedes.bean.CedesArchivosBean;
	import cedes.servicio.CedesFileUploadServicio;

	public class CedesFileUploadGridControlador extends AbstractCommandController {
		CedesFileUploadServicio cedesFileUploadServicio = null;
		

		public CedesFileUploadGridControlador() {
			setCommandClass(CedesArchivosBean.class);
			setCommandName("cuentaArchivo");
		}
			
		protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
					
			CedesArchivosBean cedesArchivos = (CedesArchivosBean) command;
			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
			List ctaArchivoList =	cedesFileUploadServicio.listaArchivosCta(tipoLista, cedesArchivos);
			
			 
					
			return new ModelAndView("cedes/cedesFileUploadGridVista", "cuentaArchivo", ctaArchivoList);
		}
		
		
		public void setCedesFileUploadServicio(CedesFileUploadServicio cedesFileUploadServicio) {
			this.cedesFileUploadServicio = cedesFileUploadServicio;
		}


	}

