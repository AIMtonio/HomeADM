	package tarjetas.controlador;
	
	import general.bean.MensajeTransaccionBean;
	import java.io.BufferedReader;
	import java.io.FileInputStream;
	
	import java.io.IOException;
	import java.io.InputStreamReader;
	
	import javax.servlet.ServletException;
	import javax.servlet.http.HttpServletRequest;
	import javax.servlet.http.HttpServletResponse;
	import org.springframework.validation.BindException;
	import org.springframework.web.servlet.ModelAndView;
	import org.springframework.web.servlet.mvc.SimpleFormController;
	import tarjetas.bean.CargaArchivosTarjetaBean;
	import tarjetas.servicio.CargaArchivosTarjetaServicio;
	
	public class CargaArchivoTransfControlador  extends  SimpleFormController{
		
		CargaArchivosTarjetaServicio cargaArchivosTarjetaServicio = null;
		
		public CargaArchivoTransfControlador(){
	 		setCommandClass(CargaArchivosTarjetaBean.class);
	 		setCommandName("cargaArchivosTarjetaBean");
	 	}
	
		protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws ServletException, IOException  {
			
			CargaArchivosTarjetaBean bean = (CargaArchivosTarjetaBean) command;
			String renglon;
	        cargaArchivosTarjetaServicio.getCargaArchivosTarjetaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
			String ruta = request.getParameter("nombreArchivo");
			int numeroTransaccion =  Integer.valueOf(request.getParameter("numTransaccion"));
			
			MensajeTransaccionBean mensaje = null;
			BufferedReader bufferedReader;	
			
		
			if(tipoTransaccion==1){
				// Archivo txt de compras
				if(bean.getTipoCarga().equalsIgnoreCase("C")){
					bean.setNumTransaccion(numeroTransaccion);
					bufferedReader = new BufferedReader(new InputStreamReader(new FileInputStream(ruta), "ISO-8859-1"));
					while ((renglon = bufferedReader.readLine())!= null && !renglon.trim().equals("")){
						bean.setContenido(renglon);
						mensaje = cargaArchivosTarjetaServicio.grabaTransaccion(2, bean);
					}
					if(mensaje.getNumero() == 0){
						bean.setNumTransaccion(numeroTransaccion);
						mensaje = cargaArchivosTarjetaServicio.grabaTransaccion(3, bean);
					}
				}
				
				// Archivo xlsx de pagos por transferencia
				if(bean.getTipoCarga().equalsIgnoreCase("P")){
				
					mensaje = cargaArchivosTarjetaServicio.grabaTransaccion(CargaArchivosTarjetaServicio.Enum_Tra_CargaArchivo.procesaPagos, bean);
				}
					
				
				
			}
	
	 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
			
		}
	
		public CargaArchivosTarjetaServicio getCargaArchivosTarjetaServicio() {
			return cargaArchivosTarjetaServicio;
		}
	
		public void setCargaArchivosTarjetaServicio(
				CargaArchivosTarjetaServicio cargaArchivosTarjetaServicio) {
			this.cargaArchivosTarjetaServicio = cargaArchivosTarjetaServicio;
		}
		
	}
