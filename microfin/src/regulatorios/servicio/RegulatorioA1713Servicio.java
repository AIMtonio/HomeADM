package regulatorios.servicio;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;

import regulatorios.bean.RegulatorioA1713Bean;
import regulatorios.dao.RegulatorioA1713DAO;
import regulatorios.servicio.RegulatorioD2442Servicio.Enum_Lis_RegulatorioD2442;
import regulatorios.servicio.RegulatorioD2443Servicio.Enum_Lis_RegulatorioD2443;
import regulatorios.servicio.RegulatorioInsServicio.Enum_Lis_TipoReporte;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class RegulatorioA1713Servicio extends BaseServicio{	
	RegulatorioA1713DAO regulatorioA1713DAO=null;
 
	public RegulatorioA1713Servicio() {
		super();
	}
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Lis_RegulatorioA1713 {
		int principal = 1;
		int listaRegistro = 2;
	}
	public static interface Enum_Alt_RegulatorioA1713 {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}
	
	
	public static interface Enum_Lis_ReportesA1713{
		int excel	 = 2;
		int csv 	 = 3;
	}
	
	public static interface Enum_Con_ReportesA1713{
		int principal = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,int tipoEntidad,	RegulatorioA1713Bean regulatorioA1713Bean ){
		ArrayList listaRegulatorioA1713 = (ArrayList) creaListaDetalle(regulatorioA1713Bean);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				
		/*SOCAP*/
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			switch (tipoTransaccion) {
				case Enum_Alt_RegulatorioA1713.alta:		
					mensaje = regulatorioA1713DAO.grabaRegulatorioA1713(regulatorioA1713Bean,listaRegulatorioA1713);									
					break;			
			}
		}
		
		/*SOFIPO*/
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch (tipoTransaccion) {
				case Enum_Alt_RegulatorioA1713.alta:		
					mensaje = regulatorioA1713DAO.altaRegistroRegA1713Sofipo(regulatorioA1713Bean);									
					break;	
				case Enum_Alt_RegulatorioA1713.modificacion:		
					mensaje = regulatorioA1713DAO.modificaRegistroRegA1713Sofipo(regulatorioA1713Bean);									
					break;
				case Enum_Alt_RegulatorioA1713.baja:		
					mensaje = regulatorioA1713DAO.bajaRegistroRegA1713Sofipo(regulatorioA1713Bean);									
					break;
			}
		}
			
		
		
		return mensaje;
	}
	
	public List lista(int tipoLista, RegulatorioA1713Bean regulatorioA1713Bean){		
		List regulatorioA1713 = null;
		switch (tipoLista) {	
			case Enum_Lis_RegulatorioA1713.principal:		
				regulatorioA1713 = regulatorioA1713DAO.lista(regulatorioA1713Bean, tipoLista);			
				break;
			
			case Enum_Lis_RegulatorioA1713.listaRegistro:		
				regulatorioA1713 = regulatorioA1713DAO.listaRegistroRegA1713Sofipo(regulatorioA1713Bean, Enum_Lis_RegulatorioA1713.principal);			
				break;
				
		}				
		return regulatorioA1713;
	}
	
	
	public RegulatorioA1713Bean consulta(int tipoConsulta, RegulatorioA1713Bean regulatorioA1713Bean){
		RegulatorioA1713Bean regBeanA1713 = null;
		switch (tipoConsulta) {
			case Enum_Con_ReportesA1713.principal:		
				regBeanA1713 = regulatorioA1713DAO.consultaRegistroRegA1713Sofipo(regulatorioA1713Bean,tipoConsulta);									
				break;	
			
		}
		
		return  regBeanA1713;
	}
	
	
	public List creaListaDetalle(RegulatorioA1713Bean regulatorioA1713Bean) {
		ArrayList listaDetalle = new ArrayList();
		List<String> tipoMovimiento  		= regulatorioA1713Bean.getlTipoMovimiento();
		List<String> nombreFuncionario 		= regulatorioA1713Bean.getlNombreFuncionario();
		List<String> rfc  					= regulatorioA1713Bean.getlRFC();
		List<String> curp  					= regulatorioA1713Bean.getlCURP();
		List<String> profesion  			= regulatorioA1713Bean.getlProfesion();
		List<String> calleDomicilio  		= regulatorioA1713Bean.getlCalleDomicilio();
		List<String> numeroExt  			= regulatorioA1713Bean.getlNumeroExt();
		List<String> numeroInt  			= regulatorioA1713Bean.getlNumeroInt();
		List<String> coloniaDomicilio  		= regulatorioA1713Bean.getlColoniaDomicilio();
		List<String> codigoPostal  			= regulatorioA1713Bean.getlCodigoPostal();
		List<String> localidad  			= regulatorioA1713Bean.getlLocalidad();
		List<String> estado  				= regulatorioA1713Bean.getlEstado();
		List<String> pais  					= regulatorioA1713Bean.getlPais();
		List<String> telefono  				= regulatorioA1713Bean.getlTelefono();
		List<String> email  				= regulatorioA1713Bean.getlEmail();
		List<String> fechaMovimiento  		= regulatorioA1713Bean.getlFechaMovimiento();
		List<String> fechaInicio  			= regulatorioA1713Bean.getlFechaInicio();
		List<String> organoPerteneciente  	= regulatorioA1713Bean.getlOrganoPerteneciente();
		List<String> cargo  				= regulatorioA1713Bean.getlCargo();
		List<String> permanente  			= regulatorioA1713Bean.getlPermanente();
		List<String> manifestCumplimiento  	= regulatorioA1713Bean.getlManifestCumplimiento();
		List<String> municipio			  	= regulatorioA1713Bean.getlMunicipio();

		
		
		RegulatorioA1713Bean regulatorioA1713 = null;	
		if(rfc != null){
			int tamanio = rfc.size();			
			for (int i = 0; i < tamanio; i++) {
				regulatorioA1713 = new RegulatorioA1713Bean();
				regulatorioA1713.setFecha(regulatorioA1713Bean.getFecha());
				regulatorioA1713.setTipoMovimiento(tipoMovimiento.get(i));
				regulatorioA1713.setNombreFuncionario(nombreFuncionario.get(i));
				regulatorioA1713.setCurp(curp.get(i));
				regulatorioA1713.setRfc(rfc.get(i));
				regulatorioA1713.setProfesion(profesion.get(i));
				regulatorioA1713.setCalleDomicilio(calleDomicilio.get(i));
				regulatorioA1713.setNumeroExt(numeroExt.get(i));
				regulatorioA1713.setNumeroInt(numeroInt.get(i));
				regulatorioA1713.setColoniaDomicilio(coloniaDomicilio.get(i));
				regulatorioA1713.setCodigoPostal(codigoPostal.get(i));
				regulatorioA1713.setLocalidad(localidad.get(i));
				regulatorioA1713.setEstado(estado.get(i));
				regulatorioA1713.setPais(pais.get(i));
				regulatorioA1713.setTelefono(telefono.get(i));
				regulatorioA1713.setEmail(email.get(i));
				regulatorioA1713.setFechaMovimiento(fechaMovimiento.get(i));
				regulatorioA1713.setFechaInicio(fechaInicio.get(i));
				regulatorioA1713.setOrganoPerteneciente(organoPerteneciente.get(i));
				regulatorioA1713.setCargo(cargo.get(i));
				regulatorioA1713.setPermanente(permanente.get(i));
				regulatorioA1713.setManifestCumplimiento(manifestCumplimiento.get(i));
				regulatorioA1713.setMunicipio(municipio.get(i));
				
	
				listaDetalle.add(regulatorioA1713);
				
			}
		}
		return listaDetalle;
		
	}
	
	/**
	 * Consulta de reporte A1713
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List <RegulatorioA1713Bean>listaReporteRegulatorioA1713(int tipoLista,int tipoEntidad, RegulatorioA1713Bean reporteBean, HttpServletResponse response){
		List<RegulatorioA1713Bean> listaReportes=null;
		
		
		/*
		 * SOCAPS
		 */
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			switch(tipoLista){
				case Enum_Lis_ReportesA1713.excel:
					listaReportes = reporteRegulatorioA1713XLSXSOCAP(Enum_Lis_ReportesA1713.excel,reporteBean,response); // 
					break;
				case Enum_Lis_ReportesA1713.csv:
					listaReportes = generarReporteRegulatorioA1713(reporteBean,Enum_Lis_ReportesA1713.csv,  response); 
					break;		
			}
		
		}
		
		/*
		 * SOFIPOS
		 */
		if(tipoEntidad == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			switch(tipoLista){
				case Enum_Lis_ReportesA1713.excel:
					listaReportes =reporteRegulatorioA1713XLSXSOFIPO(Enum_Lis_ReportesA1713.excel,reporteBean,response); // 
					break;
				case Enum_Lis_ReportesA1713.csv:
					listaReportes = generarReporteRegulatorioA1713Sofipo(reporteBean,Enum_Lis_ReportesA1713.csv,  response); 
					break;		
			}
		}
		

		return listaReportes;
	}
	
	private List<RegulatorioA1713Bean> reporteRegulatorioA1713XLSXSOFIPO(
			int tipoLista, RegulatorioA1713Bean reporteBean,
			HttpServletResponse response) {
		List<RegulatorioA1713Bean> listaA1713Bean = null;
		String mesEnLetras	 = "";
		String anio			 = "";
		String nombreArchivo = "";
		
		
		mesEnLetras = descripcionMes(reporteBean.getFecha().substring(5,7));
		anio	= reporteBean.getFecha().substring(0,4);		
		
		nombreArchivo = "R17_A_1713_"+mesEnLetras +"_"+anio; 
		
		/*Se hace la llamada para obtener la lista para llenar el reporte*/
		listaA1713Bean = regulatorioA1713DAO.reporteRegulatorioA1713Sofipo(reporteBean,tipoLista);
		
		
		if(listaA1713Bean != null){
	
			try {
				HSSFWorkbook libro = new HSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				HSSFFont fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				HSSFFont fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				HSSFFont fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)8);
				fuente8.setFontName(HSSFFont.FONT_ARIAL);
				
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				HSSFCellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				
				//Estilo negrita de 8  para encabezados del reporte
				HSSFCellStyle estiloNegro = libro.createCellStyle();
				estiloNegro.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setFont(fuenteNegrita8);
				
				//Estilo de 8  para Contenido
				HSSFCellStyle estiloNormal = libro.createCellStyle();
				HSSFDataFormat format = libro.createDataFormat();
				estiloNormal.setFont(fuente8);
				estiloNormal.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setDataFormat(format.getFormat("#,##0"));
				
				HSSFCellStyle estiloDerecha = libro.createCellStyle();
				format = libro.createDataFormat();
				estiloDerecha.setFont(fuente8);
				estiloDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
				estiloDerecha.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setDataFormat(format.getFormat("#,##0"));
	
				//Estilo negrita tamaño 8 centrado
				HSSFCellStyle estiloEncabezado = libro.createCellStyle();
				estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				estiloEncabezado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setFont(fuenteNegrita8);
			
	
				//Estilo para una celda con dato con color de fondo gris
				HSSFCellStyle celdaGrisDato = libro.createCellStyle();
				HSSFDataFormat formato3 = libro.createDataFormat();
				celdaGrisDato.setFont(fuenteNegrita8);
				celdaGrisDato.setDataFormat(formato3.getFormat("#,##0"));
				celdaGrisDato.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				celdaGrisDato.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				celdaGrisDato.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				celdaGrisDato.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);

				
				// Creacion de hoja
				HSSFSheet hoja = libro.createSheet("Altas y bajas de Personal A-1713");
				
				
				HSSFRow fila= hoja.createRow(0);
				fila = hoja.createRow(0);

				//Encabezados
				HSSFRow filaTitulo= hoja.createRow(0);
				HSSFCell celda=filaTitulo.createCell((short)0);
	
				
				fila = hoja.createRow(1);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("INFORMACIÓN SOLICITADA");
				celda.setCellStyle(estiloEncabezado);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            26  //ultima celda   (0-based)
			    ));
				
				
				fila = hoja.createRow(2);				
				
				
				celda = fila.createCell((short)0);
				celda.setCellValue("SECCIÓN IDENTIFICADOR DEL REPORTE");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            2  //ultima celda   (0-based)
			    ));	
				
				celda = fila.createCell((short)3);
				celda.setCellValue("SECCIÓN DE INFORMACIÓN DE LA GESTIÓN");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            3, //primer celda (0-based)
			            26  //ultima celda   (0-based)
			    ));				
				
				
				fila = hoja.createRow(3);
				celda = fila.createCell((short)0);
				celda.setCellValue("PERIODO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("CLAVE DE LA ENTIDAD");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("REPORTE");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("TIPO MOVIMIENTO");				
				celda.setCellStyle(estiloEncabezado);
					
				celda = fila.createCell((short)4);
				celda.setCellValue("NOMBRE DEL FUNCIONARIO ");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("RFC DEL FUNCIONARIO ");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("CURP DEL FUNCIONARIO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("TÍTULO O PROFESIÓN DEL FUNCIONARIO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("CALLE DEL DOMICILIO DEL FUNCIONARIO ");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("NÚMERO EXTERIOR DEL DOMICILIO DEL FUNCIONARIO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)10);
				celda.setCellValue("NÚMERO INTERIOR DEL DOMICILIO DEL FUNCIONARIO A");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("COLONIA DEL DOMICILIO DEL FUNCIONARIO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)12);
				celda.setCellValue("CÓDIGO POSTAL DEL DOMICILIO DEL FUNCIONARIO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)13);
				celda.setCellValue("LOCALIDAD DEL DOMICILIO DEL FUNCIONARIO ");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)14);
				celda.setCellValue("MUNICIPIO DEL DOMICILIO DEL FUNCIONARIO N");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)15);
				celda.setCellValue("ESTADO DEL DOMICILIO DEL FUNCIONARIO ");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)16);
				celda.setCellValue("PAÍS DEL DOMICILIO DEL FUNCIONARIO N");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)17);
				celda.setCellValue("TELÉFONO DEL FUNCIONARIO ");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)18);
				celda.setCellValue("CORREO ELETRÓNICO DEL FUNCIONARIO");
				celda.setCellStyle(estiloEncabezado);
								
				celda = fila.createCell((short)19);
				celda.setCellValue("FECHA DEL MOVIMIENTO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)20);
				celda.setCellValue("FECHA DE INICIO DE GESTIÓN ");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)21);
				celda.setCellValue("FECHA DE CONCLUSIÓN DE GESTIÓN");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)22);
				celda.setCellValue("ORGANO AL QUE PERTENECE");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)23);
				celda.setCellValue("CARGO DENTRO DE LA SOCIEDAD, CONSEJO O COMITÉ");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)24);
				celda.setCellValue("PERMANENTE O SUPLENTE ");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)25);
				celda.setCellValue("MOTIVO DE LA BAJA ");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)26);
				celda.setCellValue("MANIFESTACIÓN DE CUMPLIMIENTO ");
				celda.setCellStyle(estiloEncabezado);
				
						
				
				int i=4;		
				for(RegulatorioA1713Bean regA1713Bean : listaA1713Bean ){
		
					fila=hoja.createRow(i);
					
					
					/* Columna 1 "Periodo" */
					celda=fila.createCell((short)0);
					celda.setCellValue(regA1713Bean.getFecha());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 2 "Clave de la Entidad" */
					celda=fila.createCell((short)1);
					celda.setCellValue(regA1713Bean.getClaveEntidad());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 3 "Subreporte" */
					celda=fila.createCell((short)2);
					celda.setCellValue(regA1713Bean.getSubreporte());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 4 "Tipo de Movimiento" */
					celda=fila.createCell((short)3);
					celda.setCellValue(regA1713Bean.getTipoMovimientoID());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 5 "Nombre Funcionario" */
					celda=fila.createCell((short)4);
					celda.setCellValue(regA1713Bean.getNombreFuncionario());
					celda.setCellStyle(estiloNormal);
					
					
					/* Columna 6 "Registro Federal de Contribuyentes" */
					celda=fila.createCell((short)5);
					celda.setCellValue(regA1713Bean.getRfcFuncionario());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 7 "Clave Única de Registro Poblacional" */
					celda=fila.createCell((short)6);
					celda.setCellValue(regA1713Bean.getCurpFuncionario());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 8 "Grado de Estudios" */
					celda=fila.createCell((short)7);
					celda.setCellValue(regA1713Bean.getTituloPofID());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 9 "Calle del Domicilio" */
					celda=fila.createCell((short)8);
					celda.setCellValue(regA1713Bean.getCalle());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 10 "Número Exterior" */
					celda=fila.createCell((short)9);
					celda.setCellValue(regA1713Bean.getNumeroExt());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 11 "Número Interior" */
					celda=fila.createCell((short)10);
					celda.setCellValue(regA1713Bean.getNumeroInt());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 12 "Colonia del Domicilio" */
					celda=fila.createCell((short)11);
					celda.setCellValue(regA1713Bean.getNombreColonia());
					celda.setCellStyle(estiloDerecha);
					
					
					/* Columna 13 "Código Postal del Domicilio" */
					celda=fila.createCell((short)12);
					celda.setCellValue(regA1713Bean.getCodigoPostal());
					celda.setCellStyle(estiloDerecha);
					
					
					/* Columna 14 "Localidad del Domicilio" */
					celda=fila.createCell((short)13);
					celda.setCellValue(regA1713Bean.getLocalidadID());
					celda.setCellStyle(estiloDerecha);
					
					
					/* Columna 15 "Municipio" */
					celda=fila.createCell((short)14);
					celda.setCellValue(regA1713Bean.getMunicipioID());
					celda.setCellStyle(estiloNormal);
					
					
					/* Columna 16 "Estado " */
					celda=fila.createCell((short)15);
					celda.setCellValue(regA1713Bean.getEstadoID());
					celda.setCellStyle(estiloDerecha);
					
					/* Columna 17 "Pais" */
					celda=fila.createCell((short)16);
					celda.setCellValue(regA1713Bean.getPaisID());
					celda.setCellStyle(estiloDerecha);
					
					/* Columna 18 "Telefono" */
					celda=fila.createCell((short)17);
					celda.setCellValue(regA1713Bean.getTelefono());
					celda.setCellStyle(estiloDerecha);
					
					/* Columna 19 "Correo" */
					celda=fila.createCell((short)18);
					celda.setCellValue(regA1713Bean.getCorreoElectronico());
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)19);
					celda.setCellValue(regA1713Bean.getFechaMovimiento());
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)20);
					celda.setCellValue(regA1713Bean.getInicioGestion());
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)21);
					celda.setCellValue(regA1713Bean.getConclusionGestion());
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)22);
					celda.setCellValue(regA1713Bean.getOrganoID());
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)23);
					celda.setCellValue(regA1713Bean.getCargoID());
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)24);
					celda.setCellValue(regA1713Bean.getPermanenteSupID());
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)25);
					celda.setCellValue(regA1713Bean.getCausaBajaID());
					celda.setCellStyle(estiloDerecha);
					
					celda=fila.createCell((short)26);
					celda.setCellValue(regA1713Bean.getManifestacionID());
					celda.setCellStyle(estiloDerecha);
					
					
					
					i++;
				}
										
				hoja.autoSizeColumn(0);
				hoja.autoSizeColumn(1);
				hoja.autoSizeColumn(2);
				hoja.autoSizeColumn(3);
				hoja.autoSizeColumn(4);
				hoja.autoSizeColumn(5);
				hoja.autoSizeColumn(6);
				hoja.autoSizeColumn(7);
				hoja.autoSizeColumn(8);
				hoja.autoSizeColumn(11);
				hoja.autoSizeColumn(12);
				hoja.autoSizeColumn(13);
				hoja.autoSizeColumn(14);
				hoja.autoSizeColumn(15);
				hoja.autoSizeColumn(16);
				hoja.autoSizeColumn(17);
				hoja.autoSizeColumn(18);
				hoja.autoSizeColumn(19);
				hoja.autoSizeColumn(20);
				hoja.autoSizeColumn(21);
				hoja.autoSizeColumn(22);
				hoja.autoSizeColumn(23);
				hoja.autoSizeColumn(24);
				hoja.autoSizeColumn(25);
				hoja.autoSizeColumn(26);
				
										
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
			
			}catch(Exception e){
				e.printStackTrace();
			}//Fin del catch
		}
		return listaA1713Bean;
	}

	private List<RegulatorioA1713Bean> reporteRegulatorioA1713XLSXSOCAP(
			int tipoLista, RegulatorioA1713Bean reporteBean,
			HttpServletResponse response) {
		List<RegulatorioA1713Bean> listaA1713Bean = null;
		String mesEnLetras	 = "";
		String anio			 = "";
		String nombreArchivo = "";
		
		
		mesEnLetras = descripcionMes(reporteBean.getFecha().substring(5,7));
		anio	= reporteBean.getFecha().substring(0,4);		
		
		nombreArchivo = "R17_A_1713_"+mesEnLetras +"_"+anio; 
		
		/*Se hace la llamada para obtener la lista para llenar el reporte*/
		listaA1713Bean = regulatorioA1713DAO.reporteRegulatorioA1713(reporteBean,tipoLista);
		
		
		if(listaA1713Bean != null){
	
			try {
				HSSFWorkbook libro = new HSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				HSSFFont fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				HSSFFont fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				HSSFFont fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)8);
				fuente8.setFontName(HSSFFont.FONT_ARIAL);
				
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				HSSFCellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				
				//Estilo negrita de 8  para encabezados del reporte
				HSSFCellStyle estiloNegro = libro.createCellStyle();
				estiloNegro.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloNegro.setFont(fuenteNegrita8);
				
				//Estilo de 8  para Contenido
				HSSFCellStyle estiloNormal = libro.createCellStyle();
				HSSFDataFormat format = libro.createDataFormat();
				estiloNormal.setFont(fuente8);
				estiloNormal.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloNormal.setDataFormat(format.getFormat("#,##0"));
				
				HSSFCellStyle estiloDerecha = libro.createCellStyle();
				format = libro.createDataFormat();
				estiloDerecha.setFont(fuente8);
				estiloDerecha.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT);
				estiloDerecha.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloDerecha.setDataFormat(format.getFormat("#,##0"));
	
				//Estilo negrita tamaño 8 centrado
				HSSFCellStyle estiloEncabezado = libro.createCellStyle();
				estiloEncabezado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				estiloEncabezado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
				estiloEncabezado.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);
				estiloEncabezado.setFont(fuenteNegrita8);
			
	
				//Estilo para una celda con dato con color de fondo gris
				HSSFCellStyle celdaGrisDato = libro.createCellStyle();
				HSSFDataFormat formato3 = libro.createDataFormat();
				celdaGrisDato.setFont(fuenteNegrita8);
				celdaGrisDato.setDataFormat(formato3.getFormat("#,##0"));
				celdaGrisDato.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				celdaGrisDato.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				celdaGrisDato.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
				celdaGrisDato.setBorderTop((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderBottom((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderRight((short)HSSFCellStyle.BORDER_THIN);
				celdaGrisDato.setBorderLeft((short)HSSFCellStyle.BORDER_THIN);

				
				// Creacion de hoja
				HSSFSheet hoja = libro.createSheet("Altas y bajas de Personal A-1713");
				
				
				HSSFRow fila= hoja.createRow(0);
				fila = hoja.createRow(0);

				//Encabezados
				HSSFRow filaTitulo= hoja.createRow(0);
				HSSFCell celda=filaTitulo.createCell((short)0);
	
				
				fila = hoja.createRow(1);
				
				celda = fila.createCell((short)0);
				celda.setCellValue("INFORMACIÓN SOLICITADA");
				celda.setCellStyle(estiloEncabezado);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            23  //ultima celda   (0-based)
			    ));
				
				
				fila = hoja.createRow(2);				
				
				celda = fila.createCell((short)0);
				celda.setCellValue("SECCIÓN DE INFORMACIÓN DE LA GESTIÓN");
				celda.setCellStyle(celdaGrisDato);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress(
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            0, //primer celda (0-based)
			            23  //ultima celda   (0-based)
			    ));				
				
				
				fila = hoja.createRow(3);
				celda = fila.createCell((short)0);
				celda.setCellValue("FECHA");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("CLAVE DE LA ENTIDAD");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("SUBREPORTE");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("TIPO MOVIMIENTO");				
				celda.setCellStyle(estiloEncabezado);
					
				celda = fila.createCell((short)4);
				celda.setCellValue("NOMBRE ");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("RFC");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("CURP");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("PROFESION");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("CALLE ");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("NUMERO EXTERIOR");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)10);
				celda.setCellValue("NUMERO INTERIOR");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("COLONIA");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)12);
				celda.setCellValue("CÓDIGO POSTAL");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)13);
				celda.setCellValue("LOCALIDAD");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)14);
				celda.setCellValue("ESTADO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)15);
				celda.setCellValue("PAIS");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)16);
				celda.setCellValue("TELEFONO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)17);
				celda.setCellValue("EMAIL");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)18);
				celda.setCellValue("FECHA DEL MOVIMIENTO");
				celda.setCellStyle(estiloEncabezado);
								
				celda = fila.createCell((short)19);
				celda.setCellValue("FECHA INICIO O CONCLUSIÓN DE GESTIÓN");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)20);
				celda.setCellValue("ORGANO PERTENECIENTE");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)21);
				celda.setCellValue("CARGO");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)22);
				celda.setCellValue("PERMANENTE O SUPLENTE");
				celda.setCellStyle(estiloEncabezado);
				
				celda = fila.createCell((short)23);
				celda.setCellValue("MANIFESTACION DE CUMPLIMIENTO");
				celda.setCellStyle(estiloEncabezado);
				
						
				
				int i=4;		
				for(RegulatorioA1713Bean regA1713Bean : listaA1713Bean ){
		
					fila=hoja.createRow(i);
					
					
					/* Columna 1 "Fecha" */
					celda=fila.createCell((short)0);
					celda.setCellValue(regA1713Bean.getFecha());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 2 "Clave de la Entidad" */
					celda=fila.createCell((short)1);
					celda.setCellValue(regA1713Bean.getClaveEntidad());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 3 "Subreporte" */
					celda=fila.createCell((short)2);
					celda.setCellValue(regA1713Bean.getSubreporte());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 4 "Tipo de Movimiento" */
					celda=fila.createCell((short)3);
					celda.setCellValue(regA1713Bean.getTipoMovimiento());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 5 "Nombre Funcionario" */
					celda=fila.createCell((short)4);
					celda.setCellValue(regA1713Bean.getNombreFuncionario());
					celda.setCellStyle(estiloNormal);
					
					
					/* Columna 6 "Registro Federal de Contribuyentes" */
					celda=fila.createCell((short)5);
					celda.setCellValue(regA1713Bean.getRfc());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 7 "Clave Única de Registro Poblacional" */
					celda=fila.createCell((short)6);
					celda.setCellValue(regA1713Bean.getCurp());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 8 "Grado de Estudios" */
					celda=fila.createCell((short)7);
					celda.setCellValue(regA1713Bean.getProfesion());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 9 "Calle del Domicilio" */
					celda=fila.createCell((short)8);
					celda.setCellValue(regA1713Bean.getCalleDomicilio());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 10 "Número Exterior" */
					celda=fila.createCell((short)9);
					celda.setCellValue(regA1713Bean.getNumeroExt());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 11 "Número Interior" */
					celda=fila.createCell((short)10);
					celda.setCellValue(regA1713Bean.getNumeroInt());
					celda.setCellStyle(estiloNormal);
					
					/* Columna 12 "Colonia del Domicilio" */
					celda=fila.createCell((short)11);
					celda.setCellValue(regA1713Bean.getAsentamiento());
					celda.setCellStyle(estiloDerecha);
					
					
					/* Columna 13 "Código Postal del Domicilio" */
					celda=fila.createCell((short)12);
					celda.setCellValue(regA1713Bean.getCodigoPostal());
					celda.setCellStyle(estiloDerecha);
					
					
					/* Columna 14 "Localidad del Domicilio" */
					celda=fila.createCell((short)13);
					celda.setCellValue(regA1713Bean.getNombreLocalidad());
					celda.setCellStyle(estiloDerecha);
					
					
					/* Columna 15 "Estado del Domicilio" */
					celda=fila.createCell((short)14);
					celda.setCellValue(regA1713Bean.getNombreEstado());
					celda.setCellStyle(estiloNormal);
					
					
					/* Columna 16 "Pais " */
					celda=fila.createCell((short)15);
					celda.setCellValue(regA1713Bean.getNombrePais());
					celda.setCellStyle(estiloDerecha);
					
					/* Columna 17 "Telefono" */
					celda=fila.createCell((short)16);
					celda.setCellValue(regA1713Bean.getTelefono());
					celda.setCellStyle(estiloDerecha);
					
					/* Columna 18 "EMAIL" */
					celda=fila.createCell((short)17);
					celda.setCellValue(regA1713Bean.getEmail());
					celda.setCellStyle(estiloDerecha);
					
					/* Columna 19 "Fecha de Movimiento" */
					celda=fila.createCell((short)18);
					celda.setCellValue(regA1713Bean.getFechaMovimiento());
					celda.setCellStyle(estiloDerecha);
					
					/* Columna 20 "Fecha de Inicio o Conclusión de Gestión" */
					celda=fila.createCell((short)19);
					celda.setCellValue(regA1713Bean.getFechaInicio());
					celda.setCellStyle(estiloDerecha);
					
					/* Columna 21 "Organo Perteneciente" */
					celda=fila.createCell((short)20);
					celda.setCellValue(regA1713Bean.getOrganoPerteneciente());
					celda.setCellStyle(estiloDerecha);
					
					/* Columna 22 "Cargo" */
					celda=fila.createCell((short)21);
					celda.setCellValue(regA1713Bean.getCargo());
					celda.setCellStyle(estiloDerecha);
					
					/* Columna 23 "Permanente o Suplente" */
					celda=fila.createCell((short)22);
					celda.setCellValue(regA1713Bean.getPermanente());
					celda.setCellStyle(estiloDerecha);
					
					/* Columna 24 "Manifestación de Cumplimiento" */
					celda=fila.createCell((short)23);
					celda.setCellValue(regA1713Bean.getManifestCumplimiento());
					celda.setCellStyle(estiloDerecha);
					
					
					
					i++;
				}
										
				hoja.autoSizeColumn(0);
				hoja.autoSizeColumn(1);
				hoja.autoSizeColumn(2);
				hoja.autoSizeColumn(3);
				hoja.autoSizeColumn(4);
				hoja.autoSizeColumn(5);
				hoja.autoSizeColumn(6);
				hoja.autoSizeColumn(7);
				hoja.autoSizeColumn(8);
				hoja.autoSizeColumn(9);
				hoja.autoSizeColumn(10);
				hoja.autoSizeColumn(11);
				hoja.autoSizeColumn(12);
				hoja.autoSizeColumn(13);
				hoja.autoSizeColumn(14);
				hoja.autoSizeColumn(15);
				hoja.autoSizeColumn(16);
				hoja.autoSizeColumn(17);
				hoja.autoSizeColumn(18);
				hoja.autoSizeColumn(19);
				hoja.autoSizeColumn(20);
				hoja.autoSizeColumn(21);
				hoja.autoSizeColumn(22);
				hoja.autoSizeColumn(23);
				
										
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
			
			}catch(Exception e){
				e.printStackTrace();
			}//Fin del catch
		}
		return listaA1713Bean;
	}

	/**
	 * Genera reporte regulatorio A1713 version CSV
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @return
	 */
	private List generarReporteRegulatorioA1713(RegulatorioA1713Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = regulatorioA1713DAO.reporteRegulatorioA1713Csv(reporteBean, tipoReporte);
		String mesEnLetras = descripcionMes(reporteBean.getFecha().substring(5,7));
		String anio	= reporteBean.getFecha().substring(0,4);		
		
		nombreArchivo = "R17_A_1713_"+mesEnLetras +"_"+anio+".csv"; 
		
		try{
			RegulatorioA1713Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioA1713Bean) listaBeans.get(i);
					writer.write(bean.getRenglon());        
					writer.write("\r\n");	
				}
			}else{
				writer.write("");
			}
			writer.close();

			FileInputStream archivo = new FileInputStream(nombreArchivo);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition","attachment;filename="+nombreArchivo);
			response.setContentType("application/text");
			ServletOutputStream outputStream = response.getOutputStream();
			outputStream.write(datos);
			outputStream.flush();
			outputStream.close();
			
		}catch(IOException io ){	
			io.printStackTrace();
		}
		return listaBeans;
	}
	
	
	
	/**
	 * Genera reporte regulatorio A1713 version CSV - Sofipo
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @return
	 */
	private List generarReporteRegulatorioA1713Sofipo(RegulatorioA1713Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = regulatorioA1713DAO.reporteRegulatorioA1713SofipoCsv(reporteBean, tipoReporte);
		
		String mesEnLetras = descripcionMes(reporteBean.getFecha().substring(5,7));
		String anio	= reporteBean.getFecha().substring(0,4);		
		
		nombreArchivo = "R17_A_1713_"+mesEnLetras +"_"+anio+".csv"; 
		
		
		try{
			RegulatorioA1713Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioA1713Bean) listaBeans.get(i);
					writer.write(bean.getRenglon());        
					writer.write("\r\n");	
				}
			}else{
				writer.write("");
			}
			writer.close();

			FileInputStream archivo = new FileInputStream(nombreArchivo);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition","attachment;filename="+nombreArchivo);
			response.setContentType("application/text");
			ServletOutputStream outputStream = response.getOutputStream();
			outputStream.write(datos);
			outputStream.flush();
			outputStream.close();
			
		}catch(IOException io ){	
			io.printStackTrace();
		}
		return listaBeans;
	}
	
	public String descripcionMes(String meses){
		String mes = "";
		int mese = Integer.parseInt(meses);
        switch (mese) {
            case 1:  mes ="ENERO" ; break;
            case 2:  mes ="FEBRERO"; break;
            case 3:  mes ="MARZO"; break;
            case 4:  mes ="ABRIL"; break;
            case 5:  mes ="MAYO"; break;
            case 6:  mes ="JUNIO"; break;
            case 7:  mes ="JULIO"; break;
            case 8:  mes ="AGOSTO"; break;
            case 9:  mes ="SEPTIEMBRE"; break;
            case 10: mes ="OCTUBRE"; break;
            case 11: mes ="NOVIEMBRE"; break;
            case 12: mes ="DICIEMBRE"; break;
        }
        return mes;
	}
	
	
	//------------getter y setter--------------
	public RegulatorioA1713DAO getRegulatorioA1713DAO() {
		return regulatorioA1713DAO;
	}
	public void setRegulatorioA1713DAO(RegulatorioA1713DAO regulatorioA1713DAO) {
		this.regulatorioA1713DAO = regulatorioA1713DAO;
	}
	
}