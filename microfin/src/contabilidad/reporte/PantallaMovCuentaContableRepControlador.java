package contabilidad.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFFont;
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

import contabilidad.bean.ReportesContablesBean;
import contabilidad.servicio.ReportesContablesServicio;

public class PantallaMovCuentaContableRepControlador extends AbstractCommandController{

	public static interface Enum_Con_TipRepor {
		int  ReporPantalla= 1 ;
		int  ReporPDF= 2 ;
		int  ReporExcel= 3;
	}
	ReportesContablesServicio reportesContablesServicio = null;
	String nombreReporte = null;  
	String successView = null;		

	public PantallaMovCuentaContableRepControlador() {
		setCommandClass(ReportesContablesBean.class);
		setCommandName("reportesContables");
	}

	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		
		ReportesContablesBean reportesContablesBean = (ReportesContablesBean) command;
		
		int tipoReporte = (request.getParameter("tipoReporte") != null) ?Integer.parseInt(request.getParameter("tipoReporte")) : 0;
		
		String htmlString = "";
		
		switch (tipoReporte) {
			case Enum_Con_TipRepor.ReporPantalla:
				htmlString = reportesContablesServicio.reportesMovCuentaContaPoliza(reportesContablesBean, nombreReporte);
				break;
			case Enum_Con_TipRepor.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = reportesMovCuentaContaPolizaPDF(reportesContablesBean, nombreReporte, response);
				break;
			case Enum_Con_TipRepor.ReporExcel:
				reporteMovCtasExcel(reportesContablesBean, response);
				break;
		}
		
		if (tipoReporte == Enum_Con_TipRepor.ReporPantalla) {
			return new ModelAndView(getSuccessView(), "reporte", htmlString);
		} else {
			return null;
		}
		
	}
	// Reporte  de Mov de Cuentas Contables en PDF
	public ByteArrayOutputStream reportesMovCuentaContaPolizaPDF(ReportesContablesBean reportesContablesBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = reportesContablesServicio.reportesMovCuentaContaPolizaPDF(reportesContablesBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteMovCuentaContable.pdf");
			response.setContentType("application/pdf");
			byte[] bytes = htmlStringPDF.toByteArray();
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		} catch (Exception e) {
			e.printStackTrace();
		}		
		return htmlStringPDF;
	}

	/**
	 * Reporte de Movimientos por cuenta contable formato excel
	 * @param reportesContablesBean
	 * @param response
	 * @return
	 */
	public List <ReportesContablesBean>reporteMovCtasExcel(ReportesContablesBean reportesContablesBean, HttpServletResponse response){
		List <ReportesContablesBean>listaMovCta= null;
		listaMovCta=reportesContablesServicio.listaReporteMovCtas(reportesContablesBean,response);
		//hora reporte
		Calendar calendario=new GregorianCalendar();
		SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");
		reportesContablesBean.setHoraEmision(postFormater.format(calendario.getTime()));
		//Comienza el armado de la hoja
		if(listaMovCta != null){
			try{
				SXSSFWorkbook libro = new SXSSFWorkbook();
				/*************************************************************************************************
				 * *********** ESTILO DE LA HOJA *************************************************************
				 */
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				Font fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
				fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				Font fuenteNegrita10Izq= libro.createFont();
				fuenteNegrita10Izq.setFontHeightInPoints((short)10);
				fuenteNegrita10Izq.setFontName(HSSFFont.FONT_ARIAL);
				fuenteNegrita10Izq.setBoldweight(Font.BOLDWEIGHT_BOLD);

				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				Font fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
				fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);

				//Crea un Fuente con tamaño 8 para informacion del reporte.
				Font fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)8);
				fuente8.setFontName(HSSFFont.FONT_ARIAL);
				
				Font fuente8Cuerpo= libro.createFont();
				fuente8Cuerpo.setFontHeightInPoints((short)8);
				fuente8Cuerpo.setFontName(HSSFFont.FONT_ARIAL);

				//Crea un Fuente con tamaño 8 para informacion del reporte.
				Font fuente10= libro.createFont();
				fuente8.setFontHeightInPoints((short)10);
				fuente8.setFontName(HSSFFont.FONT_ARIAL);
				
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				CellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				estiloNeg10.setAlignment(CellStyle.ALIGN_CENTER);
				
				//Alineado a la izq
				CellStyle estiloNeg10Izq = libro.createCellStyle();
				estiloNeg10Izq.setFont(fuenteNegrita10Izq);
				estiloNeg10Izq.setAlignment(CellStyle.ALIGN_LEFT);
				
				//Estilo negrita de 8  para encabezados del reporte
				CellStyle estiloNeg8 = libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita8);
				
				CellStyle estilo8 = libro.createCellStyle();
				estilo8.setFont(fuente8);
				
				CellStyle estilo10 = libro.createCellStyle();
				estilo8.setFont(fuente10);

				//Estilo Formato decimal (0.00)
				CellStyle estiloFormatoDecimal = libro.createCellStyle();
				DataFormat format = libro.createDataFormat();
				estiloFormatoDecimal.setDataFormat(format.getFormat("$#,###,##0.00"));	
				estiloFormatoDecimal.setFont(fuente8);
				
				//Estilo Formato decimal (0.00)
				CellStyle estiloFormatoDecimalTit = libro.createCellStyle();
				DataFormat formatTit = libro.createDataFormat();
				estiloFormatoDecimalTit.setDataFormat(formatTit.getFormat("$#,###,##0.00"));
				estiloFormatoDecimalTit.setFont(fuenteNegrita8);
				/*************************************************************************************************
				 * *********** FIN ESTILO DE LA HOJA *************************************************************
				 */
				// Creacion de hoja					
				Sheet hoja = libro.createSheet("Reporte Movimiento por Cta Contable");
				/*************************************************************************************************
				 * ***********ENCABEZADO DEL REPORTE *************************************************************
				 */
				// inicio fecha, usuario,institucion y hora
				//USUARIO
				Row fila= hoja.createRow(0);
				Cell celdaUsu= fila.createCell((short)9);
				celdaUsu.setCellValue("Usuario:");
				celdaUsu.setCellStyle(estiloNeg10Izq);	
				celdaUsu = fila.createCell((short)10);
				celdaUsu.setCellValue(((!reportesContablesBean.getNombreusuario().isEmpty())?reportesContablesBean.getNombreusuario(): "TODOS").toUpperCase());
				//Fecha
				fila = hoja.createRow(1);
				String fechaVar = reportesContablesBean.getFechaEmision().toString();
				Cell celdaFec= fila.createCell((short)9);
				celdaFec.setCellValue("Fecha:");
				celdaFec.setCellStyle(estiloNeg10Izq);	
				celdaFec = fila.createCell((short)10);
				celdaFec.setCellValue(fechaVar);
				// INSTITUCION
				Cell celdaInst=fila.createCell((short)1);
				celdaInst.setCellValue(reportesContablesBean.getNombreInstitucion());
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					1, //primera fila (0-based)
					1, //ultima fila  (0-based)
					1, //primer celda (0-based)
					6  //ultima celda   (0-based)
				));
				 celdaInst.setCellStyle(estiloNeg10);
				//HORA
				fila = hoja.createRow(2);
				Cell celdaHora= fila.createCell((short)9);
				celdaHora.setCellValue("Hora:");
				celdaHora.setCellStyle(estiloNeg10Izq);	
				celdaHora = fila.createCell((short)10);
				celdaHora.setCellValue(reportesContablesBean.getHoraEmision());
				//TITULO REPORTE
				Cell celda=fila.createCell((short)1);
				celda.setCellValue("REPORTE DE MOVIMIENTOS POR CUENTA CONTABLE DEL "+reportesContablesBean.getFechaIni()+" AL "+reportesContablesBean.getFechaFin());
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					2, //primera fila (0-based)
					2, //ultima fila  (0-based)
					1, //primer celda (0-based)
					6 //ultima celda   (0-based)
				));
				celda.setCellStyle(estiloNeg10);	
				/*************************************************************************************************
				 * ***********FIN ENCABEZADO DEL REPORTE *************************************************************
				 */
				
				/*************************************************************************************************
				 * ***********FILTROS DEL REPORTE *************************************************************
				 */
				String centroCostos=String.valueOf(reportesContablesBean.getSegundoCentroCostos()) ;
				String tipoInstrumento=String.valueOf(reportesContablesBean.getSegundoRango()) ;
				
				if(centroCostos.equals("0")){
					centroCostos = "TODOS";
				}
				else{
					centroCostos = reportesContablesBean.getPrimerCentroCostos()+ " - "+ reportesContablesBean.getSegundoCentroCostos();
				}
				
				if(tipoInstrumento.equals("0")){
					tipoInstrumento = "TODOS";	
				}
				else{
					tipoInstrumento = reportesContablesBean.getPrimerRango()+" - "+reportesContablesBean.getSegundoRango();
				}
				// CUENTA DE INICIO
				fila = hoja.createRow(4);
				celda=fila.createCell((short)1);
				celda.setCellStyle(estiloNeg10Izq);
				celda.setCellValue("Cuenta Inicio: ");
				
				celda=fila.createCell((short)2);// NUMERO DE CUENTA
				celda.setCellValue(reportesContablesBean.getCuentaCompleta());
				celda.setCellStyle(estilo10);
				celda=fila.createCell((short)3);// DESCRIPCION DE LA CUENTA
				celda.setCellValue(reportesContablesBean.getDesCuentaCompleta());
				celda.setCellStyle(estilo10);
				
				// TIPO DE INSTRUMENTO
				celda=fila.createCell((short)4);
				celda.setCellStyle(estiloNeg10Izq);
				celda.setCellValue("Tipo Instrumento:");				
				celda=fila.createCell((short)5);
				celda.setCellValue(reportesContablesBean.getDescTipoInstrumento());
				celda.setCellStyle(estilo10);
				
				//CENTRO DE COSTOS
				celda=fila.createCell((short)6);
				celda.setCellStyle(estiloNeg10Izq);
				celda.setCellValue("CR:");
				celda=fila.createCell((short)7);
				celda.setCellStyle(estilo10);
				celda.setCellValue(centroCostos);
				
				fila = hoja.createRow(5);
				//CUENTA FIN
				celda=fila.createCell((short)1);
				celda.setCellStyle(estiloNeg10Izq);
				celda.setCellValue("Cuenta Fin: ");
				celda=fila.createCell((short)2);
				celda.setCellStyle(estilo10);
				celda.setCellValue(reportesContablesBean.getCuentaCompletaFin());
				celda=fila.createCell((short)3);
				celda.setCellStyle(estilo10);
				celda.setCellValue(reportesContablesBean.getDesCuentaCompletaF());
				// INSTRUMENTO
				celda=fila.createCell((short)4);
				celda.setCellStyle(estiloNeg10Izq);
				celda.setCellValue("Instrumento: ");
				celda=fila.createCell((short)5);
				celda.setCellStyle(estilo10);
				celda.setCellValue(tipoInstrumento);
				/*************************************************************************************************
				 * ***********FIN FILTROS DEL REPORTE *************************************************************
				 */
				
				/*************************************************************************************************
				 * ***********ENCABEZADOS DE LAS COLUMNAS DEL REPORTE *************************************************************
				 */
				fila = hoja.createRow(7);

				celda = fila.createCell((short)0);
				celda.setCellValue("Empresa");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)1);
				celda.setCellValue("Póliza");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)2);
				celda.setCellValue("Cuenta");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Descripción");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Fecha");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)5);
				celda.setCellValue("CR");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("Instrumento");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)7);
				celda.setCellValue("Concepto");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Cargos");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)9);
				celda.setCellValue("Abonos");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)10);
				celda.setCellValue("Saldos");
				celda.setCellStyle(estiloNeg8);
				/*************************************************************************************************
				 * ***********FIN ENCABEZADOS DE LAS COLUMNAS DEL REPORTE *************************************************************
				 */
				/*************************************************************************************************
				 * ***********CONTENIDO DEL REPORTE *************************************************************
				 */
				int nfila=8, tempEncabezado=8;
				double saldoInicial = 0.0;
				double subTotalCargos=0.00;
				double subTotalAbonos=0.00;
				double totalCargos=0.00;
				double totalAbonos=0.00;
				String cuentaContableActual="";
				/*** SALDO INICIAL ********************************************/
				
				for(int k=0;k<listaMovCta.size();k++){
					ReportesContablesBean movcta = listaMovCta.get(k);
					/*Si la cuenta contable actual es diferente a la anterior se setea en la variable*/
					if(!movcta.getCuentaCompleta().equals(cuentaContableActual)){
						//Obtenemos la cuenta completa
						cuentaContableActual=movcta.getCuentaCompleta();
						//Inicializamos los totales
						saldoInicial = 0.0;
						subTotalCargos=0.00;
						subTotalAbonos=0.00;
						totalCargos=0.00;
						totalAbonos=0.00;
						// guardamos la fila actual
						tempEncabezado = nfila;
						/*ENCABEZADO -----------------------------------------------------*/
						fila=hoja.createRow(tempEncabezado);
						hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
								tempEncabezado, //primera fila (0-based)
								tempEncabezado, //ultima fila  (0-based)
								0, //primer celda (0-based)
								4  //ultima celda (0-based)
								)); 	
						celda = fila.createCell((short)0);
						celda.setCellValue("No. Cuenta: "+movcta.getCuentaCompleta()+" - "+movcta.getDesCuentaCompleta());
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)6);
						celda.setCellValue("Saldo Inicial: ");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)7);
						celda.setCellValue(Utileria.convierteDoble(movcta.getSaldoInicial()));
						celda.setCellStyle(estiloFormatoDecimal);
						
			
						celda = fila.createCell((short)8);
						celda.setCellValue("Saldo Final: ");
						celda.setCellStyle(estiloNeg8);
						
						celda = fila.createCell((short)9);
						celda.setCellValue(Double.parseDouble(movcta.getSaldoFinal()));
						celda.setCellStyle(estiloFormatoDecimal);
						/*FIN ENCABEZADO -------------------------------------------------*/
						nfila++;//Se aumentan las filas en 1 para guardar la actual
						/**
						 * NOTA: Los encabezados se crearan al final ya que se tenga a sumatoria de los datos
						 * */
					}
					//CREAMOS LA FILA
					fila=hoja.createRow(nfila);
					//Empresa
					celda=fila.createCell((short)0);
					celda.setCellValue(movcta.getEmpresaID());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					//Poliza
					celda=fila.createCell((short)1);
					celda.setCellValue(movcta.getPolizaID());
					celda.setCellStyle(estilo8);
					//Cuenta completa
					celda=fila.createCell((short)2);
					celda.setCellValue(movcta.getCuentaCompleta());
					celda.setCellStyle(estilo8);
					celda.getCellStyle().setFont(fuente8Cuerpo);
					//Descripcion de la cuenta
					celda=fila.createCell((short)3);
					celda.setCellValue(movcta.getDesCuentaCompleta());
					celda.setCellStyle(estilo8);
					//Fecha
					celda=fila.createCell((short)4);
					celda.setCellValue(movcta.getFecha());
					celda.setCellStyle(estilo8);
					//Centro de costo
					celda=fila.createCell((short)5);
					celda.setCellValue(movcta.getCentroCostoID());
					celda.setCellStyle(estilo8);
					//Instrumento
					celda=fila.createCell((short)6);
					celda.setCellValue(movcta.getInstrumentos());
					celda.setCellStyle(estilo8);
					//Concepto
					celda=fila.createCell((short)7);
					celda.setCellValue(movcta.getDescripcion());
					celda.setCellStyle(estilo8);
					//Cargos
					celda=fila.createCell((short)8);
					if(movcta.getCargos()!=null && !movcta.getCargos().isEmpty()){
						celda.setCellValue(Double.parseDouble(movcta.getCargos()));
						celda.setCellStyle(estiloFormatoDecimal);
						subTotalCargos+=Double.parseDouble(movcta.getCargos());
						totalCargos+=Double.parseDouble(movcta.getCargos());
					}
					//Abonos
					celda=fila.createCell((short)9);
					if(movcta.getAbonos()!=null && !movcta.getAbonos().isEmpty()){
						celda.setCellValue(Double.parseDouble(movcta.getAbonos()));
						celda.setCellStyle(estiloFormatoDecimal);
						subTotalAbonos+=Double.parseDouble(movcta.getAbonos());
						totalAbonos+=Double.parseDouble(movcta.getAbonos());
					}
					//Saldos
					celda=fila.createCell((short)10);
					if(movcta.getSaldos()!=null && !movcta.getSaldos().isEmpty()){
						celda.setCellValue(Double.parseDouble(movcta.getSaldos()));
						celda.setCellStyle(estiloFormatoDecimal);
					}
					/*****SUBTOTALES *************************************************************/
					boolean escribirSubtotalesYEncabezado=false;
					int regActual = k+1;
					//Escribiendo subtotales en caso de que las cuentas sean diferentes
					if(regActual<listaMovCta.size()){//Si tiene siguiente registro la lista vemos si son diferentes las cuentas contables
						String cuentaContableSiguiente = listaMovCta.get(regActual).getCuentaCompleta();
						//Si la cuenta es diferente de vacio
						if(cuentaContableSiguiente!=null && !cuentaContableSiguiente.trim().equals("") &&
								!cuentaContableActual.equals(cuentaContableSiguiente)){
							escribirSubtotalesYEncabezado =true;
						}
						
					} else {
						escribirSubtotalesYEncabezado =true;
					}
					
					if(escribirSubtotalesYEncabezado){
						/*SUBTOTALES -------------------------------------------------*/
						nfila++; //Se aumenta la fila
						fila=hoja.createRow(nfila);	
						hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
							nfila, //primera fila (0-based)
							nfila, //ultima fila  (0-based)
							0, //primer celda (0-based)
							3  //ultima celda   (0-based)
						));
						celda = fila.createCell((short)0);
						celda.setCellValue("SubTotal Cuenta: "+movcta.getCuentaCompleta());
						celda.setCellStyle(estiloNeg8);	
						//SubtotalCargos
						celda = fila.createCell((short)8);
						celda.setCellValue(subTotalCargos);										
						celda.setCellStyle(estiloFormatoDecimalTit);
						//SubtotalAbonos
						celda = fila.createCell((short)9);							
						celda.setCellValue(subTotalAbonos);						
						celda.setCellStyle(estiloFormatoDecimalTit);
						/*FIN SUBTOTALES -------------------------------------------------*/
						nfila++;
					}
					/*****FIN SUBTOTALES *************************************************************/

					nfila++;
				}
				for(int celd=0; celd<=15; celd++)
					hoja.autoSizeColumn((short)celd, true);
				
				// Finaliza reporte
				response.addHeader("Content-Disposition","inline; filename=ReporteMovCtasContables.xlsx");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
			}catch(Exception ex){
				ex.printStackTrace();
			}
		}
		return listaMovCta;
	}
	
	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setReportesContablesServicio(ReportesContablesServicio reportesContablesServicio) {
		this.reportesContablesServicio = reportesContablesServicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}	

}