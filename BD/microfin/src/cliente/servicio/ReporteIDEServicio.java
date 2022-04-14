package cliente.servicio;

import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import general.servicio.ParametrosAplicacionServicio;
import herramientas.Archivos;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;
import java.util.zip.ZipOutputStream;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.tools.zip.ZipEntry;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.ModelAndView;

import contabilidad.bean.CePolizasBean;

import regulatorios.controlador.ConElectronicaXMLControlador.Enum_Con_CtasContables;

import cliente.bean.ReporteIDEBean;
import cliente.dao.ReporteIDEDAO;

public class ReporteIDEServicio extends BaseServicio{
	//---------- Variables ------------------------------------------------------------------------
	ReporteIDEDAO reporteIDEDAO = null;
	Archivos manejoArchivo = null;
	ParametrosSesionBean parametrosSesionBean;
	ParametrosAplicacionServicio	parametrosAplicacionServicio	= null;

	public ReporteIDEServicio (){
		super();
	}	
	
	
	//lista para reportes	
	public List<ReporteIDEBean> listaReportes(int tipoLista, ReporteIDEBean reporteIDEBean, HttpServletResponse response) throws Exception{		
		List<ReporteIDEBean> listaIDE=null;
		
		listaIDE = reporteIDEDAO.listaIDE(reporteIDEBean);
		
		int regExport = 0;
		
		try {
			Workbook libro = new SXSSFWorkbook();
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.						
			Font fuenteNegrita8Enc= libro.createFont();
			fuenteNegrita8Enc.setFontHeightInPoints((short)10);
			fuenteNegrita8Enc.setFontName("Negrita");
			fuenteNegrita8Enc.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.						
			Font fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)8);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);
		
			//Crea un Fuente con tamaño 10 para informacion del reporte.
			Font fuente10= libro.createFont();
			fuente10.setFontHeightInPoints((short)10);
			
			//Crea un Fuente con tamaño 10 para informacion del reporte.
			Font fuenteFecha= libro.createFont();
			fuente10.setFontHeightInPoints((short)10);
			
			//Estilo de 8  para Contenido
			CellStyle estilo10 = libro.createCellStyle();
			estilo10.setFont(fuente10);	
			
			
			//Estilo Fecha
			CellStyle estiloFecha = libro.createCellStyle();
			estiloFecha.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			estiloFecha.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			
			//Estilo negrita tamaño 8 centrado (Titulo)
			CellStyle estiloTitulo = libro.createCellStyle();
			estiloTitulo.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			estiloTitulo.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			estiloTitulo.setFont(fuenteNegrita8Enc);
			
			//Estilo negrita tamaño 8 izquierda
			CellStyle estiloEncabezado = libro.createCellStyle();
			estiloEncabezado.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
			estiloEncabezado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
			estiloEncabezado.setFont(fuenteNegrita10);
			
			
			//Estilo Formato Derecha
			CellStyle estiloFormatoDerecha= libro.createCellStyle();
			estiloFormatoDerecha.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
			
			//Estilo Formato Centrado
			CellStyle estiloCentrado= libro.createCellStyle();
			estiloCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			
			CellStyle formatoDecimal = libro.createCellStyle();
			DataFormat format = libro.createDataFormat();
			formatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			// Creacion de hoja	
			SXSSFSheet hoja = null;
			hoja = (SXSSFSheet) libro.createSheet("REPORTE IDE");
			
			Row fila= hoja.createRow(0);
		
		
			fila = hoja.createRow(1);
		
			// inicio usuario,fecha y hora
			Cell celdaUsu=fila.createCell((short)1);
			celdaUsu = fila.createCell((short)16);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloEncabezado);	
			celdaUsu = fila.createCell((short)17);
			celdaUsu.setCellValue((!reporteIDEBean.getNombreUsuario().isEmpty())?reporteIDEBean.getNombreUsuario(): "TODOS");
			
			String horaEmision=reporteIDEBean.getHoraEmision();
			String fechaVar= reporteIDEBean.getFechaEmision();
			
			String nombreMes=obtenerNombreMes(Integer.parseInt(reporteIDEBean.getPeriodo()));
			
			int itera=0;
			ReporteIDEBean reporteID = reporteIDEBean;
			if(!listaIDE.isEmpty()){
				for( itera=0; itera<1; itera ++){
					reporteID = (ReporteIDEBean) listaIDE.get(itera);								
				}
			}

			// Nombre Institucion	
			Cell celdaInst=fila.createCell((short)1);
			celdaInst.setCellValue(reporteIDEBean.getNombreInstitucion());
								
			  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            15 //ultima celda   (0-based)
			    ));
			  
			 celdaInst.setCellStyle(estiloTitulo);	
			
			fila = hoja.createRow(2);
			
			Cell celdaFec=fila.createCell((short)1);
			
			celdaFec = fila.createCell((short)16);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloEncabezado);	
			celdaFec = fila.createCell((short)17);
			celdaFec.setCellValue(fechaVar);
			
			// Titulo del Reporte	
		   Cell celda=fila.createCell((short)1);
		   if(reporteIDEBean.getTipoReporte().equalsIgnoreCase("M")){
			   celda.setCellValue("REPORTE PARA LA DECLARACIÓN MENSUAL DE LOS DEPÓSITOS EN EFECTIVO");
		   }else{
			   celda.setCellValue("REPORTE PARA LA DECLARACIÓN ANUAL DE LOS DEPÓSITOS EN EFECTIVO");
		   }
		   celda.setCellStyle(estiloTitulo);
		   hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            15  //ultima celda   (0-based)
		    ));
		    	   
		    fila = hoja.createRow(3); // Fila vacia
		
		    Cell celdaHora=fila.createCell((short)1);
		    
			celdaHora = fila.createCell((short)16);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloEncabezado);	
			celdaHora = fila.createCell((short)17);
			celdaHora.setCellValue(horaEmision);
			
			Cell celdaPeriodo=fila.createCell((short)1);
		    
		    celdaPeriodo.setCellValue("PERIODO REPORTADO: "+reporteIDEBean.getEjercicio()+" "+nombreMes);
		    celdaPeriodo.setCellStyle(estiloTitulo);
		    hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            3, //primera fila (0-based)
		            3, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            15  //ultima celda   (0-based)
		    ));
			   
			
			// Creacion de fila
		fila = hoja.createRow(6); // Fila vacia
		fila.setHeight((short)500);	
		
		celda = fila.createCell((short)1);
		celda.setCellValue("Número Cliente");
		celda.setCellStyle(estiloTitulo);
		
		celda = fila.createCell((short)2);
		celda.setCellValue("CURP");
		celda.setCellStyle(estiloTitulo);

		celda = fila.createCell((short)3);
		celda.setCellValue("RFC");
		celda.setCellStyle(estiloTitulo);
		
		celda = fila.createCell((short)4);
		celda.setCellValue("Nombre/Denominación");
		celda.setCellStyle(estiloTitulo);
		
		celda = fila.createCell((short)5);
		celda.setCellValue("Primer Apellido");
		celda.setCellStyle(estiloTitulo);
		
		celda = fila.createCell((short)6);
		celda.setCellValue("Segundo Apellido");
		celda.setCellStyle(estiloTitulo);
		
		celda = fila.createCell((short)7);
		celda.setCellValue("Fecha Corte");
		celda.setCellStyle(estiloTitulo);
		
		celda = fila.createCell((short)8);
		celda.setCellValue("Monto Depósitos");
		celda.setCellStyle(estiloTitulo);
		
		celda = fila.createCell((short)9);
		celda.setCellValue("Excedentes");
		celda.setCellStyle(estiloTitulo);
		
		celda = fila.createCell((short)10);
		celda.setCellValue("Domicilio Cliente");
		celda.setCellStyle(estiloTitulo);
				
		celda = fila.createCell((short)11);
		celda.setCellValue("Código Postal");
		celda.setCellStyle(estiloTitulo);
		
		celda = fila.createCell((short)12);
		celda.setCellValue("ID Socio Menor");
		celda.setCellStyle(estiloTitulo);
		
		celda = fila.createCell((short)13);
		celda.setCellValue("Sucursal");
		celda.setCellStyle(estiloTitulo);
		
		celda = fila.createCell((short)14);
		celda.setCellValue("Teléfono");
		celda.setCellStyle(estiloTitulo);
		
		celda = fila.createCell((short)15);
		celda.setCellValue("Teléfono 2");
		celda.setCellStyle(estiloTitulo);
		
		celda = fila.createCell((short)16);
		celda.setCellValue("Correo Electrónico");
		celda.setCellStyle(estiloTitulo);
		
		celda = fila.createCell((short)17);
		celda.setCellValue("Cuenta");
		celda.setCellStyle(estiloTitulo);
	
		// Recorremos la lista para la parte de los datos 	
		int i=7,iter=0;
		int tamanioLista = listaIDE.size();
		reporteID = null;
		for( iter=0; iter<tamanioLista; iter ++){
		
			reporteID =  listaIDE.get(iter);
			fila=hoja.createRow(i);
		
			celda=fila.createCell((short)1);
			celda.setCellValue(reporteID.getClienteID());
			
			celda=fila.createCell((short)2);
			celda.setCellValue(reporteID.getCurp());
			
			celda=fila.createCell((short)3); 
			celda.setCellValue(reporteID.getRfc());
			
			celda=fila.createCell((short)4);
			if(reporteID.getTipoPersona().equalsIgnoreCase("F")){
				celda.setCellValue(reporteID.getPrimerNombre()); 			
			}else{
				celda.setCellValue(reporteID.getNombreCompleto()); 	
			}

			celda=fila.createCell((short)5);
			celda.setCellValue(reporteID.getApellidoPaterno());

			celda=fila.createCell((short)6);
			celda.setCellValue(reporteID.getApellidoMaterno());
			
			celda=fila.createCell((short)7);
			celda.setCellValue(reporteID.getFin());
			celda.setCellStyle(estiloCentrado);

			celda=fila.createCell((short)8);
			celda.setCellValue(Utileria.convierteDoble(reporteID.getCantidad()));
			celda.setCellStyle(formatoDecimal);    

			celda=fila.createCell((short)9);
			celda.setCellValue(Utileria.convierteDoble(reporteID.getCantidadExcento()));
			celda.setCellStyle(formatoDecimal); 

			celda=fila.createCell((short)10);
			celda.setCellValue(reporteID.getDirCompleta());

			celda=fila.createCell((short)11);
			celda.setCellValue(reporteID.getCp());
			
			celda=fila.createCell((short)12);
			celda.setCellValue(reporteID.getEsMenorEdad());
			
			celda=fila.createCell((short)13);
			celda.setCellValue(reporteID.getSucursalOrigen());

			celda=fila.createCell((short)14);
			celda.setCellValue(reporteID.getTelefono());
			
			celda=fila.createCell((short)15);
			celda.setCellValue(reporteID.getTelCelular());
			
			celda=fila.createCell((short)16);
			celda.setCellValue(reporteID.getCorreo());
			
			celda=fila.createCell((short)17);
			celda.setCellValue(reporteID.getCuentaAhoID());
			
			i++;
		}
		 
			i = i+2;
			fila=hoja.createRow(i); // Fila Registros Exportados
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloEncabezado);
			
			i = i+1;
			fila=hoja.createRow(i); // Fila Total de Registros Exportados
			celda=fila.createCell((short)0);
			celda.setCellValue(tamanioLista);
			
			// Autoajusta las columnas
			hoja.setColumnWidth(1, 4000);
			hoja.setColumnWidth(2, 4500);
			hoja.setColumnWidth(3, 4300);
			hoja.setColumnWidth(4, 6500);
			hoja.setColumnWidth(5, 5000);
			hoja.setColumnWidth(6, 5000);
			hoja.setColumnWidth(7, 3000);
			hoja.setColumnWidth(8, 4100);
			hoja.setColumnWidth(9, 4100);
			hoja.setColumnWidth(10, 21000);
			hoja.setColumnWidth(11, 3000);
			hoja.setColumnWidth(12, 3300);
			hoja.setColumnWidth(13, 2100);
			hoja.setColumnWidth(14, 3000);
			hoja.setColumnWidth(15, 3000);
			hoja.setColumnWidth(16, 4600);
			hoja.setColumnWidth(17, 4500);

			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteIDE.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
			}catch(Exception e){
				e.printStackTrace();
			}//Fin del catch
			
		return  listaIDE;

	}	
	
	// encabezado para reporte mensual
	public static String ENCABEZADO_MENSUAL = "" +
			"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
     		+ "<DeclaracionInformativaMensualIDE" 
     		+ " xsi:schemaLocation=\"http://www.sat.gob.mx/fichas_tematicas/reforma_fiscal/Documents"
     		+ " http://www.sat.gob.mx/fichas_tematicas/reforma_fiscal/Documents/layout_DM_IDE.xsd\" "
     		+ "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\""
     		+ " xmlns:DeclaracionInformativaMensualIDE=\"http://www.sat.gob.mx/fichas_tematicas/reforma_fiscal/Documents/layout_DM_IDE\"" +
     		" version=\"2.0\" rfcDeclarante=\"%RfcDeclarante%\" denominacion=\"%Denominacion%\" >"+ "\n" 
     			+"<RepresentanteLegal rfc=\"%RfcRep%\">"+ "\n" 
     				+"<Nombre>"+ "\n" 
     					+"<NombreCompleto> %NombreCompletoRep% </NombreCompleto>"+ "\n" 
     				+"</Nombre >"+ "\n" 
     			+"</RepresentanteLegal>"+ "\n" 
     			+"<Normal ejercicio=\"%Ejercicio%\" periodo=\"%Periodo%\">"+ "\n" 
     			+"</Normal>"
     			+"<InstitucionDeCredito>"+ "\n" 
     				+"<ReporteDeRecaudacionYEnteroDiaria fechaDeCorte=\"%FechaDeCorte%\">"+ "\n" 
     						+" %RegistroDeDetalleMensual% "+ "\n" 
     						+"<Totales operacionesRelacionadas=\"%OperacionesRelacionadas%\" importeExcedenteDepositos=\"%ImporteExcedenteDepositos%\" " +
     							"importeDeterminadoDepositos=\"0\" importeRecaudadoDepositos=\"0\" " +
     							"importePendienteRecaudacion=\"0\" importeRemanenteDepositos=\"0\" " +
     							"importeEnterado=\"0\" importeSaldoPendienteRecaudar=\"0\" " +
     							"importeCheques=\"0\">"
     						+"</Totales>"+ "\n" 
     				+"</ReporteDeRecaudacionYEnteroDiaria>"+ "\n" 
     			+"</InstitucionDeCredito>"+ "\n" 
     		+"</DeclaracionInformativaMensualIDE>";

	//Encabezado anual
	public static String ENCABEZADO_ANUAL = "" +
			"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
     		+ "<DeclaracionInformativaAnualISR" 
     		+ " xsi:schemaLocation=\"http://www.sat.gob.mx/informacion_fiscal/depositos_efectivo/Documents"
     		+ " http://www.sat.gob.mx/informacion_fiscal/depositos_efectivo/Documents/ide_20150112_V3_0.xsd\" "
     		+ "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\""
     		+ " xmlns:DeclaracionInformativaAnualISR=\"http://www.sat.gob.mx/informacion_fiscal/depositos_efectivo/Documents/ide_20150112_V3_0\"" +
     		" version=\"3.0\" rfcDeclarante=\"%RfcDeclarante%\" denominacion=\"%Denominacion%\" >"+ "\n"
	     		+"<RepresentanteLegal rfc=\"%RfcRep%\" >"+ "\n"
					+"<Nombre>"+ "\n"
						+"<NombreCompleto> %NombreCompletoRep% </NombreCompleto>"+ "\n"
					+"</Nombre >"+ "\n"
				+"</RepresentanteLegal>"+ "\n"
				+"<Normal ejercicio=\"%Ejercicio%\">"+ "\n"
     			+"</Normal>"+ "\n"
     			+"<InstitucionDeCredito>"+ "\n"
     				+" %RegistroDeDetallePeriodo% "+ "\n"
     			+"<Totales importeExcedenteDepositos=\"%ImporteExcedenteDepositos%\" operacionesRelacionadas=\"%OperacionesRelacionadas%\" " +
					"importeCheques=\"0\">"+ "\n"
				+"</Totales>"+ "\n"
     			+"</InstitucionDeCredito>"+ "\n"
     		+"</DeclaracionInformativaAnualISR>";
	
	//Perona Fisica
	public static String PERSONA_FISICA_MENSUAL=
			"<RegistroDeDetalle> "+ "\n" 
				+"<PersonaFisica rfc=\"%Rfc%\" curp=\"%Curp%\" NumeroCliente=\"%NumeroCliente%\"" +
				" correoElectronico=\"%CorreoElectronico%\" telefono1=\"%Telefono%\"" +
				" telefono2=\"%TelefonoCel%\">"
					+"<Nombre>"+ "\n" 
						+"<NombreCompleto> %NombreCompletoCli% </NombreCompleto>"+ "\n" 
					+"</Nombre>"+ "\n" 
					+"<Domicilio>"+ "\n" 
						+"<DomicilioCompleto> %DomCompletoCli% </DomicilioCompleto>"+ "\n" 
					+"</Domicilio>"+ "\n" 
					+"<numeroCuenta> %NumeroCuenta% </numeroCuenta>"+ "\n" 
				+"</PersonaFisica>"+ "\n" 
				+"<DepositoEnEfectivo montoExcedente=\"%MontoExcedente%\" impuestoDeterminado=\"0\" " +
					"impuestoRecaudado=\"0\" recaudacionPendiente=\"0\" " +
					"remanentePeriodosAnteriores=\"0\" saldoPendienteRecaudar=\"0\">"
				+"</DepositoEnEfectivo>"+ "\n" 
			+"</RegistroDeDetalle>";

	public static String PERSONA_FISICA_ANUAL=
			"<RegistroDeDetalle> "+ "\n"
				+"<PersonaFisica rfc=\"%Rfc%\" curp=\"%Curp%\" NumeroCliente=\"%NumeroCliente%\"" +
				" correoElectronico=\"%CorreoElectronico%\" telefono1=\"%Telefono%\"" +
				" telefono2=\"%TelefonoCel%\">"+ "\n"
					+"<Nombre>"+ "\n"
						+"<NombreCompleto> %NombreCompletoCli% </NombreCompleto>"+ "\n"
					+"</Nombre>"+ "\n"
					+"<Domicilio>"+ "\n"
						+"<DomicilioCompleto> %DomCompletoCli% </DomicilioCompleto>"+ "\n"
					+"</Domicilio>"+ "\n"
					+"<numeroCuenta> %NumeroCuenta% </numeroCuenta>"+ "\n"
				+"</PersonaFisica>"+ "\n"
				+"<DepositoEnEfectivo montoExcedenteDeposito=\"%MontoExcedenteDeposito%\">"+ "\n"
				+"</DepositoEnEfectivo>"+ "\n"
			+"</RegistroDeDetalle>";
	
	public static String PERIODO_ANUAL=
			"<ReporteDeDepositosEnEfectivo Periodo=\"%Periodo%\">"+ "\n"
					+" %RegistroDeDetalleAnual% "+ "\n"
			+"</ReporteDeDepositosEnEfectivo>";

	// Persona Moral
	public static String PERSONA_MORAL_MENSUAL=
		"<RegistroDeDetalle> "+ "\n" 
			+"<PersonaMoral rfc=\"%Rfc%\" curp=\"%Curp%\" NumeroCliente=\"%NumeroCliente%\"" +
			" correoElectronico=\"%CorreoElectronico%\" telefono1=\"%Telefono%\"" +
			" telefono2=\"%TelefonoCel%\">"+ "\n" 
				+"<Denominacion> %DenominacionCli% </Denominacion>"+ "\n" 
				+"<Domicilio>"+ "\n" 
					+"<DomicilioCompleto> %DomCompletoCli% </DomicilioCompleto>"+ "\n" 
				+"</Domicilio>"+ "\n" 
				+"<numeroCuenta> %NumeroCuenta% </numeroCuenta>"+ "\n" 
				+"<DepositoEnEfectivo montoExcedente=\"%MontoExcedente%\" impuestoDeterminado=\"0\" " +
				"impuestoRecaudado=\"0\" recaudacionPendiente=\"0\" " +
				"remanentePeriodosAnteriores=\"0\" saldoPendienteRecaudar=\"0\">"
				+"</DepositoEnEfectivo>"+ "\n" 
			+"</PersonaMoral>"+ "\n" 
		+"</RegistroDeDetalle>";

	// Persona Moral ANUAL
	public static String PERSONA_MORAL_ANUAL=
	    "<RegistroDeDetalle> "+ "\n"
			+"<PersonaMoral rfc=\"%Rfc%\" curp=\"%Curp%\" NumeroCliente=\"%NumeroCliente%\"" +
			" correoElectronico=\"%CorreoElectronico%\" telefono1=\"%Telefono%\"" +
			" telefono2=\"%TelefonoCel%\">"+ "\n"
				+"<Denominacion> %DenominacionCli% </Denominacion>"+ "\n"
				+"<Domicilio>"+ "\n"
					+"<DomicilioCompleto> %DomCompletoCli% </DomicilioCompleto>"+ "\n"
				+"</Domicilio>"+ "\n"
				+"<numeroCuenta> %NumeroCuenta% </numeroCuenta>"+ "\n"
				+"<DepositoEnEfectivo montoExcedenteDeposito=\"%MontoExcedenteDeposito%\">"+ "\n"
				+"</DepositoEnEfectivo>"+ "\n"
			+"</PersonaMoral>"+ "\n"
		+"</RegistroDeDetalle>";
			
	public ModelAndView generaIDEXml(HttpServletResponse response,String contentOriginal, ReporteIDEBean reporteIDEBean){
		
 		try{
 			
 			List<ReporteIDEBean> listaIDERep = null;
 			String ReporteXML="";
 			String Detalle="";
 			String Auxiliar="";
 			String Periodos="";
 			int Contador=0;
 			long total = 0;
 			
 			ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
 			String directorio = parametros.getRutaArchivos()+"IDE/";
 			String nombreXml = ""; // Nombre del Archivo Xml
		    String nombreZip = ""; // Nombre del Archivo Xml
		    String rutaCompleta = "";
		    String rutaZip = "";
		   
		    listaIDERep=reporteIDEDAO.listaIDE(reporteIDEBean); 
		    
		    //Elegir tipo de reporte
		    if(reporteIDEBean.getTipoReporte().equalsIgnoreCase("M")){
		    	 nombreXml = "DeclaracionInformativaMensualIDE.xml"; // Nombre del Archivo Xml
			     nombreZip = "ReporteIDE_EJERCICIO_"+reporteIDEBean.getEjercicio()+"_PERIODO_"
		    	 +reporteIDEBean.getPeriodo()+".zip"; // Nombre del Archivo Xml
			     rutaCompleta = directorio + nombreXml;
			     rutaZip = directorio + nombreZip;
			     
			     borrarArchivo(rutaCompleta);
			     
				ReporteXML=  ENCABEZADO_MENSUAL;
				
			    ReporteXML = StringUtils.replace(ReporteXML, "%Periodo%",reporteIDEBean.getPeriodo());
			    ReporteXML = StringUtils.replace(ReporteXML, "%FechaDeCorte%",reporteIDEBean.getFechaCorte());
			   
			    // detalles del reporte mensual
		 	    for(ReporteIDEBean bean:listaIDERep){
		 	    	if(bean.getTipoPersona().equalsIgnoreCase("F")){
					    Detalle=PERSONA_FISICA_MENSUAL;
		 	    	}else{
		 	    		 Detalle=PERSONA_MORAL_MENSUAL;
		 	    	}
		 	    		//completar ceros para telefono
		 	    		bean.setTelefono(Utileria.completaCerosIzquierda(bean.getTelefono(), 15));
		 	    		bean.setTelCelular(Utileria.completaCerosIzquierda(bean.getTelCelular(), 15));
		 	    		bean.setNombreCompleto(bean.getNombreCompleto().trim().replaceAll("\\&",""));
		 	    		total = total+ Utileria.convierteLong(bean.getCantidadExcento()) ;
		 	    		
					    Detalle = StringUtils.replace(Detalle, "%Rfc%",bean.getRfc());
					    Detalle = StringUtils.replace(Detalle, "%Curp%",bean.getCurp());
					    Detalle = StringUtils.replace(Detalle, "%NumeroCliente%",bean.getClienteID());
					    Detalle = StringUtils.replace(Detalle, "%CorreoElectronico%",bean.getCorreo());
					    Detalle = StringUtils.replace(Detalle, "%Telefono%",bean.getTelefono());
					    Detalle = StringUtils.replace(Detalle, "%TelefonoCel%",bean.getTelCelular());
					    Detalle = StringUtils.replace(Detalle, "%NombreCompletoCli%",bean.getNombreCompleto());
					    Detalle = StringUtils.replace(Detalle, "%DenominacionCli%",bean.getNombreCompleto());
					    Detalle = StringUtils.replace(Detalle, "%DomCompletoCli%",bean.getDirCompleta());
					    Detalle = StringUtils.replace(Detalle, "%NumeroCuenta%",bean.getCuentaAhoID());
					    Detalle = StringUtils.replace(Detalle, "%MontoExcedente%",bean.getCantidadExcento());
					    Auxiliar =Auxiliar+Detalle;
		 	    }
		 	    ReporteXML = StringUtils.replace(ReporteXML, "%ImporteExcedenteDepositos%",Double.toString(total));
			    ReporteXML = StringUtils.replace(ReporteXML, "%RegistroDeDetalleMensual%",Auxiliar);

		    }else{
		    	nombreXml = "DeclaracionInformativaAnualIDE.xml"; // Nombre del Archivo Xml
			    nombreZip = "ReporteIDE_EJERCICIO_"+reporteIDEBean.getEjercicio()+".zip"; // Nombre del Archivo Xml
			    rutaCompleta = directorio + nombreXml;
			    rutaZip = directorio + nombreZip;
			    borrarArchivo(rutaCompleta);
			    long totalAnual=0;
			    
			    
				ReporteXML=  ENCABEZADO_ANUAL;
				Periodos= "";
				String PeriodoActual=PERIODO_ANUAL;
				String ListaPersonas[]={"","","","","","","","","","","",""};
			
				//detalles de anual
				for( int i=0; i<listaIDERep.size(); i ++){

					ReporteIDEBean	bean = (ReporteIDEBean) listaIDERep.get(i);	
					
					if(bean.getTipoPersona().equalsIgnoreCase("F")){
					    Detalle=PERSONA_FISICA_ANUAL;
		 	    	}else{
		 	    		 Detalle=PERSONA_MORAL_ANUAL;
		 	    	}
		 	    		//completar ceros para telefono
		 	    		bean.setTelefono(Utileria.completaCerosIzquierda(bean.getTelefono(), 15));
		 	    		bean.setTelCelular(Utileria.completaCerosIzquierda(bean.getTelCelular(), 15));
		 	    		bean.setNombreCompleto(bean.getNombreCompleto().trim().replaceAll("\\&",""));
		 	    		long valorActual =Utileria.convierteLong(bean.getCantidadExcento());
		 	    		totalAnual=(herramientas.CalculosyOperaciones.suma(totalAnual, valorActual));
		 	    		Contador = Utileria.convierteEntero(bean.getConsecutivo()) ;
		 	    		
					    Detalle = StringUtils.replace(Detalle, "%Rfc%",bean.getRfc());
					    Detalle = StringUtils.replace(Detalle, "%Curp%",bean.getCurp());
					    Detalle = StringUtils.replace(Detalle, "%NumeroCliente%",bean.getClienteID());
					    Detalle = StringUtils.replace(Detalle, "%CorreoElectronico%",bean.getCorreo());
					    Detalle = StringUtils.replace(Detalle, "%Telefono%",bean.getTelefono());
					    Detalle = StringUtils.replace(Detalle, "%TelefonoCel%",bean.getTelCelular());
					    Detalle = StringUtils.replace(Detalle, "%NombreCompletoCli%",bean.getNombreCompleto());
					    Detalle = StringUtils.replace(Detalle, "%DenominacionCli%",bean.getNombreCompleto());
					    Detalle = StringUtils.replace(Detalle, "%DomCompletoCli%",bean.getDirCompleta());
					    Detalle = StringUtils.replace(Detalle, "%NumeroCuenta%",bean.getCuentaAhoID());
					    Detalle = StringUtils.replace(Detalle, "%MontoExcedenteDeposito%",bean.getCantidadExcento());
					    
					    ListaPersonas[Contador-1]+=Detalle;

				}
				for(int i=1;i<=12;i++){
					PeriodoActual=PERIODO_ANUAL;
					PeriodoActual=StringUtils.replace(PeriodoActual, "%Periodo%",Integer.toString(i));
					PeriodoActual = StringUtils.replace(PeriodoActual, "%RegistroDeDetalleAnual%",ListaPersonas[i-1]);
					Periodos=Periodos+PeriodoActual;
				}
		 	    ReporteXML = StringUtils.replace(ReporteXML, "%ImporteExcedenteDepositos%",Long.toString(totalAnual));
				ReporteXML = StringUtils.replace(ReporteXML, "%RegistroDeDetallePeriodo%",Periodos);
		    }
		    
		    // Datos Generales
		    ReporteXML = StringUtils.replace(ReporteXML, "%RfcDeclarante%",reporteIDEBean.getRfcIns());
		    ReporteXML = StringUtils.replace(ReporteXML, "%Denominacion%",reporteIDEBean.getNombreInstitucion());
		    ReporteXML = StringUtils.replace(ReporteXML, "%RfcRep%",reporteIDEBean.getRfcRep());
		    ReporteXML = StringUtils.replace(ReporteXML, "%Ejercicio%",reporteIDEBean.getEjercicio());
		    ReporteXML = StringUtils.replace(ReporteXML, "%NombreCompletoRep%",reporteIDEBean.getRepresentanteLegal());
		    ReporteXML = StringUtils.replace(ReporteXML, "%OperacionesRelacionadas%",Integer.toString(listaIDERep.size()));

	 	    escribeArchivo(rutaCompleta, ReporteXML);	    	

		      File f = null;
		      boolean exists = new File(directorio).exists();
		      if (exists)
		      {
		        f = new File(rutaCompleta);
		      }
		      else
		      { 
		        File aDir = new File(directorio);
		        aDir.mkdir();
		        f = new File(rutaCompleta);
		      }
		      
		 		String inputFile = rutaCompleta;
		 		String rutaArchivo = rutaZip;
		 		FileInputStream in = new FileInputStream(inputFile);
		 		FileOutputStream out = new FileOutputStream(rutaArchivo);

		 				  	 		
		 		byte b[] = new byte[2048];
		 		ZipOutputStream zipOut = new ZipOutputStream(out);
		 		ZipEntry entry = new ZipEntry(nombreXml);
		 		zipOut.putNextEntry(entry);
		 		int len = 0;
		 		while ((len = in.read(b)) != -1) {
		 			zipOut.write(b, 0, len);
		 		}		
		 		zipOut.flush();
		 		
		 		zipOut.close();	
		 		
		 		File xml = new File(rutaCompleta);
		 		xml.delete();
		 		File archivoFile = new File(rutaZip);
		 		
			      FileInputStream fileInputStream = new FileInputStream(archivoFile);
			      
			 		response.addHeader("Content-Disposition","attachment; filename="+nombreZip);
			 		response.setContentType("application/zip");
			
			 		response.setContentLength((int) archivoFile.length()); 		
			 		int bytes;
			 		
					while ((bytes = fileInputStream.read()) != -1) {
						response.getOutputStream().write(bytes);
					}
					fileInputStream.close();
					response.getOutputStream().flush();
					response.getOutputStream().close();
		      
		      return null;
		    }
		    catch (Exception e)
		    {
		      e.printStackTrace();
		      String htmlString = Constantes.htmlErrorReporteCirculo;
		      response.addHeader("Content-Disposition", "");
		      response.setContentType(contentOriginal);
		      response.setContentLength(htmlString.length());
		      return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString);
		    }
		}
	
	public void escribeArchivo(String fileName, String linea) throws Exception { 

		 FileWriter fichero = null; 
		 PrintWriter pw = null; 
		 try{ 
		   fichero = new FileWriter(fileName,true); 
		   pw = new PrintWriter(fichero); 
		   pw.println(linea); 
          pw.flush();
          fichero.close();
		  }catch (Exception e) { 
		    e.printStackTrace();
		    throw new Exception(e);
		  }finally{ 
		    if (null != fichero){
		     try{
		       fichero.close(); 
		     }catch (Exception e2) { 
		       e2.printStackTrace(); 
		     }
		    }
		 } 
	}
	 public void borrarArchivo(String fileName)
	  {
	    File f = new File(fileName);
	    if (f.exists()) {
	      f.delete();
	    }
	    f = null;
	  }
	
	public String obtenerNombreMes(int mes){
		String nombreMes="";
		switch(mes){
		case 1:  nombreMes="ENERO";
			break;
		case 2:	nombreMes="FEBRERO";
			break;
		case 3: nombreMes="MARZO";
			break;			
		case 4: nombreMes="ABRIL";
			break;
		case 5: nombreMes="MAYO";
			break;
		case 6: nombreMes="JUNIO";
			break;
		case 7: nombreMes="JULIO";
			break;
		case 8: nombreMes="AGOSTO";
			break;
		case 9: nombreMes="SEPTIEMBRE";
			break;
		case 10: nombreMes="OCTUBRE";
			break;
		case 11: nombreMes="NOVIEMBRE";
			break;
		case 12: nombreMes="DICIEMBRE";
			break;		
		}
		return nombreMes;
	}
	
	public ReporteIDEDAO getReporteIDEDAO() {
		return reporteIDEDAO;
	}
	public void setReporteIDEDAO(ReporteIDEDAO reporteIDEDAO) {
		this.reporteIDEDAO = reporteIDEDAO;
	}


	public Archivos getManejoArchivo() {
		return manejoArchivo;
	}


	public void setManejoArchivo(Archivos manejoArchivo) {
		this.manejoArchivo = manejoArchivo;
	}


	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}


	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}


	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}


	public void setParametrosAplicacionServicio(
			ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}
	
}
