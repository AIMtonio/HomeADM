package nomina.servicio;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

import nomina.bean.ArchivoInstalBean;
import nomina.bean.DetalleArchivoInstalBean;
import nomina.dao.ArchivoInstalDAO;
import nomina.servicio.NominaEmpleadosServicio.Enum_Tra_NominaEmpleados;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import general.servicio.ParametrosAplicacionServicio;
import herramientas.Utileria;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;

public class ArchivoInstalServicio extends BaseServicio{
	ArchivoInstalDAO archivoInstalDAO = null;
	String					nombreReporte			= null;
	String					successView				= null;
	ParametrosSesionBean	parametrosSesionBean	= null;
	ParametrosSisServicio	parametrosSisServicio	= null;
	ParametrosAplicacionServicio parametrosAplicacionServicio = null;
	CreditosServicio		creditosServicio 		=null;
	CalendarioIngresosServicio calendarioIngresosServicio = null;
	DetalleArchivoInstalServicio detalleArchivoInstalServicio = null;

	public static interface Enum_Tra_ArchivoInstal {
		int alta = 1;
		int procesarArchivo = 2;
		int procesarAnteriorFolio = 3;
	}
	
	public static interface Enum_Con_ArchivoInstal {
		int principal = 1;
		int folioAnterior = 2;
		int conInstitucionConvenio  = 52;
	}
	
	public static interface Enum_Lis_ArchivoInstal {
		int principal = 1;
	}
	
	public static interface Enum_Rep_ArchivoInstal {
		int reporteArchivos = 1;
	}
	
	public static interface Enum_EstatusNomina {
		String ESTATUS_NOMINA_NO = "N";
		String ESTATUS_NOMINA_SI = "E";
	}
	
	public static interface Enum_EstatusArchivo {
		String ESTATUS_ENVIADO = "E";
		String ESTATUS_PROCESADO = "P";
	}
	
	public static interface Enum_Pro_ArchivoInstal {
		int ESTATUS_NOMINA_ENVIADO = 3;
		int ESTATUS_NOMINA_NOENVIADO = 2;
		int ESTATUS_NOMINA_AUTORIZADO = 1;
	}
	
	/**
	 * Método que realiza una determinada acción deacuerdo al parámetro tipoTransaccion.
	 * @param tipoTransaccion Parámetro auxiliar que permite determina la acción a realizar.
	 * @param archivoInstalBean Información del Folio del archivo de instalación.
	 * @return Mensaje que indica si la acción fue realizada con éxito, y en caso contrario un error que indica el fallo.
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ArchivoInstalBean archivoInstalBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();	
		switch (tipoTransaccion) {
			case Enum_Tra_ArchivoInstal.alta:
				mensaje = archivoInstalDAO.altaArchivoInstal(archivoInstalBean);
				break;
			case Enum_Tra_ArchivoInstal.procesarArchivo:
				mensaje = ValidarCreditosReporte(archivoInstalBean);
				break;
			case Enum_Tra_ArchivoInstal.procesarAnteriorFolio:
				mensaje = procesarAnteriorFolio(archivoInstalBean);
				break;
		}
		return mensaje;
	}
	
	

	/**
	 * Método que realiza una determinada consulta. 
	 * @param tipoConsulta Parámetro que indica el tipo de consulta que se realizará.
	 * @param bean Objeto que almacena el filtro por el cual se realizará la consulta.
	 * @return Objeto que guarda la información del objeto consultado.
	 */
	public ArchivoInstalBean consulta(int tipoConsulta, ArchivoInstalBean bean){
		ArchivoInstalBean archivoInstalBean = null;
		switch(tipoConsulta){
			case Enum_Con_ArchivoInstal.principal:
				archivoInstalBean = archivoInstalDAO.consultaPrincipal(Enum_Con_ArchivoInstal.principal, bean);
			break;
			case Enum_Con_ArchivoInstal.folioAnterior:
				archivoInstalBean = archivoInstalDAO.consultaArchivoInstal(tipoConsulta, bean);
				if (archivoInstalBean == null){
					System.out.println("Es nulo");
				}
			break;
		}
		
		return archivoInstalBean;
	}
	
	/**
	 * Método que realiza una determinada consulta con el objetivo de obtener un listado de registros coincidentes a un determinado filtro.
	 * @param tipoLista Parámetro que determina el tipo de lista que se realizará.
	 * @param bean Objeto que almacena el filtro por el cual se realizará la consulta.
	 * @return Lista que almacena los registros coincidentes.
	 */
	public List<ArchivoInstalBean> lista(int tipoLista, ArchivoInstalBean bean){
		List<ArchivoInstalBean> listaArchivos = null;
		switch(tipoLista){
			case Enum_Lis_ArchivoInstal.principal:
				listaArchivos = archivoInstalDAO.listaPrincipal(Enum_Lis_ArchivoInstal.principal, bean);
			break;
		}
		return listaArchivos;
	}
	
	/**
	 * Método que permite obtener el listado de créditos cargados en el archivo de instalación.
	 * @return
	 */
	public List<ArchivoInstalBean> obtenerListadoCreditosReporte(ArchivoInstalBean bean){
		List<List<ArchivoInstalBean>> listaArchivosInstal = null;
		List<ArchivoInstalBean> listaArchivos = new ArrayList<ArchivoInstalBean>();
		ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
		String directorio = null;
		String rutaArchivo = null;
		directorio = parametros.getRutaArchivos() + "Nomina/ArchivoInstalacion";
		rutaArchivo = directorio + "/" + parametros.getNombreUsuario() + "_" +  bean.getFolioID() + ".xls";
		
		listaArchivosInstal = archivoInstalDAO.leerArchivoExcel(rutaArchivo);
		
		listaArchivos = listaArchivosInstal.get(0);
		
		return listaArchivos;
	}
	
	/**
	 * Método que permite procesar los créditos con incidencias obtenidos del archivo de instalación.
	 * @param bean Objeto que guarda el folio, institucion y convencion de nomina.
	 * @return Objeto que guarda el mensaje que se desplegará al usuario.
	 */
	public MensajeTransaccionBean ValidarCreditosReporte(ArchivoInstalBean bean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		List<List<ArchivoInstalBean>> listaArchivosInstal = null;
		List<ArchivoInstalBean> listaExito = new ArrayList<ArchivoInstalBean>();
		List<ArchivoInstalBean> listaError = new ArrayList<ArchivoInstalBean>();
		List<DetalleArchivoInstalBean> listaDetalle = new ArrayList<DetalleArchivoInstalBean>();
		List<ArchivoInstalBean> listaAutorizados = new ArrayList<ArchivoInstalBean>();
		ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
		CreditosBean credito = null;
		DetalleArchivoInstalBean detalleArchivo = null;
		String directorio = null;
		String rutaArchivo = null;
		boolean continuar = true;
		Date fechaRecep = null;
		SimpleDateFormat sdformat = new SimpleDateFormat("yyyy-MM-dd");
		
		directorio = parametros.getRutaArchivos() + "Nomina/ArchivoInstalacion";
		rutaArchivo = directorio + "/" + parametros.getNombreUsuario() + "_" +  bean.getFolioID() + ".xls";
		
		// Se valida la existencia 
		if (!new File(rutaArchivo).exists()){
			mensaje.setDescripcion("No se encuentra el archivo.");
			mensaje.setNumero(999);
			mensaje.setNombreControl("grabar");
			return mensaje;
		}
		
		try {
			listaArchivosInstal = archivoInstalDAO.leerArchivoExcel(rutaArchivo);
		} catch (Exception e){
			mensaje.setDescripcion("Error en la lectura del archivo Excel. Verificar contenido.");
			mensaje.setNumero(999);
			mensaje.setNombreControl("grabar");
			return mensaje;
		}
				
		listaExito = listaArchivosInstal.get(0);
		listaError = listaArchivosInstal.get(1);
		
		//Se valida si hubieron errores en la lectura del archivo excel.
		if (listaError.size() > 0){
			mensaje.setDescripcion("Verifique el contenido del archivo. " + listaError.get(0).getDescError() + "En la linea: " + listaError.get(0).getLineaError());
			mensaje.setNumero(999);
			mensaje.setNombreControl("grabar");
			return mensaje;
		}
		
		//Se valida si el archivo tenia algún registro valido.
		if (listaExito.size() <= 0){
			mensaje.setDescripcion("Verifique el contenido del archivo. Razón: No existen registros dentro del documento.");
			mensaje.setNumero(999);
			mensaje.setNombreControl("grabar");
			return mensaje;
		}
		
		// Se consulta el listado de créditos que pertenecen al folio.
		detalleArchivo = new DetalleArchivoInstalBean();
		detalleArchivo.setFolioID(bean.getFolioID());
		listaDetalle = detalleArchivoInstalServicio.lista(Enum_Lis_ArchivoInstal.principal, detalleArchivo);
		
		for (ArchivoInstalBean archivoInstalBean : listaExito) {
			continuar = false;
			// Comparación de los creditos con los creditos guardados en la tabla DETALLEARCHIVOINSTAL
			for (DetalleArchivoInstalBean tempoArchivo : listaDetalle){
				
				if (tempoArchivo.getCreditoID().equals(archivoInstalBean.getCreditoID())){
					
					try {
						fechaRecep = sdformat.parse(tempoArchivo.getFechaLimiteRecep());
					} catch (Exception e){
						mensaje.setDescripcion("Error en el proceso de carga del archivo, intente nuevamente.");
						mensaje.setNumero(999);
						mensaje.setNombreControl("grabar");
						return mensaje;
					}
					
					// Se valida si el crédito se encuentra dentro de su limite de recepción de incidencia.
					if (fechaRecep.compareTo(parametros.getFechaSucursal()) < 0){
						mensaje.setDescripcion("Verifique el contenido del archivo. Razón: El crédito " + archivoInstalBean.getCreditoID() + " sobrepaso su fecha limite de recepción.");
						mensaje.setNumero(999);
						mensaje.setNombreControl("grabar");
						return mensaje;
					}
					
					// Se valida si el crédito se encuentra en un estatus enviado.
					if (tempoArchivo.getEstatus().equals(Enum_EstatusNomina.ESTATUS_NOMINA_SI)){
						continuar = true;
						listaDetalle.remove(tempoArchivo);
						break;
					}
				}
			}
			
			if (!continuar){
				mensaje.setDescripcion("Verifique el contenido del archivo. Razón: El crédito " + archivoInstalBean.getCreditoID() + " No pertenece al folio.");
				mensaje.setNumero(999);
				mensaje.setNombreControl("grabar");
				return mensaje;
			}
		}
		
		for (DetalleArchivoInstalBean tempoArchivo : listaDetalle){
			ArchivoInstalBean archivoNuevo = new ArchivoInstalBean();
			archivoNuevo.setCreditoID(tempoArchivo.getCreditoID());
			listaAutorizados.add(archivoNuevo);
		}
		
		if (listaAutorizados.size() > 0){
			mensaje = cambiarEstatusCredito(listaAutorizados, Enum_Pro_ArchivoInstal.ESTATUS_NOMINA_AUTORIZADO, Utileria.convierteEntero(bean.getFolioID()));
			
			if (mensaje.getNumero() != 0){
				return mensaje;
			}
		}
		
		mensaje = cambiarEstatusCredito(listaExito, Enum_Pro_ArchivoInstal.ESTATUS_NOMINA_NOENVIADO, Utileria.convierteEntero(bean.getFolioID()));
		
		if (mensaje.getNumero() != 0){
			return mensaje;
		}
		
		//Aqui hay que actualizar el estatus del folio de la tabla CRENOMINAARCHINSTAL
		
		mensaje = archivoInstalDAO.modificaArchivoInstal(bean, Enum_EstatusArchivo.ESTATUS_PROCESADO);
		
		if (mensaje.getNumero() != 0){
			return mensaje;
		}
		
		mensaje.setDescripcion("Archivo procesado. Los créditos con incidencias han cambiado a su estatus inicial.");
		mensaje.setNumero(0);
		mensaje.setConsecutivoInt(bean.getFolioID());
		mensaje.setConsecutivoString(bean.getFolioID());
		mensaje.setNombreControl("grabar");
		
		return mensaje;
		
	}
	
	private MensajeTransaccionBean procesarAnteriorFolio(
			ArchivoInstalBean archivoInstalBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();	
		List<DetalleArchivoInstalBean> listaDetalle = new ArrayList<DetalleArchivoInstalBean>();
		List<ArchivoInstalBean> listaAutorizados = new ArrayList<ArchivoInstalBean>();
		DetalleArchivoInstalBean detalleArchivo = null;
		ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
		Date fechaRecep = null;
		SimpleDateFormat sdformat = new SimpleDateFormat("yyyy-MM-dd");
		
		// Se consulta el listado de créditos que pertenecen al folio.
		detalleArchivo = new DetalleArchivoInstalBean();
		detalleArchivo.setFolioID(archivoInstalBean.getFolioIDAnterior());
		listaDetalle = detalleArchivoInstalServicio.lista(Enum_Lis_ArchivoInstal.principal, detalleArchivo);
		
		for(DetalleArchivoInstalBean detalle : listaDetalle){
			try {
				fechaRecep = sdformat.parse(detalle.getFechaLimiteRecep());
			} catch (Exception e){
				mensaje.setDescripcion("Error en el proceso de carga del archivo, intente nuevamente.");
				mensaje.setNumero(999);
				mensaje.setNombreControl("grabar");
				return mensaje;
			}
			if (fechaRecep.compareTo(parametros.getFechaSucursal()) > 0 && !detalle.getEstatus().equals(Enum_EstatusArchivo.ESTATUS_PROCESADO)){
				ArchivoInstalBean archivoNuevo = new ArchivoInstalBean();
				archivoNuevo.setCreditoID(detalle.getCreditoID());
				listaAutorizados.add(archivoNuevo);
			}
		}
		
		if (listaAutorizados.size() > 0){
			mensaje = cambiarEstatusCredito(listaAutorizados, Enum_Pro_ArchivoInstal.ESTATUS_NOMINA_AUTORIZADO,
					Utileria.convierteEntero(archivoInstalBean.getFolioIDAnterior()));
			
			if (mensaje.getNumero() != 0){
				return mensaje;
			}
		}
		
		//Aqui hay que actualizar el estatus del folio de la tabla CRENOMINAARCHINSTAL
		ArchivoInstalBean bean = archivoInstalBean;
		bean.setFolioID(bean.getFolioIDAnterior());
		mensaje = archivoInstalDAO.modificaArchivoInstal(bean, Enum_EstatusArchivo.ESTATUS_PROCESADO);
		
		if (mensaje.getNumero() != 0){
			return mensaje;
		}
		
		mensaje.setDescripcion("Archivo procesado. Los créditos relacionados con el folio sin cargar han sido Autorizados.");
		mensaje.setNumero(0);
		mensaje.setConsecutivoInt(archivoInstalBean.getFolioID());
		mensaje.setConsecutivoString(archivoInstalBean.getFolioID());
		mensaje.setNombreControl("grabar");
				
		return mensaje;
	}

	/**
	 * Método intermediario entre la generación del reporte y la consulta de la información de los créditos.
	 * @param response response Parámetro que hace referencia a la respuesta de la petición HTTP, por el cual se enviará el archivo Excel.
	 * @param bean Información del Folio del archivo de instalación.
	 */
	public void generarReporteExcel(HttpServletResponse response, ArchivoInstalBean bean){
		List<ArchivoInstalBean> listaReporte = archivoInstalDAO.listadoCreditosRep(Enum_Rep_ArchivoInstal.reporteArchivos, bean);
		reporteExcel(response, bean, listaReporte);
		cambiarEstatusCredito(listaReporte, Enum_Pro_ArchivoInstal.ESTATUS_NOMINA_ENVIADO, Utileria.convierteEntero(bean.getFolioID()));
	}
	
	/**
	 * Método que permite el cambio de EstatusNomina de cada Crédito en la lista listaReporte.
	 * @param listaReporte Lista de créditos a modificar.
	 */
	private MensajeTransaccionBean cambiarEstatusCredito(List<ArchivoInstalBean> listaReporte, int tipoPro, int folioID){
		MensajeTransaccionBean mensaje = null;
		ArchivoInstalBean beanLista = null;
		int tamanioLista = 0;
		
		if (listaReporte != null){
			
			tamanioLista = listaReporte.size();
			
			for (int iter = 0; iter < tamanioLista; iter++) {
				beanLista = listaReporte.get(iter);
				System.out.println("Tipo proceso : " + tipoPro);
				mensaje = archivoInstalDAO.modificarEstatusCredito(beanLista, tipoPro, folioID);
				
				if (mensaje.getNumero() != 0){
					return mensaje;
				}
			}
		}
		
		return mensaje;
	}
	
	/**
	 * Método que genera el archivo de excel con la lista de créditos consultados.
	 * @param response Parámetro que hace referencia a la respuesta de la petición HTTP, por el cual se enviará el archivo Excel.
	 * @param bean Información del Folio del archivo de instalación.
	 * @param listaReporte Listado de créditos filtrados por institución, convenio y estatus.
	 * @return listado de cŕeditos.
	 */
	private List<ArchivoInstalBean> reporteExcel(HttpServletResponse response, ArchivoInstalBean bean, List<ArchivoInstalBean> listaReporte) {
		double montoPagare = 0;
		double descuentoPeriodico = 0;
		
		try {
			

			// Se obtiene el tipo de institucion financiera
			ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
			parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.tipoInstitFin, parametrosSisBean);
			String				safilocaleCliente	= Utileria.generaLocale("safilocale.cliente", parametrosSisBean.getNombreCortoInst());

			Calendar			calendario			= new GregorianCalendar();
			SimpleDateFormat	postFormater		= new SimpleDateFormat("HH:mm");
			String				hora				= postFormater.format(calendario.getTime());

			XSSFSheet			hoja				= null;
			XSSFWorkbook		libro				= null;
			libro = new XSSFWorkbook();
			// Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFFont fuenteNegrita10 = libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short) 10);
			fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);

			XSSFFont fuenteNegrita10Izq = libro.createFont();
			fuenteNegrita10Izq.setFontHeightInPoints((short) 10);
			fuenteNegrita10Izq.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10Izq.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);

			// Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			XSSFFont fuenteNegrita8 = libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short) 8);
			fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);

			// Fuente encabezado del reporte
			XSSFFont fuenteEncabezado = libro.createFont();
			fuenteEncabezado.setFontHeightInPoints((short) 8);
			fuenteEncabezado.setFontName(HSSFFont.FONT_ARIAL);
			fuenteEncabezado.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);

			// Crea un Fuente con tamaño 8 para informacion del reporte.
			XSSFFont fuente8 = libro.createFont();
			fuente8.setFontHeightInPoints((short) 8);
			fuente8.setFontName(HSSFFont.FONT_ARIAL);

			XSSFFont fuente8Decimal = libro.createFont();
			fuente8Decimal.setFontHeightInPoints((short) 8);
			fuente8Decimal.setFontName(HSSFFont.FONT_ARIAL);

			XSSFFont fuente8Cuerpo = libro.createFont();
			fuente8Cuerpo.setFontHeightInPoints((short) 8);
			fuente8Cuerpo.setFontName(HSSFFont.FONT_ARIAL);

			// Crea un Fuente con tamaño 8 para informacion del reporte.
			XSSFFont fuente10 = libro.createFont();
			fuente8.setFontHeightInPoints((short) 10);
			fuente8.setFontName(HSSFFont.FONT_ARIAL);

			// La fuente se mete en un estilo para poder ser usada.
			// Estilo negrita de 10 para el titulo del reporte
			XSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			estiloNeg10.setAlignment(XSSFCellStyle.ALIGN_CENTER);

			// Alineado a la izq
			XSSFCellStyle estiloNeg10Izq = libro.createCellStyle();
			estiloNeg10Izq.setFont(fuenteNegrita10Izq);
			estiloNeg10Izq.setAlignment(XSSFCellStyle.ALIGN_LEFT);

			// Estilo negrita de 8 para encabezados del reporte
			XSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);

			// Estilo de datos centrados
			XSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteEncabezado);
			estiloCentrado.setAlignment(XSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment(XSSFCellStyle.VERTICAL_CENTER);

			XSSFCellStyle estilo8 = libro.createCellStyle();
			estilo8.setFont(fuente8);

			XSSFCellStyle estilo10 = libro.createCellStyle();
			estilo8.setFont(fuente10);

			// Estilo Formato decimal (0.00)
			XSSFCellStyle	estiloFormatoDecimal	= libro.createCellStyle();
			XSSFDataFormat	format					= libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,###,##0.00"));
			estiloFormatoDecimal.setFont(fuente8);

			XSSFCellStyle	estiloDecimalSinSimbol	= libro.createCellStyle();
			XSSFDataFormat	format2					= libro.createDataFormat();
			estiloDecimalSinSimbol.setDataFormat(format2.getFormat("#,###,##0.00"));
			estiloDecimalSinSimbol.setFont(fuente8Decimal);
			estiloDecimalSinSimbol.setAlignment(XSSFCellStyle.ALIGN_RIGHT);

			// Estilo Formato decimal (0.00)
			XSSFCellStyle	estiloFormatoDecimalTit	= libro.createCellStyle();
			XSSFDataFormat	formatTit				= libro.createDataFormat();
			estiloFormatoDecimalTit.setDataFormat(formatTit.getFormat("$#,###,##0.00"));
			estiloFormatoDecimalTit.setFont(fuenteNegrita8);

			// Creacion de hoja
			hoja = libro.createSheet("Archivo de Instalación");

			// inicio fecha, usuario,institucion y hora
			XSSFRow		fila		= hoja.createRow(0);
			XSSFCell	celdaUsu	= fila.createCell(9);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg10Izq);
			celdaUsu = fila.createCell(10);
			celdaUsu.setCellValue(((!bean.getUsuario().isEmpty()) ? bean.getUsuario() : "TODOS").toUpperCase());

			fila = hoja.createRow(1);
			String		fechaVar	= bean.getFechaSistema().toString();
			XSSFCell	celdaFec	= fila.createCell(9);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg10Izq);
			celdaFec = fila.createCell(10);
			celdaFec.setCellValue(fechaVar);

			XSSFCell celdaInst = fila.createCell((short) 1);
			celdaInst.setCellValue(bean.getNombreInstitucion());
			hoja.addMergedRegion(new CellRangeAddress(// funcion para unir celdas
					1, // primera fila (0-based)
					1, // ultima fila (0-based)
					1, // primer celda (0-based)
					8 // ultima celda (0-based)
			));
			celdaInst.setCellStyle(estiloNeg10);

			fila = hoja.createRow(2);
			XSSFCell celdaHora = fila.createCell(9);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg10Izq);
			celdaHora = fila.createCell(10);
			celdaHora.setCellValue(hora);
			// fin fecha usuario,institucion y hora
			XSSFCell celda = fila.createCell((short) 1);
			celda.setCellValue("REPORTE DE ARCHIVO DE INSTALACIÓN");
			celda.setCellStyle(estiloNeg10);

			hoja.addMergedRegion(new CellRangeAddress(// funcion para unir celdas
					2, // primera fila (0-based)
					2, // ultima fila (0-based)
					1, // primer celda (0-based)
					8 // ultima celda (0-based)
			));
			celda.setCellStyle(estiloNeg10);

			fila = hoja.createRow(5);
			XSSFCell celdaSucur = fila.createCell(0);

			celdaSucur.setCellValue("Folio:");
			celdaSucur.setCellStyle(estiloNeg10Izq);
			celdaSucur = fila.createCell((short) 1);
			celdaSucur.setCellStyle(estilo10);
			celdaSucur.setCellValue(bean.getFolioID());
			
			celdaSucur = fila.createCell((short) 2);
			celdaSucur.setCellStyle(estilo10);
			celdaSucur.setCellValue("Institución Nomina:");
			celdaSucur = fila.createCell((short) 3);
			celdaSucur.setCellStyle(estilo10);
			celdaSucur.setCellValue(bean.getInstitNominaID());
			
			celdaSucur = fila.createCell((short) 4);
			celdaSucur.setCellStyle(estilo10);
			celdaSucur.setCellValue("Convenio Nomina:");
			celdaSucur = fila.createCell((short) 5);
			celdaSucur.setCellStyle(estilo10);
			celdaSucur.setCellValue(bean.getConvenioNominaID());
			

			// Inicio en la segunda fila y que el fila uno tiene los encabezados
			fila = hoja.createRow(6);
			int numCelda = 0;
			celda = fila.createCell(numCelda);
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));

			celda = fila.createCell(numCelda++);
			celda.setCellValue("NÚMERO SOLICITUD");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell(numCelda++);
			celda.setCellValue("NÚMERO CRÉDITO");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell(numCelda++);
			celda.setCellValue("NÚMERO EMPLEADO");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell(numCelda++);
			celda.setCellValue("DEPENDENCIA");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell(numCelda++);
			celda.setCellValue("NOMBRE COMPLETO");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell(numCelda++);
			celda.setCellValue("RFC");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell(numCelda++);
			celda.setCellValue("CURP");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("MONTO OTORGADO");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("MONTO PAGARE");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("TASA ANUAL");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("TASA MENSUAL");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("PLAZO");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("NÚMERO PAGOS");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("DESCUENTO PERIÓDICO");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("PERIODO INICIO");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell(numCelda++);
			celda.setCellValue("PERIODO FIN");
			hoja.addMergedRegion(new CellRangeAddress(6, 7, numCelda, numCelda));
			celda.setCellStyle(estiloCentrado);

			for (int celd = 0; celd <= 42; celd++) {
				hoja.autoSizeColumn(celd, true);
			}
			int i = 8;
			if (listaReporte != null) {

				int	tamanioLista = listaReporte.size();

				ArchivoInstalBean beanLista = null;
				for (int iter = 0; iter < tamanioLista; iter++) {
					beanLista = listaReporte.get(iter);

					numCelda = 0;
					fila = hoja.createRow(i);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(beanLista.getSolicitudCreditoID());
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda.getCellStyle().setFont(fuente8Cuerpo);

					celda = fila.createCell(numCelda++);
					celda.setCellValue(beanLista.getCreditoID());
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(beanLista.getNumeroEmpleado());
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					//Utileria.convierteDoble
					celda = fila.createCell(numCelda++);
					celda.setCellValue(beanLista.getNombreInstit());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(beanLista.getNombreCompleto());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(beanLista.getRFC());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(beanLista.getCURP());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(beanLista.getMontoCredito()));
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					montoPagare = Utileria.convierteDoble(beanLista.getMontoCredito()) + Utileria.convierteDoble(beanLista.getMontoPagare());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(montoPagare);
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(beanLista.getTasaAnual()));
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue((Utileria.convierteDoble(beanLista.getTasaAnual())) / 12);
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(beanLista.getPlazo());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(beanLista.getNumAmortizacion()));
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					descuentoPeriodico = Utileria.convierteDoble(beanLista.getDescuentoPeriodico());
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(descuentoPeriodico);
					celda.setCellStyle(estiloDecimalSinSimbol);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(beanLista.getFechaInicioAmor());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(beanLista.getFechaVencimiento());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					
					i++;
				}

				i = i + 2;
				fila = hoja.createRow(i);
				celda = fila.createCell((short) 0);
				celda.setCellValue("Registros Exportados:");
				celda.setCellStyle(estiloNeg8);
				i++;
				fila = hoja.createRow(i);
				celda = fila.createCell((short) 0);
				if (listaReporte != null) {
					celda.setCellValue(listaReporte.size());
				}
				celda.setCellStyle(estilo8);

				i++;
				fila = hoja.createRow(i);
				celda = fila.createCell((short) 0);

			}

			for (int celd = 0; celd <= 42; celd++) {
				hoja.autoSizeColumn(celd, true);
			}
			// Creo la cabecera
			response.addHeader("Content-Disposition", "inline; filename=ArchivoInstalacion.xls");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return listaReporte;
	}

	// Métodos GET y SET.
	public ArchivoInstalDAO getArchivoInstalDAO() {
		return archivoInstalDAO;
	}

	public void setArchivoInstalDAO(ArchivoInstalDAO archivoInstalDAO) {
		this.archivoInstalDAO = archivoInstalDAO;
	}
	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}

	public void setParametrosAplicacionServicio(
			ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	public CalendarioIngresosServicio getCalendarioIngresosServicio() {
		return calendarioIngresosServicio;
	}

	public void setCalendarioIngresosServicio(
			CalendarioIngresosServicio calendarioIngresosServicio) {
		this.calendarioIngresosServicio = calendarioIngresosServicio;
	}

	public DetalleArchivoInstalServicio getDetalleArchivoInstalServicio() {
		return detalleArchivoInstalServicio;
	}

	public void setDetalleArchivoInstalServicio(
			DetalleArchivoInstalServicio detalleArchivoInstalServicio) {
		this.detalleArchivoInstalServicio = detalleArchivoInstalServicio;
	}
	
}
