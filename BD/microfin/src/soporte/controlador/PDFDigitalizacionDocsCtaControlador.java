package soporte.controlador;

import general.bean.ParametrosAuditoriaBean;
import general.bean.ParametrosSesionBean;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import com.itextpdf.text.BadElementException;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.exceptions.BadPasswordException;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfImportedPage;
import com.itextpdf.text.pdf.PdfReader;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.RandomAccessFileOrArray;
import com.itextpdf.text.pdf.codec.TiffImage;



import soporte.bean.CuentaArchivosBean;
import soporte.servicio.FileUploadServicio;
import cliente.bean.ClienteBean;
import cliente.servicio.ClienteArchivosServicio;
import cliente.servicio.ClienteServicio;

public class PDFDigitalizacionDocsCtaControlador  extends AbstractCommandController{
	
	String successView = null;
	FileUploadServicio cuentaArchivosServicio = null;		  
	String nombreReporte = null;	
	ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	ClienteServicio clienteServicio = null;
	
	public PDFDigitalizacionDocsCtaControlador() {
		setCommandClass(CuentaArchivosBean.class);
 		setCommandName("cuentaArchivosBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		String archivoName="";
 		
 		
 		String nombreCortoInst = request.getParameter("nombreCorto");
 		CuentaArchivosBean reporteBean = (CuentaArchivosBean) command;
 		
 		
 		//llamada a la lista del Reporte Integral del cliente
 		
 		
 		archivoName = reporteClienteArchivos(reporteBean,nombreCortoInst,response);
 	
 		 File archivoFile = new File(archivoName);
 		 File archivo= new File(archivoName);
 		 FileInputStream fileInputStream = new FileInputStream(archivo);	
 		
 		
 		
 		response.addHeader("Content-Disposition","inline; filename="+archivoFile);
		response.setContentType("application/pdf");
		response.setContentLength((int) archivoFile.length()); 		
 		int bytes;
		while ((bytes = fileInputStream.read()) != -1) {
			response.getOutputStream().write(bytes);
		}

		response.getOutputStream().flush();
		response.getOutputStream().close();
 		 		
		return null;
	}

	private String reporteClienteArchivos(CuentaArchivosBean reporteBean,
			String nombreCortoInst,
			HttpServletResponse response) throws FileNotFoundException, DocumentException{

		List<CuentaArchivosBean> cuentaArchivosBean = null;
		
		
		//Obtenci??n de las variables que se imprimen el el reporte
		Locale currentLocale;
		ResourceBundle messages;
		
        currentLocale = new Locale(clienteServicio.getClienteDAO().getParametrosSesionBean().getNomCortoInstitucion());
        messages = ResourceBundle.getBundle("messages", currentLocale);
        
		String imagenReporte=parametrosAuditoriaBean.getRutaImgReportes();
		String nombreInstitucion=reporteBean.getNombreInstitucion();
		String nombreUsuario=reporteBean.getUsuario();
		
		String nombreReporte="Reporte Expediente de Cuentas";
		String Fecha=reporteBean.getFechaActual();
		
		Calendar calendario = new GregorianCalendar();
		String archivoFile ="";
		String recurso ="";
		
		//obtener el cliente
		ClienteBean cliente = null;
		cliente = clienteServicio.consulta(ClienteServicio.Enum_Con_Cliente.foranea , reporteBean.getClienteID(), "");
		ClienteBean prospecto = null;
		prospecto = clienteServicio.consulta(ClienteServicio.Enum_Con_Cliente.prospecClien , reporteBean.getClienteID(), "");
		
		cuentaArchivosBean = cuentaArchivosServicio.listaArchivosCta(FileUploadServicio.Enum_Lis_File.archivosCuentas, reporteBean);
			recurso =cuentaArchivosBean.get(0).getRecurso();
			archivoFile =recurso.substring(0, recurso.lastIndexOf(reporteBean.getCuentaAhoID()));
			
			if(!Utileria.existeArchivo(archivoFile)){
				File archivo= new File(archivoFile);
				archivo.mkdirs();
			}
			
			archivoFile+="/Expediente"+reporteBean.getCuentaAhoID()+".pdf";
			
			
		Document document = new Document(PageSize.LETTER , 36, 36, 36, 36);
		PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream(archivoFile));
        Paragraph tipoDocumento, observacion,parrafo,nombreDelReporte,nomCliente,nomProspecto,parrafo2,parrafoImagen,parrafoPdf;
       
        Image imagen =  null; //Variable Imagen para guardar los archivos de tipo imagen
        
        document.open();
        
        
        String extension = "";   
		try {
			CuentaArchivosBean beanClientes = null;
 			
 			String hora=calendario.get(Calendar.HOUR_OF_DAY)+":"+calendario.get(Calendar.MINUTE)+":"+calendario.get(Calendar.SECOND);
 			
 			//Se agrega el logotipo
 			if(Utileria.existeArchivo(imagenReporte)){
 			imagen = agregarLogoPDF(imagenReporte);
 			imagen.setAbsolutePosition(30f, 725f); // para poner el logo en una posici??n especifica
 			document.add(imagen);
 			}
 			//Definici??n de fuentes a utilizar en el reporte
 			Font boldFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD); // LETRA EN NEGRITA
 			Font fuente = new Font(Font.FontFamily.HELVETICA,10);
 			
 			//Se agrega el nombre de la Institucion
 			parrafo = new Paragraph( nombreInstitucion, boldFont);
 			parrafo.setAlignment(Element.ALIGN_CENTER);
 			//Se agrega el nombre del Reporte
 			nombreDelReporte=new Paragraph(nombreReporte,fuente);
 			nombreDelReporte.setAlignment(Element.ALIGN_CENTER);
 			
 			document.add(parrafo);
 			document.add(nombreDelReporte);
 		
 			
 			// Se instancian los objetos para usuario, fecha  hora, cliente y prospecto que forman el encabezado del reporte
 			Chunk c1 = new Chunk("",boldFont); // texto negritas
 			Chunk c2 = new Chunk("",fuente); // texto normal
 			Chunk c3 = new Chunk("",boldFont); // texto negritas
 			Chunk c4 = new Chunk("",fuente); 
 			Chunk c5 = new Chunk("",boldFont); // texto negritas
 			Chunk c6 = new Chunk("",fuente);; 
 			Chunk c7 = new Chunk("",boldFont); //}
 			Chunk c8 = new Chunk("",fuente);
 			Chunk c9 = new Chunk("",boldFont);// texto normal
 			Chunk c10 = new Chunk("",fuente);
 			
 			Phrase phrase1 = new Phrase(); // se agrega a un objeto el texto normal
 			Phrase phrase2 = new Phrase(); // se agrega el texto en negrista
 			Phrase phrase3 = new Phrase();
 			Phrase phrase4 = new Phrase();
 			Phrase phrase5 = new Phrase();
 			Phrase phrase6 = new Phrase();
 			Phrase phrase7 = new Phrase();
 			Phrase phrase8 = new Phrase();
 			Phrase phrase9 = new Phrase();
 			Phrase phrase10 = new Phrase();
 			
 			parrafo = new Paragraph(); // se crea el nuevo parrafo
 			//Se agrega el nombre del usuario
 			c1.append("Usuario: "); // texto negritas
 			c2.append(nombreUsuario+"\n"); // texto normal
 			c3.append("Fecha: "); // texto negritas
 			c4.append(Fecha+"\n"); // texto normal
 			c5.append("Hora: "); // texto negritas
 			c6.append(hora); // texto normal
 			c7.append(messages.getString("safilocale.cliente")+": ");
 			c8.append(cliente.getNumero()+"     "+cliente.getNombreCompleto());
 			
 			
 			
 			phrase1.add(c1); // se agrega a un objeto el texto normal
 			phrase2.add(c2); // se agrega el texto en negrista
 			phrase3.add(c3);
 			phrase4.add(c4);
 			phrase5.add(c5);
 			phrase6.add(c6);
 			phrase7.add(c7);
 			phrase8.add(c8);
 			
 			
 			parrafo.add(phrase1);
 			parrafo.add(phrase2);
 			parrafo.add(phrase3);
 			parrafo.add(phrase4);
 			parrafo.add(phrase5);
 			parrafo.add(phrase6);
 			parrafo.setAlignment(Element.ALIGN_RIGHT);
 			
 			document.add(parrafo);
 			  
 			
 			nomCliente = new Paragraph();
 			nomCliente.add(phrase7);
 			nomCliente.add(phrase8);
 			nomCliente.setAlignment(Element.ALIGN_LEFT);
 			document.add(nomCliente);
 			
 			if(prospecto!= null){
 				c9.append("Prospecto: ");
 	 			c10.append(prospecto.getNumero()+"   "+cliente.getNombreCompleto());
 	 			phrase9.add(c9);
 	 			phrase10.add(c10);
 			
 	 			nomProspecto = new Paragraph();
 	 			nomProspecto.add(phrase9);
 	 			nomProspecto.add(phrase10); 	
 	 			nomProspecto.setAlignment(Element.ALIGN_LEFT);
 	 			document.add(nomProspecto);
 			}
 			
 			Chunk salto1 = new Chunk("",fuente);
 			salto1.append("\n");
 			Phrase phraseSalto1 = new Phrase();
 			phraseSalto1.add(salto1);
 			parrafo2 = new Paragraph();
 			parrafo2.add(phraseSalto1);
 			document.add(parrafo2);
 		
            
 			
 			for(CuentaArchivosBean listaArchivos : cuentaArchivosBean ){
 				
				Chunk c11 = new Chunk("",boldFont);
		 		Chunk c12 = new Chunk("",fuente);
		 		Chunk c13 = new Chunk("",boldFont);
		 		Chunk c14 = new Chunk("",fuente);
 				Phrase phrase11 = new Phrase();
		 		Phrase phrase12 = new Phrase();
		 		Phrase phrase13 = new Phrase();
		 		Phrase phrase14 = new Phrase();
 				beanClientes = new CuentaArchivosBean();
 				beanClientes.setRecurso(listaArchivos.getRecurso());

 		      
 		       extension = listaArchivos.getRecurso().substring(listaArchivos.getRecurso().lastIndexOf('.'));
 		       
 		       extension = extension.toLowerCase();// se convierte la extension a minusculas
 		       
				if(extension.equalsIgnoreCase(".jpg")||extension.equalsIgnoreCase(".jpeg")||extension.equalsIgnoreCase(".gif")||extension.equalsIgnoreCase(".png")
				   ||extension.equalsIgnoreCase(".bmp")||extension.equalsIgnoreCase(".tiff")){
					
		 			
					  c11.append("Tipo Documento: ");
					  c12.append(listaArchivos.getTipoDocumento());
					  c13.append("Observaci??n: ");
					  c14.append(listaArchivos.getObservacion());
					  
					  phrase11.add(c11);
			 		  phrase12.add(c12);
			 		  phrase13.add(c13);
			 		  phrase14.add(c14);
					 
			 		  tipoDocumento = new Paragraph();
					  tipoDocumento.add(phrase11);
					  tipoDocumento.add(phrase12);
					  
					  observacion=new Paragraph();
					  observacion.add(phrase13);
					  observacion.add(phrase14);
					
					  tipoDocumento.setAlignment(Element.ALIGN_LEFT);
					  observacion.setAlignment(Element.ALIGN_LEFT);
					  document.add(tipoDocumento);
					  document.add(observacion);
					 if(Utileria.existeArchivo(listaArchivos.getRecurso())){
						 if(extension.equalsIgnoreCase(".tiff")){
							  document.newPage();
							  agregaTiffPDF(listaArchivos.getRecurso(),archivoFile,document,writer);
						  }else{
			 		      imagen = agregarImagenPDF(listaArchivos.getRecurso());
				 		  document.add(imagen);
				 		  }
			 		  }else{
			 			 Chunk info = new Chunk("Informaci??n: ",boldFont);
			 			 Chunk noExisteImagen = new Chunk("No se Pudo Localizar la Imagen.");
			  			 Phrase phraseNoExiste = new Phrase(); // se agrega a un objeto el texto normal
			  			 parrafoImagen = new Paragraph();
			  			phraseNoExiste.add(info); 
			  			phraseNoExiste.add(noExisteImagen);
			  			parrafoImagen.add(phraseNoExiste);
			  			document.add(parrafoImagen);
			  			
			 		  }
				}
				
				else{
					if(extension.equals(".pdf")){
	 				
	 				c11.append("Tipo Documento: ");
					c12.append(listaArchivos.getTipoDocumento());
					c13.append("Observaci??n: ");
				    c14.append(listaArchivos.getObservacion());
					phrase11.add(c11);
			 		phrase12.add(c12);
			 		phrase13.add(c13);
			 		phrase14.add(c14);
				    tipoDocumento = new Paragraph();
					tipoDocumento.add(phrase11);
					tipoDocumento.add(phrase12);
					observacion=new Paragraph();
					observacion.add(phrase13);
					observacion.add(phrase14);
					
					tipoDocumento.setAlignment(Element.ALIGN_LEFT);
					observacion.setAlignment(Element.ALIGN_LEFT);
				    document.add(tipoDocumento);
					document.add(observacion);
	 			   
					if(Utileria.existeArchivo(listaArchivos.getRecurso())){
					document.newPage();	
	 				agregarPDF(listaArchivos.getRecurso(),archivoFile,document,writer);
	 				}else{
	 					 Chunk info = new Chunk("Informaci??n: ",boldFont);
						 Chunk noExisteImagen = new Chunk("No se Pudo Localizar el Archivo.");
			  			 Phrase phraseNoExiste = new Phrase(); // se agrega a un objeto el texto normal
			  			 parrafoImagen = new Paragraph();
			  			phraseNoExiste.add(info); 
			  			phraseNoExiste.add(noExisteImagen);
			  			parrafoImagen.add(phraseNoExiste);
			  			document.add(parrafoImagen);
			  			
					}
					}
					
				}
				
 		        document.newPage();   
 			}
 			document.newPage();
 	        document.close();

			
		} catch (Exception e) {
			e.printStackTrace();
		}		
		
		
		return archivoFile;
	
	}
	static public  void agregarPDF(String rutaPDF1, String filename, Document document, PdfWriter writer) throws DocumentException, IOException{
	       
		try{
        List<InputStream> list = new ArrayList<InputStream>();
        list.add(new FileInputStream(new File(rutaPDF1)));
        document.open();
        
        PdfContentByte cb = writer.getDirectContent();
        
        for (InputStream in : list) {
            PdfReader reader = new PdfReader(in);
            if(!reader.isEncrypted() && reader.isOpenedWithFullPermissions()){
            	
            	for (int i = 1; i <= reader.getNumberOfPages(); i++) {
            	
            		document.newPage();
            		//Importa la p??ginas del pdf de origen
            		PdfImportedPage page = writer.getImportedPage(reader, i);
            		
            		//a??ade las p??ginas al pdf destino
            		cb.addTemplate(page, 0, 0);

            	}
           }else{
        	  Font boldFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD); // LETRA EN NEGRITA
        	  Chunk info = new Chunk("Informaci??n: ",boldFont);
	 		  Chunk encriptado = new Chunk("No es Posible Manipular el Archivo PDF Consultelo de Forma Individual.");
	  		  Phrase phraseNoExiste = new Phrase(); // se agrega a un objeto el texto normal
	  		Paragraph parrafoPdfEncryp = new Paragraph();
	  			phraseNoExiste.add(info); 
	  			phraseNoExiste.add(encriptado);
	  			parrafoPdfEncryp.add(phraseNoExiste);
	  			document.add(parrafoPdfEncryp);
	  			break;
           }
        }      
		}catch(BadPasswordException ex){
			
			Font boldFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD); // LETRA EN NEGRITA
			Chunk info = new Chunk("Informaci??n: ",boldFont);
	 		  Chunk encriptado = new Chunk("No es Posible Manipular el Archivo PDF Consultelo de Forma Individual .");
	  		  Phrase phraseNoExiste = new Phrase(); // se agrega a un objeto el texto normal
	  		Paragraph parrafoPdfEncryp = new Paragraph();
	  			phraseNoExiste.add(info); 
	  			phraseNoExiste.add(encriptado);
	  			parrafoPdfEncryp.add(phraseNoExiste);
	  			document.add(parrafoPdfEncryp);
		}
 
        
    }
    
    static public Image agregarImagenPDF(String rutaImagen) throws IOException, BadElementException{
	  Image imagen =  null;
      float alturaImg = 0;
      float por = 0;
      float porcen = 0;
      imagen = Image.getInstance(rutaImagen);    
      alturaImg = (float) imagen.getWidth();
      por = alturaImg / 450;
      porcen = 100 /por;
     
      if(alturaImg>600){ /* Se ajusta a un tama??o apropiado*/
          imagen.scalePercent(porcen,porcen);
      }else{
          imagen.scalePercent(90, 90);
      }
      imagen.setAlignment(Element.ALIGN_CENTER);
           
      return imagen;      
    }
    
    static public Image agregarLogoPDF(String rutaImagen) throws IOException, BadElementException{
    	  Image imagen =  null;
          float alturaImg = 0;
          float por = 0;
          float porcen = 0;
       
          
          imagen = Image.getInstance(rutaImagen);    
          alturaImg = (float) imagen.getWidth();
          por = alturaImg / 450;
          porcen = 100 /por;

          imagen.scalePercent(30, 30);
          imagen.setAlignment(Element.ALIGN_CENTER);
               
          return imagen;      
        }
    
    public void agregaTiffPDF(String tifPath, String pdfPath, Document document, PdfWriter writer) {
        File pdfFile = null;
        String imgeFilename = tifPath;
        try {
          
            writer.setStrictImageSequence(true);
            Image image;
            document.open();
            RandomAccessFileOrArray ra = new RandomAccessFileOrArray(imgeFilename);
            int pagesTif = TiffImage.getNumberOfPages(ra);
          
            for (int i = 1; i <= pagesTif; i++) {
                image = TiffImage.getTiffImage(ra, i);
              
                float alturaImg = 0;
                float por = 0;
                float porcen = 0;
                alturaImg = (float) image.getWidth();
                por = alturaImg / 450;
                porcen = 100 /por;
                
                if(alturaImg>600){ /* Se ajusta a un tama??o apropiado*/
                    image.scalePercent(porcen,porcen);
                }else{
                    image.scalePercent(90, 90);
                }
                
                image.setAlignment(Element.ALIGN_CENTER);
                
                document.newPage();
                document.add(image);
                
            }
           
        } catch (Exception ex) {
            
        	
        	ex.printStackTrace();
        }
  
    }
    
	public FileUploadServicio getCuentaArchivosServicio() {
		return cuentaArchivosServicio;
	}
	
	public void setCuentaArchivosServicio(
			FileUploadServicio cuentaArchivosServicio) {
		this.cuentaArchivosServicio = cuentaArchivosServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

    public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}

	public ClienteServicio getClienteServicio() {
		return clienteServicio;
	}

	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}
	

}
