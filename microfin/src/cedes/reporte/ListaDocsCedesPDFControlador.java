package cedes.reporte;

	import java.io.ByteArrayOutputStream;

	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;

	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.AbstractCommandController;
	import org.springframework.web.servlet.mvc.SimpleFormController;

	import cedes.bean.CheckListCedesBean;
	import cedes.servicio.CheckListCedesServicio;

	public class ListaDocsCedesPDFControlador extends AbstractCommandController{

		CheckListCedesServicio checkListCedesServicio = null;
		String nombreReporte = null;	

	 	public ListaDocsCedesPDFControlador(){
	 		setCommandClass(CheckListCedesBean.class);
	 		setCommandName("checkListCedes");
	 	}
 
	 	protected ModelAndView handle(HttpServletRequest request,
				  HttpServletResponse response,
				  Object command,
				  BindException errors) throws Exception {

	 		CheckListCedesBean checkListCedesBean = (CheckListCedesBean) command;
	 		String cedeID = request.getParameter("cedeID");
	 		String nombreInstitucion = request.getParameter("nombreInstit");
	 		String sucursal = request.getParameter("sucursal");
	 		String fecha = request.getParameter("fecha");
	 		String usuario = request.getParameter("usuario");

	 	
	 		ByteArrayOutputStream htmlString = checkListCedesServicio.reporteArchivosCedesPDF(checkListCedesBean, cedeID, nombreInstitucion, 
	 				sucursal, fecha, usuario, nombreReporte);
	 		
	 		response.addHeader("Content-Disposition","inline; filename=listaDocsCuenta.pdf");
	 		response.setContentType("application/pdf");
	 		byte[] bytes = htmlString.toByteArray();
	 		response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();

	 		return null;
	 	}

		public void setCheckListCedesServicio(CheckListCedesServicio checkListCedesServicio) {
			this.checkListCedesServicio = checkListCedesServicio;
		}

		public void setNombreReporte(String nombreReporte) {
			this.nombreReporte = nombreReporte;
		}
		
	}


