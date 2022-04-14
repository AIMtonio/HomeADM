package regulatorios.reporte;

import general.bean.MensajeTransaccionBean;

import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.DesagregadoCarteraC0451Bean;
import regulatorios.servicio.DesagregadoCarteraC0451Servicio;

public class RegulatorioC0451ReporteControlador extends AbstractCommandController  {

	public static interface Enum_Con_TipReporte {
		  int  ReporPantalla= 1;
		  int  ReporPDF= 2;
		  int  ReporExcel= 3;
		  int  ReporCsv= 4;
	}

	DesagregadoCarteraC0451Servicio desagregadoCarteraC0451Servicio = null;
	String successView = null;

	public RegulatorioC0451ReporteControlador () {
		setCommandClass(DesagregadoCarteraC0451Bean.class);
		setCommandName("C0451");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response,
								  Object command, BindException errors)throws Exception {

		MensajeTransaccionBean mensaje = null;
		DesagregadoCarteraC0451Bean c0451Bean = (DesagregadoCarteraC0451Bean) command;

		int tipoReporte =(request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")): 0;
		int tipoLista =(request.getParameter("tipoLista")!=null)?Integer.parseInt(request.getParameter("tipoLista")):0;
		int version=(request.getParameter("version")!=null)?Integer.parseInt(request.getParameter("version")):2017;

		switch(tipoReporte){
			case 1:
				List<DesagregadoCarteraC0451Bean> listaReportes2015 = reporteC0451Version2015Excel(tipoLista,c0451Bean,response);
			break;
			case 2:
					desagregadoCarteraC0451Servicio.consultaRegulatorioC0451VersionSOFIPO(tipoLista,c0451Bean,response);

			break;
			}
		return null;
		}



	/**
	 * Generacion de reporte C0451 en Excel version 2015
	 * @param tipoLista
	 * @param version
	 * @param c0451Bean
	 * @param response
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public List<DesagregadoCarteraC0451Bean>reporteC0451Version2015Excel(int tipoLista, DesagregadoCarteraC0451Bean c0451Bean,  HttpServletResponse response){
		List<DesagregadoCarteraC0451Bean> listaC0451Bean = null;
		String mesEnLetras	= "";
		String anio		= "";
		String nombreArchivo = "";

		mesEnLetras = desagregadoCarteraC0451Servicio.descripcionMes(c0451Bean.getFecha().substring(5,7));
		anio	= c0451Bean.getFecha().substring(0,4);
		nombreArchivo = "R04_C_451_"+mesEnLetras +"_"+anio;

		/*Se hace la llamada para obtener la lista para llenar el reporte*/
		listaC0451Bean = desagregadoCarteraC0451Servicio.consultaRegulatorioC0451VersionSOFIPO(tipoLista,c0451Bean,response);
		int contador = 1;

		if(listaC0451Bean != null){
			try {
				//////////////////////////////////////////////////////////////////////////////////////
				////////////////////// ENCABEZADO y CONFIGURACION DEL  EXCEL /////////////////////////////////////////
				SXSSFWorkbook libro = new SXSSFWorkbook();
				Font fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setFontName("Negrita");
				fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);

				Font fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)8);

				CellStyle estilo8 = libro.createCellStyle();
				estilo8.setFont(fuente8);

				CellStyle estiloFormatoTasa = libro.createCellStyle();
				DataFormat format = libro.createDataFormat();
				estiloFormatoTasa.setDataFormat(format.getFormat("0.0000"));
				estiloFormatoTasa.setFont(fuente8);

				//Encabezado agrupaciones
				CellStyle estiloAgrupacion = libro.createCellStyle();
				estiloAgrupacion.setAlignment((short)CellStyle.ALIGN_CENTER);
				estiloAgrupacion.setVerticalAlignment((short)CellStyle.VERTICAL_CENTER);
				estiloAgrupacion.setBorderTop((short)CellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderBottom((short)CellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderRight((short)CellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setBorderLeft((short)CellStyle.BORDER_MEDIUM);
				estiloAgrupacion.setFont(fuenteNegrita8);
				estiloAgrupacion.setWrapText(true);
				estiloAgrupacion.setFillBackgroundColor(HSSFColor.GREY_25_PERCENT.index);
				estiloAgrupacion.setFillPattern(CellStyle.SOLID_FOREGROUND);

				//Estilo negrita tamaño 8 centrado
				CellStyle estiloEncabezado = libro.createCellStyle();
				estiloEncabezado.setAlignment((short)CellStyle.ALIGN_CENTER);
				estiloEncabezado.setVerticalAlignment((short)CellStyle.VERTICAL_CENTER);
				estiloEncabezado.setBorderTop((short)CellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderBottom((short)CellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderRight((short)CellStyle.BORDER_MEDIUM);
				estiloEncabezado.setBorderLeft((short)CellStyle.BORDER_MEDIUM);
				estiloEncabezado.setFont(fuenteNegrita8);
				estiloEncabezado.setWrapText(true);


				// Creacion de hoja
				Sheet hoja = libro.createSheet("R04 C 451");
				Row fila = hoja.createRow(0);
				fila = hoja.createRow(0);
				Cell celda=fila.createCell((short)1);
				/////////////////////////////////////////////////////////////////////////////////////
				///////////////////////// FIN ENCABEZADO EXCEL //////////////////////////////////////

					//AGREGAR GRUPOS DE COLUMNAS
					//////////////////////////////////////////////////////////////////////////////
					fila = hoja.createRow(0);
					celda=fila.createCell((short)0);
					celda.setCellValue("SECCIÓN IDENTIFICADOR DEL REPORTE");
					celda.setCellStyle(estiloAgrupacion);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            2  //ultima celda   (0-based)
				    ));

					celda=fila.createCell((short)3);
					celda.setCellValue("SECCIÓN IDENTIFICADOR DEL ACREDITADO");
					celda.setCellStyle(estiloAgrupacion);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            3, //primer celda (0-based)
				            27 //ultima celda   (0-based)
				    ));

					celda=fila.createCell((short)28);
					celda.setCellValue("SECCIÓN IDENTIFICADOR DEL CRÉDITO");
					celda.setCellStyle(estiloAgrupacion);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            28, //primer celda (0-based)
				            39  //ultima celda   (0-based)
				    ));

					celda=fila.createCell((short)40);
					celda.setCellValue("SECCIÓN DE CONDICIONES FINANCIERAS");
					celda.setCellStyle(estiloAgrupacion);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            40, //primer celda (0-based)
				            55  //ultima celda   (0-based)
				    ));

					celda=fila.createCell((short)56);
					celda.setCellValue("SECCIÓN DATOS DE LA VIVIENDA");
					celda.setCellStyle(estiloAgrupacion);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            56, //primer celda (0-based)
				            59  //ultima celda   (0-based)
				    ));

					celda=fila.createCell((short)60);
					celda.setCellValue("SECCIÓN DE UBICACIÓN GEOGRÁFICA Y ACTIVIDAD ECONÓMICA A LA QUE SE DESTINARÁ EL CRÉDITO");
					celda.setCellStyle(estiloAgrupacion);
					//funcion para unir celdas
					hoja.addMergedRegion(new CellRangeAddress(
				            0, //primera fila (0-based)
				            0, //ultima fila  (0-based)
				            60, //primer celda (0-based)
				            63  //ultima celda   (0-based)
				    ));

					////////////////////////////////////////////////////////////////////////////////

					//Titulos del Reporte
					fila = hoja.createRow(1);
					fila.setHeight((short)1500);

					celda=fila.createCell((short)0);
					celda.setCellValue("PERÍODO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)1);
					celda.setCellValue("CLAVE DE LA ENTIDAD");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)2);
					celda.setCellValue("REPORTE");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)3);
					celda.setCellValue("NÚMERO DE CLIENTE");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)4);
					celda.setCellValue("TIPO DE CLIENTE\n(ACREDITADO Y AHORRADOR)");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)5);
					celda.setCellValue("NOMBRE(S) O RAZÓN SOCIAL\nDEL ACREDITADO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)6);
					celda.setCellValue("APELLIDO PATERNO DEL\nACREDITADO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)7);
					celda.setCellValue("APELLIDO MATERNO DEL\nACREDITADO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)8);
					celda.setCellValue("PERSONALIDAD JURÍDICA\nDEL ACREDITADO ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)9);
					celda.setCellValue("GRUPO DE RIESGO COMÚN");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)10);
					celda.setCellValue("ACTIVIDAD ECONÓMICA DEL\nACREDITADO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)11);
					celda.setCellValue("NACIONALIDAD DEL\nACREDITADO ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)12);
					celda.setCellValue("FECHA DE NACIMIENTO DEL\nACREDITADO O FECHA DE\nCONSTITUCIÓN DE LA\nEMPRESA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)13);
					celda.setCellValue("RFC DEL ACREDITADO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)14);
					celda.setCellValue("CLAVE UNICA DE REGISTRO\nDE POBLACIÓN (CURP) DEL\nACREDITADO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)15);
					celda.setCellValue("GÉNERO DEL ACREDITADO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)16);
					celda.setCellValue("CALLE DEL DOMICILIO DEL\nACREDITADO ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)17);
					celda.setCellValue("NÚMERO EXTERIOR DEL\nDOMICILIO DEL ACREDITADO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)18);
					celda.setCellValue("COLONIA DEL DOMICILIO DEL\nACREDITADO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)19);
					celda.setCellValue("CÓDIGO POSTAL DEL\nDOMICILIO DEL ACREDITADO ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)20);
					celda.setCellValue("LOCALIDAD DEL DOMICILIO\nDEL ACREDITADO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)21);
					celda.setCellValue("ESTADO DEL DOMICILIO DEL\nACREDITADO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)22);
					celda.setCellValue("MUNICIPIO DEL DOMICILIO\nDEL ACREDITADO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)23);
					celda.setCellValue("PAÍS DEL DOMCILIO DEL\nACREDITADO ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)24);
					celda.setCellValue("TIPO DE ACREDITADO\nRELACIONADO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)25);
					celda.setCellValue("NÚMERO DE CONSULTA\nREALIZADA A LA SOCIEDAD\nDE INFORMACIÓN CREDITICIA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)26);
					celda.setCellValue("INGRESOS MENSUALES DEL\nACREDITADO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)27);
					celda.setCellValue("TAMAÑO DEL ACREDITADO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)28);
					celda.setCellValue("IDENTIFICADOR DEL CRÉDITO\nASIGNADO METODOLOGÍA CNBV ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)29);
					celda.setCellValue("IDENTIFICADOR DEL CRÉDITO\nLÍNEA GRUPAL ASIGNADO\nMETODOLOGÍA CNBV");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)30);
					celda.setCellValue("FECHA DE OTORGAMIENTO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)31);
					celda.setCellValue("TIPO DE ALTA DEL CRÉDITO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)32);
					celda.setCellValue("TIPO DE CARTERA CREDITICIA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)33);
					celda.setCellValue("TIPO DE PRODUCTO ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)34);
					celda.setCellValue("DESTINO DEL CRÉDITO ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)35);
					celda.setCellValue("CLAVE DE LA SUCURSAL QUE\nOPERA EL CRÉDITO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)36);
					celda.setCellValue("NÚMERO DE CUENTA ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)37);
					celda.setCellValue("NÚMERO DEL CONTRATO DE\nCRÉDITO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)38);
					celda.setCellValue("NOMBRE DEL FACTORADO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)39);
					celda.setCellValue("RFC DEL FACTORADO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)40);
					celda.setCellValue("MONTO DE LA LÍNEA DE\nCRÉDITO AUTORIZADO\nVALORIZADO EN PESOS");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)41);
					celda.setCellValue("MONTO DE LA LÍNEA DE\nCRÉDITO AUTORIZADO\nEXPRESADO EN LA MONEDA\nDE ORIGEN");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)42);
					celda.setCellValue("FECHA MÁXIMA PARA\nDISPONER LOS RECURSOS ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)43);
					celda.setCellValue("FECHA DE VENCIMIENTO DE\nLA LÍNEA DE CRÉDITO ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)44);
					celda.setCellValue("FORMA DE LA DISPOSICIÓN ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)45);
					celda.setCellValue("TASA DE INTERÉS DE\nREFERENCIA");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)46);
					celda.setCellValue("DIFERENCIAL SOBRE LA TASA\nDE REFERENCIA DE LA LÍNEA\nDE CRÉDITO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)47);
					celda.setCellValue("OPERACIÓN DIFERENCIAL\nSOBRE TASA DE REFERENCIA\n(ADITIVA O FACTOR) DE LA\nLÍNEA DE CRÉDITO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)48);
					celda.setCellValue("TIPO DE MONEDA ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)49);
					celda.setCellValue("PERIODICIDAD PAGOS DE\nCAPITAL ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)50);
					celda.setCellValue("PERIODICIDAD PAGOS DE\nINTERÉS");
					celda.setCellStyle(estiloEncabezado);


					celda=fila.createCell((short)51);
					celda.setCellValue("PERIODO DE FACTURACIÓN");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)52);
					celda.setCellValue("COMISIÓN DE APERTURA DEL\nCRÉDITO (TASA)");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)53);
					celda.setCellValue("COMISIÓN DE APERTURA DEL\nCRÉDITO (MONTO) ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)54);
					celda.setCellValue("COMISIÓN POR DISPOSICIÓN\nDEL CRÉDITO (TASA) ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)55);
					celda.setCellValue("COMISIÓN POR DISPOSICIÓN\nDEL CRÉDITO (MONTO)  ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)56);
					celda.setCellValue("VALOR DE LA VIVIENDA AL\nMOMENTO DE LA\nORIGINACIÓN");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)57);
					celda.setCellValue("VALOR DEL INMUEBLE SEGÚN\nAVALÚO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)58);
					celda.setCellValue("NÚMERO DE AVALÚO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)59);
					celda.setCellValue("LOAN TO VALUE (LTV)");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)60);
					celda.setCellValue("LOCALIDAD EN DONDE SE\nDESTINARÁ EL CRÉDITO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)61);
					celda.setCellValue("MUNICIPIO EN DONDE SE\nDESTINARÁ EL CRÉDITO ");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)62);
					celda.setCellValue("ESTADO EN DONDE SE\nDESTINARÁ EL CRÉDITO");
					celda.setCellStyle(estiloEncabezado);

					celda=fila.createCell((short)63);
					celda.setCellValue("ACTIVIDAD ECONÓMICA A LA\nQUE SE DESTINARÁ EL CRÉDITO");
					celda.setCellStyle(estiloEncabezado);

					for (int celd = 0; celd <= 65; celd++){
						hoja.autoSizeColumn(celd, true);
					}

					int rowExcel=2;
					contador=2;
					for(DesagregadoCarteraC0451Bean regC0451Bean : listaC0451Bean ){

						fila=hoja.createRow(rowExcel);
						fila = hoja.createRow(contador);
						celda=fila.createCell((short)0);
						celda.setCellValue(regC0451Bean.getPeriodo());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)1);
						celda.setCellValue(regC0451Bean.getClaveEntidad());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)2);
						celda.setCellValue(regC0451Bean.getFor_0451());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)3);
						celda.setCellValue(regC0451Bean.getClienteID());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)4);
						celda.setCellValue(regC0451Bean.getTipoCliente());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)5);
						celda.setCellValue(regC0451Bean.getNombre());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)6);
						celda.setCellValue(regC0451Bean.getApellidoPaterno());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)7);
						celda.setCellValue(regC0451Bean.getApellidoMaterno());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)8);
						celda.setCellValue(regC0451Bean.getPersoJuridica());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)9);
						celda.setCellValue(regC0451Bean.getGrupoRiesgo());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)10);
						celda.setCellValue(regC0451Bean.getActividadEco());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)11);
						celda.setCellValue(regC0451Bean.getNacionalidad());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)12);
						celda.setCellValue(regC0451Bean.getFechaNacimiento());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)13);
						celda.setCellValue(regC0451Bean.getRfc());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)14);
						celda.setCellValue(regC0451Bean.getCURP());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)15);
						celda.setCellValue(regC0451Bean.getGenero());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)16);
						celda.setCellValue(regC0451Bean.getCalle());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)17);
						celda.setCellValue(regC0451Bean.getNumeroExt());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)18);
						celda.setCellValue(regC0451Bean.getColonia());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)19);
						celda.setCellValue(regC0451Bean.getCodigoPostal());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)20);
						celda.setCellValue(regC0451Bean.getLocalidad());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)21);
						celda.setCellValue(regC0451Bean.getEstado());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)22);
						celda.setCellValue(regC0451Bean.getMunicipio());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)23);
						celda.setCellValue(regC0451Bean.getPais());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)24);
						celda.setCellValue(regC0451Bean.getTipoRelacionado());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)25);
						celda.setCellValue(regC0451Bean.getNumConsultaSIC());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)26);
						celda.setCellValue(regC0451Bean.getIngresosMes());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)27);
						celda.setCellValue(regC0451Bean.getTamanioAcred());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)28);
						celda.setCellValue(regC0451Bean.getIdenCreditoCNBV());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)29);
						celda.setCellValue(regC0451Bean.getIdenGrupalCNBV());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)30);
						celda.setCellValue(regC0451Bean.getFechaOtorga());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)31);
						celda.setCellValue(regC0451Bean.getTipoAlta());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)32);
						celda.setCellValue(regC0451Bean.getTipoCartera());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)33);
						celda.setCellValue(regC0451Bean.getTipoProducto());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)34);
						celda.setCellValue(regC0451Bean.getDestinoCred());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)35);
						celda.setCellValue(regC0451Bean.getClaveSucursal());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)36);
						celda.setCellValue(regC0451Bean.getNumeroCuenta());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)37);
						celda.setCellValue(regC0451Bean.getNumContrato());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)38);
						celda.setCellValue(regC0451Bean.getNombreFacto());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)39);
						celda.setCellValue(regC0451Bean.getrFCFactorado());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)40);
						celda.setCellValue(regC0451Bean.getMontoLineaPes());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)41);
						celda.setCellValue(regC0451Bean.getMontoLineaOri());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)42);
						celda.setCellValue(regC0451Bean.getFechaMaxima());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)43);
						celda.setCellValue(regC0451Bean.getFechaVencimien());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)44);
						celda.setCellValue(regC0451Bean.getFormaDisposi());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)45);
						celda.setCellValue(regC0451Bean.getTasaReferencia());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)46);
						celda.setCellValue(regC0451Bean.getDiferencial());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)47);
						celda.setCellValue(regC0451Bean.getOpeDirencial());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)48);
						celda.setCellValue(regC0451Bean.getTipoMoneda());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)49);
						celda.setCellValue(regC0451Bean.getPeriodicidadCap());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)50);
						celda.setCellValue(regC0451Bean.getPeriodicidadInt());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)51);
						celda.setCellValue(regC0451Bean.getPeriodoFactura());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)52);
						celda.setCellValue(regC0451Bean.getComisionAper());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)53);
						celda.setCellValue(regC0451Bean.getMontoComAper());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)54);
						celda.setCellValue(regC0451Bean.getComisionDispo());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)55);
						celda.setCellValue(regC0451Bean.getMontoComDispo());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)56);
						celda.setCellValue(regC0451Bean.getValorVivienda());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)57);
						celda.setCellValue(regC0451Bean.getValoAvaluo());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)58);
						celda.setCellValue(regC0451Bean.getNumeroAvaluo());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)59);
						celda.setCellValue(regC0451Bean.getLTV());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)60);
						celda.setCellValue(regC0451Bean.getLocalidadCred());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)61);
						celda.setCellValue(regC0451Bean.getMunicipioCred());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)62);
						celda.setCellValue(regC0451Bean.getEstadoCred());
						celda.setCellStyle(estilo8);

						celda=fila.createCell((short)63);
						celda.setCellValue(regC0451Bean.getActividadEcoCred());
						celda.setCellStyle(estilo8);



						rowExcel++;
						contador++;
					}

				for (int celd = 0; celd <= 65; celd++){
					hoja.autoSizeColumn(celd, true);
				}
				// REPORTE
				hoja.setColumnWidth(2, 12 * 256);
				// LOCALIDAD EN DONDE SE DESTINARÁ EL CRÉDITO
				hoja.setColumnWidth(60, 22 * 256);
				// MUNICIPIO EN DONDE SE DESTINARÁ EL CRÉDITO
				hoja.setColumnWidth(61, 22 * 256);
				// ESTADO EN DONDE SE DESTINARÁ EL CRÉDITO
				hoja.setColumnWidth(62, 22 * 256);
				// ACTIVIDAD ECONÓMICA A LA QUE SE DESTINARÁ EL CRÉDITO
				hoja.setColumnWidth(63, 25 * 256);

				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xlsx");
				response.setContentType("application/vnd.ms-excel");

				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();

			}catch(Exception e){
				e.printStackTrace();
			}//Fin del catch
		}
		return listaC0451Bean;
	}

	// Setter y Getters


	public String getSuccessView() {
		return successView;
	}

	public DesagregadoCarteraC0451Servicio getDesagregadoCarteraC0451Servicio() {
		return desagregadoCarteraC0451Servicio;
	}

	public void setDesagregadoCarteraC0451Servicio(
			DesagregadoCarteraC0451Servicio desagregadoCarteraC0451Servicio) {
		this.desagregadoCarteraC0451Servicio = desagregadoCarteraC0451Servicio;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}


}
