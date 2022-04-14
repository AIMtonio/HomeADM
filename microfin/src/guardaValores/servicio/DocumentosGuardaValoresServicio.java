package guardaValores.servicio;

import java.util.ArrayList;
import java.util.List;

import java.io.ByteArrayOutputStream;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import guardaValores.bean.DocumentosGuardaValoresBean;
import guardaValores.dao.DocumentosGuardaValoresDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import reporte.ParametrosReporte;
import reporte.Reporte;


public class DocumentosGuardaValoresServicio extends BaseServicio {

	DocumentosGuardaValoresDAO documentosGuardaValoresDAO = null;

	// Transacciones de Documentos
	public static interface Enum_Tran_Documento {
		int registroDocumentos	= 1;
		int asignaUbicacion		= 2;
		int estatusPrestamo 	= 3;
		int estatusDevolucion	= 4;
		int estatusSustitucion	= 5;
		int estatusBaja			= 6;
	}

	// Transacciones de Estatus de Documento
	public static interface Enum_Act_Documento {
		int asignaUbicacion	  	 = 1;
		int prestamoDocumento 	 = 2;
		int devolucionDocumento  = 3;
		int sustitucionDocumento = 4;
		int bajaDocumento 		 = 5;
	}

	// Validacion de Autorización de Operaciones de Documento
	public static interface Enum_Val_Documento {
		int autorizacionOperacion = 6;
		int autorizacionSustitucionBaja = 7;
	}

	// Validacion de Prestamo de Documento
	public static interface Enum_Tran_PrestamoDocumento {
		int prestamoDocumento = 1;
	}
	
	// Consultas de Expediente
	public static interface Enum_Con_Expediente {
		int con_principal = 1;
		int con_foranea   = 2;
		int con_validaExpediente = 3;
	}

	// Consulta de Documentos
	public static interface Enum_Con_Documento {
		int con_principal   	  = 1;
		int con_asignaUbicacion   = 2;
		int con_prestamoDocumento = 3;
		int con_registro 		  = 4;
		int con_validaCheck 	  = 5;
	}
	
	// Consulta de Prestamo
	public static interface Enum_Con_Prestamo {
		int con_principal   = 1;
	}
	
	// Lista de Expediente 
	public static interface Enum_Lis_Expediente {
		int lista_principal	 	= 1;
		int lista_foranea 		= 2;
		int lista_expediente 	= 4;
	}
	
	// Lista no invocadas en BD
	public static interface Enum_Lis_GridExpediente {
		int lista_RegistroExpediente = 1;
		int lista_Cliente			 = 2;
		int lista_Cuenta			 = 3;
		int lista_Cede				 = 4;
		int lista_Inversion			 = 5;
		int lista_SolicitudCredito	 = 6;
		int lista_Credito			 = 7;
		int lista_Prospecto			 = 8;
		int lista_Aportacion		 = 9;
	}
	
	// Listas de Documentos
	public static interface Enum_Lis_Documento {
		int lista_principal			= 1;
		int lista_asignaUbicacion 	= 2;
		int lista_prestamoDocumento = 3;
		int lista_registro 			= 4;
	}

	// Reportes en Documento Excel
	public static interface Enum_Rep_DocumentosExcel {
		int reporteIngresoDocumentos  = 1;
		int reporteEstatusDocumentos  = 2;
	}

	// Reportes Bitacora Documento Excel
	public static interface Enum_Rep_BitacoraExcel {
		int reporteBitacoraDocumentos = 1;
	}
	
	// Reportes en Documento Excel
	public static interface Enum_Rep_PrestamoDocumentosExcel {
		int reportePrestamoDocumentos = 1;
	}

	// Reportes en Documento PDF
	public static interface Enum_Rep_DocumentosPDF {
		int reporteIngresoDocumentos  = 1;
		int reporteEstatusDocumentos  = 2;
		int reportePrestamoDocumentos = 3;
		int reporteExpediente 		  = 4;
	}

	// Transacciones
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, DocumentosGuardaValoresBean documentosGuardaValoresBean ) {

		MensajeTransaccionBean mensajeTransaccionBean = null;
		List listaDocumentos = null;
		try{
			switch (tipoTransaccion) {
				case Enum_Tran_Documento.registroDocumentos:
					mensajeTransaccionBean = new MensajeTransaccionBean();
					listaDocumentos = crearRegistroDocumento(documentosGuardaValoresBean);
					mensajeTransaccionBean = documentosGuardaValoresDAO.altaDocumentosGuardaValores(documentosGuardaValoresBean, listaDocumentos);
				break;
				case Enum_Tran_Documento.asignaUbicacion:
					mensajeTransaccionBean = new MensajeTransaccionBean();
					mensajeTransaccionBean = documentosGuardaValoresDAO.asignaUbicacionGuardaValores(documentosGuardaValoresBean, Enum_Act_Documento.asignaUbicacion);
				break;
				case Enum_Tran_Documento.estatusPrestamo:
					mensajeTransaccionBean = new MensajeTransaccionBean();
					mensajeTransaccionBean = documentosGuardaValoresDAO.prestamoDocumento(documentosGuardaValoresBean);
				break;
				case Enum_Tran_Documento.estatusDevolucion:
					mensajeTransaccionBean = new MensajeTransaccionBean();
					mensajeTransaccionBean = documentosGuardaValoresDAO.devolucionDocumento(documentosGuardaValoresBean);
				break;
				case Enum_Tran_Documento.estatusSustitucion:
					mensajeTransaccionBean = new MensajeTransaccionBean();
					mensajeTransaccionBean = documentosGuardaValoresDAO.sustitucionDocumento(documentosGuardaValoresBean);
				break;
				case Enum_Tran_Documento.estatusBaja:
					mensajeTransaccionBean = new MensajeTransaccionBean();
					mensajeTransaccionBean = documentosGuardaValoresDAO.bajaDocumento(documentosGuardaValoresBean);
				break;
				default:
					mensajeTransaccionBean = new MensajeTransaccionBean();
					mensajeTransaccionBean.setNumero(999);
					mensajeTransaccionBean.setDescripcion("Tipo de Transaccion desconocida.");
				break;
			}
		} catch(Exception exception){
			if(mensajeTransaccionBean == null){
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean.setNumero(999);
				mensajeTransaccionBean.setDescripcion("Ha ocurrido un Error al Grabar la Transaccion");
			}
			loggerSAFI.error(mensajeTransaccionBean.getDescripcion(), exception);
			exception.printStackTrace();
		}
		return mensajeTransaccionBean;
	}

	// Consultas de Expedientes
	public DocumentosGuardaValoresBean consultaExpediente(int tipoConsulta, DocumentosGuardaValoresBean documentosGuardaValoresBean) {

		DocumentosGuardaValoresBean documentos = null;
		try{
			switch(tipoConsulta){
				case Enum_Con_Expediente.con_principal:
					documentos = documentosGuardaValoresDAO.consultaPrincipalExpediente(documentosGuardaValoresBean, tipoConsulta);
				break;
				case Enum_Con_Expediente.con_foranea:
					documentos = documentosGuardaValoresDAO.consultaForaneaExpediente(documentosGuardaValoresBean, tipoConsulta);
				break;
				case Enum_Con_Expediente.con_validaExpediente:
					documentos = documentosGuardaValoresDAO.consultaForaneaExpediente(documentosGuardaValoresBean, tipoConsulta);
				break;
				default:
					documentos = null;
				break;
			}

		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Consulta de Documentos Guarda Valores", exception);
			exception.printStackTrace();
		}
		return documentos;
	}

	// Lista de ayuda de safi
	public List<DocumentosGuardaValoresBean> listaExpediente(int tipoLista, DocumentosGuardaValoresBean documentosGuardaValoresBean) {

		List<DocumentosGuardaValoresBean> listaDocumentos = null;
		try{
			switch(tipoLista){
				case Enum_Lis_Expediente.lista_principal:
					listaDocumentos = documentosGuardaValoresDAO.listaPrincipalExpediente(documentosGuardaValoresBean, tipoLista);
				break;
				case Enum_Lis_Expediente.lista_foranea:
					listaDocumentos = documentosGuardaValoresDAO.listaExpedienteForanea(documentosGuardaValoresBean, tipoLista);
				break;
				default:
					listaDocumentos = null;
				break;
			}
		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Lista de Expediente Guarda Valores ", exception);
			exception.printStackTrace();
		}
		return listaDocumentos;
	}
	
	// Lista de Grid para Expedientes
	public List<DocumentosGuardaValoresBean> listaExpedienteGrid(int tipoLista, int tipoReporte, DocumentosGuardaValoresBean documentosGuardaValoresBean) {

		List<DocumentosGuardaValoresBean> listaDocumentos = null;
		try{				
			switch(tipoLista){
				case Enum_Lis_GridExpediente.lista_RegistroExpediente:
					listaDocumentos = documentosGuardaValoresDAO.listaRegistroExpediente(documentosGuardaValoresBean, Enum_Lis_Expediente.lista_expediente);
				break;
				case Enum_Lis_GridExpediente.lista_Cliente:
				case Enum_Lis_GridExpediente.lista_Cuenta:
				case Enum_Lis_GridExpediente.lista_Cede:
				case Enum_Lis_GridExpediente.lista_Inversion:
				case Enum_Lis_GridExpediente.lista_SolicitudCredito:
				case Enum_Lis_GridExpediente.lista_Credito:
				case Enum_Lis_GridExpediente.lista_Prospecto:
				case Enum_Lis_GridExpediente.lista_Aportacion:
					listaDocumentos = documentosGuardaValoresDAO.listaExpediente(documentosGuardaValoresBean, tipoReporte);
				break;
				default:
					listaDocumentos = null;
				break;
			}
		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Lista paginada Expedientes Guarda Valores ", exception);
			exception.printStackTrace();
		}
		return listaDocumentos;
	}

	// Consulta de Documentos
	public DocumentosGuardaValoresBean consultaDocumento(int tipoConsulta, DocumentosGuardaValoresBean documentosGuardaValoresBean) {

		DocumentosGuardaValoresBean documentos = null;
		try{
			switch(tipoConsulta){
				case Enum_Con_Documento.con_principal:
					documentos = documentosGuardaValoresDAO.consultaPrincipalDocumento(documentosGuardaValoresBean, tipoConsulta);
				break;
				case Enum_Con_Documento.con_asignaUbicacion:
					documentos = documentosGuardaValoresDAO.consultaForanea(documentosGuardaValoresBean, tipoConsulta);
				break;
				case Enum_Con_Documento.con_prestamoDocumento:
					documentos = documentosGuardaValoresDAO.consultaForanea(documentosGuardaValoresBean, tipoConsulta);
				break;
				case Enum_Con_Documento.con_registro:
					documentos = documentosGuardaValoresDAO.consultaRegistroDocumento(documentosGuardaValoresBean, Enum_Con_Documento.con_principal);
				break;
				case Enum_Con_Documento.con_validaCheck:
					documentos = documentosGuardaValoresDAO.consultaRegistroDocumento(documentosGuardaValoresBean, Enum_Con_Documento.con_asignaUbicacion);
				break;
				default:
					documentos = null;
				break;
			}

		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Consulta de Documentos Guarda Valores", exception);
			exception.printStackTrace();
		}
		return documentos;
	}

	// Consulta de Prestamo de Documento
	public DocumentosGuardaValoresBean consultaPrestamoDocumento(int tipoConsulta, DocumentosGuardaValoresBean documentosGuardaValoresBean) {

		DocumentosGuardaValoresBean documentos = null;
		try{
			switch(tipoConsulta){
				case Enum_Con_Documento.con_principal:
					documentos = documentosGuardaValoresDAO.consultaPrincipalPrestamoDocumento(documentosGuardaValoresBean, tipoConsulta);
				break;
				default:
					documentos = null;
				break;
			}

		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Consulta de Documentos Guarda Valores", exception);
			exception.printStackTrace();
		}
		return documentos;
	}
	
	// Lista de Documentos
	public List<DocumentosGuardaValoresBean> listaDocumento(int tipoLista, DocumentosGuardaValoresBean documentosGuardaValoresBean) {

		List<DocumentosGuardaValoresBean> listaDocumentos = null;
		try{
			switch(tipoLista){
				case Enum_Lis_Documento.lista_principal:
					listaDocumentos = documentosGuardaValoresDAO.listaPrincipalDocumentos(documentosGuardaValoresBean, tipoLista);
				break;
				case Enum_Lis_Documento.lista_asignaUbicacion:
					listaDocumentos = documentosGuardaValoresDAO.listaPantalla(documentosGuardaValoresBean, tipoLista);
				break;
				case Enum_Lis_Documento.lista_prestamoDocumento:
					listaDocumentos = documentosGuardaValoresDAO.listaPantalla(documentosGuardaValoresBean, tipoLista);
				break;
				case Enum_Lis_Documento.lista_registro:
					listaDocumentos = documentosGuardaValoresDAO.listaRegistroDocumento(documentosGuardaValoresBean, Enum_Lis_Documento.lista_asignaUbicacion);
				break;
				default:
					listaDocumentos = null;
				break;
			}
		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Lista de Documentos Guarda Valores ", exception);
			exception.printStackTrace();
		}
		return listaDocumentos;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista,DocumentosGuardaValoresBean documentosGuardaValoresBean) {
		List listaInstrumentos = null;
		try{
			switch(tipoLista){
				case Enum_Lis_Documento.lista_principal: 
					listaInstrumentos = documentosGuardaValoresDAO.listaRegistroDocumento(documentosGuardaValoresBean, tipoLista);
				break;
				case Enum_Lis_Documento.lista_registro: 
					listaInstrumentos = documentosGuardaValoresDAO.listaRegistroDocumento(documentosGuardaValoresBean, Enum_Lis_Documento.lista_principal);
				break;
			}
			
		}catch(Exception exception){
			loggerSAFI.error("Ha ocurrido un Error al realizar la Lista de Combo Documentos de Pantalla Guarda Valores ", exception);
			exception.printStackTrace();
		}
		return listaInstrumentos.toArray();		
	}
	
	// Lista de Documentos a Registrar
	public List<DocumentosGuardaValoresBean> crearRegistroDocumento(DocumentosGuardaValoresBean documentosGuardaValoresBean) {
		ArrayList listaDocumentos = null;
		DocumentosGuardaValoresBean documentosGuardaValores = null;
		int tamanio = 0;
		try{

			List<String> listaOrigenDocumento  = documentosGuardaValoresBean.getListaOrigenDocumento();
			List<String> listaGrupoDocumentoID = documentosGuardaValoresBean.getListaGrupoDocumentoID();
			List<String> listaTipoDocumentoID  = documentosGuardaValoresBean.getListaTipoDocumentoID();
			List<String> listaNombreDocumento  = documentosGuardaValoresBean.getListaNombreDocumento();
			List<String> listaArchivoID  	   = documentosGuardaValoresBean.getListaArchivoID();

			listaDocumentos = new ArrayList();

			if(listaOrigenDocumento != null){

				tamanio = listaOrigenDocumento.size();
				for (int iteracion = 0; iteracion < tamanio; iteracion++) {

					documentosGuardaValores = new DocumentosGuardaValoresBean();
					documentosGuardaValores.setOrigenDocumento(listaOrigenDocumento.get(iteracion));
					documentosGuardaValores.setGrupoDocumentoID(listaGrupoDocumentoID.get(iteracion));
					documentosGuardaValores.setTipoDocumentoID(listaTipoDocumentoID.get(iteracion));
					documentosGuardaValores.setNombreDocumento(listaNombreDocumento.get(iteracion));
					documentosGuardaValores.setSucursalID(documentosGuardaValoresBean.getSucursalID());
					documentosGuardaValores.setNumeroInstrumento(documentosGuardaValoresBean.getNumeroInstrumento());
					documentosGuardaValores.setTipoInstrumento(documentosGuardaValoresBean.getTipoInstrumento());
					documentosGuardaValores.setArchivoID(listaArchivoID.get(iteracion));
					listaDocumentos.add(documentosGuardaValores);
				}
			}
		} catch(Exception exception){
			loggerSAFI.error("Ha ocurrido en la creacion de la lista de Documentos a Reguardo de Guarda Valores ", exception);
			exception.printStackTrace();
			listaDocumentos = null;
		}
		return listaDocumentos;
	}

	// Reporte Ingreso de Documentos en Excel
	public void reporteIngresoDocumentosExcel( DocumentosGuardaValoresBean documentosGuardaValoresBean, HttpServletResponse response) {

		List<DocumentosGuardaValoresBean> listaDocumentos = null;
		String nombreArchivo = "";

		try{

			nombreArchivo = "IngresoDocumentos.xls";
			listaDocumentos = documentosGuardaValoresDAO.reporteIngresoDocumentos(documentosGuardaValoresBean, Enum_Rep_DocumentosExcel.reporteIngresoDocumentos);
			XSSFWorkbook libro = new XSSFWorkbook();

			//Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFCellStyle estiloTitulo = Utileria.crearFuente(libro, 10, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para cabeceras del reporte.
			XSSFCellStyle estiloCabecera = Utileria.crearFuente(libro, 10, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para los Parametros del reporte.
			XSSFCellStyle estiloParametros = Utileria.crearFuente(libro, 10, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFCellStyle estiloTexto = Utileria.crearFuente(libro, 10, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_NOBOLD);

			//Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFCellStyle estiloTextoCentrado = Utileria.crearFuente(libro, 10, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_NOBOLD);

			// Creacion de hoja
			XSSFSheet hoja = libro.createSheet("REPORTE_INGRESO_DOCUMENTOS");
			XSSFRow fila= hoja.createRow(0);

			// Nombre Institucion y Usuario
			fila = hoja.createRow(1);
			XSSFCell celdaInstitucion=fila.createCell((short)1);
			celdaInstitucion.setCellStyle(estiloTitulo);
			celdaInstitucion.setCellValue(documentosGuardaValoresBean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(1, 1, 1, 6));

			celdaInstitucion = fila.createCell((short)7);
			celdaInstitucion.setCellValue("Usuario:");
			celdaInstitucion.setCellStyle(estiloParametros);
			celdaInstitucion = fila.createCell((short)8);
			celdaInstitucion.setCellValue((!documentosGuardaValoresBean.getNombreUsuario().isEmpty())?documentosGuardaValoresBean.getNombreUsuario(): "TODOS");
			celdaInstitucion.setCellStyle(estiloTexto);

			String horaReporte  = documentosGuardaValoresBean.getHoraEmision();
			String fechaReporte = documentosGuardaValoresBean.getFechaEmision();

			// Titulo del Reporte y Fecha
			fila = hoja.createRow(2);
			XSSFCell celdaTitulo = fila.createCell((short)1);
			celdaTitulo.setCellStyle(estiloTitulo);
			celdaTitulo.setCellValue("REPORTE INGRESO DOCUMENTOS" );
			hoja.addMergedRegion(new CellRangeAddress(2, 2, 1, 6));

			celdaTitulo = fila.createCell((short)7);
			celdaTitulo.setCellValue("Fecha:");
			celdaTitulo.setCellStyle(estiloParametros);
			celdaTitulo = fila.createCell((short)8);
			celdaTitulo.setCellValue(fechaReporte);
			celdaTitulo.setCellStyle(estiloTexto);

			// Rango de Fechas del Reporte y hora
			fila = hoja.createRow(3);
			XSSFCell celdaRangoFecha = fila.createCell((short)1);
			celdaRangoFecha.setCellStyle(estiloTitulo);
			celdaRangoFecha.setCellValue(documentosGuardaValoresBean.getRangoFechas());
			hoja.addMergedRegion(new CellRangeAddress(3, 3, 1, 6));

			celdaRangoFecha = fila.createCell((short)7);
			celdaRangoFecha.setCellValue("Hora:");
			celdaRangoFecha.setCellStyle(estiloParametros);
			celdaRangoFecha = fila.createCell((short)8);
			celdaRangoFecha.setCellValue(horaReporte);
			celdaRangoFecha.setCellStyle(estiloTexto);

			fila = hoja.createRow(4);
			fila = hoja.createRow(5);

			XSSFCell celdaParametros = fila.createCell((short)1);
			celdaParametros = fila.createCell((short)1);
			celdaParametros.setCellValue("Sucursal:");
			celdaParametros.setCellStyle(estiloParametros);
			celdaParametros = fila.createCell((short)2);
			celdaParametros.setCellValue(documentosGuardaValoresBean.getNombreSucursal());
			celdaParametros.setCellStyle(estiloTexto);

			celdaParametros = fila.createCell((short)5);
			celdaParametros.setCellValue("Almacén:");
			celdaParametros.setCellStyle(estiloParametros);
			celdaParametros = fila.createCell((short)6);
			celdaParametros.setCellValue(documentosGuardaValoresBean.getNombreAlmacen());
			celdaParametros.setCellStyle(estiloTexto);

			fila = hoja.createRow(6);
			fila = hoja.createRow(7);

			XSSFCell celdaEncabezados = fila.createCell((short)1);

			celdaEncabezados = fila.createCell((short)1);
			celdaEncabezados.setCellValue("Número de Documento");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)2);
			celdaEncabezados.setCellValue("Nombre");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)3);
			celdaEncabezados.setCellValue("Tipo Canal");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)4);
			celdaEncabezados.setCellValue("Número Instrumento");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)5);
			celdaEncabezados.setCellValue("Documento");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)6);
			celdaEncabezados.setCellValue("Almacén");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)7);
			celdaEncabezados.setCellValue("Ubicación");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)8);
			celdaEncabezados.setCellValue("Usuario Registró");
			celdaEncabezados.setCellStyle(estiloCabecera);

			int renglon = 8;
			int iteracion = 0;
			int numRegistros = 0;
			int tamanioLista = listaDocumentos.size();
			DocumentosGuardaValoresBean documentos = null;


			for( iteracion =0; iteracion <tamanioLista; iteracion  ++){

				documentos = (DocumentosGuardaValoresBean) listaDocumentos.get(iteracion );

				fila=hoja.createRow(renglon);
				XSSFCell celdaCuerpo = fila.createCell((short)1);

				celdaCuerpo=fila.createCell((short)1);
				celdaCuerpo.setCellValue(documentos.getDocumentoID());
				celdaCuerpo.setCellStyle(estiloTextoCentrado);

				celdaCuerpo=fila.createCell((short)2);
				celdaCuerpo.setCellValue(documentos.getNombreParticipante());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)3);
				celdaCuerpo.setCellValue(documentos.getTipoInstrumento());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)4);
				celdaCuerpo.setCellValue(documentos.getNumeroInstrumento());
				celdaCuerpo.setCellStyle(estiloTextoCentrado);

				celdaCuerpo=fila.createCell((short)5);
				celdaCuerpo.setCellValue(documentos.getNombreDocumento());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)6);
				celdaCuerpo.setCellValue(documentos.getNombreAlmacen());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)7);
				celdaCuerpo.setCellValue(documentos.getUbicacion());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)8);
				celdaCuerpo.setCellValue(documentos.getNombreUsuarioRegistroID());

				renglon++;
				numRegistros = numRegistros+1;
			}

			renglon = renglon + 1;
			fila = hoja.createRow(renglon);
			XSSFCell celdaPiePagina = fila.createCell((short)1);
			celdaPiePagina = fila.createCell((short)0);
			celdaPiePagina.setCellValue("Registros Exportados");
			celdaPiePagina.setCellStyle(estiloParametros);

			renglon = renglon + 1;
			fila = hoja.createRow(renglon);
			celdaPiePagina = fila.createCell((short)0);
			celdaPiePagina.setCellValue(numRegistros);
			celdaPiePagina.setCellStyle(estiloTexto);

			for(int celdaAjustar = 0; celdaAjustar <= 8; celdaAjustar++){
				hoja.autoSizeColumn((short)celdaAjustar);
			}

			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename="+nombreArchivo);
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();

		} catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.info("Error al crear el reporte Ingreso de Documentos en Guarda Valores: " + exception);
		}
	}

	// Reporte Estatus de Documentos en Excel
	public void reporteEstatusDocumentosExcel( DocumentosGuardaValoresBean documentosGuardaValoresBean, HttpServletResponse response) {

		List<DocumentosGuardaValoresBean> bitacoraDocumentos = null;
		String nombreArchivo = "";

		try{

			nombreArchivo = "EstatusDocumentos.xls";
			bitacoraDocumentos = documentosGuardaValoresDAO.reporteEstatusDocumentos(documentosGuardaValoresBean, Enum_Rep_DocumentosExcel.reporteEstatusDocumentos);
			XSSFWorkbook libro = new XSSFWorkbook();

			//Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFCellStyle estiloTitulo = (XSSFCellStyle) Utileria.crearFuente(libro, 10, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para cabeceras del reporte.
			XSSFCellStyle estiloCabecera = (XSSFCellStyle) Utileria.crearFuente(libro, 10, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para los Parametros del reporte.
			XSSFCellStyle estiloParametros = (XSSFCellStyle) Utileria.crearFuente(libro, 10, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFCellStyle estiloTexto = (XSSFCellStyle) Utileria.crearFuente(libro, 10, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_NOBOLD);

			//Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFCellStyle estiloTextoDerecha = (XSSFCellStyle) Utileria.crearFuente(libro, 10, Constantes.FUENTE_DERECHA, Constantes.FUENTE_NOBOLD);

			//Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFCellStyle estiloTextoCentrado = (XSSFCellStyle) Utileria.crearFuente(libro, 10, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_NOBOLD);

			// Creacion de hoja
			XSSFSheet hoja = libro.createSheet("REPORTE_ESTATUS_DOCUMENTO");
			XSSFRow fila= hoja.createRow(0);

			// Nombre Institucion y Usuario
			fila = hoja.createRow(1);
			XSSFCell celdaInstitucion=fila.createCell((short)1);
			celdaInstitucion.setCellStyle(estiloTitulo);
			celdaInstitucion.setCellValue(documentosGuardaValoresBean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(1, 1, 1, 8));

			celdaInstitucion = fila.createCell((short)9);
			celdaInstitucion.setCellValue("Usuario:");
			celdaInstitucion.setCellStyle(estiloParametros);
			celdaInstitucion = fila.createCell((short)10);
			celdaInstitucion.setCellValue((!documentosGuardaValoresBean.getNombreUsuario().isEmpty())?documentosGuardaValoresBean.getNombreUsuario(): "TODOS");
			celdaInstitucion.setCellStyle(estiloTexto);

			String horaReporte  = documentosGuardaValoresBean.getHoraEmision();
			String fechaReporte = documentosGuardaValoresBean.getFechaEmision();

			// Titulo del Reporte y Fecha
			fila = hoja.createRow(2);
			XSSFCell celdaTitulo = fila.createCell((short)1);
			celdaTitulo.setCellValue("REPORTE DOCUMENTOS POR ESTATUS");
			celdaTitulo.setCellStyle(estiloTitulo);
			hoja.addMergedRegion(new CellRangeAddress(2, 2, 1, 8));

			celdaTitulo = fila.createCell((short)9);
			celdaTitulo.setCellValue("Fecha:");
			celdaTitulo.setCellStyle(estiloParametros);
			celdaTitulo = fila.createCell((short)10);
			celdaTitulo.setCellValue(fechaReporte);
			celdaTitulo.setCellStyle(estiloTexto);

			// Rango de Fechas del Reporte y hora
			fila = hoja.createRow(3);
			XSSFCell celdaRangoReporte = fila.createCell((short)1);
			celdaRangoReporte.setCellValue(documentosGuardaValoresBean.getRangoFechas());
			celdaRangoReporte.setCellStyle(estiloTitulo);
			hoja.addMergedRegion(new CellRangeAddress(3, 3, 1, 8));

			celdaRangoReporte = fila.createCell((short)9);
			celdaRangoReporte.setCellValue("Hora:");
			celdaRangoReporte.setCellStyle(estiloParametros);
			celdaRangoReporte = fila.createCell((short)10);
			celdaRangoReporte.setCellValue(horaReporte);
			celdaRangoReporte.setCellStyle(estiloTexto);

			fila = hoja.createRow(4);
			fila = hoja.createRow(5);

			XSSFCell celdaParametros = fila.createCell((short)1);
			celdaParametros = fila.createCell((short)1);
			celdaParametros.setCellValue("Sucursal:");
			celdaParametros.setCellStyle(estiloParametros);
			celdaParametros = fila.createCell((short)2);
			celdaParametros.setCellValue(documentosGuardaValoresBean.getNombreSucursal());
			celdaParametros.setCellStyle(estiloTexto);

			celdaParametros = fila.createCell((short)4);
			celdaParametros.setCellValue("Almacén:");
			celdaParametros.setCellStyle(estiloParametros);
			celdaParametros = fila.createCell((short)5);
			celdaParametros.setCellValue(documentosGuardaValoresBean.getNombreAlmacen());
			celdaParametros.setCellStyle(estiloTexto);

			celdaParametros = fila.createCell((short)7);
			celdaParametros.setCellValue("Estatus:");
			celdaParametros.setCellStyle(estiloParametros);
			celdaParametros = fila.createCell((short)8);
			celdaParametros.setCellValue(documentosGuardaValoresBean.getDescripcionEstatus());
			celdaParametros.setCellStyle(estiloTexto);

			fila = hoja.createRow(6);
			fila = hoja.createRow(7);
			XSSFCell celdaEncabezados = fila.createCell((short)1);

			celdaEncabezados = fila.createCell((short)1);
			celdaEncabezados.setCellValue("No. Documento");
			celdaEncabezados.setCellStyle(estiloTextoDerecha);

			celdaEncabezados = fila.createCell((short)2);
			celdaEncabezados.setCellValue("Nombre");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)3);
			celdaEncabezados.setCellValue("Tipo Canal");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)4);
			celdaEncabezados.setCellValue("No. Instrumento");
			celdaEncabezados.setCellStyle(estiloTextoDerecha);

			celdaEncabezados = fila.createCell((short)5);
			celdaEncabezados.setCellValue("Documento");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)6);
			celdaEncabezados.setCellValue("Almacén");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)7);
			celdaEncabezados.setCellValue("Ubicación");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)8);
			celdaEncabezados.setCellValue("Usuario Registro");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)9);
			celdaEncabezados.setCellValue("Estatus");
			celdaEncabezados.setCellStyle(estiloCabecera);
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)10);
			celdaEncabezados.setCellValue("Motivo");
			celdaEncabezados.setCellStyle(estiloCabecera);


			int renglon = 8;
			int iteracion = 0;
			int numRegistros = 0;
			int tamanioLista = bitacoraDocumentos.size();
			DocumentosGuardaValoresBean documentos = null;

			for( iteracion =0; iteracion <tamanioLista; iteracion  ++){

				documentos = (DocumentosGuardaValoresBean) bitacoraDocumentos.get(iteracion );
				fila=hoja.createRow(renglon);
				XSSFCell celdaCuerpo = fila.createCell((short)1);

				celdaCuerpo=fila.createCell((short)1);
				celdaCuerpo.setCellValue(documentos.getDocumentoID());
				celdaCuerpo.setCellStyle(estiloTextoCentrado);

				celdaCuerpo=fila.createCell((short)2);
				celdaCuerpo.setCellValue(documentos.getNombreParticipante());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)3);
				celdaCuerpo.setCellValue(documentos.getTipoInstrumento());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)4);
				celdaCuerpo.setCellValue(documentos.getNumeroInstrumento());
				celdaCuerpo.setCellStyle(estiloTextoCentrado);

				celdaCuerpo=fila.createCell((short)5);
				celdaCuerpo.setCellValue(documentos.getNombreDocumento());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)6);
				celdaCuerpo.setCellValue(documentos.getNombreAlmacen());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)7);
				celdaCuerpo.setCellValue(documentos.getUbicacion());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)8);
				celdaCuerpo.setCellValue(documentos.getNombreUsuarioRegistroID());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)9);
				celdaCuerpo.setCellValue(documentos.getEstatus());
				celdaCuerpo.setCellStyle(estiloTextoCentrado);

				celdaCuerpo=fila.createCell((short)10);
				celdaCuerpo.setCellValue(documentos.getObservaciones());
				celdaCuerpo.setCellStyle(estiloTexto);

				renglon++;
				numRegistros = numRegistros+1;
			}

			renglon = renglon + 1;
			fila = hoja.createRow(renglon);
			XSSFCell celdaPiePagina = fila.createCell((short)1);
			celdaPiePagina = fila.createCell((short)0);
			celdaPiePagina.setCellValue("Registros Exportados");
			celdaPiePagina.setCellStyle(estiloParametros);

			renglon = renglon + 1;
			fila = hoja.createRow(renglon);
			celdaPiePagina = fila.createCell((short)0);
			celdaPiePagina.setCellValue(numRegistros);
			celdaPiePagina.setCellStyle(estiloTexto);

			for(int celdaAjustar=0; celdaAjustar <= 10; celdaAjustar++){
				hoja.autoSizeColumn((short)celdaAjustar);
			}

			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=" + nombreArchivo);
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();


		} catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.info("Error al crear el reporte de Documentos por Estatus en Guarda Valores " + exception);
		}

	}

	// Reporte Prestamo de Documentos en Excel
	public void reportePrestamoDocumentosExcel( DocumentosGuardaValoresBean documentosGuardaValoresBean, HttpServletResponse response) {

		List<DocumentosGuardaValoresBean> listaDocumentos = null;
		String nombreArchivo = "";

		try{
			nombreArchivo = "PrestamoDocumentos.xls";
			listaDocumentos = documentosGuardaValoresDAO.reportePrestamoDocumentos(documentosGuardaValoresBean, Enum_Rep_PrestamoDocumentosExcel.reportePrestamoDocumentos);
			XSSFWorkbook libro = new XSSFWorkbook();

			//Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFCellStyle estiloTitulo = Utileria.crearFuente(libro, 10, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para cabeceras del reporte.
			XSSFCellStyle estiloCabecera = Utileria.crearFuente(libro, 10, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para los Parametros del reporte.
			XSSFCellStyle estiloParametros = Utileria.crearFuente(libro, 10, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFCellStyle estiloTexto = Utileria.crearFuente(libro, 10, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_NOBOLD);

			//Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFCellStyle estiloTextoCentrado = Utileria.crearFuente(libro, 10, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_NOBOLD);

			// Creacion de hoja
			XSSFSheet hoja = libro.createSheet("REPORTE_ADMON_DOCUMENTOS");
			XSSFRow fila= hoja.createRow(0);

			// Nombre Institucion y Usuario
			fila = hoja.createRow(1);
			XSSFCell celdaInstitucion=fila.createCell((short)1);
			celdaInstitucion.setCellStyle(estiloTitulo);
			celdaInstitucion.setCellValue(documentosGuardaValoresBean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(1, 1, 1, 12));

			celdaInstitucion = fila.createCell((short)13);
			celdaInstitucion.setCellValue("Usuario:");
			celdaInstitucion.setCellStyle(estiloParametros);
			celdaInstitucion = fila.createCell((short)14);
			celdaInstitucion.setCellValue((!documentosGuardaValoresBean.getNombreUsuario().isEmpty())?documentosGuardaValoresBean.getNombreUsuario(): "TODOS");
			celdaInstitucion.setCellStyle(estiloTexto);

			String horaReporte  = documentosGuardaValoresBean.getHoraEmision();
			String fechaReporte = documentosGuardaValoresBean.getFechaEmision();

			// Titulo del Reporte y Fecha
			fila = hoja.createRow(2);
			XSSFCell celdaTitulo = fila.createCell((short)1);
			celdaTitulo.setCellStyle(estiloTitulo);
			celdaTitulo.setCellValue("REPORTE DE PRÉSTAMO DOCUMENTOS" );
			hoja.addMergedRegion(new CellRangeAddress(2, 2, 1, 12));

			celdaTitulo = fila.createCell((short)13);
			celdaTitulo.setCellValue("Fecha:");
			celdaTitulo.setCellStyle(estiloParametros);
			celdaTitulo = fila.createCell((short)14);
			celdaTitulo.setCellValue(fechaReporte);
			celdaTitulo.setCellStyle(estiloTexto);

			// Rango de Fechas del Reporte y hora
			fila = hoja.createRow(3);
			XSSFCell celdaRangoFecha = fila.createCell((short)1);
			celdaRangoFecha.setCellStyle(estiloTitulo);
			celdaRangoFecha.setCellValue(documentosGuardaValoresBean.getRangoFechas());
			hoja.addMergedRegion(new CellRangeAddress(3, 3, 1, 12));

			celdaRangoFecha = fila.createCell((short)13);
			celdaRangoFecha.setCellValue("Hora:");
			celdaRangoFecha.setCellStyle(estiloParametros);
			celdaRangoFecha = fila.createCell((short)14);
			celdaRangoFecha.setCellValue(horaReporte);
			celdaRangoFecha.setCellStyle(estiloTexto);

			fila = hoja.createRow(4);
			fila = hoja.createRow(5);

			XSSFCell celdaParametros = fila.createCell((short)1);
			celdaParametros = fila.createCell((short)4);
			celdaParametros.setCellValue("Sucursal:");
			celdaParametros.setCellStyle(estiloParametros);
			celdaParametros = fila.createCell((short)5);
			celdaParametros.setCellValue(documentosGuardaValoresBean.getNombreSucursal());
			celdaParametros.setCellStyle(estiloTexto);

			celdaParametros = fila.createCell((short)8);
			celdaParametros.setCellValue("Almacén:");
			celdaParametros.setCellStyle(estiloParametros);
			celdaParametros = fila.createCell((short)9);
			celdaParametros.setCellValue(documentosGuardaValoresBean.getNombreAlmacen());
			celdaParametros.setCellStyle(estiloTexto);

			fila = hoja.createRow(6);
			fila = hoja.createRow(7);

			XSSFCell celdaEncabezados = fila.createCell((short)1);

			celdaEncabezados = fila.createCell((short)1);
			celdaEncabezados.setCellValue("No. Documento");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)2);
			celdaEncabezados.setCellValue("Nombre");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)3);
			celdaEncabezados.setCellValue("Tipo Instrumento");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)4);
			celdaEncabezados.setCellValue("No Instrumento");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)5);
			celdaEncabezados.setCellValue("Documento");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)6);
			celdaEncabezados.setCellValue("Almacén");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)7);
			celdaEncabezados.setCellValue("Ubicación");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)8);
			celdaEncabezados.setCellValue("Fecha Préstamo");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)9);
			celdaEncabezados.setCellValue("Hora Préstamo");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)10);
			celdaEncabezados.setCellValue("Usuario Presto");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)11);
			celdaEncabezados.setCellValue("Usuario Autorizo");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)12);
			celdaEncabezados.setCellValue("Usuario Préstamo");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)13);
			celdaEncabezados.setCellValue("Fecha / Hora Devolución");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)14);
			celdaEncabezados.setCellValue("Motivo");
			celdaEncabezados.setCellStyle(estiloCabecera);

			int renglon = 8;
			int iteracion = 0;
			int numRegistros = 0;
			int tamanioLista = listaDocumentos.size();
			DocumentosGuardaValoresBean documentos = null;

			for( iteracion =0; iteracion <tamanioLista; iteracion  ++){

				documentos = (DocumentosGuardaValoresBean) listaDocumentos.get(iteracion );

				fila=hoja.createRow(renglon);
				XSSFCell celdaCuerpo = fila.createCell((short)1);

				celdaCuerpo=fila.createCell((short)1);
				celdaCuerpo.setCellValue(documentos.getDocumentoID());
				celdaCuerpo.setCellStyle(estiloTextoCentrado);

				celdaCuerpo=fila.createCell((short)2);
				celdaCuerpo.setCellValue(documentos.getNombreParticipante());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)3);
				celdaCuerpo.setCellValue(documentos.getTipoInstrumento());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)4);
				celdaCuerpo.setCellValue(documentos.getNumeroInstrumento());
				celdaCuerpo.setCellStyle(estiloTextoCentrado);

				celdaCuerpo=fila.createCell((short)5);
				celdaCuerpo.setCellValue(documentos.getNombreDocumento());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)6);
				celdaCuerpo.setCellValue(documentos.getNombreAlmacen());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)7);
				celdaCuerpo.setCellValue(documentos.getUbicacion());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)8);
				celdaCuerpo.setCellValue(documentos.getFechaRegistro());
				celdaCuerpo.setCellStyle(estiloTextoCentrado);

				celdaCuerpo=fila.createCell((short)9);
				celdaCuerpo.setCellValue(documentos.getHoraRegistro());
				celdaCuerpo.setCellStyle(estiloTextoCentrado);

				celdaCuerpo=fila.createCell((short)10);
				celdaCuerpo.setCellValue(documentos.getNombreUsuarioRegistroID());
				celdaCuerpo.setCellStyle(estiloTextoCentrado);

				celdaCuerpo=fila.createCell((short)11);
				celdaCuerpo.setCellValue(documentos.getNombreUsuarioAutorizaID());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)12);
				celdaCuerpo.setCellValue(documentos.getNombreUsuarioProcesaID());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)13);
				celdaCuerpo.setCellValue(documentos.getFechaDevolucion());
				celdaCuerpo.setCellStyle(estiloTextoCentrado);

				celdaCuerpo=fila.createCell((short)14);
				celdaCuerpo.setCellValue(documentos.getObservaciones());
				celdaCuerpo.setCellStyle(estiloTexto);

				renglon++;
				numRegistros = numRegistros+1;
			}

			renglon = renglon + 1;
			fila = hoja.createRow(renglon);
			XSSFCell celdaPiePagina = fila.createCell((short)1);
			celdaPiePagina = fila.createCell((short)0);
			celdaPiePagina.setCellValue("Registros Exportados");
			celdaPiePagina.setCellStyle(estiloParametros);

			renglon = renglon + 1;
			fila = hoja.createRow(renglon);
			celdaPiePagina = fila.createCell((short)0);
			celdaPiePagina.setCellValue(numRegistros);
			celdaPiePagina.setCellStyle(estiloTexto);

			for(int celdaAjustar = 0; celdaAjustar <= 14; celdaAjustar++){
				hoja.autoSizeColumn((short)celdaAjustar);
			}

			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename="+ nombreArchivo);
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();


		} catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.info("Error al crear el reporte de Préstamo de Documentos en Guarda Valores " + exception);
		}
	}

	// Reporte Bitacora de Documentos en Excel
	public void reporteBitacoraDocumentosExcel( DocumentosGuardaValoresBean documentosGuardaValoresBean, HttpServletResponse response) {

		List<DocumentosGuardaValoresBean> bitacoraDocumentos = null;
		String nombreArchivo = "";

		try{
			nombreArchivo = "BitacoraDocumento.xls";
			bitacoraDocumentos = documentosGuardaValoresDAO.reporteBitacoraDocumento(documentosGuardaValoresBean, Enum_Rep_BitacoraExcel.reporteBitacoraDocumentos);
			XSSFWorkbook libro = new XSSFWorkbook();

			//Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFCellStyle estiloTitulo = Utileria.crearFuente(libro, 10, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para cabeceras del reporte.
			XSSFCellStyle estiloCabecera = Utileria.crearFuente(libro, 10, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para los Parametros del reporte.
			XSSFCellStyle estiloParametros = Utileria.crearFuente(libro, 10, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFCellStyle estiloTexto = Utileria.crearFuente(libro, 10, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_NOBOLD);

			//Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFCellStyle estiloTextoCentrado = Utileria.crearFuente(libro, 10, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_NOBOLD);

			// Creacion de hoja
			XSSFSheet hoja = libro.createSheet("REPORTE_BITACORA_DOCUMENTO");
			XSSFRow fila= hoja.createRow(0);

			// Nombre Institucion y Usuario
			fila = hoja.createRow(1);
			XSSFCell celdaNombreUsuario=fila.createCell((short)1);
			celdaNombreUsuario = fila.createCell((short)9);
			celdaNombreUsuario.setCellValue("Usuario:");
			celdaNombreUsuario.setCellStyle(estiloParametros);
			celdaNombreUsuario = fila.createCell((short)10);
			celdaNombreUsuario.setCellValue((!documentosGuardaValoresBean.getNombreUsuario().isEmpty())?documentosGuardaValoresBean.getNombreUsuario(): "TODOS");
			celdaNombreUsuario.setCellStyle(estiloTexto);

			String horaReporte  = documentosGuardaValoresBean.getHoraEmision();
			String fechaReporte = documentosGuardaValoresBean.getFechaEmision();

			// Titulo del Reporte y Fecha
			fila = hoja.createRow(2);
			XSSFCell celdaInstitucion = fila.createCell((short)1);
			celdaInstitucion.setCellValue(documentosGuardaValoresBean.getNombreInstitucion());
			celdaInstitucion.setCellStyle(estiloTitulo);
			hoja.addMergedRegion(new CellRangeAddress(2, 2, 1, 8));

			celdaInstitucion = fila.createCell((short)9);
			celdaInstitucion.setCellValue("Fecha:");
			celdaInstitucion.setCellStyle(estiloParametros);
			celdaInstitucion = fila.createCell((short)10);
			celdaInstitucion.setCellValue(fechaReporte);
			celdaInstitucion.setCellStyle(estiloTexto);

			// Rango de Fechas del Reporte y hora
			fila = hoja.createRow(3);
			XSSFCell celdaNombreReporte = fila.createCell((short)1);
			celdaNombreReporte.setCellValue("REPORTE BITÁCORA DOCUMENTO");
			celdaNombreReporte.setCellStyle(estiloTitulo);
			hoja.addMergedRegion(new CellRangeAddress(3, 3, 1, 8));

			celdaNombreReporte = fila.createCell((short)9);
			celdaNombreReporte.setCellValue("Hora:");
			celdaNombreReporte.setCellStyle(estiloParametros);
			celdaNombreReporte = fila.createCell((short)10);
			celdaNombreReporte.setCellValue(horaReporte);
			celdaNombreReporte.setCellStyle(estiloTexto);

			fila = hoja.createRow(4);
			fila = hoja.createRow(5);

			XSSFCell celdaParametros = fila.createCell((short)1);
			celdaParametros.setCellValue("No. Documento:");
			celdaParametros.setCellStyle(estiloParametros);
			celdaParametros = fila.createCell((short)2);
			celdaParametros.setCellValue(documentosGuardaValoresBean.getNumeroInstrumento());
			celdaParametros.setCellStyle(estiloTexto);

			fila = hoja.createRow(6);
			fila = hoja.createRow(7);
			XSSFCell celdaEncabezados = fila.createCell((short)1);

			celdaEncabezados = fila.createCell((short)1);
			celdaEncabezados.setCellValue("Número Consecutivo");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)2);
			celdaEncabezados.setCellValue("Tipo instrumento");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)3);
			celdaEncabezados.setCellValue("Número Instrumento");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)4);
			celdaEncabezados.setCellValue("Nombre");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)5);
			celdaEncabezados.setCellValue("Nombre Documento");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)6);
			celdaEncabezados.setCellValue("Estatus Previo");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)7);
			celdaEncabezados.setCellValue("Estatus Actual");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)8);
			celdaEncabezados.setCellValue("Usuario Registro");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)9);
			celdaEncabezados.setCellValue("Fecha Operación");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)10);
			celdaEncabezados.setCellValue("Observaciones");
			celdaEncabezados.setCellStyle(estiloCabecera);

			int renglon = 8;
			int iteracion = 0;
			int numRegistros = 0;
			int tamanioLista = bitacoraDocumentos.size();
			DocumentosGuardaValoresBean documentos = null;

			for( iteracion =0; iteracion <tamanioLista; iteracion  ++){

				documentos = (DocumentosGuardaValoresBean) bitacoraDocumentos.get(iteracion );
				fila=hoja.createRow(renglon);
				XSSFCell celdaCuerpo = fila.createCell((short)1);

				celdaCuerpo=fila.createCell((short)1);
				celdaCuerpo.setCellValue(documentos.getDocumentoID());
				celdaCuerpo.setCellStyle(estiloTextoCentrado);

				celdaCuerpo=fila.createCell((short)2);
				celdaCuerpo.setCellValue(documentos.getTipoInstrumento());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)3);
				celdaCuerpo.setCellValue(documentos.getNumeroInstrumento());
				celdaCuerpo.setCellStyle(estiloTextoCentrado);

				celdaCuerpo=fila.createCell((short)4);
				celdaCuerpo.setCellValue(documentos.getNombreParticipante());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)5);
				celdaCuerpo.setCellValue(documentos.getNombreDocumento());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)6);
				celdaCuerpo.setCellValue(documentos.getEstatusPrevio());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)7);
				celdaCuerpo.setCellValue(documentos.getEstatus());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)8);
				celdaCuerpo.setCellValue(documentos.getUsuarioRegistroID());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)9);
				celdaCuerpo.setCellValue(documentos.getFechaRegistro());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)10);
				celdaCuerpo.setCellValue(documentos.getObservaciones());
				celdaCuerpo.setCellStyle(estiloTexto);

				renglon++;
				numRegistros = numRegistros+1;
			}

			renglon = renglon + 1;
			fila = hoja.createRow(renglon);
			XSSFCell celdaPiePagina = fila.createCell((short)1);
			celdaPiePagina = fila.createCell((short)0);
			celdaPiePagina.setCellValue("Registros Exportados");
			celdaPiePagina.setCellStyle(estiloParametros);

			renglon = renglon + 1;
			fila = hoja.createRow(renglon);
			celdaPiePagina = fila.createCell((short)0);
			celdaPiePagina.setCellValue(numRegistros);
			celdaPiePagina.setCellStyle(estiloTexto);

			for(int celdaAjustar=0; celdaAjustar <= 10; celdaAjustar++){
				hoja.autoSizeColumn((short)celdaAjustar);
			}

			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=" + nombreArchivo);
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();


		} catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.info("Error al crear el reporte Bitácora de Documentos en Guarda Valores " + exception);
		}

	}

	// Reporte Ingreso de Documentos en PDF
	public ByteArrayOutputStream reporteIngresoDocumentosPDF( DocumentosGuardaValoresBean documentosGuardaValoresBean, String nombreReporte) throws Exception{

		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_DocumentoID", documentosGuardaValoresBean.getDocumentoID());
		parametrosReporte.agregaParametro("Par_FechaInicio", documentosGuardaValoresBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin", documentosGuardaValoresBean.getFechaFin());
		parametrosReporte.agregaParametro("Par_SucursalID", documentosGuardaValoresBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_NombreSucursal", documentosGuardaValoresBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_AlmacenID", documentosGuardaValoresBean.getAlmacenID());
		parametrosReporte.agregaParametro("Par_NombreAlmacen", documentosGuardaValoresBean.getNombreAlmacen());
		parametrosReporte.agregaParametro("Par_Estatus", documentosGuardaValoresBean.getEstatus());
		parametrosReporte.agregaParametro("Par_EstatusDescripcion", documentosGuardaValoresBean.getDescripcionEstatus());
		parametrosReporte.agregaParametro("Par_RangoFechas", documentosGuardaValoresBean.getRangoFechas());
		parametrosReporte.agregaParametro("Par_NombreInstitucion", documentosGuardaValoresBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_HoraEmision", documentosGuardaValoresBean.getHoraEmision());
		parametrosReporte.agregaParametro("Par_FechaEmision", documentosGuardaValoresBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NombreUsuario", documentosGuardaValoresBean.getNombreUsuario());
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	// Reporte Estatus de Documentos en PDF
	public ByteArrayOutputStream reporteEstatusDocumentosPDF( DocumentosGuardaValoresBean documentosGuardaValoresBean, String nombreReporte) throws Exception{

		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_DocumentoID", documentosGuardaValoresBean.getDocumentoID());
		parametrosReporte.agregaParametro("Par_FechaInicio", documentosGuardaValoresBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin", documentosGuardaValoresBean.getFechaFin());
		parametrosReporte.agregaParametro("Par_SucursalID", documentosGuardaValoresBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_NombreSucursal", documentosGuardaValoresBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_AlmacenID", documentosGuardaValoresBean.getAlmacenID());
		parametrosReporte.agregaParametro("Par_NombreAlmacen", documentosGuardaValoresBean.getNombreAlmacen());
		parametrosReporte.agregaParametro("Par_Estatus", documentosGuardaValoresBean.getEstatus());
		parametrosReporte.agregaParametro("Par_DescripcionEstatus", documentosGuardaValoresBean.getDescripcionEstatus());
		parametrosReporte.agregaParametro("Par_RangoFechas", documentosGuardaValoresBean.getRangoFechas());
		parametrosReporte.agregaParametro("Par_NombreInstitucion", documentosGuardaValoresBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_HoraEmision", documentosGuardaValoresBean.getHoraEmision());
		parametrosReporte.agregaParametro("Par_FechaEmision", documentosGuardaValoresBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NombreUsuario", documentosGuardaValoresBean.getNombreUsuario());

		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	// Reporte Prestamo de Documentos en PDF
	public ByteArrayOutputStream reportePrestamoDocumentosPDF( DocumentosGuardaValoresBean documentosGuardaValoresBean, String nombreReporte) throws Exception{

		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_DocumentoID", documentosGuardaValoresBean.getDocumentoID());
		parametrosReporte.agregaParametro("Par_FechaInicio", documentosGuardaValoresBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin", documentosGuardaValoresBean.getFechaFin());
		parametrosReporte.agregaParametro("Par_SucursalID", documentosGuardaValoresBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_NombreSucursal", documentosGuardaValoresBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_AlmacenID", documentosGuardaValoresBean.getAlmacenID());
		parametrosReporte.agregaParametro("Par_NombreAlmacen", documentosGuardaValoresBean.getNombreAlmacen());
		parametrosReporte.agregaParametro("Par_Estatus", documentosGuardaValoresBean.getEstatus());
		parametrosReporte.agregaParametro("Par_EstatusDescripcion", documentosGuardaValoresBean.getDescripcionEstatus());
		parametrosReporte.agregaParametro("Par_RangoFechas", documentosGuardaValoresBean.getRangoFechas());
		parametrosReporte.agregaParametro("Par_NombreInstitucion", documentosGuardaValoresBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_HoraEmision", documentosGuardaValoresBean.getHoraEmision());
		parametrosReporte.agregaParametro("Par_FechaEmision", documentosGuardaValoresBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NombreUsuario", documentosGuardaValoresBean.getNombreUsuario());
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	// Reporte Bitacora de Documentos en PDF
	public ByteArrayOutputStream reporteExpedientePDF( DocumentosGuardaValoresBean documentosGuardaValoresBean, String nombreReporte) throws Exception{

		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_ExpedienteID", documentosGuardaValoresBean.getNumeroExpedienteID());
		parametrosReporte.agregaParametro("Par_NombreInstrumento", documentosGuardaValoresBean.getTipoInstrumento());
		parametrosReporte.agregaParametro("Par_SucursalID", documentosGuardaValoresBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_TipoPersona", documentosGuardaValoresBean.getTipoPersona());
		parametrosReporte.agregaParametro("Par_NombreSucursal", documentosGuardaValoresBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_NombreInstitucion", documentosGuardaValoresBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_HoraEmision", documentosGuardaValoresBean.getHoraEmision());
		parametrosReporte.agregaParametro("Par_FechaEmision", documentosGuardaValoresBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NombreUsuario", documentosGuardaValoresBean.getNombreUsuario());

		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public DocumentosGuardaValoresDAO getDocumentosGuardaValoresDAO() {
		return documentosGuardaValoresDAO;
	}

	public void setDocumentosGuardaValoresDAO(DocumentosGuardaValoresDAO documentosGuardaValoresDAO) {
		this.documentosGuardaValoresDAO = documentosGuardaValoresDAO;
	}	
}
