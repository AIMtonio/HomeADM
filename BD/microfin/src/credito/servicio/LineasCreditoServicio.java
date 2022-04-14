package credito.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import reporte.ParametrosReporte;
import reporte.Reporte;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;


import credito.bean.LineasCreditoBean;
import credito.dao.LineasCreditoDAO;

public class LineasCreditoServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	LineasCreditoDAO lineasCreditoDAO = null;
	static int tamanioTexto = 10;


	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_LineasCredito {
		int lineasCredito   = 1;
		int linCredAlt		= 2;
		int linCredActivo	= 3;
		int linCredInact	= 4;
		int linCredBloq		= 5;
		int linCredActBloq	= 6;
		int linCredAgropecuaria	= 7;
		int lisLineaActivaAgro	= 8;
		int lisLineaInactiAgro	= 9;
	}

	public static interface Enum_Tra_LineasCredito {
		int alta 			= 1;
		int modificacion 	= 2;
		int actualizacion	= 3;
	}

	public static interface Enum_Act_LineasCredito {
		int autoriza 	= 1;
		int bloquea		= 2;
		int desbloquea 	= 3;
		int cancela		= 4;
		int actMonto    = 5;
		int actAutorizaAgro = 6;
		int actRechazoAgro  = 7;
		int condiciones     = 8;
		int reactivar        = 9;
	}

	public static interface Enum_Con_LineasCredito {
		int principal		= 1;
		int foranea			= 2;
		int actualizacion	= 3;
		int agropecuaria	= 4;
		int agroInactiva	= 5;
	}

	public static interface Enum_Act_LineasCreditoAgro {
		int alta = 1;
	}
	// ---------- Reporte Lineas de Credito ----------- //
	public static interface Enum_Rep_DepLineaCredito {
		int  reporteLineaCredito = 1;
		int  reporteLineaCreditoAgro 	 = 2;
	}
	public static interface Enum_Rep_DepLineaCredito_Tipo {
		int  Principal_LineaCredito = 1;
	}
	public LineasCreditoServicio () {
		super();
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, LineasCreditoBean lineasCredito){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Tra_LineasCredito.alta:
				mensaje = lineasCreditoDAO.procesoLineaCredito(lineasCredito, tipoTransaccion);
			break;
			case Enum_Tra_LineasCredito.modificacion:
				mensaje = lineasCreditoDAO.procesoLineaCredito(lineasCredito, tipoTransaccion);
			break;
			case Enum_Tra_LineasCredito.actualizacion:
				mensaje = actualizaLineasCredito(lineasCredito, tipoActualizacion);
			break;		
		}

		return mensaje;
	}


	// Reporte Excel Depreciacion y Amortizacion de Activos
	public void listaRepLineasCredito( int tipoReporte, LineasCreditoBean lineasCreditoBean, HttpServletResponse httpServletResponse){
		switch(tipoReporte){
			case Enum_Rep_DepLineaCredito.reporteLineaCreditoAgro:
			reporteLineaCreditoAgroExcel(lineasCreditoBean, httpServletResponse);
			break;
		}
	}

	public MensajeTransaccionBean actualizaLineasCredito(LineasCreditoBean lineasCredito,int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		switch(tipoActualizacion){
			case Enum_Act_LineasCredito.autoriza:
				mensaje = lineasCreditoDAO.autoriza(lineasCredito, tipoActualizacion);
			break;
			case Enum_Act_LineasCredito.bloquea:
				mensaje = lineasCreditoDAO.bloqueoLinCred(lineasCredito, tipoActualizacion);
			break;
			case Enum_Act_LineasCredito.desbloquea:
				mensaje = lineasCreditoDAO.desbloqLinCred(lineasCredito, tipoActualizacion);
			break;
			case Enum_Act_LineasCredito.cancela:
				mensaje = lineasCreditoDAO.cancelarLinCred(lineasCredito, tipoActualizacion);
			break;
			case Enum_Act_LineasCredito.actMonto:
				mensaje = lineasCreditoDAO.actMontAutorizado(lineasCredito, tipoActualizacion);
			break;
			case Enum_Act_LineasCredito.actAutorizaAgro:
			case Enum_Act_LineasCredito.actRechazoAgro:
				mensaje = lineasCreditoDAO.autorizaLineaCreAgro(lineasCredito, tipoActualizacion);
			break;
			case Enum_Act_LineasCredito.reactivar:
			case Enum_Act_LineasCredito.condiciones:
				mensaje = lineasCreditoDAO.condicionesLineaAgro(lineasCredito, tipoActualizacion);
			break;
		}

		return mensaje;
	}

	public LineasCreditoBean consulta(int tipoConsulta, LineasCreditoBean lineasCredito){
		LineasCreditoBean lineasCreditoBean = null;
		switch(tipoConsulta){
			case Enum_Con_LineasCredito.principal:
				lineasCreditoBean = lineasCreditoDAO.consultaPrincipal(lineasCredito, Enum_Con_LineasCredito.principal);
			break;
			case Enum_Con_LineasCredito.foranea:
				lineasCreditoBean = lineasCreditoDAO.consultaForanea(lineasCredito, Enum_Con_LineasCredito.foranea);
			break;
			case Enum_Con_LineasCredito.actualizacion:
				lineasCreditoBean = lineasCreditoDAO.consultaActualizacion(lineasCredito, Enum_Con_LineasCredito.actualizacion);
			break;
			case Enum_Con_LineasCredito.agropecuaria:
				lineasCreditoBean = lineasCreditoDAO.consultaPrincipalAgro(lineasCredito, tipoConsulta);
			break;
			case Enum_Con_LineasCredito.agroInactiva:
				lineasCreditoBean = lineasCreditoDAO.consultaPrincipalAgro(lineasCredito, tipoConsulta);
			break;
		}
		return lineasCreditoBean;
	}

	public List<LineasCreditoBean> lista(int tipoLista, LineasCreditoBean lineasCredito){
		List<LineasCreditoBean> lineasCreditoLista = null;

		switch (tipoLista) {
			case  Enum_Lis_LineasCredito.lineasCredito:
				lineasCreditoLista = lineasCreditoDAO.listaLineaCredito(lineasCredito, tipoLista);
			break;
			case  Enum_Lis_LineasCredito.linCredAlt:
				lineasCreditoLista = lineasCreditoDAO.listaLineaAltaCred(lineasCredito, tipoLista);
			break;
			case  Enum_Lis_LineasCredito.linCredActivo:
				lineasCreditoLista = lineasCreditoDAO.listaLineaCredito(lineasCredito, tipoLista);
			break;
			case  Enum_Lis_LineasCredito.linCredInact:
				lineasCreditoLista = lineasCreditoDAO.listaLineaCredito(lineasCredito, tipoLista);
			break;
			case  Enum_Lis_LineasCredito.linCredBloq:
				lineasCreditoLista = lineasCreditoDAO.listaLineaCredito(lineasCredito, tipoLista);
			break;
			case  Enum_Lis_LineasCredito.linCredActBloq:
				lineasCreditoLista = lineasCreditoDAO.listaLineaCredito(lineasCredito, tipoLista);
			break;
			case Enum_Lis_LineasCredito.linCredAgropecuaria:
			case Enum_Lis_LineasCredito.lisLineaActivaAgro:
				lineasCreditoLista = lineasCreditoDAO.listaLineaCreaditoAgro(lineasCredito, tipoLista);
			break;
			case  Enum_Lis_LineasCredito.lisLineaInactiAgro:
				lineasCreditoLista = lineasCreditoDAO.listaLineaCreaditoAgro(lineasCredito, tipoLista);
			break;
		}
		return lineasCreditoLista;
	}

	//Se crea el Reporte de Lineas de Credito
	public ByteArrayOutputStream creaRepLineasCreditoPDF(LineasCreditoBean lineasCredito,String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();

		parametrosReporte.agregaParametro("Par_FechaInicio",lineasCredito.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin",lineasCredito.getFechaVencimiento());
		parametrosReporte.agregaParametro("Par_LineaCredito",Utileria.convierteEntero(lineasCredito.getLineaCreditoID()));
		parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(lineasCredito.getClienteID()));
		parametrosReporte.agregaParametro("Par_CreditoID",lineasCredito.getCreditoID());
		parametrosReporte.agregaParametro("Par_ProductoCredito",Utileria.convierteEntero(lineasCredito.getProductoCreditoID()));
		parametrosReporte.agregaParametro("Par_SucursalID",Utileria.convierteEntero(lineasCredito.getSucursalID()));
		parametrosReporte.agregaParametro("Par_Estatus",lineasCredito.getEstatus());
		parametrosReporte.agregaParametro("Par_FechaEmision",lineasCredito.getFechaActual());

		parametrosReporte.agregaParametro("Par_NomCliente",(!lineasCredito.getNombreCliente().isEmpty())? lineasCredito.getNombreCliente():"TODOS");
		parametrosReporte.agregaParametro("Par_NomProductoCre",(!lineasCredito.getNombreProducto().isEmpty())? lineasCredito.getNombreProducto():"TODOS");
		parametrosReporte.agregaParametro("Par_NomSucursal",(!lineasCredito.getNombreSucursal().isEmpty())? lineasCredito.getNombreSucursal():"TODOS");
		parametrosReporte.agregaParametro("Par_NomEstatus",(!lineasCredito.getNombreEstatus().isEmpty())? lineasCredito.getNombreEstatus():"TODOS");

		parametrosReporte.agregaParametro("Par_NomUsuario",(!lineasCredito.getNombreUsuario().isEmpty())? lineasCredito.getNombreUsuario():"TODOS");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!lineasCredito.getNombreInstitucion().isEmpty())? lineasCredito.getNombreInstitucion():"TODOS");
		parametrosReporte.agregaParametro("Par_FechaEmision",lineasCredito.getFechaEmision());

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}


	// Reporte Linea de Credito Agro en formato Excel
	public void reporteLineaCreditoAgroExcel(LineasCreditoBean lineasCreditoBean, HttpServletResponse response){
		String nombreArchivo = "";
		try{
			nombreArchivo = "REPORTE_LINEAS_CREDITO_AGRO.xls";
			List<LineasCreditoBean> listaLineas = lineasCreditoDAO.reporteLineasCreditoAgro(Enum_Rep_DepLineaCredito_Tipo.Principal_LineaCredito, lineasCreditoBean);

			XSSFWorkbook libro = new XSSFWorkbook();

			//Fuente Negrita con tamaño 10 para el titulo del reporte
			XSSFCellStyle estiloTitulo = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para cabeceras del reporte.
			XSSFCellStyle estiloCabecera = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para los Parametros del reporte.
			XSSFCellStyle estiloParametros = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_BOLD);

			//Fuente tamaño 10 para Texto
			XSSFCellStyle estiloTexto = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_NOBOLD);

			//Fuente tamaño 10 para Texto Centrado
			XSSFCellStyle estiloTextoCentrado = Utileria.crearFuente(libro, tamanioTexto, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_NOBOLD);

			//Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFCellStyle estiloDecimal = Utileria.crearFuenteDecimal(libro, 10, Constantes.FUENTE_NOBOLD);
			
			
			// Creacion de hoja
			XSSFSheet hoja = (XSSFSheet) libro.createSheet("REPORTE_LINEAS_CREDITO_AGRO");
			XSSFRow fila = hoja.createRow(0);
			// Nombre Institucion y Usuario
			fila = hoja.createRow(1);
			XSSFCell celda=fila.createCell((short)1);
			celda.setCellValue(lineasCreditoBean.getNombreInstitucion());
			celda.setCellStyle(estiloTitulo);
			hoja.addMergedRegion(new CellRangeAddress(1, 1, 1, 11));
			celda = fila.createCell((short)12);
			celda.setCellValue("Usuario:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)13);
			celda.setCellValue((!lineasCreditoBean.getClaveUsuario().isEmpty())?lineasCreditoBean.getClaveUsuario(): "TODOS");
			celda.setCellStyle(estiloTexto);
			String horaReporte  = lineasCreditoBean.getHoraEmision();
			String fechaReporte = lineasCreditoBean.getFechaEmision();

			// Titulo del Reporte y Fecha
			fila = hoja.createRow(2);
			celda = fila.createCell((short)1);
			celda.setCellValue("REPORTE DE LÍNEAS DE CRÉDITO AGROPECUARIAS " + lineasCreditoBean.getFechaInicio() + " AL " + lineasCreditoBean.getFechaVencimiento());
			celda.setCellStyle(estiloTitulo);
			hoja.addMergedRegion(new CellRangeAddress(2, 2, 1, 11));
			celda = fila.createCell((short)12);
			celda.setCellValue("Fecha:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)13);
			celda.setCellValue(fechaReporte);
			celda.setCellStyle(estiloTexto);

			// Hora del Reporte
			fila = hoja.createRow(3);
			celda = fila.createCell((short)12);
			celda.setCellValue("Hora:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)13);
			celda.setCellValue(horaReporte);
			celda.setCellStyle(estiloTexto);
			fila = hoja.createRow(4);
			fila = hoja.createRow(5);
			celda = fila.createCell((short)1);
			celda.setCellValue("Fecha Inicio Registro:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)2);
			celda.setCellValue(lineasCreditoBean.getFechaInicio());
			celda.setCellStyle(estiloTexto);
			celda = fila.createCell((short)3);
			celda.setCellValue("Fecha Final Registro:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)4);
			celda.setCellValue(lineasCreditoBean.getFechaVencimiento());
			celda.setCellStyle(estiloTexto);

			celda = fila.createCell((short)5);
			celda.setCellValue("Línea de Crédito:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)6);
			celda.setCellValue((!lineasCreditoBean.getLineaCreditoID().isEmpty())?lineasCreditoBean.getLineaCreditoID(): "TODOS");
			celda.setCellStyle(estiloTexto);

			celda = fila.createCell((short)7);
			celda.setCellValue("Cliente:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)8);
			celda.setCellValue((!lineasCreditoBean.getNombreCliente().isEmpty())?lineasCreditoBean.getNombreCliente(): "TODOS");
			celda.setCellStyle(estiloTexto);

			celda = fila.createCell((short)9);
			celda.setCellValue("Producto Crédito:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)10);
			celda.setCellValue((!lineasCreditoBean.getNombreProducto().isEmpty())?lineasCreditoBean.getProductoCreditoID(): "TODOS");
			celda.setCellStyle(estiloTexto);

			celda = fila.createCell((short)11);
			celda.setCellValue("Sucursal:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)12);
			celda.setCellValue(lineasCreditoBean.getNombreSucursal());
			celda.setCellStyle(estiloTexto);
			
			celda = fila.createCell((short)13);
			celda.setCellValue("Estatus:");
			celda.setCellStyle(estiloParametros);
			celda = fila.createCell((short)14);
			celda.setCellValue((!lineasCreditoBean.getNombreEstatus().isEmpty())?lineasCreditoBean.getNombreEstatus(): "TODOS");
			celda.setCellStyle(estiloTexto);
			fila = hoja.createRow(6);
			fila = hoja.createRow(7);
			// Encabezados de los campos
			XSSFCell celdaEncabezados = fila.createCell((short)1);
			celdaEncabezados = fila.createCell((short)1);
			celdaEncabezados.setCellValue("Línea Crédito ID");
			celdaEncabezados.setCellStyle(estiloCabecera);
			celdaEncabezados = fila.createCell((short)2);
			celdaEncabezados.setCellValue("Cuenta");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)3);
			celdaEncabezados.setCellValue("Folio Contrato");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)4);
			celdaEncabezados.setCellValue("Fecha Inicio");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)5);
			celdaEncabezados.setCellValue("Fecha Vencimiento");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)6);
			celdaEncabezados.setCellValue("Monto Solicitado");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)7);
			celdaEncabezados.setCellValue("Monto Autorizado");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)8);
			celdaEncabezados.setCellValue("Monto Dispuesto");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)9);
			celdaEncabezados.setCellValue("Monto Pagado");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)10);
			celdaEncabezados.setCellValue("Monto Disponible");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)11);
			celdaEncabezados.setCellValue("Saldo Deudor");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)12);
			celdaEncabezados.setCellValue("Estatus");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)13);
			celdaEncabezados.setCellValue("Número Créditos");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			int iteracion = Constantes.ENTERO_CERO;
			int numRegistros = Constantes.ENTERO_CERO;
			
			int renglon = 8;
			int tamanioLista = listaLineas.size();
		    LineasCreditoBean lineasCredito = null;
			for( iteracion=Constantes.ENTERO_CERO; iteracion<tamanioLista; iteracion++){

				lineasCredito = (LineasCreditoBean) listaLineas.get(iteracion );
				fila=hoja.createRow(renglon);
				XSSFCell celdaCuerpo = fila.createCell((short)1);

				celdaCuerpo=fila.createCell((short)1);
				celdaCuerpo.setCellValue(Utileria.convierteEntero(lineasCredito.getLineaCreditoID()));
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)2);
				celdaCuerpo.setCellValue(Utileria.convierteEntero(lineasCredito.getCuentaID()));
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)3);
				celdaCuerpo.setCellValue(lineasCredito.getFolioContrato());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)4);
				celdaCuerpo.setCellValue(lineasCredito.getFechaInicio());
				celdaCuerpo.setCellStyle(estiloTextoCentrado);

				celdaCuerpo=fila.createCell((short)5);
				celdaCuerpo.setCellValue(lineasCredito.getFechaVencimiento());
				celdaCuerpo.setCellStyle(estiloTextoCentrado);

				celdaCuerpo=fila.createCell((short)6);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(lineasCredito.getSolicitado()));
				celdaCuerpo.setCellStyle(estiloDecimal);

				celdaCuerpo=fila.createCell((short)7);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(lineasCredito.getAutorizado()));
				celdaCuerpo.setCellStyle(estiloDecimal);

				celdaCuerpo=fila.createCell((short)8);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(lineasCredito.getDispuesto()));
				celdaCuerpo.setCellStyle(estiloDecimal);

				celdaCuerpo=fila.createCell((short)9);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(lineasCredito.getPagado()));
				celdaCuerpo.setCellStyle(estiloDecimal);

				celdaCuerpo=fila.createCell((short)10);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(lineasCredito.getSaldoDisponible()));
				celdaCuerpo.setCellStyle(estiloDecimal);
				
				celdaCuerpo=fila.createCell((short)11);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(lineasCredito.getSaldoDeudor()));
				celdaCuerpo.setCellStyle(estiloDecimal);
				
				celdaCuerpo=fila.createCell((short)12);
				celdaCuerpo.setCellValue(lineasCredito.getEstatus());
				celdaCuerpo.setCellStyle(estiloTextoCentrado);
				
				celdaCuerpo=fila.createCell((short)13);
				celdaCuerpo.setCellValue(Utileria.convierteEntero(lineasCredito.getNumeroCreditos()));
				celdaCuerpo.setCellStyle(estiloTextoCentrado);
				
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

			for(int celdaAjustar=0; celdaAjustar <= 13; celdaAjustar++){
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
			loggerSAFI.info("error en el Reporte de Líneas de Crédito Agro " + exception);
		}
	}

	//------------------ Geters y Seters ------------------------------------------------------
	public void setLineasCreditoDAO(LineasCreditoDAO lineasCreditoDAO) {
		this.lineasCreditoDAO = lineasCreditoDAO;
	}

	public LineasCreditoDAO getLineasCreditoDAO() {
		return lineasCreditoDAO;
	}

}
