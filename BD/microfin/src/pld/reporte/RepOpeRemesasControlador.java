package pld.reporte;

import general.bean.ParametrosAuditoriaBean;
import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.ReporteOpeRemesasBean;
import pld.servicio.ReporteOpeRemesasServicio;

public class RepOpeRemesasControlador extends AbstractCommandController{
	
	ReporteOpeRemesasServicio reporteOpeRemesasServicio = null;
	public ParametrosSesionBean parametrosSesionBean = null;
	private ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public RepOpeRemesasControlador(){
 		setCommandClass(ReporteOpeRemesasBean.class);
 		setCommandName("reporteOpeRemesasBean");
 	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {

		ReporteOpeRemesasBean reporteOpeRemesasBean = (ReporteOpeRemesasBean) command;

		String htmlString = "";
		List listaReporteOpe;
		try {							
			listaReporteOpe = reporteOperacionesRemExcel(reporteOpeRemesasBean, response);															
				
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public List reporteOperacionesRemExcel(ReporteOpeRemesasBean reporteOpeRemesasBean,HttpServletResponse response){
		List <ReporteOpeRemesasBean> listaRepOpe  = null;
		listaRepOpe = reporteOpeRemesasServicio.listaReporteOperaRemesas(reporteOpeRemesasBean);
		Calendar calendario = new GregorianCalendar();
		try {
			Workbook libro = new SXSSFWorkbook();
				// Se crea una Fuente Negrita 	con tamaño 10 para el titulo del reporte
				Font fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setFontName("Arial");
				fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				// Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				Font fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setFontName("Arial");
				fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				Font fuenteNeg8= libro.createFont();
				fuenteNeg8.setFontHeightInPoints((short)8);
				fuenteNeg8.setFontName("Arial");
				fuenteNeg8.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				// Estilo negrita de 10 para encabezados del reporte
				XSSFCellStyle estiloNeg10 = (XSSFCellStyle) libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				
				// Estilo de datos centrado en la información del reporte
				XSSFCellStyle estiloDatosCentrado = (XSSFCellStyle) libro.createCellStyle();
				estiloDatosCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER); 
				
				// Estrilo centrado fuente negrita 10
				XSSFCellStyle estiloCentrado10 = (XSSFCellStyle) libro.createCellStyle();			
				estiloCentrado10.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloCentrado10.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloCentrado10.setFont(fuenteNegrita10);
				
				// Estilo centrado fuente negrita 8
				XSSFCellStyle estiloCentrado = (XSSFCellStyle) libro.createCellStyle();
				estiloCentrado.setFont(fuenteNegrita8);
				estiloCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloCentrado.setWrapText(true);
				
				// Estilo centrado fuente  8
				XSSFCellStyle estiloCentra = (XSSFCellStyle) libro.createCellStyle();
				estiloCentra.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloCentra.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloCentra.setWrapText(true);
				
				// Estilo derecho fuente  8
				XSSFCellStyle estiloDerecho = (XSSFCellStyle) libro.createCellStyle();
				estiloDerecho.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
				estiloDerecho.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloDerecho.setWrapText(true);
				
				// Estilo negrita de 8 para encabezados del reporte
				XSSFCellStyle estiloNeg8 = (XSSFCellStyle) libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita8);
				
				XSSFCellStyle estiloNegro8 = (XSSFCellStyle) libro.createCellStyle();
				estiloNegro8.setFont(fuenteNeg8);
				
				// Estilo negrita de 8  y color de fondo
				XSSFCellStyle estiloColor = (XSSFCellStyle) libro.createCellStyle();
				estiloColor.setFont(fuenteNegrita8);
				estiloColor.setFillForegroundColor(IndexedColors.CORNFLOWER_BLUE.index);
				estiloColor.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
				
				// Estilo Formato decimal (000,000.00)
				XSSFCellStyle estiloFormatoDecimal = (XSSFCellStyle) libro.createCellStyle();
				DataFormat format = libro.createDataFormat();
				estiloFormatoDecimal.setDataFormat(format.getFormat("$ ###,###.##000,000.00"));
				estiloFormatoDecimal.setAlignment(CellStyle.ALIGN_RIGHT);
				
				//NUEVA HOJA DE EXCEL
				SXSSFSheet hoja = (SXSSFSheet) libro.createSheet("Reporte Operaciones Remesas");
				
				//PRIMER FILA
				Row fila = hoja.createRow(0);

				// Nombre Institucion	
				Cell celdaInst=fila.createCell((short)2);
				celdaInst.setCellValue(parametrosSesionBean.getNombreInstitucion());
				celdaInst.setCellStyle(estiloCentrado10);				
				hoja.addMergedRegion(new CellRangeAddress(
						0, //primera fila 
			            0, //ultima fila 
			            2, //primer celda
			            7 //ultima celda
			    ));	
				
				// Nombre Usuario
				Cell celdaUsu=fila.createCell((short)10);
				celdaUsu.setCellValue("Usuario:");
				celdaUsu.setCellStyle(estiloNegro8);	
				celdaUsu = fila.createCell((short)11);				
				celdaUsu.setCellValue(((!parametrosSesionBean.getClaveUsuario().isEmpty())?parametrosSesionBean.getClaveUsuario(): "TODOS").toUpperCase());				
					
				// SEGUNDA FILA
				fila = hoja.createRow(1);		
				
				// Titulo del Reporte
				Cell celda=fila.createCell((short)2);
				celda.setCellValue("Reporte de Operaciones de Remesas del " +Utileria.convierteFecha(reporteOpeRemesasBean.getFechaInicial())
						+" AL "+reporteOpeRemesasBean.getFechaFinal());
				celda.setCellStyle(estiloCentrado10);					
				hoja.addMergedRegion(new CellRangeAddress(
					1, //primera fila 
			        1, //ultima fila 
			        2, //primer celda
			        7 //ultima celda
			    ));	
				
				// Fecha en que se genera el reporte
				Cell celdaFec=fila.createCell((short)10);
				celdaFec.setCellValue("Fecha:");
				celdaFec.setCellStyle(estiloNegro8);	
				celdaFec = fila.createCell((short)11);
				celdaFec.setCellValue(parametrosSesionBean.getFechaAplicacion().toString());	
				
				// TERCER FILA
				fila = hoja.createRow(2);
								
				// Hora en que se genera el reporte
				Cell celdaHora=fila.createCell((short)10);
				celdaHora.setCellValue("Hora:");
				celdaHora.setCellStyle(estiloNegro8);	
				celdaHora = fila.createCell((short)11);
				
				String horaVar=""; 
 				int hora = calendario.get(Calendar.HOUR_OF_DAY);
 				int minutos = calendario.get(Calendar.MINUTE);
 				
 				String h = "";
 				String m = "";
 		
 				if(hora<10)h="0"+Integer.toString(hora); else h=Integer.toString(hora);
 				if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
 							 
 				horaVar= h+":"+m;
 				
 				celdaHora.setCellValue(horaVar);	
				
				// CUARTA FILA SEPARADOR
 				fila = hoja.createRow(3);
 				
 				// Nombre de la Entidad TD o TDE
				Cell entidad=fila.createCell((short)0);
				entidad.setCellValue("Entidad TD o TDE");
				entidad.setCellStyle(estiloNegro8);	
				entidad = fila.createCell((short)1);
				entidad.setCellValue(reporteOpeRemesasBean.getNombreEnt());	
				
				// Tipo de Operacion
				Cell operacion=fila.createCell((short)4);
				operacion.setCellValue("Tipo Operación");
				operacion.setCellStyle(estiloNegro8);	
				operacion = fila.createCell((short)5);
				final String tipoOpe = reporteOpeRemesasBean.getTipoOperacion();// variable para obtener el tipo de operacion
				switch (Utileria.convierteEntero(tipoOpe)){
		            case 0:  operacion.setCellValue("TODOS");
		                     break;
		            case 1:  operacion.setCellValue("EFECTIVO");
		                     break;
		            case 2:  operacion.setCellValue("SPEI");
		                     break;
		            case 3:  operacion.setCellValue("ABONO A CTA.");
		                     break;
		            default: operacion.setCellValue("DEFAULT");
		                     break;
		        }				
				
				// Estatus
				Cell estatus=fila.createCell((short)8);
				estatus.setCellValue("Estatus");
				estatus.setCellStyle(estiloNegro8);	
				estatus = fila.createCell((short)9);
				final String est = reporteOpeRemesasBean.getEstatus();// variable para obtener el estatus
				switch (Utileria.convierteEntero(est)){
		            case 0:  estatus.setCellValue("TODOS");
		                     break;
		            case 1:  estatus.setCellValue("REGISTRADOS");
		                     break;
		            case 2:  estatus.setCellValue("EN REVISIÓN");
		                     break;
		            case 3:  estatus.setCellValue("RECHAZADOS");
		                     break;
		            case 4:  estatus.setCellValue("PAGADOS");
                    		 break;
		            default: estatus.setCellValue("DEFAULT");
		                     break;
		        }
				
				// Umbral
				Cell umbral=fila.createCell((short)12);
				umbral.setCellValue("Umbral");
				umbral.setCellStyle(estiloNegro8);	
				umbral = fila.createCell((short)13);
				final String umb = reporteOpeRemesasBean.getUmbral();// variable para obtener el umbral en dolares
				switch (Utileria.convierteEntero(umb)){
		            case 0:  umbral.setCellValue("TODOS");
		                     break;
		            case 1:  umbral.setCellValue("< 1000");
		                     break;
		            case 2:  umbral.setCellValue("< 3000");
		                     break;
		            case 3:  umbral.setCellValue("< 5000");
		                     break;		           
		            default: umbral.setCellValue("DEFAULT");
		                     break;
		        }
				
				// QUINTA FILA
				fila = hoja.createRow(4);
				
				// SEXTA FILA SEPARADOR
				fila = hoja.createRow(5);

				celda = fila.createCell((short)0);
				celda.setCellValue("Nombre de la Entidad TD o TDE");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("Número de Identificación");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("Fecha de la Operación");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Monto de la Operación");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Moneda");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Número de Cliente o Usuario");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("Apellido Paterno Beneficiario");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("Apellido Materno Beneficiario");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Nombre del Beneficiario (S)");
				celda.setCellStyle(estiloCentrado);	
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Razón Social o Denominación del Beneficiario");
				celda.setCellStyle(estiloCentrado);	
				
				celda = fila.createCell((short)10);
				celda.setCellValue("Tipo de Persona");
				celda.setCellStyle(estiloCentrado);	
				
				celda = fila.createCell((short)11);
				celda.setCellValue("Instrucciones de Liquidación");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)12);
				celda.setCellValue("Fecha de Liquidación");
				celda.setCellStyle(estiloCentrado);	
				
				celda = fila.createCell((short)13);
				celda.setCellValue("Monto de Liquidación");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)14);
				celda.setCellValue("Concepto Pago");
				celda.setCellStyle(estiloCentrado);	
				
				celda = fila.createCell((short)15);
				celda.setCellValue("Causa de  Devolución");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)16);
				celda.setCellValue("Moneda de Liquidación");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)17);
				celda.setCellValue("Cuenta Clabe de Depósito");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)18);
				celda.setCellValue("Apellido Paterno Remitente");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)19);
				celda.setCellValue("Apellido Materno Remitente");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)20);
				celda.setCellValue("Nombre Remitente");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)21);
				celda.setCellValue("Razón Social o Denominación Remitente");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)22);
				celda.setCellValue("Tipo de Persona Remitente");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)23);
				celda.setCellValue("Estatus");
				celda.setCellStyle(estiloCentrado);
								
				int i=7, iter=0;
				int tamanioLista = listaRepOpe.size();
				ReporteOpeRemesasBean beanLis = null;
				
				for(iter=0; iter<tamanioLista; iter ++){
					beanLis = (ReporteOpeRemesasBean) listaRepOpe.get(iter);
					
					fila = hoja.createRow(i);
					
					celda = fila.createCell((short)0);
					celda.setCellValue(beanLis.getNombreEntidad());
					
					celda = fila.createCell((short)1);
					celda.setCellValue(beanLis.getNumIdentificacion());
					
					celda = fila.createCell((short)2);
					celda.setCellValue(beanLis.getFechaOperacion());
					
					celda = fila.createCell((short)3);
					celda.setCellValue(beanLis.getMontoOperacion());
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)4);
					celda.setCellValue(beanLis.getMoneda());
					
					celda = fila.createCell((short)5);
					celda.setCellValue(beanLis.getClienteID());
					
					celda = fila.createCell((short)6);
					celda.setCellValue(beanLis.getApellidoPatBene());
					
					celda = fila.createCell((short)7);
					celda.setCellValue(beanLis.getApellidoMatBene());

					celda = fila.createCell((short)8);
					celda.setCellValue(beanLis.getNombreBene());
					
					celda = fila.createCell((short)9);
					celda.setCellValue(beanLis.getRazonSocialBene());
					
					celda = fila.createCell((short)10);
					celda.setCellValue(beanLis.getTipoPersonaBene());
					
					celda = fila.createCell((short)11);
					celda.setCellValue(beanLis.getTipoLiquidacion());
					
					celda = fila.createCell((short)12);
					celda.setCellValue(beanLis.getFechaLiquidacion());	
					
					celda = fila.createCell((short)13);
					celda.setCellValue(beanLis.getMontoLiquidacion());
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)14);
					celda.setCellValue(beanLis.getConceptoPago());	
					
					celda = fila.createCell((short)15);
					celda.setCellValue(beanLis.getCausaDevolucion());
					
					celda = fila.createCell((short)16);
					celda.setCellValue(beanLis.getMonedaLiquidacion());	
					
					celda = fila.createCell((short)17);
					celda.setCellValue(beanLis.getCuentaClabe());
					
					celda = fila.createCell((short)18);
					celda.setCellValue(beanLis.getApellidoPatRemi());
					
					celda = fila.createCell((short)19);
					celda.setCellValue(beanLis.getApellidoMatRemi());
					
					celda = fila.createCell((short)20);
					celda.setCellValue(beanLis.getNombreRemi());
					
					celda = fila.createCell((short)21);
					celda.setCellValue(beanLis.getRazonSocialRemi());
					
					celda = fila.createCell((short)22);
					celda.setCellValue(beanLis.getTipoPersonaRemi());
					
					celda = fila.createCell((short)23);
					celda.setCellValue(beanLis.getEstatusOperacion());
					
					i++;
				}	
				i = i+2;
				fila=hoja.createRow(i);
				celda = fila.createCell((short)0);
				celda.setCellValue("Núm. Registros");
				celda.setCellStyle(estiloNegro8);
				celda=fila.createCell((short)1);
				celda.setCellValue(tamanioLista);			

				hoja.setColumnWidth(0, 22 * 256);
				hoja.setColumnWidth(1, 18 * 256);
				hoja.setColumnWidth(2, 16 * 256);
				hoja.setColumnWidth(3, 16 * 256);
				hoja.setColumnWidth(4, 12 * 256);
				hoja.setColumnWidth(5, 15 * 256);
				hoja.setColumnWidth(6, 16 * 256);
				hoja.setColumnWidth(7, 16 * 256);
				hoja.setColumnWidth(8, 20 * 256);
				hoja.setColumnWidth(9, 20 * 256);
				hoja.setColumnWidth(10, 12 * 256);
				hoja.setColumnWidth(11, 16 * 256);
				hoja.setColumnWidth(12, 14 * 256);
				hoja.setColumnWidth(13, 14 * 256);
				hoja.setColumnWidth(14, 14 * 256);
				hoja.setColumnWidth(15, 15 * 256);
				hoja.setColumnWidth(16, 16 * 256);
				hoja.setColumnWidth(17, 16 * 256);
				hoja.setColumnWidth(18, 16 * 256);
				hoja.setColumnWidth(19, 14 * 256);
				hoja.setColumnWidth(20, 16 * 256);
				hoja.setColumnWidth(21, 18 * 256);
				hoja.setColumnWidth(22, 15 * 256);
				hoja.setColumnWidth(23, 12 * 256);
				
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReporteOpeRemesas.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				libro.write(outputStream);
				outputStream.flush();
				outputStream.close();
				
				loggerSAFI.debug("Termina Reporte de Operaciones con Remesas");
		
		}catch(Exception e){
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte de Operaciones con remesas: " + e.getMessage());
			e.printStackTrace();
		}//Fin del catch
		return  listaRepOpe;	
	}

	public ReporteOpeRemesasServicio getReporteOpeRemesasServicio() {
		return reporteOpeRemesasServicio;
	}

	public void setReporteOpeRemesasServicio(
			ReporteOpeRemesasServicio reporteOpeRemesasServicio) {
		this.reporteOpeRemesasServicio = reporteOpeRemesasServicio;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}

}
