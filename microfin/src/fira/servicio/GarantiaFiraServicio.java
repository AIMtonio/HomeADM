package fira.servicio;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import fira.bean.GarantiaFiraBean;
import fira.dao.GarantiaFiraDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

public class GarantiaFiraServicio extends BaseServicio {

	GarantiaFiraDAO garantiaFiraDAO = null;

	public GarantiaFiraDAO getGarantiaFiraDAO() {
		return garantiaFiraDAO;
	}

	public void setGarantiaFiraDAO(GarantiaFiraDAO garantiaFiraDAO) {
		this.garantiaFiraDAO = garantiaFiraDAO;
	}

	public GarantiaFiraServicio(){
		super();
	}

	public static interface Enum_Tran_Garantia{
		int alta = 1;
		int aplicaGarantias = 2;
		int cancelaGarantias = 13;
	}

	public static interface Enum_Con_Garantia {
		int garantias = 1;
	}

	public static interface Enum_Rep_GarantiasExcel {
		int reporteCreditoAfectacionGarantia  = 1;
	}


	public MensajeTransaccionBean grabaTransaccion(GarantiaFiraBean garantiaFiraBean, int tipoTransaccion){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Tran_Garantia.alta:
				mensaje = procesaAltaGarantiasFira(garantiaFiraBean, tipoTransaccion);
				break;
			case Enum_Tran_Garantia.aplicaGarantias:
				mensaje = procesaApliGarantiasFira(garantiaFiraBean, tipoTransaccion);
				break;
			case Enum_Tran_Garantia.cancelaGarantias:
				mensaje = cancelacionGarantiasFira(garantiaFiraBean, tipoTransaccion);
				break;
		}

		return mensaje;
	}

	private MensajeTransaccionBean procesaAltaGarantiasFira(GarantiaFiraBean garantiaFiraBean,int tipoTransaccion) {
		MensajeTransaccionBean mensaje = null;
		ArrayList<GarantiaFiraBean> listaCreditos = creaListaCreditos(garantiaFiraBean);
		mensaje = garantiaFiraDAO.registraCreditosConGarSinFondeo(garantiaFiraBean, listaCreditos,tipoTransaccion);

		return mensaje;
	}

	private MensajeTransaccionBean procesaApliGarantiasFira(GarantiaFiraBean garantiaFiraBean,int tipoTransaccion) {
		MensajeTransaccionBean mensaje = null;
		mensaje = garantiaFiraDAO.aplicacionGtiaFira(garantiaFiraBean,tipoTransaccion);

		return mensaje;
	}

	private MensajeTransaccionBean cancelacionGarantiasFira(GarantiaFiraBean garantiaFiraBean,int tipoTransaccion) {
		MensajeTransaccionBean mensaje = null;
		mensaje = garantiaFiraDAO.cancelaGarantiasFira(garantiaFiraBean,tipoTransaccion);

		return mensaje;
	}



	public GarantiaFiraBean consulta(int tipoConsulta,GarantiaFiraBean garantiaFiraBean){
		GarantiaFiraBean garantias= null;
		switch(tipoConsulta){
			case Enum_Con_Garantia.garantias:
				garantias = garantiaFiraDAO.bitacoApliGarAgro(tipoConsulta,garantiaFiraBean);
			break;
		}
		return garantias;
	}

	private ArrayList<GarantiaFiraBean> creaListaCreditos(GarantiaFiraBean garantiaFiraBean) {
		ArrayList<GarantiaFiraBean> listaGarantias = new ArrayList();
		List<String> listaCredito = garantiaFiraBean.getLisCreditoID();
		List<String> listaTipoGarantia = garantiaFiraBean.getLisTipoGarantiaID();
		GarantiaFiraBean garantiaFira = null;

		for(int pos=0 ; pos < listaTipoGarantia.size() ; pos++){
			garantiaFira = new GarantiaFiraBean();
			garantiaFira.setCreditoID(listaCredito.get(pos));
			garantiaFira.setTipoGarantiaID(listaTipoGarantia.get(pos));


			if(!garantiaFira.getTipoGarantiaID().equals("")){
				if(garantiaFira.getTipoGarantiaID().equals("4")){
					garantiaFira.setEsCancelado("S");
				}else{
					garantiaFira.setEsCancelado("N");
				}

				listaGarantias.add(garantiaFira);
			}
		}


		return listaGarantias;
	}

	// Reporte de Créditos con Afectación de Garantía Periódico
	public void reporteCreditoAfectacionGarantia(GarantiaFiraBean garantiaFiraBean, HttpServletResponse response) {

		List<GarantiaFiraBean> listaGarantias = null;
		String nombreArchivo = "";

		try{

			nombreArchivo = "Reporte_Creditos_Afectaciones_Garantias.xls";
			listaGarantias = garantiaFiraDAO.reporteCreditoAfectacionGarantia(garantiaFiraBean, Enum_Rep_GarantiasExcel.reporteCreditoAfectacionGarantia);
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

			//Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFCellStyle estiloDecimal = Utileria.crearFuenteDecimal(libro, 10,  Constantes.FUENTE_NOBOLD);

			// Creacion de hoja
			XSSFSheet hoja = libro.createSheet("REPORTE_CREDITOS_AFECTADOS_GARANTIA");
			XSSFRow fila= hoja.createRow(0);

			// Nombre Institucion y Usuario
			fila = hoja.createRow(1);
			XSSFCell celdaNombreUsuario=fila.createCell((short)1);
			celdaNombreUsuario = fila.createCell((short)25);
			celdaNombreUsuario.setCellValue("Usuario:");
			celdaNombreUsuario.setCellStyle(estiloParametros);
			celdaNombreUsuario = fila.createCell((short)26);
			celdaNombreUsuario.setCellValue((!garantiaFiraBean.getNombreUsuario().isEmpty())?garantiaFiraBean.getNombreUsuario(): "TODOS");
			celdaNombreUsuario.setCellStyle(estiloTexto);

			String horaReporte  = garantiaFiraBean.getHoraEmision();
			String fechaReporte = garantiaFiraBean.getFechaEmision();

			// Titulo del Reporte y Fecha
			fila = hoja.createRow(2);
			XSSFCell celdaInstitucion = fila.createCell((short)1);
			celdaInstitucion.setCellValue(garantiaFiraBean.getNombreInstitucion());
			celdaInstitucion.setCellStyle(estiloTitulo);
			hoja.addMergedRegion(new CellRangeAddress(2, 2, 1, 24));

			celdaInstitucion = fila.createCell((short)25);
			celdaInstitucion.setCellValue("Fecha:");
			celdaInstitucion.setCellStyle(estiloParametros);
			celdaInstitucion = fila.createCell((short)26);
			celdaInstitucion.setCellValue(fechaReporte);
			celdaInstitucion.setCellStyle(estiloTexto);

			// Rango de Fechas del Reporte y hora
			fila = hoja.createRow(3);
			XSSFCell celdaNombreReporte = fila.createCell((short)1);
			celdaNombreReporte.setCellValue("REPORTE DE CRÉDITO CON AFECTACIÓN DE GARANTÍA DEL " + garantiaFiraBean.getRangoFechas());
			celdaNombreReporte.setCellStyle(estiloTitulo);
			hoja.addMergedRegion(new CellRangeAddress(3, 3, 1, 24));

			celdaNombreReporte = fila.createCell((short)25);
			celdaNombreReporte.setCellValue("Hora:");
			celdaNombreReporte.setCellStyle(estiloParametros);
			celdaNombreReporte = fila.createCell((short)26);
			celdaNombreReporte.setCellValue(horaReporte);
			celdaNombreReporte.setCellStyle(estiloTexto);

			fila = hoja.createRow(4);
			fila = hoja.createRow(5);

			XSSFCell celdaParametros = fila.createCell((short)1);
			celdaParametros = fila.createCell((short)1);
			celdaParametros.setCellValue("Sucursal:");
			celdaParametros.setCellStyle(estiloParametros);
			celdaParametros = fila.createCell((short)2);
			celdaParametros.setCellValue(garantiaFiraBean.getNombreSucursal());
			celdaParametros.setCellStyle(estiloTexto);

			celdaParametros = fila.createCell((short)4);
			celdaParametros.setCellValue("Producto de Crédito:");
			celdaParametros.setCellStyle(estiloParametros);
			celdaParametros = fila.createCell((short)5);
			celdaParametros.setCellValue(garantiaFiraBean.getNombreProductoCredito());
			celdaParametros.setCellStyle(estiloTexto);

			celdaParametros = fila.createCell((short)7);
			celdaParametros.setCellValue("Tipo de Garantía:");
			celdaParametros.setCellStyle(estiloParametros);
			celdaParametros = fila.createCell((short)8);
			celdaParametros.setCellValue(garantiaFiraBean.getTipoGarantia());
			celdaParametros.setCellStyle(estiloTexto);

			fila = hoja.createRow(6);
			fila = hoja.createRow(7);
			XSSFCell celdaEncabezados = fila.createCell((short)1);

			celdaEncabezados = fila.createCell((short)1);
			celdaEncabezados.setCellValue("No. Registro");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)2);
			celdaEncabezados.setCellValue("Sucursal");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)3);
			celdaEncabezados.setCellValue("Tipo Crédito");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)4);
			celdaEncabezados.setCellValue("ID Crédito Activo");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)5);
			celdaEncabezados.setCellValue("ID Crédito Pasivo");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)6);
			celdaEncabezados.setCellValue("ID Crédito Contingente");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)7);
			celdaEncabezados.setCellValue("ID Crédito Fondeador");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)8);
			celdaEncabezados.setCellValue("ID Pasivo Contingente");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)9);
			celdaEncabezados.setCellValue("Estatus");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)10);
			celdaEncabezados.setCellValue("Tipo Garantía");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)11);
			celdaEncabezados.setCellValue("Nombre Acreditado");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)12);
			celdaEncabezados.setCellValue("Fuente de Fondeo \nantes de afectar \nla garantía");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)13);
			celdaEncabezados.setCellValue("Causa de pago");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)14);
			celdaEncabezados.setCellValue("Cadena Productiva");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)15);
			celdaEncabezados.setCellValue("Monto Otorgado de Garantía");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)16);
			celdaEncabezados.setCellValue("Fecha de Otorgamiento \nde la afectación de \nla garantía");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)17);
			celdaEncabezados.setCellValue("Fecha última recuperación");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)18);
			celdaEncabezados.setCellValue("Saldo Capital");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)19);
			celdaEncabezados.setCellValue("Saldo Interés");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)20);
			celdaEncabezados.setCellValue("Monto Total Recuperado \nde Capital");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)21);
			celdaEncabezados.setCellValue("Monto Total Recuperado \nInterés");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)22);
			celdaEncabezados.setCellValue("Monto Pendiente Recuperar \nCapital");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)23);
			celdaEncabezados.setCellValue("Monto Pendiente Recuperar \nInterés");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)24);
			celdaEncabezados.setCellValue("Saldo Incobrable");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)25);
			celdaEncabezados.setCellValue("Total Recuperado (Cap.+Int.)");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)26);
			celdaEncabezados.setCellValue("Antigüedad de saldo \nen años");
			celdaEncabezados.setCellStyle(estiloCabecera);


			int renglon = 8;
			int iteracion = 0;
			int numRegistros = 0;
			int tamanioLista = listaGarantias.size();
			GarantiaFiraBean garantiaFira = null;

			for( iteracion =0; iteracion <tamanioLista; iteracion  ++){

				garantiaFira = (GarantiaFiraBean) listaGarantias.get(iteracion );
				fila=hoja.createRow(renglon);
				XSSFCell celdaCuerpo = fila.createCell((short)1);

				celdaCuerpo=fila.createCell((short)1);
				celdaCuerpo.setCellValue(Utileria.convierteEntero(garantiaFira.getConsecutivo()));
				celdaCuerpo.setCellStyle(estiloTextoCentrado);

				celdaCuerpo=fila.createCell((short)2);
				celdaCuerpo.setCellValue(garantiaFira.getNombreSucursal());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)3);
				celdaCuerpo.setCellValue(garantiaFira.getTipoCredito());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)4);
				celdaCuerpo.setCellValue(Utileria.convierteLong(garantiaFira.getCreditoActivo()));
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)5);
				celdaCuerpo.setCellValue(Utileria.convierteLong(garantiaFira.getCreditoPasivo()));
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)6);
				celdaCuerpo.setCellValue(Utileria.convierteLong(garantiaFira.getCreditoContigente()));
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)7);
				celdaCuerpo.setCellValue(Utileria.convierteLong(garantiaFira.getCreditoFondeador()));
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)8);
				celdaCuerpo.setCellValue(Utileria.convierteLong(garantiaFira.getCreditoPasivoContigente()));
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)9);
				celdaCuerpo.setCellValue(garantiaFira.getEstatus());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)10);
				celdaCuerpo.setCellValue(garantiaFira.getTipoGarantia());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)11);
				celdaCuerpo.setCellValue(garantiaFira.getNombreCliente());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)12);
				celdaCuerpo.setCellValue(garantiaFira.getFuenteFondeo());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)13);
				celdaCuerpo.setCellValue(garantiaFira.getCausaPago());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)14);
				celdaCuerpo.setCellValue(garantiaFira.getCadenaProductiva());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo=fila.createCell((short)15);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(garantiaFira.getMontoGarantia()));
				celdaCuerpo.setCellStyle(estiloDecimal);

				celdaCuerpo=fila.createCell((short)16);
				celdaCuerpo.setCellValue(garantiaFira.getFechaGarantia());
				celdaCuerpo.setCellStyle(estiloTextoCentrado);

				celdaCuerpo=fila.createCell((short)17);
				celdaCuerpo.setCellValue(garantiaFira.getFechaAfectacion());
				celdaCuerpo.setCellStyle(estiloTextoCentrado);

				celdaCuerpo=fila.createCell((short)18);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(garantiaFira.getSaldoCapital()));
				celdaCuerpo.setCellStyle(estiloDecimal);

				celdaCuerpo=fila.createCell((short)19);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(garantiaFira.getSaldoInteres()));
				celdaCuerpo.setCellStyle(estiloDecimal);

				celdaCuerpo=fila.createCell((short)20);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(garantiaFira.getMontoTotalCapitalRecuperado()));
				celdaCuerpo.setCellStyle(estiloDecimal);

				celdaCuerpo=fila.createCell((short)21);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(garantiaFira.getMontoTotalInteresRecuperado()));
				celdaCuerpo.setCellStyle(estiloDecimal);

				celdaCuerpo=fila.createCell((short)22);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(garantiaFira.getMontoPendienteCapitalRecuperado()));
				celdaCuerpo.setCellStyle(estiloDecimal);

				celdaCuerpo=fila.createCell((short)23);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(garantiaFira.getMontoPendienteInteresRecuperado()));
				celdaCuerpo.setCellStyle(estiloDecimal);

				celdaCuerpo=fila.createCell((short)24);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(garantiaFira.getSaldoIncobrable()));
				celdaCuerpo.setCellStyle(estiloDecimal);

				celdaCuerpo=fila.createCell((short)25);
				celdaCuerpo.setCellValue(Utileria.convierteDoble(garantiaFira.getTotalRecuperado()));
				celdaCuerpo.setCellStyle(estiloDecimal);

				celdaCuerpo=fila.createCell((short)26);
				celdaCuerpo.setCellValue(garantiaFira.getAntiguedad());
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

			for(int celdaAjustar=0; celdaAjustar <= 26; celdaAjustar++){
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
			loggerSAFI.info("error en el Reporte de Créditos con Afectación de Garantía Periódico  " + exception);
		}

	}
}
