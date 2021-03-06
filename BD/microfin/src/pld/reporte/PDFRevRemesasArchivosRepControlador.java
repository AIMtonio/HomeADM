package pld.reporte;

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

import general.bean.ParametrosAuditoriaBean;
import herramientas.Utileria;
import pld.bean.RevisionRemesasBean;
import pld.servicio.RevisionRemesasServicio;

public class PDFRevRemesasArchivosRepControlador extends AbstractCommandController{

	String successView = null;
	RevisionRemesasServicio revisionRemesasServicio = null;
	String nombreReporte = null;
	ParametrosAuditoriaBean parametrosAuditoriaBean=null;

	public PDFRevRemesasArchivosRepControlador(){
		setCommandClass(RevisionRemesasBean.class);
 		setCommandName("revision");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		String archivoName = "";
 		int reportePDF	= 3; //Tipo de Consulta para obtener la lista de archivos de Remesas
 		String nombreCliente = request.getParameter("nombreCliente");
 		String nombreUsuarioServicio = request.getParameter("nombreUsuario");

 		RevisionRemesasBean revisionRemesasBean = (RevisionRemesasBean) command;
 		// Llamada a la lista del Reporte de Revisi??n de Remesas
 		archivoName = reporteRevisionRemesasArchivos(revisionRemesasBean,nombreCliente,nombreUsuarioServicio,reportePDF,response);

 		File archivoFile = new File(archivoName);
 		File archivo= new File(reporteRevisionRemesasArchivos(revisionRemesasBean,nombreCliente,nombreUsuarioServicio,reportePDF,response));
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

	// Reporte de Archivos de Revisi??n de Remesas
	public String reporteRevisionRemesasArchivos(RevisionRemesasBean reporteBean, String nombreCliente,String nombreUsuarioServicio,int tipoReporte, HttpServletResponse response) throws FileNotFoundException, DocumentException{
		List<RevisionRemesasBean> revisionRemesasBean = null;

		//Obtenci??n de las variables que se imprimen el el reporte
		String imagenReporte=parametrosAuditoriaBean.getRutaImgReportes();

		String nombreInstitucion = reporteBean.getNombreInstitucion();
		String usuario = reporteBean.getUsuario();

		String nombreReporte = "Reporte Expediente Revisi??n Remesas";
		String remesaFolioID = "Referencia"+reporteBean.getRemesaFolioID();
		String fecha = reporteBean.getFechaEmision();
		String clienteID = reporteBean.getClienteID();
		String usuarioServicioID = reporteBean.getUsuarioServicioID();
		String nombreDelCliente = nombreCliente;
		String nombreDelUsuarioServicio = nombreUsuarioServicio;

		String archivoFile = "";
		String recurso = "";
		int tipoLista =  2;

		revisionRemesasBean = revisionRemesasServicio.listaArchivosRevisionRemesas(tipoLista,reporteBean);
		for(RevisionRemesasBean listaArchivos : revisionRemesasBean ){
			recurso = listaArchivos.getRecurso();
			if(listaArchivos.getOrigenDoc().equals("P")){
				archivoFile = recurso.substring(0, recurso.lastIndexOf(remesaFolioID))+remesaFolioID+"/Expediente"+".pdf";
			}else{
				archivoFile = recurso.substring(0, recurso.lastIndexOf("/"))+"/Expediente"+".pdf";
			}

			break;
		}

		Document document = new Document(PageSize.LETTER , 36, 36, 36, 36);
		PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream(archivoFile));
		Paragraph tipoDocumentoID, descripcion,parrafo,nombreDelReporte,nomCliente,nomUsuarioServicio,parrafoImagen;

        Image imagen =  null; //Variable Imagen para guardar los archivos de tipo imagen

        document.open();

        String extension = "";

        try {

        	RevisionRemesasBean beanRemesas = null;
        	revisionRemesasBean = revisionRemesasServicio.listaArchivosRevisionRemesas(tipoLista,reporteBean);

        	String hora = "";

        	for(RevisionRemesasBean listaArchivos : revisionRemesasBean ){

        		beanRemesas = new RevisionRemesasBean();
 				hora = listaArchivos.getHora();
 			}

        	//Se agrega el logotipo
			if(Utileria.existeArchivo(imagenReporte)){
				imagen = agregarLogoPDF(imagenReporte);
				imagen.setAbsolutePosition(30f, 725f); // para poner el logo en una posici??n especifica
				document.add(imagen);
			}
			//Definici??n de fuentes a utilizar en el reporte
			Font boldFont = new Font(Font.FontFamily.HELVETICA, 10,Font.BOLD); // LETRA EN NEGRITA
			Font fuente = new Font(Font.FontFamily.HELVETICA,10); //
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
 			c2.append(usuario+"\n"); // texto normal
 			c3.append("Fecha: "); // texto negritas
 			c4.append(fecha+"\n"); // texto normal
 			c5.append("Hora: "); // texto negritas
 			c6.append(hora); // texto normal
 			c7.append("Cliente: ");
 			c8.append(clienteID+"     "+nombreDelCliente);
 			c9.append("Usuario Servicio: ");
 			c10.append(usuarioServicioID+"   "+nombreDelUsuarioServicio);

 			phrase1.add(c1); // se agrega a un objeto el texto normal
 			phrase2.add(c2); // se agrega el texto en negrista
 			phrase3.add(c3);
 			phrase4.add(c4);
 			phrase5.add(c5);
 			phrase6.add(c6);
 			phrase7.add(c7);
 			phrase8.add(c8);
 			phrase9.add(c9);
 			phrase10.add(c10);

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

 			nomUsuarioServicio = new Paragraph();
 			nomUsuarioServicio.add(phrase9);
 			nomUsuarioServicio.add(phrase10);
 			nomUsuarioServicio.setAlignment(Element.ALIGN_LEFT);
 			document.add(nomUsuarioServicio);

 			for(RevisionRemesasBean listaArchivos : revisionRemesasBean ){

				Chunk c11 = new Chunk("",boldFont);
		 		Chunk c12 = new Chunk("",fuente);
		 		Chunk c13 = new Chunk("",boldFont);
		 		Chunk c14 = new Chunk("",fuente);
 				Phrase phrase11 = new Phrase();
		 		Phrase phrase12 = new Phrase();
		 		Phrase phrase13 = new Phrase();
		 		Phrase phrase14 = new Phrase();
		 		beanRemesas = new RevisionRemesasBean();
		 		beanRemesas.setRecurso(listaArchivos.getRecurso());


 		       extension = listaArchivos.getRecurso().substring(listaArchivos.getRecurso().lastIndexOf('.'));
 		       extension = extension.toLowerCase();// se convierte la extension a minusculas

				if(extension.equalsIgnoreCase(".jpg")||extension.equalsIgnoreCase(".jpeg")||extension.equalsIgnoreCase(".gif")||extension.equalsIgnoreCase(".png")
						||extension.equalsIgnoreCase(".bmp")||extension.equalsIgnoreCase(".tiff")){


					c11.append("Tipo Documento: ");
					c12.append(listaArchivos.getTipoDocumentoID());
					c13.append("Descripci??n: ");
					c14.append(listaArchivos.getDescripcion());

					phrase11.add(c11);
					phrase12.add(c12);
					phrase13.add(c13);
					phrase14.add(c14);

					tipoDocumentoID = new Paragraph();
					tipoDocumentoID.add(phrase11);
					tipoDocumentoID.add(phrase12);

					descripcion=new Paragraph();
					descripcion.add(phrase13);
					descripcion.add(phrase14);

					tipoDocumentoID.setAlignment(Element.ALIGN_LEFT);
					descripcion.setAlignment(Element.ALIGN_LEFT);
					document.add(tipoDocumentoID);
					document.add(descripcion);

					if(Utileria.existeArchivo(listaArchivos.getRecurso())){
						if(extension.equalsIgnoreCase(".tiff")){
							document.newPage();
							agregaTiffPDF(listaArchivos.getRecurso(),archivoFile,document,writer);
						}else{
							imagen = agregarImagenPDF(document, listaArchivos.getRecurso());
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
					c12.append(listaArchivos.getTipoDocumentoID());
					c13.append("Descripci??n: ");
				    c14.append(listaArchivos.getDescripcion());
					phrase11.add(c11);
			 		phrase12.add(c12);
			 		phrase13.add(c13);
			 		phrase14.add(c14);
			 		tipoDocumentoID = new Paragraph();
			 		tipoDocumentoID.add(phrase11);
			 		tipoDocumentoID.add(phrase12);
			 		descripcion=new Paragraph();
			 		descripcion.add(phrase13);
			 		descripcion.add(phrase14);

			 		tipoDocumentoID.setAlignment(Element.ALIGN_LEFT);
					descripcion.setAlignment(Element.ALIGN_LEFT);
				    document.add(tipoDocumentoID);
					document.add(descripcion);

					document.newPage();

	 				agregarPDF(listaArchivos.getRecurso(),archivoFile,document,writer);}

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
						Rectangle pagesize = reader.getPageSizeWithRotation(i);


						float oWidth = pagesize.getWidth();
			            float oHeight = pagesize.getHeight();
			            float scale = getScale(oWidth, oHeight);
			            float scaledWidth = oWidth * scale;
			            float scaledHeight = oHeight * scale;

						//a??ade las p??ginas al pdf destino
						cb.addTemplate(page, scale, 0, 0, scale, 0, 0);
					}
				}else{
					Font boldFont = new Font(Font.FontFamily.HELVETICA,10,Font.BOLD); // LETRA EN NEGRITA

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
			Font boldFont = new Font(Font.FontFamily.HELVETICA,10,Font.BOLD); // LETRA EN NEGRITA
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

	private static float getScale(float width, float height) {
	    float scaleX = PageSize.LETTER.getWidth() / width;
	    float scaleY = PageSize.LETTER.getHeight() / height;
	    return Math.min(scaleX, scaleY);
	}

	static public Image agregarImagenPDF(Document document, String rutaImagen) throws IOException, BadElementException{
		Image imagen =  null;
		imagen = Image.getInstance(rutaImagen);

		// Se obtiene el ancho y alto de la p??gina considerando los m??rgenes derecho e izquierdo.
		float documentWidth = document.getPageSize().getWidth() - document.leftMargin() - document.rightMargin();
		float documentHeight = document.getPageSize().getHeight() - document.topMargin() - document.bottomMargin();
		// Se ajusta la imagen al ??rea permitida y se centra.
		imagen.scaleToFit(documentWidth, documentHeight);
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

				// Se obtiene el ancho y alto de la p??gina considerando los m??rgenes derecho e izquierdo.
				float documentWidth = document.getPageSize().getWidth() - document.leftMargin() - document.rightMargin();
				float documentHeight = document.getPageSize().getHeight() - document.topMargin() - document.bottomMargin();
				// Se ajusta la imagen al ??rea permitida y se centra.
				image.scaleToFit(documentWidth, documentHeight);
				image.setAlignment(Element.ALIGN_CENTER);

				document.newPage();
				document.add(image);
			}

		} catch (Exception ex) {
			ex.printStackTrace();
		}

	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public RevisionRemesasServicio getRevisionRemesasServicio() {
		return revisionRemesasServicio;
	}

	public void setRevisionRemesasServicio(RevisionRemesasServicio revisionRemesasServicio) {
		this.revisionRemesasServicio = revisionRemesasServicio;
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

}
