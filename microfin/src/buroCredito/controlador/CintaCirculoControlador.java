package buroCredito.controlador;

	import general.bean.MensajeTransaccionArchivoBean;
import herramientas.Utileria;

import java.io.File;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.jfree.util.Log;
import org.springframework.validation.BindException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import buroCredito.bean.SolBuroCreditoBean;
import buroCredito.servicio.EnvioCintaCirculoServicio;
import buroCredito.servicio.SolBuroCreditoServicio;
import soporte.bean.TiposDocumentosBean;
import cliente.servicio.ClienteArchivosServicio;
import soporte.servicio.TiposDocumentosServicio;

	import java.util.Date;
import java.util.Random;

	public class CintaCirculoControlador extends SimpleFormController {
		EnvioCintaCirculoServicio envioCintaCirculoServicio = null;
		
	    protected ModelAndView onSubmit(HttpServletRequest request,
	    								HttpServletResponse response,
	    								Object command,
	    								BindException errors) throws ServletException, IOException {
	    	
			SolBuroCreditoBean bean = (SolBuroCreditoBean) command;
		
	        MensajeTransaccionArchivoBean mensaje = null; 
	        
	    	       
	        return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	    
	    }

		

	//---------gettter y setter------------------------------------------------
	    public EnvioCintaCirculoServicio getEnvioCintaCirculoServicio() {
			return envioCintaCirculoServicio;
		}

		public void setEnvioCintaCirculoServicio(
				EnvioCintaCirculoServicio envioCintaCirculoServicio) {
			this.envioCintaCirculoServicio = envioCintaCirculoServicio;
		}
		
	}




		