package originacion.reporte;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

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
import com.itextpdf.text.pdf.draw.LineSeparator;

import general.bean.ParametrosAuditoriaBean;
import herramientas.Constantes;
import herramientas.Utileria;
import originacion.bean.SolicitudesArchivoBean;
import originacion.servicio.SolicitudArchivoServicio;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;

public class PDFSolicitudesArchivoRepControlador extends AbstractCommandController {
	
	SolicitudArchivoServicio solicitudArchivoServicio = null;
	ParametrosSisServicio parametrosSisServicio = null;
	String nombreReporte = null;	
	ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	
 	public PDFSolicitudesArchivoRepControlador(){
 		setCommandClass(SolicitudesArchivoBean.class);
 		setCommandName("archivo");
 	} 

	protected ModelAndView handle( HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors ) throws Exception {
 		
 		String archivoName = "";
		SolicitudesArchivoBean solicitudesArchivoBean = (SolicitudesArchivoBean) command; 

 		int reportePDF			= 1; //Tipo de Consulta para obtener la lista de archivos del cliente  
 		String nombreCliente 	= request.getParameter("nombreCliente");
		
 		//llamada a la lista del Reporte Integral del cliente
 		archivoName = repExpSol( solicitudesArchivoBean, nombreCliente, reportePDF, response );
 		File archivoFile = new File( archivoName );
 		File archivo = new File( repExpSol( solicitudesArchivoBean, nombreCliente,
 											reportePDF, response ) );
 		FileInputStream fileInputStream = new FileInputStream( archivo );	
 		
 		response.addHeader( "Content-Disposition", "inline; filename=" + archivoFile );
		response.setContentType( "application/pdf" );
		response.setContentLength( ( int ) archivoFile.length() ); 		
 		
		int bytes;
		while (( bytes = fileInputStream.read() ) != -1 ) {
			response.getOutputStream().write( bytes );
		}

		response.getOutputStream().flush();
		response.getOutputStream().close();
 		 		
		return null;
	}

 	// Función para generar el Reporte de Expediente de Solicitud
	public String repExpSol( SolicitudesArchivoBean reporteBean, String nombreCliente, int tipoLista,
							 HttpServletResponse response 
							) throws FileNotFoundException, DocumentException {
		
		List<SolicitudesArchivoBean> solicitudArchivosBeanList = null;
		
		//Obtención de las variables que se imprimen el el reporte
		String imagenReporte = parametrosAuditoriaBean.getRutaImgReportes();
		
		String nombreInstitucion 	= reporteBean.getNombreInstitucion();
		String nombreUsuario 	 	= reporteBean.getNombreusuario();
		
		String nombreReporte 		= "Expediente de Solicitud de Crédito";
		String Fecha 				= reporteBean.getParFechaEmision();
		String clienteID 			= reporteBean.getClienteID();
		String solicitudCreditoID 	= reporteBean.getSolicitudCreditoID();
		String estatus 				= reporteBean.getEstatus();
		String productoID 			= reporteBean.getProductoCreditoID();
		String productoNombre		= reporteBean.getNombreProducto();
		String grupoID				= reporteBean.getGrupoID();
		String nombreGrupo			= reporteBean.getNombreGrupo();
		String cicloGrupo			= reporteBean.getCiclo();
		String nombreDelCliente 	= nombreCliente;

		String archivoFile	= "";
		String recurso 		= "";
		long valor 			= 0;
		valor = Utileria.convierteLong(solicitudCreditoID);
		
		solicitudArchivosBeanList = solicitudArchivoServicio.listaArchivosSolCredito( tipoLista, reporteBean );
		
		ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		
		parametrosSisBean = parametrosSisServicio.consulta( Enum_Con_ParametrosSis.tipoInstitFin, parametrosSisBean );
		String safilocaleCliente = Utileria.generaLocale( Constantes.CLIENTE_SOCIO, parametrosSisBean.getNombreCortoInst() );
		
		for( SolicitudesArchivoBean listaArchivos : solicitudArchivosBeanList ) {
			recurso = listaArchivos.getRecurso();
				
			archivoFile = recurso.substring(0, recurso.indexOf(solicitudCreditoID)) + 
					valor + 
					"/Expediente" + 
					Utileria.completaCerosIzquierda( valor, 10 ) + 
					".pdf";
			
			break;
		}
 		
		Document document = new Document( PageSize.LETTER , 18, 18, 18, 18 );
		PdfWriter writer = PdfWriter.getInstance( document, new FileOutputStream(archivoFile) );
		
		Paragraph tipoDocumento, observacion,   nombreDelaInstitucion, nombreDelReporte, DSC,
				  parCS,         parrafoImagen, solCreditoEstatus,     Expediente,       usuarioPara,
				  fechaPara,     horaPara,		grupo,                 errorImg;

        Image imagen =  null; //Variable Imagen para guardar los archivos de tipo imagen
        
        document.open();
        
        String extension = "";   

		try {
			
			SolicitudesArchivoBean beanSolArchivos = null;
			solicitudArchivosBeanList = solicitudArchivoServicio.listaArchivosSolCredito( tipoLista, reporteBean );

 			String hora= "";

			hora = Utileria.horaActual();
 			
			//Se agrega el logotipo
			if( Utileria.existeArchivo( imagenReporte ) ) {
				imagen = agregarLogoPDF( imagenReporte );
				imagen.setAbsolutePosition( 30f, 725f ); // para poner el logo en una posición especifica
				document.add( imagen );
			}
			
			//Definición de fuentes a utilizar en el reporte
			Font boldFont = new Font( Font.FontFamily.HELVETICA, 10, Font.BOLD ); // LETRA EN NEGRITA
			Font fuente   = new Font( Font.FontFamily.HELVETICA, 10 );
			
			//Se agrega el nombre de la Institucion
			nombreDelaInstitucion = new Paragraph( nombreInstitucion, boldFont );
			nombreDelaInstitucion.setAlignment( Element.ALIGN_CENTER );
			
			//Se agrega el nombre del Reporte
			nombreDelReporte = new Paragraph( nombreReporte, boldFont );
			nombreDelReporte.setAlignment( Element.ALIGN_CENTER );

			// Se insertan en el documento el nombre de la institución y del reporte
			document.add( nombreDelaInstitucion );
			document.add( nombreDelReporte );
			
 			// Se instancian los objetos del reporte
 			Chunk c1 = new Chunk( "", boldFont ); 	// texto negritas
 			Chunk c2 = new Chunk( "", fuente ); 	// texto normal
 			Chunk c3 = new Chunk( "", boldFont );
 			Chunk c4 = new Chunk( "", fuente ); 
 			Chunk c5 = new Chunk( "", boldFont );
 			Chunk c6 = new Chunk( "", fuente );; 
 			Chunk c7 = new Chunk( "", boldFont );
 			Chunk c8 = new Chunk( "", boldFont );
 			Chunk c9 = new Chunk( "", fuente );
 			Chunk c10 = new Chunk( "", boldFont );
 			Chunk c11 = new Chunk( "", fuente );
 			Chunk c12 = new Chunk( "", boldFont );
 			Chunk c13 = new Chunk( "", fuente );
 			Chunk c14 = new Chunk( "", fuente );
 			Chunk c15 = new Chunk( "", boldFont );
 			Chunk c16 = new Chunk( "", fuente );
 			Chunk c17 = new Chunk( "", fuente );
 			Chunk c18 = new Chunk( "", boldFont );
 			Chunk c19 = new Chunk( "", fuente );
 			Chunk c20 = new Chunk( "", fuente );
 			Chunk c21 = new Chunk( "", boldFont );
 			Chunk c22 = new Chunk( "", fuente );
 			Chunk c23 = new Chunk( "", boldFont );
 			
 			// Se instancian los parrafos del PDF
 			Phrase phrase1 = new Phrase();
 			Phrase phrase2 = new Phrase();
 			Phrase phrase3 = new Phrase();
 			Phrase phrase4 = new Phrase();
 			Phrase phrase5 = new Phrase();
 			Phrase phrase6 = new Phrase();
 			Phrase phrase7 = new Phrase();
 			Phrase phrase8 = new Phrase();
 			Phrase phrase9 = new Phrase();
 			Phrase phrase10 = new Phrase();
 			Phrase phrase11 = new Phrase();
 			Phrase phrase12 = new Phrase();
 			Phrase phrase13 = new Phrase();
 			Phrase phrase14 = new Phrase();
 			Phrase phrase15 = new Phrase();
 			Phrase phrase16 = new Phrase();
 			Phrase phrase17 = new Phrase();
 			Phrase phrase18 = new Phrase();
 			Phrase phrase19 = new Phrase();
 			Phrase phrase20 = new Phrase();
 			Phrase phrase21 = new Phrase();
 			Phrase phrase22 = new Phrase();
 			Phrase phrase23 = new Phrase();
 			
 			LineSeparator line = new LineSeparator(); // Se instancia un subrayado de palabra
 			Chunk linebreak = new Chunk(new LineSeparator()); // Se instancia una linea de separacion 
 			
 			// Se agregan los textos en su respectivo Chunk
 			c1.append( "Usuario: " ); 						
 			c2.append( nombreUsuario + "\n" ); 				
 			c3.append( "Fecha:    " ); 						
 			c4.append( Fecha + "\n"); 						
 			c5.append( "Hora:        "); 					
 			c6.append( hora ); 								
 			
 			c7.append( "Datos de la Solicitud de Crédito");
 			line.setOffset(-2);
 			
 			c8.append( "Solicitud de Crédito: " );
 			c9.append( solicitudCreditoID + "                                                                        ");
 			c10.append( "Estatus:      " );
 			c11.append( estatus + "\n" );
 			
 			c12.append( safilocaleCliente + ":                       " );
 			c13.append( clienteID + "          ");
 			c14.append( nombreDelCliente + "\n" );
 			c15.append( "Producto Crédito:     " );
 			c16.append( productoID + "          ");
 			c17.append( productoNombre );
 			
 			c18.append( "Grupo:                        " );
 			c19.append( grupoID + "          ");
 			c20.append( nombreGrupo + "            " );
 			c21.append( "Ciclo del Grupo:    " );
 			c22.append( cicloGrupo );
 			
 			c23.append( "Expediente" );
 			line.setOffset(-2);
 			
 			// Los chunck se entrelazan a los Phrase 
 			phrase1.add(c1); 
 			phrase2.add(c2); 
 			phrase3.add(c3);
 			phrase4.add(c4);
 			phrase5.add(c5);
 			phrase6.add(c6);
 			phrase7.add(c7);
 			phrase7.add(line);
 			phrase8.add(c8);
 			phrase9.add(c9);
 			phrase10.add(c10);
 			phrase11.add(c11);
 			phrase12.add(c12);
 			phrase13.add(c13);
 			phrase14.add(c14);
 			phrase15.add(c15);
 			phrase16.add(c16);
 			phrase17.add(c17);
 			phrase18.add(c18);
 			phrase19.add(c19);
 			phrase20.add(c20);
 			phrase21.add(c21);
 			phrase22.add(c22); 			
 			phrase23.add(c23);
 			phrase23.add(line);
 			
 			// La Phrase se añade a un Párrafo 
 			usuarioPara = new Paragraph();
 			
 			usuarioPara.add(phrase1);
 			usuarioPara.add(phrase2);
 			usuarioPara.setIndentationLeft(265); // Se le añade una indentación a la izquierda para acomodar el texto
 			usuarioPara.setAlignment(Element.ALIGN_CENTER); // Se alinea el parrafo
 			
 			document.add(usuarioPara); // Se añade al PDF parrafo
 			
 			fechaPara = new Paragraph();
 			
 			fechaPara.add(phrase3);
 			fechaPara.add(phrase4);
 			fechaPara.setIndentationLeft(270);
 			fechaPara.setAlignment(Element.ALIGN_CENTER);
 			
 			document.add(fechaPara);
 			
 			horaPara = new Paragraph();
 			
 			horaPara.add(phrase5);
 			horaPara.add(phrase6);
 			horaPara.setIndentationLeft(265);
 			horaPara.setAlignment(Element.ALIGN_CENTER);
 			
 			document.add(horaPara);

 			DSC = new Paragraph();
 			
 			DSC.add(phrase7);
 			DSC.setAlignment(Element.ALIGN_LEFT);
 			
 			document.add(DSC);
 			
 			solCreditoEstatus = new Paragraph();
 			
 			solCreditoEstatus.add(phrase8);
 			solCreditoEstatus.add(phrase9);
 			solCreditoEstatus.add(phrase10);
 			solCreditoEstatus.add(phrase11);
 			solCreditoEstatus.setAlignment(Element.ALIGN_LEFT);
 			
 			document.add(solCreditoEstatus);
 			
 			parCS = new Paragraph();

 			parCS.add(phrase12);
 			parCS.add(phrase13);
 			parCS.add(phrase14);
 			parCS.add(phrase15);
 			parCS.add(phrase16);
 			parCS.add(phrase17);
 			parCS.setAlignment(Element.ALIGN_LEFT);
 			
 			document.add(parCS);
 			
 			// Validación para que aparezca la sección de grupo en el reporte.
 			int grupoBandera = Integer.parseInt( grupoID );
 			if ( grupoBandera != 0 ) {
 				grupo = new Paragraph();
 				
 				grupo.add(phrase18);
 				grupo.add(phrase19);
 				grupo.add(phrase20);
 				grupo.add(phrase21);
 				grupo.add(phrase22);
 	 			
 				document.add(grupo);
 	 			
 				// Se Agregan un espacio en blanco
 	 	        document.add( Chunk.NEWLINE );
 			} else {
 				// Se Agregan espacios en blanco
 	 	        document.add( Chunk.NEWLINE );
 	 	        document.add( Chunk.NEWLINE );
 			}
 			
 			Expediente = new Paragraph();
 	       
 			document.add(linebreak); // Se añade una linea de separación en el PDF
 			
 			Expediente.add(phrase23);
 			Expediente.setAlignment(Element.ALIGN_LEFT);
 			
 			document.add(Expediente);
 		
 			for( SolicitudesArchivoBean listaArchivos : solicitudArchivosBeanList ) {
 				
				Chunk c24 = new Chunk("",boldFont);
		 		Chunk c25 = new Chunk("",fuente);
		 		Chunk c26 = new Chunk("",boldFont);
		 		Chunk c27 = new Chunk("",fuente);
				Phrase phrase24 = new Phrase();
		 		Phrase phrase25 = new Phrase();
		 		Phrase phrase26 = new Phrase();
		 		Phrase phrase27 = new Phrase();
		 		beanSolArchivos = new SolicitudesArchivoBean();
		 		beanSolArchivos.setRecurso( listaArchivos.getRecurso() );

		        extension = listaArchivos.getRecurso().substring(listaArchivos.getRecurso().lastIndexOf('.'));
		        extension = extension.toLowerCase();// se convierte la extension a minusculas

		        // Se valida la extencion del archivo
				if(extension.equalsIgnoreCase(".jpg")||extension.equalsIgnoreCase(".jpeg")||extension.equalsIgnoreCase(".gif")||extension.equalsIgnoreCase(".png")
						||extension.equalsIgnoreCase(".bmp")||extension.equalsIgnoreCase(".tiff")){

	 				c24.append( "Tipo Documento: " );
					c25.append( listaArchivos.getDescripcion() );
					c26.append( "Observación:        " );
				    c27.append( listaArchivos.getComentario() );

					phrase24.add(c24);
					phrase25.add(c25);
					phrase26.add(c26);
					phrase27.add(c27);

					tipoDocumento = new Paragraph();
					tipoDocumento.add(phrase24);
					tipoDocumento.add(phrase25);

					observacion=new Paragraph();
					observacion.add(phrase26);
					observacion.add(phrase27);

					tipoDocumento.setAlignment(Element.ALIGN_LEFT);
					observacion.setAlignment(Element.ALIGN_LEFT);
					document.add(tipoDocumento);
					document.add(observacion);

					// Se valida si existe el archivo
					if( Utileria.existeArchivo( listaArchivos.getRecurso() ) ) {
						// Se verifica la extencion de la imagen y se añade dependiendo de esta.
						if( extension.equalsIgnoreCase( ".tiff" ) ) {
							
							document.newPage();
							agregaTiffPDF( listaArchivos.getRecurso(),archivoFile,document,writer );
							
						} else {
							
							imagen = agregarImagenPDF(document, listaArchivos.getRecurso());
							imagen.setIndentationLeft(100);
							document.add(imagen);
							document.add(linebreak);
							
						}

					} else {
						// En caso de no encontrar la imagen aparece un texto de que no la pudo encontrar
						Chunk c28 = new Chunk( "", boldFont );
				 		Chunk c29 = new Chunk( "", fuente );
						Phrase phrase28 = new Phrase();
				 		Phrase phrase29= new Phrase();
						
				 		c28.append( "Información:         " );
						c29.append( "No se Pudo Localizar la Imagen." );

						phrase28.add(c28);
						phrase29.add(c29);

						errorImg = new Paragraph();
						errorImg.add(phrase28);
						errorImg.add(phrase29);
						errorImg.setAlignment(Element.ALIGN_LEFT);
						
						document.add(errorImg);
						document.add(linebreak);
						
					}
				} else{
					// Validacion para verificar que sea un PDF
					if( extension.equals( ".pdf" ) ) {
	 				
		 				c24.append("Tipo Documento: ");
						c25.append( listaArchivos.getDescripcion() );
						c26.append("Observación:        ");
					    c27.append( listaArchivos.getComentario() );
						phrase24.add(c24);
				 		phrase25.add(c25);
				 		phrase26.add(c26);
				 		phrase27.add(c27);
					    tipoDocumento = new Paragraph();
						tipoDocumento.add(phrase24);
						tipoDocumento.add(phrase25);
						observacion=new Paragraph();
						observacion.add(phrase26);
						observacion.add(phrase27);
						
						tipoDocumento.setAlignment(Element.ALIGN_LEFT);
						observacion.setAlignment(Element.ALIGN_LEFT);
					    document.add(tipoDocumento);
						document.add(observacion);
		 			   
						document.newPage();
		 			    
						// Funcion que añade el archivo PDF al reporte
		 				agregarPDF(listaArchivos.getRecurso(),archivoFile,document,writer);
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
						//Importa la páginas del pdf de origen
						PdfImportedPage page = writer.getImportedPage(reader, i);
						Rectangle pagesize = reader.getPageSizeWithRotation(i);
						
						
						float oWidth = pagesize.getWidth();
			            float oHeight = pagesize.getHeight();
			            float scale = getScale(oWidth, oHeight);
			            float scaledWidth = oWidth * scale;
			            float scaledHeight = oHeight * scale;

						//añade las páginas al pdf destino
						cb.addTemplate(page, scale, 0, 0, scale, 0, 0);
					}
				}else{
					Font boldFont = new Font(Font.FontFamily.HELVETICA,10,Font.BOLD); // LETRA EN NEGRITA

					Chunk info = new Chunk("Información: ",boldFont);
					Chunk encriptado = new Chunk("No es Posible Manipular el Archivo PDF Consultelo de Forma Individual.");
					Phrase phraseNoExiste = new Phrase(); // se agrega a un objeto el texto normal
					Paragraph parrafoPdfEncryp = new Paragraph();
					phraseNoExiste.add(info + "        ");
					phraseNoExiste.add(encriptado);
					parrafoPdfEncryp.add(phraseNoExiste);
					document.add(parrafoPdfEncryp);
					break;
				}
			}
		}catch(BadPasswordException ex){
			Font boldFont = new Font(Font.FontFamily.HELVETICA,10,Font.BOLD); // LETRA EN NEGRITA
			Chunk info = new Chunk("Información: ",boldFont);
			Chunk encriptado = new Chunk("No es Posible Manipular el Archivo PDF Consultelo de Forma Individual .");
			Phrase phraseNoExiste = new Phrase(); // se agrega a un objeto el texto normal
			Paragraph parrafoPdfEncryp = new Paragraph();
			phraseNoExiste.add(info);
			phraseNoExiste.add(encriptado);
			parrafoPdfEncryp.add(phraseNoExiste);
			document.add(parrafoPdfEncryp);
		}


	}
	
	private static float getScale(float width, float height) {
	    float scaleX = PageSize.LETTER.getWidth() / width;
	    float scaleY = PageSize.LETTER.getHeight() / height;
	    return Math.min(scaleX, scaleY);
	}
	
	static public Image agregarImagenPDF(Document document, String rutaImagen) throws IOException, BadElementException{
		Image imagen =  null;
		imagen = Image.getInstance(rutaImagen);
		
		// Se obtiene el ancho y alto de la página considerando los márgenes derecho e izquierdo.
		float documentWidth = document.getPageSize().getWidth() - document.leftMargin() - document.rightMargin();
		float documentHeight = document.getPageSize().getHeight() - document.topMargin() - document.bottomMargin();
		// Se ajusta la imagen al área permitida y se centra.
		imagen.scaleToFit(documentWidth/4, documentHeight/4);
		imagen.setAlignment(Element.ALIGN_LEFT);

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

		imagen.scalePercent(20, 20);

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
				
				// Se obtiene el ancho y alto de la página considerando los márgenes derecho e izquierdo.
				float documentWidth = document.getPageSize().getWidth() - document.leftMargin() - document.rightMargin();
				float documentHeight = document.getPageSize().getHeight() - document.topMargin() - document.bottomMargin();
				// Se ajusta la imagen al área permitida y se centra.
				image.scaleToFit(documentWidth, documentHeight);
				image.setAlignment(Element.ALIGN_CENTER);

				document.newPage();
				document.add(image);
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}

	}
	
	public SolicitudArchivoServicio getSolicitudArchivoServicio() {
		return solicitudArchivoServicio;
	}

	public void setSolicitudArchivoServicio(
			SolicitudArchivoServicio solicitudArchivoServicio) {
		this.solicitudArchivoServicio = solicitudArchivoServicio;
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

	public void setParametrosAuditoriaBean(ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
	
	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
}