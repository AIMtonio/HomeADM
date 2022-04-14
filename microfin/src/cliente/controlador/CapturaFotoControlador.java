package cliente.controlador;

import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import java.io.BufferedInputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.SucursalesBean;
import soporte.bean.TiposDocumentosBean;
import soporte.dao.TiposDocumentosDAO;

import cliente.bean.ClienteArchivosBean;
import cliente.servicio.ClienteArchivosServicio;


public class CapturaFotoControlador extends SimpleFormController{
	ClienteArchivosServicio clienteArchivosServicio = null;
	TiposDocumentosDAO tiposDocumentosDAO = new TiposDocumentosDAO();
	public CapturaFotoControlador(){
 		setCommandClass(ClienteArchivosBean.class);
 		setCommandName("datosCliente");
 	}
			
	protected ModelAndView onSubmit(HttpServletRequest arg0,
										HttpServletResponse response,
										Object command,
										BindException errors) throws Exception {
		
		String recurso ="";
        String directorio ="";
        String cliente ="";
        String archivo="";
       
        ClienteArchivosBean bean = (ClienteArchivosBean) command;

		BufferedInputStream bis = new BufferedInputStream(arg0.getInputStream());
		FileOutputStream fos;
		
		int tipoTransaccion = (arg0.getParameter("tipoTransaccion")!=null)?
						Integer.parseInt(arg0.getParameter("tipoTransaccion")):0; 				
		
					
		cliente = arg0.getParameter("clienteID");
		recurso= arg0.getParameter("recurso");						
		bean.setExtension(".jpg");
		bean.setObservacion(arg0.getParameter("observacion"));	
		
		TiposDocumentosBean tiposDocumentosBean = new TiposDocumentosBean();
		
		String TipoDoc="1";
		tiposDocumentosBean.setTipoDocumentoID(TipoDoc);
		
		System.out.println("Antes de la consulta" +tiposDocumentosBean.getTipoDocumentoID());
		
		tiposDocumentosBean= tiposDocumentosDAO.consultaDescripcion(tiposDocumentosBean,1);
		
		System.out.println("Despues de la consulat" +tiposDocumentosBean.getTipoDocumentoID());
		
		directorio =	recurso+"Clientes/Cliente"+Utileria.completaCerosIzquierda(cliente, 10)+"/";			
		String directorioExists =	recurso+"Clientes/Cliente"+Utileria.completaCerosIzquierda(cliente, 10)+"/"+tiposDocumentosBean.getDescripcion()+"/";
		bean.setRecurso(directorio);
		
		clienteArchivosServicio.getClienteArchivosDAO().getParametrosAuditoriaBean().setNombrePrograma(arg0.getRequestURI().toString());

		
		MensajeTransaccionArchivoBean mensaje = null;  		
 		mensaje = clienteArchivosServicio.grabaTransaccion(tipoTransaccion,bean);
 		archivo = mensaje.getRecursoOrigen();						
			
					
		
		try {							
			boolean exists = (new File(directorioExists)).exists();
			if (!exists) {
				File aDir = new File(directorioExists);
				aDir.mkdirs();
				
			}
			
			fos = new FileOutputStream(new File(archivo));	
			byte[] bs = new byte[1024];
			int len;
	
			while ((len = bis.read(bs, 0, bs.length)) != -1) {
				fos.write(bs, 0, len);
			}
			fos.close();									
			
		} catch (Exception ex){
			ex.printStackTrace();
		}
		bis.close();
		//return null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		 
	}
	
	
//-------------------------setter---------------------
	public void setClienteArchivosServicio(
			ClienteArchivosServicio clienteArchivosServicio) {
		this.clienteArchivosServicio = clienteArchivosServicio;
	}

	public TiposDocumentosDAO getTiposDocumentosDAO() {
		return tiposDocumentosDAO;
	}

	public void setTiposDocumentosDAO(TiposDocumentosDAO tiposDocumentosDAO) {
		this.tiposDocumentosDAO = tiposDocumentosDAO;
	}
	
	
	
}