package inversiones.reporte;
import java.io.ByteArrayOutputStream;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import general.bean.ParametrosAuditoriaBean;
import herramientas.Constantes;
import herramientas.Utileria;
import inversiones.bean.InversionBean;
import inversiones.servicio.InversionServicio;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
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
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import org.springframework.web.servlet.mvc.AbstractCommandController;


import credito.bean.CreQuitasBean;
import credito.reporte.ReporteQuitasCondControlador.Enum_Con_TipRepor;

	public class AperturasInvRepControlador extends AbstractCommandController{
		InversionServicio inversionServicio = null;
		String nombreReporte = null;
		String successView = null;				   
		protected final Logger loggerSAFI = Logger.getLogger("SAFI");
		private ParametrosAuditoriaBean parametrosAuditoriaBean=null;	   
		
		public static interface Enum_Con_TipRepor {
			  int  ReporPantalla= 1 ;
			  int  ReporPDF= 2 ;
			  int  ReporExcel= 3 ;
		}
		
		public AperturasInvRepControlador() {
			setCommandClass(InversionBean.class);
			setCommandName("aperturasInv");
		}
		
		protected ModelAndView handle(HttpServletRequest request,
				  HttpServletResponse response,
				  Object command,
				  BindException errors) throws Exception {

			InversionBean inversionBean = (InversionBean) command;
			
			int tipoReporte =(request.getParameter("tipoReporte")!=null)?
					Integer.parseInt(request.getParameter("tipoReporte")):0;
			
				int tipoLista =(request.getParameter("tipoLista")!=null)?
					Integer.parseInt(request.getParameter("tipoLista")):0;
			
			String htmlString= "";
			
			switch(tipoReporte){
				
				case Enum_Con_TipRepor.ReporPantalla:
					 htmlString = inversionServicio.reporteInversionDia(inversionBean, nombreReporte);
				break;
					
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = reporteInversionDiaPDF(inversionBean, nombreReporte, response);
				break;

				case Enum_Con_TipRepor.ReporExcel:		
					 List<InversionBean>listaReportes = reporteInversionDiaExcel(inversionBean,response);
				break;
			}
			
			if(tipoReporte == Enum_Con_TipRepor.ReporPantalla ){
				return new ModelAndView(getSuccessView(), "reporte", htmlString);
			}
			else {
				return null;
			}
		}

		public ByteArrayOutputStream reporteInversionDiaPDF(InversionBean inversionBean, String nombreReporte, HttpServletResponse response){
			ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = inversionServicio.repInversionPDF(inversionBean, nombreReporte);
				response.addHeader("Content-Disposition","inline; filename=RepAperturaInversiones.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlStringPDF.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}		
		return htmlStringPDF;
		}
		
		
		public List <InversionBean> reporteInversionDiaExcel(InversionBean inversionBean, HttpServletResponse response){
			
			List<InversionBean> listaInversiones = null;
			listaInversiones = inversionServicio.listaInversionesAperturaExcel(inversionBean, response); 	
			Date date = new Date();
			DateFormat hora = new SimpleDateFormat("HH:mm");
			
			int registrosExportados = 0;
			
			if(listaInversiones != null){
				// Creacion de Libro
				try {
				Workbook libro = new SXSSFWorkbook();
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				Font fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)10);
				fuenteNegrita8.setFontName("Arial");
				fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
				// Fuente Negrita
				Font fuenteNegrita= libro.createFont();
				fuenteNegrita.setFontHeightInPoints((short)10);
				fuenteNegrita.setFontName("Arial");
				fuenteNegrita.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				//Crea un Fuente Negrita con tamaño 10 para informacion del reporte.
				Font fuente8= libro.createFont();
				fuente8.setFontHeightInPoints((short)10);
				fuente8.setFontName("Arial");
				
				// Estilo Encabezado
				CellStyle estiloNegritaEncabezado = libro.createCellStyle();
				estiloNegritaEncabezado.setFont(fuenteNegrita8);
				estiloNegritaEncabezado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloNegritaEncabezado.setWrapText(true);
				
				// Estilo 10 negrita
				CellStyle estiloNegrita = libro.createCellStyle();
				estiloNegrita.setFont(fuenteNegrita8);
				estiloNegrita.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloNegrita.setWrapText(true);
				
				// Estilo 10 negrita derecha
				CellStyle estiloNegritaIzquierda = libro.createCellStyle();
				estiloNegritaIzquierda.setFont(fuenteNegrita);
				estiloNegritaIzquierda.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
				estiloNegritaIzquierda.setWrapText(true);
				
				//Estilo de 10  para Contenido
				CellStyle estilo8 = libro.createCellStyle();
				estilo8.setFont(fuente8);
				estilo8.setAlignment((short)XSSFCellStyle.ALIGN_LEFT);
				estilo8.setWrapText(true);
				
				//Estilo Formato Tasa (0.0000)
				CellStyle estiloFormatoTasa = libro.createCellStyle();
				DataFormat formato = libro.createDataFormat();
				estiloFormatoTasa.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
				estiloFormatoTasa.setDataFormat(formato.getFormat("0.0000"));
				estiloFormatoTasa.setFont(fuente8);
				estiloFormatoTasa.setWrapText(true);
				
				//Estilo Formato Decimal (0.00)
				CellStyle estiloFormatoDecimal = libro.createCellStyle();
				DataFormat formatodecimal = libro.createDataFormat();
				estiloFormatoDecimal.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
				estiloFormatoDecimal.setDataFormat(formatodecimal.getFormat("#,##0.00"));
				estiloFormatoDecimal.setFont(fuente8);
				estiloFormatoDecimal.setWrapText(true);
				
				//Estilo Formato Decimal Negrita en montos totales(0.00)
				CellStyle estiloNegritaDerecha = libro.createCellStyle();
				DataFormat formatodecimalNegrita = libro.createDataFormat();
				estiloNegritaDerecha.setAlignment((short)XSSFCellStyle.ALIGN_RIGHT);
				estiloNegritaDerecha.setDataFormat(formatodecimalNegrita.getFormat("#,##0.00"));
				estiloNegritaDerecha.setFont(fuenteNegrita8);
				estiloNegritaDerecha.setWrapText(true);
				
				//Estilo de 10  para Contenido
				CellStyle estiloCentrado = libro.createCellStyle();
				DataFormat formatoCentrado = libro.createDataFormat();
				estiloCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloCentrado.setFont(fuente8);
				estiloCentrado.setDataFormat(formatoCentrado.getFormat("#"));
				estiloCentrado.setWrapText(true);
				
				// Creacion de hoja
				SXSSFSheet hoja = null;
				hoja = (SXSSFSheet) libro.createSheet("Reporte Aperturas de Inversión.");
				
				Row fila = (Row) hoja.createRow(1);
				
				fila = hoja.createRow(0);
				fila = hoja.createRow(1);
				Cell celda=fila.createCell((short)1);
				
				/* FIN ENCABEZADO y CONFIGURACION DEL  EXCEL */
				celda = fila.createCell((short)1);
				celda.setCellValue(inversionBean.getNombreInstitucion());
				celda.setCellStyle(estiloNegritaEncabezado);
				//funcion para unir celdas
				hoja.addMergedRegion(new CellRangeAddress( 1, 1, 1, 14));
				
				/* Campo Fecha */
				celda = fila.createCell((short)15);
				celda.setCellValue("Usuario:");
				celda.setCellStyle(estiloNegritaIzquierda);
			    
				/* Valor de Fecha*/
				celda = fila.createCell((short)16);
				celda.setCellValue(inversionBean.getNombreUsuario());
				celda.setCellStyle(estilo8);
				
				fila = hoja.createRow(2);
				celda = fila.createCell((short)1);
				celda.setCellValue("REPORTE DE APERTURAS DEL DÍA " + inversionBean.getFechaInicio());
				celda.setCellStyle(estiloNegritaEncabezado);
				hoja.addMergedRegion(new CellRangeAddress(2, 2, 1, 14));
				
				/* Campo Hora */
				celda = fila.createCell((short)15);
				celda.setCellValue("Fecha:");
				celda.setCellStyle(estiloNegritaIzquierda);
				
				/* Valor de hora*/
				celda = fila.createCell((short)16);
				celda.setCellValue(inversionBean.getFechaActual());
				celda.setCellStyle(estilo8);
				
				fila = hoja.createRow(3);
				/* Campo Reporte */
				celda = fila.createCell((short)15);
				celda.setCellValue("Hora:");
				celda.setCellStyle(estiloNegritaIzquierda);
				
				/* Valor de Reporte*/
				celda = fila.createCell((short)16);
				celda.setCellValue(hora.format(date));
				celda.setCellStyle(estilo8);
				
				fila = hoja.createRow(4);
				/* Campo Usuario */
				celda = fila.createCell((short)15);
				celda.setCellValue("Reporte:");
				celda.setCellStyle(estiloNegritaIzquierda);
				
				/* Valor de Usuario*/
				celda = fila.createCell((short)16);
				celda.setCellValue("APERTURAS");
				celda.setCellStyle(estilo8);
				
				fila = hoja.createRow(5);
				/* Campo Sucursal */
				celda = fila.createCell((short)1);
				celda.setCellValue("Sucursal:");
				celda.setCellStyle(estiloNegritaIzquierda);
				hoja.addMergedRegion(new CellRangeAddress(5, 5, 1, 2));
				
				/* Valor de Sucursal*/
				String sucursalID=inversionBean.getNombreSucursal();
				if(sucursalID.equals("")){
					sucursalID="TODOS";
				}
				celda = fila.createCell((short)3);
				celda.setCellValue(sucursalID);
				celda.setCellStyle(estilo8);
				
				/* Campo Promotor */
				celda = fila.createCell((short)8);
				celda.setCellValue("Promotor:");
				celda.setCellStyle(estiloNegritaIzquierda);
				hoja.addMergedRegion(new CellRangeAddress(5, 5, 8, 9));
				
				/* Valor de Promotor*/
				String promotorID=inversionBean.getNombrePromotor();
				if(promotorID.equals("")){
					promotorID="TODOS";
				}
				celda = fila.createCell((short)10);
				celda.setCellValue(promotorID);
				celda.setCellStyle(estilo8);
				hoja.addMergedRegion(new CellRangeAddress(5, 5, 10, 12));
				
				fila = hoja.createRow(6);
				/* Campo Inversion */
				celda = fila.createCell((short)1);
				celda.setCellValue("Tipo de Inversión:");
				celda.setCellStyle(estiloNegritaIzquierda);
				hoja.addMergedRegion(new CellRangeAddress(6, 6, 1, 2));
				
				/* Valor de Inversion */
				String tipoInversionID = inversionBean.getDescripcionTipoInv();
				if(tipoInversionID.equals("")){
					tipoInversionID="TODOS";
				}
				celda = fila.createCell((short)3);
				celda.setCellValue(tipoInversionID);
				celda.setCellStyle(estilo8);
				
				/* Campo Modena */
				celda = fila.createCell((short)8);
				celda.setCellValue("Moneda:");
				celda.setCellStyle(estiloNegritaIzquierda);
				hoja.addMergedRegion(new CellRangeAddress(6, 6, 8, 9));
				
				/* Valor de ModenaID */
				String modenaID=inversionBean.getNombreMoneda();
				if(modenaID.equals("")){
					modenaID="TODOS";
				}
				celda = fila.createCell((short)10);
				celda.setCellValue(modenaID);
				celda.setCellStyle(estilo8);
				hoja.addMergedRegion(new CellRangeAddress(6, 6, 10, 12));
				
				// Creacion de fila
				fila = hoja.createRow(7);
				
				//Inicio en la segunda fila y que el fila uno tiene los encabezados
				fila = hoja.createRow(8);
				celda = fila.createCell((short)1);
				celda.setCellValue("No. Inv");
				celda.setCellStyle(estiloNegrita);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("No. Cliente");
				celda.setCellStyle(estiloNegrita);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Nombre Cliente");
				celda.setCellStyle(estiloNegrita);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Sucursal");
				celda.setCellStyle(estiloNegrita);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Tipo Inversión");
				celda.setCellStyle(estiloNegrita);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("Promotor");
				celda.setCellStyle(estiloNegrita);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("Tasa");
				celda.setCellStyle(estiloNegrita);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("Tasa ISR");
				celda.setCellStyle(estiloNegrita);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Tasa Neta");
				celda.setCellStyle(estiloNegrita);
				
				celda = fila.createCell((short)10);
				celda.setCellValue("Monto");
				celda.setCellStyle(estiloNegrita);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("Plazo(Días)");
				celda.setCellStyle(estiloNegrita);
				
				celda = fila.createCell((short)12);
				celda.setCellValue("Fecha Vencimiento");
				celda.setCellStyle(estiloNegrita);
				
				celda = fila.createCell((short)13);
				celda.setCellValue("Interés Generado");
				celda.setCellStyle(estiloNegrita);
				
				celda = fila.createCell((short)14);
				celda.setCellValue("Interés Retenido");
				celda.setCellStyle(estiloNegrita);
				
				celda = fila.createCell((short)15);
				celda.setCellValue("Interés Recibir");
				celda.setCellStyle(estiloNegrita);
				
				celda = fila.createCell((short)16);
				celda.setCellValue("Total Recibir");
				celda.setCellStyle(estiloNegrita);
				
				int i=9;
				double totalInteresGenerado = 0;
				double totalInteresRetenido = 0;
				double totalRecibir = 0;
				double totalInteresRecibir = 0;
				double totalMonto = 0;
											
				for(InversionBean bean : listaInversiones ){
					
					fila=hoja.createRow(i);
					
					/* Inversion */
					celda=fila.createCell((short)1);
					celda.setCellValue(Integer.parseInt(bean.getInversionID()));
					celda.setCellStyle(estilo8);
										
					/* Cliente o socio */
					celda=fila.createCell((short)2);
					celda.setCellValue(Integer.parseInt(bean.getClienteID()));
					celda.setCellStyle(estilo8);

					/* Nombre Cliente/Socio */
					celda=fila.createCell((short)3);
					celda.setCellValue(bean.getNombreCompleto());
					celda.setCellStyle(estilo8);

					/* Sucursal */
					celda=fila.createCell((short)4);
					celda.setCellValue(bean.getNombreSucursal());
					celda.setCellStyle(estilo8);

					/* Tipo Inversion */
					celda=fila.createCell((short)5);
					celda.setCellValue(bean.getDescripcionTipoInv());
					celda.setCellStyle(estilo8);
					
					/* Promotor */
					celda=fila.createCell((short)6);
					celda.setCellValue(bean.getNombrePromotor());
					celda.setCellStyle(estilo8);

					/* Tasa */
					celda=fila.createCell((short)7);
					celda.setCellValue(bean.getTasa());
					celda.setCellStyle(estiloFormatoTasa);

					/* TasaISR */
					celda=fila.createCell((short)8);
					celda.setCellValue(bean.getTasaISR());
					celda.setCellStyle(estiloFormatoTasa);
					
					/* Tasa Neta */
					celda=fila.createCell((short)9);
					celda.setCellValue(bean.getTasaNeta());
					celda.setCellStyle(estiloFormatoTasa);
										
					/* Monto */
					celda=fila.createCell((short)10);
					celda.setCellValue(bean.getMonto());
					celda.setCellStyle(estiloFormatoDecimal);
					
					/* Plazo */
					celda=fila.createCell((short)11);
					celda.setCellValue(bean.getPlazo());
					celda.setCellStyle(estiloCentrado);
					
					/* Fecha Venciemiento */
					celda=fila.createCell((short)12);
					celda.setCellValue(bean.getFechaVencimiento());
					celda.setCellStyle(estilo8);
					
					/* Interés Generado */
					celda=fila.createCell((short)13);
					celda.setCellValue(bean.getInteresGenerado());
					celda.setCellStyle(estiloFormatoDecimal);
										
					/* Interés Retenido */
					celda=fila.createCell((short)14);
					celda.setCellValue(bean.getInteresRetener());
					celda.setCellStyle(estiloFormatoDecimal);
					
					/* Interés Retenido */
					celda=fila.createCell((short)15);
					celda.setCellValue(bean.getInteresRecibir());
					celda.setCellStyle(estiloFormatoDecimal);

					/* Total a Recibir */
					celda=fila.createCell((short)16);
					celda.setCellValue(bean.getTotalRecibir());
					celda.setCellStyle(estiloFormatoDecimal);
											
					registrosExportados = registrosExportados + 1;
					totalMonto = totalMonto + bean.getMonto();
					totalInteresGenerado = totalInteresGenerado + bean.getInteresGenerado();
					totalInteresRetenido = totalInteresRetenido + bean.getInteresRetener();
					totalInteresRecibir = totalInteresRecibir + bean.getInteresRecibir();
					totalRecibir = totalRecibir + bean.getTotalRecibir();
					
					i++;										
				}
				
				fila=hoja.createRow(i);
				/* Total General*/
				celda = fila.createCell((short)1);
				celda.setCellValue("Total General:");
				celda.setCellStyle(estiloNegritaIzquierda);
				
				/* Monto Total */
				celda = fila.createCell((short)10);
				celda.setCellValue(totalMonto);
				celda.setCellStyle(estiloNegritaDerecha);
				
				/* Interés Generado Total */
				celda = fila.createCell((short)13);
				celda.setCellValue(totalInteresGenerado);
				celda.setCellStyle(estiloNegritaDerecha);
				
				/* Interés Retenido Total */
				celda = fila.createCell((short)14);
				celda.setCellValue(totalInteresRetenido);
				celda.setCellStyle(estiloNegritaDerecha);
				
				/* Interés Recibir Total */
				celda = fila.createCell((short)15);
				celda.setCellValue(totalInteresRecibir);
				celda.setCellStyle(estiloNegritaDerecha);
				
				/* Total */
				celda = fila.createCell((short)16);
				celda.setCellValue(totalRecibir);
				celda.setCellStyle(estiloNegritaDerecha);
				
				i = i+2;
				fila=hoja.createRow(i);
				celda = fila.createCell((short)0);
				celda.setCellValue("Registros Exportados:");
				hoja.addMergedRegion(new CellRangeAddress(i, i, 0, 0));
				celda.setCellStyle(estiloNegritaIzquierda);
				
				celda = fila.createCell((short)1);
				celda.setCellValue(registrosExportados);
				hoja.addMergedRegion(new CellRangeAddress(i, i, 1, 1));
				celda.setCellStyle(estiloNegritaIzquierda);
				
				hoja.setColumnWidth(0,2500);
				hoja.setColumnWidth(1,3000);
				hoja.setColumnWidth(2,3000);
				hoja.setColumnWidth(3,10000);
				hoja.setColumnWidth(4,6000);
				hoja.setColumnWidth(5,6000);
				hoja.setColumnWidth(6,9000);
				hoja.setColumnWidth(7,3000);
				hoja.setColumnWidth(8,3000);
				hoja.setColumnWidth(9,3000);
				hoja.setColumnWidth(10,3000);
				hoja.setColumnWidth(11,3000);
				hoja.setColumnWidth(12,3000);
				hoja.setColumnWidth(13,3000);
				hoja.setColumnWidth(14,3000);
				hoja.setColumnWidth(15,3000);
				hoja.setColumnWidth(16,3500);
				
				String nombreArchivo = "Reporte Aperturas del Día";
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename="+nombreArchivo+".xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
			
				}catch(Exception e){
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte Apertura del dia: " + e.getMessage());
					e.printStackTrace();
				}
			}
			return  listaInversiones;
			
		}

		public InversionServicio getInversionServicio() {
			return inversionServicio;
		}

		public void setInversionServicio(InversionServicio inversionServicio) {
			this.inversionServicio = inversionServicio;
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
		
	}
	
