package nomina.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletOutputStream;

import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import reporte.ParametrosReporte;
import reporte.Reporte;
import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;

import nomina.bean.PagoNominaBean;
import nomina.dao.PagoNominaDAO;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.ReportesExcel;
import herramientas.Utileria;

public class PagoNominaServicio extends BaseServicio {

	PagoNominaDAO pagoNominaDAO= null;
	TransaccionDAO transaccionDAO = null;
	ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	PolizaDAO polizaDAO = null;

	String conceptoConManualID = "54"; // numero de concepto contable para la conciliacion Manual
	String conceptoConManualDes = "PAGO DE CREDITO"; // descripcion para el concepto contable de conciliacion manual
	String automatico = "A"; // indica que se trata de una poliza automatica

	// -------------- Tipo Transaccion ----------------
	public static interface Enum_Tipo_Transaccion{
		int alta     = 1;
		int pagar    = 2;
		int cancelar = 3;
	}
	// -------------- Tipo Lista ----------------
	public static interface Enum_Lis_PagoNomina{
		int porAplicar	= 1;
		int movsTeso	= 2;
	}

	public static interface Enum_Lis_PagosAplica{
		int pagosAplicaExcel = 2;
	}
	//-------------- Tipo Actualizacion ---------
	private static interface Enum_Act_PagoNomina{
		int cancelarPagos=1;
	}
	//-------------- Tipo Consulta ---------
	public static interface Enum_Con_PagoNomina{
		int conCorreoInstit   = 7;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,PagoNominaBean pagoNominaBean, List<PagoNominaBean> listaPagoNominaBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tipo_Transaccion.alta:
				mensaje = pagoNominaDAO.altaPagosNomina(pagoNominaBean,parametrosAuditoriaBean.getNumeroTransaccion());
			break;
			case Enum_Tipo_Transaccion.pagar:
				mensaje= realizarPagosGrid(pagoNominaBean, listaPagoNominaBean);
			break;
			case Enum_Tipo_Transaccion.cancelar:
				mensaje= cancelarPagosGrid(pagoNominaBean, listaPagoNominaBean);
			break;
		}
		return mensaje;
	}

	public PagoNominaBean consulta(int tipoConsulta, PagoNominaBean pagoNominaBean){
		PagoNominaBean consultaPago = null;
		switch(tipoConsulta){
			case Enum_Con_PagoNomina.conCorreoInstit:
				consultaPago = pagoNominaDAO.consultaCorreoWS(pagoNominaBean, tipoConsulta);
			break;
		}
		return consultaPago;
	}

	public List<PagoNominaBean> lista(int tipoLista, PagoNominaBean pagoNominaBean){
		List<PagoNominaBean> pagoNominaLista = null;
		switch (tipoLista) {
			case  Enum_Lis_PagoNomina.porAplicar:
				pagoNominaLista = pagoNominaDAO.listaPagosGrid(pagoNominaBean, tipoLista);
			break;
		}
		return pagoNominaLista;
	}

	public List listaCombo(int tipoLista, PagoNominaBean pagoNominaBean){
		List pagoNominaLista = null;
		switch (tipoLista) {
			case  Enum_Lis_PagoNomina.movsTeso:
				pagoNominaLista = pagoNominaDAO.listaMovsTeso(pagoNominaBean, tipoLista);
			break;
		}
		return pagoNominaLista;
	}

	// Método para aplicar los pagos Seleccionados en el Grid
	public MensajeTransaccionBean realizarPagosGrid(final PagoNominaBean pagoNominaBean, List<PagoNominaBean> listaPagoNominaBean){

		MensajeTransaccionBean mensajeTransaccionBean = null;
		try{

			mensajeTransaccionBean = new MensajeTransaccionBean();
			if( listaPagoNominaBean.isEmpty() || listaPagoNominaBean.size() == Constantes.ENTERO_CERO ){
				mensajeTransaccionBean.setNumero(999);
				mensajeTransaccionBean.setDescripcion("No hay pagos de Créditos de Nómina por realizar.");
				throw new Exception(mensajeTransaccionBean.getDescripcion());
			}

			long polizaID 					= Constantes.ENTERO_CERO;
			int  numeroPagosExitos 			= Constantes.ENTERO_CERO;
			int  numeroPagosFallos 			= Constantes.ENTERO_CERO;
			int  numeroCancelacionExitosa	= Constantes.ENTERO_CERO;
			int  numeroCancelacionFallida	= Constantes.ENTERO_CERO;
			long numeroTransaccion			= Constantes.ENTERO_CERO;
			String mensajeDefault			= "CANCELACIÓN AUTOMÁTICA POR APLICACIÓN DE PAGOS DE CRÉDITO DE NÓMINA.";

			PolizaBean polizaBean = new PolizaBean();
			polizaBean.setConceptoID(conceptoConManualID);
			polizaBean.setConcepto(conceptoConManualDes);
			polizaBean.setTipo(automatico);

			polizaBean.setFecha(pagoNominaBean.getFechaAplica());
			transaccionDAO.generaNumeroTransaccion();
			numeroTransaccion = parametrosAuditoriaBean.getNumeroTransaccion();

			// se manda a llamar el alta de la poliza
			mensajeTransaccionBean = polizaDAO.altaPoliza(polizaBean, numeroTransaccion);
			if( mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ){
				throw new Exception(mensajeTransaccionBean.getDescripcion());
			}

			polizaID = Utileria.convierteLong(mensajeTransaccionBean.getConsecutivoString());
			pagoNominaBean.setPolizaID(String.valueOf(polizaID));

			for( PagoNominaBean pagoNomina : listaPagoNominaBean ){

				pagoNomina.setFechaAplica(pagoNominaBean.getFechaAplica());
				pagoNomina.setInstitNominaID(pagoNominaBean.getInstitNominaID());
				pagoNomina.setDepositoBancos(pagoNominaBean.getDepositoBancos());
				pagoNomina.setBorraDatos(Constantes.STRING_VACIO);
				pagoNomina.setMotivoCancela(mensajeDefault);

				if( pagoNomina.getEsSeleccionado().equalsIgnoreCase(Constantes.STRING_SI) ){
					mensajeTransaccionBean = pagoNominaDAO.realizarPagosCredito(pagoNomina, numeroTransaccion, polizaID);
					numeroPagosExitos++;
				} else {
					mensajeTransaccionBean = pagoNominaDAO.cancelarPagosCredito(pagoNomina, numeroTransaccion, Enum_Act_PagoNomina.cancelarPagos);
					numeroCancelacionExitosa++;
				}

				if( mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ){
					if( pagoNomina.getEsSeleccionado().equalsIgnoreCase(Constantes.STRING_SI) ){
						numeroPagosExitos--;
						numeroPagosFallos++;
						pagoNomina.setMotivoCancela(mensajeTransaccionBean.getDescripcion());
						mensajeTransaccionBean = pagoNominaDAO.cancelarPagosCredito(pagoNomina, numeroTransaccion, Enum_Act_PagoNomina.cancelarPagos);
					} else {
						numeroCancelacionExitosa--;
						numeroCancelacionFallida++;
					}
				}
			}

			// se manda a llamar la comprobacion de la poliza y la actualizacion de pagos
			mensajeTransaccionBean = pagoNominaDAO.verificaPoliza(pagoNominaBean, numeroTransaccion);

			mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO);
			mensajeTransaccionBean.setDescripcion("El Proceso de Pago de Nómina para el Folio Pendiente: "+ pagoNominaBean.getFolioPendienteID() +" fue Realizado Correctamente. <br>"+
												   "Pagos Exitosos: <b>"+ numeroPagosExitos + "</b>.<br>" +
												   "Pagos Fallidos: <b>"+ numeroPagosFallos + "</b>.<br>" +
												   "Cancelaciones Exitosas: <b>"+ numeroCancelacionExitosa + "</b>.<br>" +
												   "Cancelaciones Fallidas: <b>"+ numeroCancelacionFallida + "</b>.");
			mensajeTransaccionBean.setNombreControl("institNominaID");
			mensajeTransaccionBean.setConsecutivoInt(pagoNominaBean.getInstitNominaID());
			mensajeTransaccionBean.setConsecutivoString(pagoNominaBean.getInstitNominaID());

		} catch( Exception exception ){
			if( mensajeTransaccionBean == null ) {
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean.setNumero(999);
			}

			if( mensajeTransaccionBean.getNumero() == 0 ) {
				mensajeTransaccionBean.setNumero(999);
			}

			mensajeTransaccionBean.setDescripcion(exception.getMessage());
			mensajeTransaccionBean.setNombreControl(Constantes.STRING_VACIO);
			mensajeTransaccionBean.setConsecutivoInt(pagoNominaBean.getInstitNominaID());
			mensajeTransaccionBean.setConsecutivoString(pagoNominaBean.getInstitNominaID());
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el pago de créditos Nómina: ", exception);
		}
		return mensajeTransaccionBean;
	}

	// Método para cancelar los pagos Seleccionados en el Grid
	public MensajeTransaccionBean cancelarPagosGrid(final PagoNominaBean pagoNominaBean, List<PagoNominaBean> listaPagoNominaBean){

		MensajeTransaccionBean mensajeTransaccionBean = null;
		try{

			mensajeTransaccionBean = new MensajeTransaccionBean();
			if( listaPagoNominaBean.isEmpty() || listaPagoNominaBean.size() == Constantes.ENTERO_CERO ){
				mensajeTransaccionBean.setNumero(999);
				mensajeTransaccionBean.setDescripcion("No hay Cancelaciones de Créditos de Nómina por realizar.");
				throw new Exception(mensajeTransaccionBean.getDescripcion());
			}

			long numeroTransaccion 	= Constantes.ENTERO_CERO;
			int  numeroExitos 		= Constantes.ENTERO_CERO;
			int  numeroFallos 		= Constantes.ENTERO_CERO;
			int  numeroPendientes	= Constantes.ENTERO_CERO;

			transaccionDAO.generaNumeroTransaccion();
			numeroTransaccion = parametrosAuditoriaBean.getNumeroTransaccion();

			for( PagoNominaBean pagoNomina : listaPagoNominaBean ){

				if( pagoNomina.getEsSeleccionado().equalsIgnoreCase(Constantes.STRING_SI) ) {
					pagoNomina.setMotivoCancela(pagoNominaBean.getMotivoCancela());
					mensajeTransaccionBean = pagoNominaDAO.cancelarPagosCredito(pagoNomina, numeroTransaccion, Enum_Act_PagoNomina.cancelarPagos);

					numeroExitos++;
					if (mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ){

						numeroExitos--;
						numeroFallos++;
					}
				}
				numeroPendientes++;
			}

			numeroPendientes = numeroPendientes - (numeroExitos + numeroFallos);
			mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO);
			mensajeTransaccionBean.setDescripcion("El Proceso de Cancelación de Pago de Nómina para el Folio Pendiente: "+ pagoNominaBean.getFolioPendienteID() +" fue Realizado Correctamente. <br>"+
												   "Cancelaciones Exitosas: <b> "+ numeroExitos + "</b>.<br>"+
												   "Cancelaciones Fallidas: <b> "+ numeroFallos + "</b>.<br>"+
												   "Pagos Pendientes: <b> "+ numeroPendientes + "</b>.");
			mensajeTransaccionBean.setNombreControl("institNominaID");
			mensajeTransaccionBean.setConsecutivoInt(pagoNominaBean.getInstitNominaID());
			mensajeTransaccionBean.setConsecutivoString(pagoNominaBean.getInstitNominaID());

		} catch( Exception exception ){
			if( mensajeTransaccionBean == null ) {
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean.setNumero(999);
			}

			if( mensajeTransaccionBean.getNumero() == 0 ) {
				mensajeTransaccionBean.setNumero(999);
			}

			mensajeTransaccionBean.setDescripcion(exception.getMessage());
			mensajeTransaccionBean.setNombreControl(Constantes.STRING_VACIO);
			mensajeTransaccionBean.setConsecutivoInt(pagoNominaBean.getInstitNominaID());
			mensajeTransaccionBean.setConsecutivoString(pagoNominaBean.getInstitNominaID());
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la cancelación de créditos Nómina: ", exception);
		}
		return mensajeTransaccionBean;
	}

	// Reporte  de Pagos Aplicados en PDF
	public ByteArrayOutputStream reportePDF(PagoNominaBean pagoNomina, String nombreReporte, HttpServletResponse httpServletResponse) throws Exception{
		ByteArrayOutputStream byteArrayOutputStream = null;
		try {
			
			ParametrosReporte parametrosReporte = new ParametrosReporte();
		
			parametrosReporte.agregaParametro("Par_FechaInicio",pagoNomina.getFechaInicio());
			parametrosReporte.agregaParametro("Par_FechaFin",pagoNomina.getFechaFin());
			parametrosReporte.agregaParametro("Par_FechaEmision",pagoNomina.getFechaEmision());
			parametrosReporte.agregaParametro("Par_TipoReporte",pagoNomina.getTipoReporte());
			parametrosReporte.agregaParametro("Par_ClienteID", pagoNomina.getClienteID());
	
			parametrosReporte.agregaParametro("Par_NombreUsuario",pagoNomina.getNombreUsuario());
			parametrosReporte.agregaParametro("Par_NombreInstitucion",pagoNomina.getNombreInstitFin());
			parametrosReporte.agregaParametro("Par_InstitNominaID",pagoNomina.getInstitNominaID());
			parametrosReporte.agregaParametro("Par_NomInstitNomina",pagoNomina.getNombreInstitNomina());

			byteArrayOutputStream = Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			
			httpServletResponse.addHeader("Content-Disposition", "inline; filename=PagosAplicadosCredito.pdf");
			httpServletResponse.setContentType("application/pdf");
			byte[] bytes = byteArrayOutputStream.toByteArray();
			httpServletResponse.getOutputStream().write(bytes,0,bytes.length);
			httpServletResponse.getOutputStream().flush();
			httpServletResponse.getOutputStream().close();
		} catch (Exception exception) {
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el Reporte PDF de pago de créditos Nómina: ", exception);
		}		
		return byteArrayOutputStream;
	}

	// Reporte  de Pagos Aplicados en Pantalla
	public String reportePantalla(PagoNominaBean pagoNomina, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicio",pagoNomina.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin",pagoNomina.getFechaFin());
		parametrosReporte.agregaParametro("Par_FechaEmision",pagoNomina.getFechaEmision());
		parametrosReporte.agregaParametro("Par_TipoReporte",pagoNomina.getTipoReporte());
		parametrosReporte.agregaParametro("Par_ClienteID", pagoNomina.getClienteID());

		parametrosReporte.agregaParametro("Par_NombreUsuario",pagoNomina.getClaveUsuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",pagoNomina.getNombreInstitFin());
		parametrosReporte.agregaParametro("Par_InstitNominaID",pagoNomina.getInstitNominaID());
		parametrosReporte.agregaParametro("Par_NomInstitNomina",pagoNomina.getNombreInstitNomina());

		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public void reporteExcel(int tipoLista, PagoNominaBean pagoNominaBean, HttpServletResponse httpServletResponse){
		List<PagoNominaBean> listaPagos = null;
		try {
			
			listaPagos = pagoNominaDAO.consultaPagosAplicadosExcel(pagoNominaBean, Enum_Lis_PagosAplica.pagosAplicaExcel);
			
			// Creacion de Libro
			XSSFWorkbook xssfWorkbook = new XSSFWorkbook();

			// Creacion de Estilo
			XSSFCellStyle estiloTitulo			= ReportesExcel.estiloTitulo(xssfWorkbook);
			XSSFCellStyle estiloEncabezado		= ReportesExcel.estiloCabecera(xssfWorkbook);
			XSSFCellStyle estiloParametro		= ReportesExcel.estiloParametros(xssfWorkbook);
			XSSFCellStyle estiloTexto			= ReportesExcel.estiloTexto(xssfWorkbook);
			XSSFCellStyle estiloMoneda			= ReportesExcel.estiloMoneda(xssfWorkbook);
			XSSFCellStyle estiloTextoCentrado 	= ReportesExcel.estiloTextoCentrado(xssfWorkbook);

			// Creacion de hoja
			int fila = Constantes.ENTERO_CERO;
			int columna = Constantes.ENTERO_CERO;
			XSSFSheet xssfSheet = null;
			xssfSheet = xssfWorkbook.createSheet("Pagos Aplicados de Nómina");
			XSSFRow xssfRow = xssfSheet.createRow(fila);
			XSSFCell xssfCell = xssfRow.createCell((short)0);

			fila++;
			xssfRow = xssfSheet.createRow(fila);

			xssfCell = xssfRow.createCell((short)12);
			xssfCell.setCellValue("Usuario:");
			xssfCell.setCellStyle(estiloParametro);

			xssfCell = xssfRow.createCell((short)13);
			xssfCell.setCellValue((!pagoNominaBean.getNombreUsuario().isEmpty())?pagoNominaBean.getNombreUsuario(): "TODOS");
			xssfCell.setCellStyle(estiloTexto);

			fila++;
			xssfRow = xssfSheet.createRow(fila);

			xssfCell = xssfRow.createCell((short)1);
			xssfCell.setCellValue(pagoNominaBean.getNombreInstitFin());
			xssfSheet.addMergedRegion(new CellRangeAddress(fila, fila, 1, 11));
			xssfCell.setCellStyle(estiloTitulo);

			xssfCell = xssfRow.createCell((short)12);
			xssfCell.setCellValue("Fecha:");
			xssfCell.setCellStyle(estiloParametro);

			xssfCell = xssfRow.createCell((short)13);
			xssfCell.setCellValue(pagoNominaBean.getFechaEmision());
			xssfCell.setCellStyle(estiloTexto);

			fila++;
			xssfRow = xssfSheet.createRow(fila);

			xssfCell = xssfRow.createCell((short)1);
			xssfCell.setCellValue("REPORTE DE PAGOS NÓMINA DE CRÉDITOS DEL " + pagoNominaBean.getFechaInicio()+ " AL "+pagoNominaBean.getFechaFin());
			xssfSheet.addMergedRegion(new CellRangeAddress(fila, fila, 1, 11));
			xssfCell.setCellStyle(estiloTitulo);

			xssfCell = xssfRow.createCell((short)12);
			xssfCell.setCellValue("Hora:");
			xssfCell.setCellStyle(estiloParametro);

			xssfCell = xssfRow.createCell((short)13);
			xssfCell.setCellValue(ReportesExcel.horaSistema());
			xssfCell.setCellStyle(estiloTexto);

			fila++;
			fila++;
			xssfRow = xssfSheet.createRow(fila);

			xssfCell = xssfRow.createCell((short)1);
			xssfCell.setCellValue("Empresa Nómina: "+pagoNominaBean.getNombreInstitNomina());
			xssfCell.setCellStyle(estiloParametro);

			fila++;
			fila++;
			columna++;
			xssfRow = xssfSheet.createRow(fila);
			xssfCell = xssfRow.createCell((short)columna++);
			xssfCell.setCellValue("Folio de Carga");
			xssfCell.setCellStyle(estiloEncabezado);
			
			xssfCell = xssfRow.createCell((short)columna++);
			xssfCell.setCellValue("Cliente");
			xssfCell.setCellStyle(estiloEncabezado);

			xssfCell = xssfRow.createCell((short)columna++);
			xssfCell.setCellValue("Institución de Nómina");
			xssfCell.setCellStyle(estiloEncabezado);

			xssfCell = xssfRow.createCell((short)columna++);
			xssfCell.setCellValue("Convenio");
			xssfCell.setCellStyle(estiloEncabezado);

			xssfCell = xssfRow.createCell((short)columna++);
			xssfCell.setCellValue("Producto de Crédito");
			xssfCell.setCellStyle(estiloEncabezado);

			xssfCell = xssfRow.createCell((short)columna++);
			xssfCell.setCellValue("No. Crédito");
			xssfCell.setCellStyle(estiloEncabezado);

			xssfCell = xssfRow.createCell((short)columna++);
			xssfCell.setCellValue("No. Cuenta");
			xssfCell.setCellStyle(estiloEncabezado);

			xssfCell = xssfRow.createCell((short)columna++);
			xssfCell.setCellValue("Fecha Pago");
			xssfCell.setCellStyle(estiloEncabezado);

			xssfCell = xssfRow.createCell((short)columna++);
			xssfCell.setCellValue("Monto Aplicado");
			xssfCell.setCellStyle(estiloEncabezado);

			xssfCell = xssfRow.createCell((short)columna++);
			xssfCell.setCellValue("Monto No Aplicado");
			xssfCell.setCellStyle(estiloEncabezado);

			xssfCell = xssfRow.createCell((short)columna++);
			xssfCell.setCellValue("Total Recibido");
			xssfCell.setCellStyle(estiloEncabezado);

			xssfCell = xssfRow.createCell((short)columna++);
			xssfCell.setCellValue("Estatus");
			xssfCell.setCellStyle(estiloEncabezado);

			xssfCell = xssfRow.createCell((short)columna++);
			xssfCell.setCellValue("Descripción Pago");
			xssfCell.setCellStyle(estiloEncabezado);
			
			for( PagoNominaBean pagoNomina : listaPagos){

				fila++;
				columna = Constantes.ENTERO_UNO;
				xssfRow = xssfSheet.createRow(fila);
				
				xssfCell = xssfRow.createCell((short)columna++);
				xssfCell.setCellValue(Utileria.convierteLong(pagoNomina.getFolioCargaID()));
				xssfCell.setCellStyle(estiloTexto);
				
				xssfCell = xssfRow.createCell((short)columna++);
				xssfCell.setCellValue(pagoNomina.getClienteID());
				xssfCell.setCellStyle(estiloTexto);
				
				xssfCell = xssfRow.createCell((short)columna++);
				xssfCell.setCellValue(Utileria.convierteEntero(pagoNomina.getInstitNominaID()));
				xssfCell.setCellStyle(estiloTextoCentrado);
				
				xssfCell = xssfRow.createCell((short)columna++);
				xssfCell.setCellValue(Utileria.convierteEntero(pagoNomina.getConvenio()));
				xssfCell.setCellStyle(estiloTextoCentrado);
				
				xssfCell = xssfRow.createCell((short)columna++);
				xssfCell.setCellValue(pagoNomina.getProducCreditoID());
				xssfCell.setCellStyle(estiloTexto);
				
				xssfCell = xssfRow.createCell((short)columna++);
				xssfCell.setCellValue(Utileria.convierteLong(pagoNomina.getCreditoID()));
				xssfCell.setCellStyle(estiloTextoCentrado);
				
				xssfCell = xssfRow.createCell((short)columna++);
				xssfCell.setCellValue(Utileria.convierteLong(pagoNomina.getCuentaAhoID()));
				xssfCell.setCellStyle(estiloTextoCentrado);

				xssfCell = xssfRow.createCell((short)columna++);
				xssfCell.setCellValue(pagoNomina.getFechaPago());
				xssfCell.setCellStyle(estiloTextoCentrado);
				
				xssfCell = xssfRow.createCell((short)columna++);
				xssfCell.setCellValue(Utileria.convierteDoble(pagoNomina.getMontoAplicado()));
				xssfCell.setCellStyle(estiloMoneda);
				
				xssfCell = xssfRow.createCell((short)columna++);
				xssfCell.setCellValue(Utileria.convierteDoble(pagoNomina.getMontoNoAplicado()));
				xssfCell.setCellStyle(estiloMoneda);
				
				xssfCell = xssfRow.createCell((short)columna++);
				xssfCell.setCellValue(Utileria.convierteDoble(pagoNomina.getMontoRecibido()));
				xssfCell.setCellStyle(estiloMoneda);
				
				xssfCell = xssfRow.createCell((short)columna++);
				xssfCell.setCellValue(pagoNomina.getEstatus());
				xssfCell.setCellStyle(estiloTextoCentrado);
				
				xssfCell = xssfRow.createCell((short)columna++);
				xssfCell.setCellValue(pagoNomina.getMotivoCancela());
				xssfCell.setCellStyle(estiloTexto);
			}

			fila++;
			fila++;
			xssfRow = xssfSheet.createRow(fila);

			xssfCell = xssfRow.createCell((short)0);
			xssfCell.setCellValue("Registros Exportados");
			xssfCell.setCellStyle(estiloParametro);

			xssfCell = xssfRow.createCell((short)1);
			xssfCell.setCellValue(listaPagos.size());
			xssfCell.setCellStyle(estiloTexto);

			ReportesExcel.autoAjusteColumnas(13, xssfSheet);

			// Finaliza reporte
			httpServletResponse.addHeader("Content-Disposition","inline; filename=ReportePagosAplicados.xls");
			httpServletResponse.setContentType("application/vnd.ms-excel");

			ServletOutputStream servletOutputStream = httpServletResponse.getOutputStream();
			xssfSheet.getWorkbook().write(servletOutputStream);
			servletOutputStream.flush();
			servletOutputStream.close();
			
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.info("Error al crear el reporte Regulatorio Excel Pagos Aplicados de Nomina: "+ exception);
		}
	}

	public PagoNominaDAO getPagoNominaDAO() {
		return pagoNominaDAO;
	}

	public void setPagoNominaDAO(PagoNominaDAO pagoNominaDAO) {
		this.pagoNominaDAO = pagoNominaDAO;
	}

	public TransaccionDAO getTransaccionDAO() {
		return transaccionDAO;
	}

	public void setTransaccionDAO(TransaccionDAO transaccionDAO) {
		this.transaccionDAO = transaccionDAO;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
		ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}

}
