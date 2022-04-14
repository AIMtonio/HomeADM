package nomina.reporte;

import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.servicio.NominaServicio;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import nomina.bean.EmpleadoNominaBean;

public class DescuentosNominaRepControlador extends AbstractCommandController {

	NominaServicio nominaServicio = null;
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporExcel= 1 ;
		}
	public DescuentosNominaRepControlador () {
		setCommandClass(EmpleadoNominaBean.class);
		setCommandName("descuentosNominaBean");
	}
		
		protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors)throws Exception {
			
			EmpleadoNominaBean descuentosNominaBean = (EmpleadoNominaBean) command;

		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):
			0;
		int tipoLista =(request.getParameter("tipoLista")!=null)?
						Integer.parseInt(request.getParameter("tipoLista")):
			0;			
		String htmlString= "";
		tipoReporte=tipoLista;
		switch(tipoReporte){
		case Enum_Con_TipRepor.ReporExcel:		
			 List listaReportes = conDescuentosNominaExcel(tipoLista,descuentosNominaBean,response);
		break;
	}
		return null;
	}
		// Reporte de Descuentos de Nomina en EXCEL
				public List conDescuentosNominaExcel(int tipoLista,EmpleadoNominaBean descuentosNominaBean,  HttpServletResponse response){
				List <EmpleadoNominaBean> listaDescuentosNomina=null;
				listaDescuentosNomina = (List) nominaServicio.listaEstatusEmpleadosNomina(tipoLista,descuentosNominaBean,response); 
				
				int regExport = 0;
			
					
				try {
					HSSFWorkbook libro = new HSSFWorkbook();
					//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
					HSSFFont fuenteNegrita10= libro.createFont();
					fuenteNegrita10.setFontHeightInPoints((short)10);
					fuenteNegrita10.setFontName("Negrita");
					fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
					
					
					//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
					HSSFFont fuenteNegrita8= libro.createFont();
					fuenteNegrita8.setFontHeightInPoints((short)8);
					fuenteNegrita8.setFontName("Negrita");
					fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
					
					// La fuente se mete en un estilo para poder ser usada.
					//Estilo negrita de 10 para el titulo del reporte
					HSSFCellStyle estiloNeg10 = libro.createCellStyle();
					estiloNeg10.setFont(fuenteNegrita10);
					
					//Estilo negrita de 8  para encabezados del reporte
					HSSFCellStyle estiloNeg8 = libro.createCellStyle();
					estiloNeg8.setFont(fuenteNegrita8);
					
					HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
					estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
					
					HSSFCellStyle estiloCentrado = libro.createCellStyle();
					estiloCentrado.setFont(fuenteNegrita8);
					estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
					estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
					
					
					//Estilo negrita de 8  y color de fondo
					HSSFCellStyle estiloColor = libro.createCellStyle();
					estiloColor.setFont(fuenteNegrita8);
					estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
					estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
					
					//Estilo Formato decimal (0.00)
					HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
					HSSFDataFormat format = libro.createDataFormat();
					estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
					
					// Creacion de hoja					
					HSSFSheet hoja = libro.createSheet("Reporte Descuentos de Nómina");
					HSSFRow fila= hoja.createRow(0);
					HSSFCell celda=fila.createCell((short)0);
					
				
					celda.setCellValue(descuentosNominaBean.getNombreInstitucion());
					estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER); 
					hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					            0, //primera fila (0-based)
					            0, //ultima fila  (0-based)
					            0, //primer celda (0-based)
					            6 //ultima celda   (0-based)
					    ));
					 celda.setCellStyle(estiloCentrado);
				
					 
					celda=fila.createCell((short)11);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Usuario: "+descuentosNominaBean.getUsuario());
					
					fila = hoja.createRow(1);
					celda=fila.createCell((short)11);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Fecha: "+descuentosNominaBean.getFechaEmision());
						
					fila = hoja.createRow(2);
					celda=fila.createCell((short)0);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("REPORTE DE DESCUENTOS DE NÓMINA");
					estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER); 
					hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					            2, //primera fila (0-based)
					            2, //ultima fila  (0-based)
					            0, //primer celda (0-based)
					            6  //ultima celda   (0-based)
					    ));
					 celda.setCellStyle(estiloCentrado);
	
					if( !listaDescuentosNomina.isEmpty()){
						String hora = listaDescuentosNomina.get(0).getHoraEmision();
						celda=fila.createCell((short)11);
						celda.setCellStyle(estiloNeg10);
						celda.setCellValue("Hora: "+hora);
					}
				   	// Creacion de filas
					fila = hoja.createRow(3);
					fila = hoja.createRow(4);

					celda = fila.createCell((short)0);
					celda.setCellValue("Número de Empleado");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)1);
					celda.setCellValue("Nombre Completo");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)2);
					celda.setCellValue("Monto a Descontar");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)3);
					celda.setCellValue("Plazo");
					celda.setCellStyle(estiloNeg8);
						
					celda = fila.createCell((short)4);
					celda.setCellValue("Dependencia");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)5);
					celda.setCellValue("Número de Pago");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)6);
					celda.setCellValue("Fecha Exigible");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)7);
					celda.setCellValue("Número Crédito");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)8);
					celda.setCellValue("Monto en Atraso");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)9);
					celda.setCellValue("Monto Exigible");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)10);
					celda.setCellValue("Monto Accesorio");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)11);
					celda.setCellValue("Monto Total");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)12);
					celda.setCellValue("Adeudo Total del Crédito");
					celda.setCellStyle(estiloNeg8);
				
				
					 
					 int i=5,iter=0;
						if( !listaDescuentosNomina.isEmpty()){
						int tamanioLista = listaDescuentosNomina.size();
						EmpleadoNominaBean descuentoCredito = null;
						for( iter=0; iter<tamanioLista; iter ++){
					
					descuentoCredito = (EmpleadoNominaBean) listaDescuentosNomina.get(iter);
					fila=hoja.createRow(i);
					
					// Número de Empleado ,Nombre Completo,Plazo,Monto a Descontar,Dependencia
										
					celda=fila.createCell((short)0);
					celda.setCellValue(descuentoCredito.getFolioCtrl());
					
					celda=fila.createCell((short)1);
					celda.setCellValue(descuentoCredito.getNombreCompleto());
					
					celda=fila.createCell((short)2);
					celda.setCellValue(Double.parseDouble(descuentoCredito.getMontoCuota()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)3);
					celda.setCellValue(descuentoCredito.getPlazo());
					
					celda=fila.createCell((short)4);
					celda.setCellValue(descuentoCredito.getNombreInstNomina());
	
					celda=fila.createCell((short)5);
					celda.setCellValue(descuentoCredito.getNumPago());
					
					celda=fila.createCell((short)6);
					celda.setCellValue(descuentoCredito.getFechaPago());
					
					celda=fila.createCell((short)7);
					celda.setCellValue(descuentoCredito.getCreditoID());
					
					celda=fila.createCell((short)8);
					celda.setCellValue(Double.parseDouble(descuentoCredito.getMontoAtraso()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)9);
					celda.setCellValue(Double.parseDouble(descuentoCredito.getMontoExigible()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell( ( short ) 10 );
					celda.setCellValue( Double.parseDouble( descuentoCredito.getMontoAccesorio() ) );
					celda.setCellStyle( estiloFormatoDecimal );
					
					celda=fila.createCell((short)11);
					celda.setCellValue(Double.parseDouble(descuentoCredito.getMontoTotal()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)12);
					celda.setCellValue(Double.parseDouble(descuentoCredito.getAdeudoTotal()));
					celda.setCellStyle(estiloFormatoDecimal);
				
					i++;
					regExport++;
						}
					}
				
					
					i = i+1;
					fila=hoja.createRow(i);
					celda = fila.createCell((short)0);
					celda.setCellValue("Registros Exportados");
					celda.setCellStyle(estiloNeg8);
					
					
					
					i = i+1;
					fila=hoja.createRow(i);
					celda=fila.createCell((short)0);
					celda.setCellValue(regExport);
					

					for(int celd=0; celd<=19; celd++)
					hoja.autoSizeColumn((short)celd);
				
					//Se crea la cabecera
					response.addHeader("Content-Disposition","inline; filename=RepDescuentosNomina.xls");
					response.setContentType("application/vnd.ms-excel");
					
					ServletOutputStream outputStream = response.getOutputStream();
					hoja.getWorkbook().write(outputStream);
					outputStream.flush();
					outputStream.close();
						
				//	log.info("Termina Reporte");
					}catch(Exception e){
					//	log.info("Error al crear el reporte: " + e.getMessage());
						e.printStackTrace();
					}//Fin del catch
					
				return  listaDescuentosNomina;		
				}
		
		

		public NominaServicio getNominaServicio() {
					return nominaServicio;
				}

				public void setNominaServicio(NominaServicio nominaServicio) {
					this.nominaServicio = nominaServicio;
				}

		public String getSuccessView() {
			return successView;
		}

		public void setSuccessView(String successView) {
			this.successView = successView;
		}
}
