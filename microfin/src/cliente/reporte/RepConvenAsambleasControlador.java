package cliente.reporte;

import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
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
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.RepConvenSecBean;
import cliente.servicio.RepConvenSecServicio;

public class RepConvenAsambleasControlador extends AbstractCommandController{

	public static interface Enum_Con_TipRepor {
		  int  excel= 1 ;
		  int  excelins= 2 ;
		  int excelpros= 3 ;
	}
	RepConvenSecServicio repConvenSecServicio = null;
	
	String nombreReporte = null;
	String successView = null;
	
	public RepConvenAsambleasControlador(){
		setCommandClass(RepConvenSecBean.class);
		setCommandName("repConvenSecBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		RepConvenSecBean repConvenSecBean = (RepConvenSecBean) command;
		int tipoReporte =(request.getParameter("tipoRep")!=null)?
				Integer.parseInt(request.getParameter("tipoRep")):0;
	
			
		String htmlString= "";
		
		switch(tipoReporte){	
		case Enum_Con_TipRepor.excel:	
			 List<RepConvenSecBean>listaReportes = listaReporte(tipoReporte, repConvenSecBean ,response);
			 break;
		case Enum_Con_TipRepor.excelins:	
			 List<RepConvenSecBean>listaReportesIns = listaReporte(tipoReporte, repConvenSecBean ,response);
			 break;
		case Enum_Con_TipRepor.excelpros:	
			 List<RepConvenSecBean>listaReportesPros = listaReporte(tipoReporte, repConvenSecBean ,response);
			 break;	 
		}
		return null;	
	}
	
	public List<RepConvenSecBean> listaReporte(int tipoReporte,RepConvenSecBean repConvenSecBean,  HttpServletResponse response){
		List<RepConvenSecBean> listaAsambleasPre=null;
		
		if(tipoReporte ==1){
		listaAsambleasPre = repConvenSecServicio.listaReporte(1, repConvenSecBean, response);
		}
		
		else if(tipoReporte ==2){
			listaAsambleasPre = repConvenSecServicio.listaReporte(2, repConvenSecBean, response);
		}
		else if(tipoReporte ==3){
			listaAsambleasPre = repConvenSecServicio.listaReporte(3, repConvenSecBean, response);
		}
	     
		int regExport = 0;
		Calendar calendario = Calendar.getInstance();
		
		if(listaAsambleasPre != null){
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

						//Estilo de datos centrados Encabezado
						HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
						estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  
						estiloDatosCentrado.setFont(fuenteNegrita10);
						estiloDatosCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
						
						// La fuente se mete en un estilo para poder ser usada.
						//Estilo negrita de 10 para el titulo del reporte
						HSSFCellStyle estiloNeg10 = libro.createCellStyle();
						estiloNeg10.setFont(fuenteNegrita10);

						//Estilo negrita de 8  para encabezados del reporte
						HSSFCellStyle estiloNeg8 = libro.createCellStyle();
						estiloNeg8.setFont(fuenteNegrita8);

						//Estilo de 8  para Contenido
						HSSFCellStyle estilo8 = libro.createCellStyle();
						estilo8.setFont(fuente8);

						//Estilo negrita de 8  y color de fondo
						HSSFCellStyle estiloColor = libro.createCellStyle();
						estiloColor.setFont(fuenteNegrita8);
						estiloColor.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
						estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);	
						
						HSSFSheet hoja = libro.createSheet("Reporte de Asambleas");
						HSSFRow fila= hoja.createRow(0);
						fila = hoja.createRow(1);
						fila = hoja.createRow(2);

						if(tipoReporte == 1) {

						HSSFCell celda=fila.createCell((short)1);
						
						celda.setCellStyle(estiloNeg10);
						celda.setCellValue(repConvenSecBean.getNombreInstitucion());
						hoja.addMergedRegion(new CellRangeAddress(
						           2,2,1,3));
						
						celda = fila.createCell((short)4);
						celda.setCellValue("Usuario:");
						celda.setCellStyle(estiloNeg8);
						celda = fila.createCell((short)5);
						celda.setCellValue(repConvenSecBean.getUsuario());
						celda.setCellStyle(estiloNeg8);
						fila = hoja.createRow(3);
						//celda = fila.createCell((short)6);
					
						
						fila = hoja.createRow(3);
						celda = fila.createCell	((short)1);
						celda.setCellStyle(estiloNeg10);
						celda.setCellValue("REPORTE DE PREINSCRIPCION A ASAMBLEAS DEL "+repConvenSecBean.getFechaInicio()+" AL "+repConvenSecBean.getFechaFin());
						hoja.addMergedRegion(new CellRangeAddress(
						           3,3,1,3));
				
									
					
						celda = fila.createCell((short)4);
						celda.setCellValue("Hora:");
						celda.setCellStyle(estiloNeg8);
						celda = fila.createCell((short)5);
						
						String horaVar="";
						
					 
						int hora =calendario.get(Calendar.HOUR_OF_DAY);
						int minutos = calendario.get(Calendar.MINUTE);
						int segundos = calendario.get(Calendar.SECOND);
						
						String h = Integer.toString(hora);
						String m = "";
						String s = "";
						if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
						if(segundos<10)s="0"+Integer.toString(segundos); else s=Integer.toString(segundos);
						
							 
						horaVar= h+":"+m+":"+s;
						
						celda.setCellValue(horaVar);
						celda.setCellStyle(estiloNeg8);
						fila = hoja.createRow(5);
						celda = fila.createCell((short)5);
					
						
						// Creacion de fila
						fila = hoja.createRow(6);
						fila = hoja.createRow(7);

						//Inicio en la segunda fila y que el fila uno tiene los encabezados
						celda = fila.createCell((short)0);
						celda.setCellValue("NÚMERO DE SOCIO");
						celda.setCellStyle(estiloNeg8);
						celda.setCellStyle(estiloColor);
									

						celda = fila.createCell((short)1);
						celda.setCellValue("NOMBRE SOCIO");
						celda.setCellStyle(estiloNeg8);
						celda.setCellStyle(estiloColor);
						
						celda = fila.createCell((short)2);
						celda.setCellValue("NOMBRE SUCURSAL");
						celda.setCellStyle(estiloNeg8);
						celda.setCellStyle(estiloColor);
						
						celda = fila.createCell((short)3);
						celda.setCellValue("ASAMBLEA");
						celda.setCellStyle(estiloNeg8);
						celda.setCellStyle(estiloColor);
						
						celda = fila.createCell((short)4);
						celda.setCellValue("FECHA ASAMBLEA");
						celda.setCellStyle(estiloNeg8);
						celda.setCellStyle(estiloColor);
						
						celda = fila.createCell((short)5);
						celda.setCellValue("FECHA REGISTRO");
						celda.setCellStyle(estiloNeg8);
						celda.setCellStyle(estiloColor);
						
						
						int i=8;
						for(RepConvenSecBean asambleaspre : listaAsambleasPre ){
							fila=hoja.createRow(i);
							celda=fila.createCell((short)0);
							celda.setCellValue(asambleaspre.getNoSocio());
							celda.setCellStyle(estilo8);
							
						
							celda=fila.createCell((short)1);
							celda.setCellValue(asambleaspre.getNombreCompleto());
							celda.setCellStyle(estilo8);
							
							celda=fila.createCell((short)2);
							celda.setCellValue(asambleaspre.getNombreSucurs());
							celda.setCellStyle(estilo8);
							
							celda=fila.createCell((short)3);
							celda.setCellValue(asambleaspre.getTipoRegistroDes());
							celda.setCellStyle(estilo8);						
							
							celda=fila.createCell((short)4);					
							celda.setCellValue(asambleaspre.getFechaAsamblea());
							celda.setCellStyle(estilo8);
							
							celda=fila.createCell((short)5);
							celda.setCellValue(asambleaspre.getFechaRegistro());
							celda.setCellStyle(estilo8);						
							
												
							regExport 		= regExport + 1;

							i++;
						}
						
									
											
						hoja.autoSizeColumn((short)0);
						hoja.autoSizeColumn((short)1);
						hoja.autoSizeColumn((short)2);
						hoja.autoSizeColumn((short)3);
						hoja.autoSizeColumn((short)4);
						hoja.autoSizeColumn((short)5);
					}
						else if(tipoReporte == 2) {
							
							HSSFCell celda=fila.createCell((short)1);
							
							celda.setCellStyle(estiloNeg10);
							celda.setCellValue(repConvenSecBean.getNombreInstitucion());
							hoja.addMergedRegion(new CellRangeAddress(
							           2,2,1,3));
							
							celda = fila.createCell((short)4);
							celda.setCellValue("Usuario:");
							celda.setCellStyle(estiloNeg8);
							celda = fila.createCell((short)5);
							celda.setCellValue(repConvenSecBean.getUsuario());
							celda.setCellStyle(estiloNeg8);
							fila = hoja.createRow(3);
							//celda = fila.createCell((short)6);
						
							
							fila = hoja.createRow(3);
							celda = fila.createCell	((short)1);
							celda.setCellStyle(estiloNeg10);
							celda.setCellValue("REPORTE DE INSCRIPCION A ASAMBLEAS DEL "+repConvenSecBean.getFechaInicio()+" AL "+repConvenSecBean.getFechaFin());
							hoja.addMergedRegion(new CellRangeAddress(
							           3,3,1,3));
							
										
							
							celda = fila.createCell((short)4);
							celda.setCellValue("Hora:");
							celda.setCellStyle(estiloNeg8);
							celda = fila.createCell((short)5);
							
							
							String horaVar="";
							
							 
							int hora =calendario.get(Calendar.HOUR_OF_DAY);
							int minutos = calendario.get(Calendar.MINUTE);
							int segundos = calendario.get(Calendar.SECOND);
							
							String h = Integer.toString(hora);
							String m = "";
							String s = "";
							if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
							if(segundos<10)s="0"+Integer.toString(segundos); else s=Integer.toString(segundos);
							
								 
							horaVar= h+":"+m+":"+s;
							
							celda.setCellValue(horaVar);
							celda.setCellStyle(estiloNeg8);
							fila = hoja.createRow(5);
							celda = fila.createCell((short)5);
						
							
							// Creacion de fila
							fila = hoja.createRow(6);
							fila = hoja.createRow(7);

							//Inicio en la segunda fila y que el fila uno tiene los encabezados
							celda = fila.createCell((short)0);
							celda.setCellValue("NÚMERO DE SOCIO");
							celda.setCellStyle(estiloNeg8);
							celda.setCellStyle(estiloColor);
										
						
							celda = fila.createCell((short)1);
							celda.setCellValue("NOMBRE SOCIO");
							celda.setCellStyle(estiloNeg8);
							celda.setCellStyle(estiloColor);
							
							celda = fila.createCell((short)2);
							celda.setCellValue("NOMBRE SUCURSAL");
							celda.setCellStyle(estiloNeg8);
							celda.setCellStyle(estiloColor);
							
							celda = fila.createCell((short)3);
							celda.setCellValue("ASAMBLEA");
							celda.setCellStyle(estiloNeg8);
							celda.setCellStyle(estiloColor);
							
							celda = fila.createCell((short)4);
							celda.setCellValue("FECHA ASAMBLEA");
							celda.setCellStyle(estiloNeg8);
							celda.setCellStyle(estiloColor);
							
							celda = fila.createCell((short)5);
							celda.setCellValue("FECHA REGISTRO");
							celda.setCellStyle(estiloNeg8);
							celda.setCellStyle(estiloColor);
							
							
							int x=8;
							for(RepConvenSecBean asambleasIns : listaAsambleasPre ){
								fila=hoja.createRow(x);
								celda=fila.createCell((short)0);
								celda.setCellValue(asambleasIns.getNoSocio());
								celda.setCellStyle(estilo8);
								
								celda=fila.createCell((short)1);
								celda.setCellValue(asambleasIns.getNombreCompleto());
								celda.setCellStyle(estilo8);
								
								celda=fila.createCell((short)2);
								celda.setCellValue(asambleasIns.getNombreSucurs());
								celda.setCellStyle(estilo8);
								
								celda=fila.createCell((short)3);
								celda.setCellValue(asambleasIns.getTipoRegistroDes());
								celda.setCellStyle(estilo8);						
								
								celda=fila.createCell((short)4);					
								celda.setCellValue(asambleasIns.getFechaAsamblea());
								celda.setCellStyle(estilo8);
								
								celda=fila.createCell((short)5);
								celda.setCellValue(asambleasIns.getFechaRegistro());
								celda.setCellStyle(estilo8);						
								
													
								regExport 		= regExport + 1;

								x++;
							}
							
										
												
							hoja.autoSizeColumn((short)0);
							hoja.autoSizeColumn((short)1);
							hoja.autoSizeColumn((short)2);
							hoja.autoSizeColumn((short)3);
							hoja.autoSizeColumn((short)4);
							hoja.autoSizeColumn((short)5);
						}
		
							else if(tipoReporte == 3) {
							
							HSSFCell celda=fila.createCell((short)0);
							
							celda.setCellStyle(estiloNeg10);
							celda.setCellValue(repConvenSecBean.getNombreInstitucion());
							hoja.addMergedRegion(new CellRangeAddress(
									2,2,0,1));
							
							celda = fila.createCell((short)2);
							celda.setCellValue("Usuario:");
							celda.setCellStyle(estiloNeg8);
							celda = fila.createCell((short)3);
							celda.setCellValue(repConvenSecBean.getUsuario());
							celda.setCellStyle(estiloNeg8);
							fila = hoja.createRow(3);
							//celda = fila.createCell((short)6);
						
							
							fila = hoja.createRow(3);
							celda = fila.createCell	((short)0);
							celda.setCellStyle(estiloNeg10);
							celda.setCellValue("REPORTE DE PROSPECTOS A ASAMBLEAS DEL "+repConvenSecBean.getFechaInicio());
							hoja.addMergedRegion(new CellRangeAddress(
							           3,3,0,1));
							
										
							
							celda = fila.createCell((short)2);
							celda.setCellValue("Hora:");
							celda.setCellStyle(estiloNeg8);
							celda = fila.createCell((short)3);
							
							
							String horaVar="";
							
							 
							int hora =calendario.get(Calendar.HOUR_OF_DAY);
							int minutos = calendario.get(Calendar.MINUTE);
							int segundos = calendario.get(Calendar.SECOND);
							
							String h = Integer.toString(hora);
							String m = "";
							String s = "";
							if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
							if(segundos<10)s="0"+Integer.toString(segundos); else s=Integer.toString(segundos);
							
								 
							horaVar= h+":"+m+":"+s;
							
							celda.setCellValue(horaVar);
							celda.setCellStyle(estiloNeg8);
							fila = hoja.createRow(5);
							celda = fila.createCell((short)5);
						
							
							// Creacion de fila
							fila = hoja.createRow(6);
							fila = hoja.createRow(7);

							//Inicio en la segunda fila y que el fila uno tiene los encabezados
							celda = fila.createCell((short)0);
							celda.setCellValue("NÚMERO DE SOCIO");
							celda.setCellStyle(estiloNeg8);
							celda.setCellStyle(estiloColor);
										
						
							celda = fila.createCell((short)1);
							celda.setCellValue("NOMBRE SOCIO");
							celda.setCellStyle(estiloNeg8);
							celda.setCellStyle(estiloColor);
							
							celda = fila.createCell((short)2);
							celda.setCellValue("NOMBRE SUCURSAL");
							celda.setCellStyle(estiloNeg8);
							celda.setCellStyle(estiloColor);
							
													
							
							int x=8;
							for(RepConvenSecBean asambleasIns : listaAsambleasPre ){
								fila=hoja.createRow(x);
								celda=fila.createCell((short)0);
								celda.setCellValue(asambleasIns.getNoSocio());
								celda.setCellStyle(estilo8);
								
								celda=fila.createCell((short)1);
								celda.setCellValue(asambleasIns.getNombreCompleto());
								celda.setCellStyle(estilo8);
								
								celda=fila.createCell((short)2);
								celda.setCellValue(asambleasIns.getNombreSucurs());
								celda.setCellStyle(estilo8);
								
												
													
								regExport 		= regExport + 1;

								x++;
							}
							
										
												
							hoja.autoSizeColumn((short)0);
							hoja.autoSizeColumn((short)1);
							hoja.autoSizeColumn((short)2);

						}
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReporteAsambleas.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
				}catch(Exception e){
				
					e.printStackTrace();
				}//Fin del catch
			}
						
			return  listaAsambleasPre;
			
			}

	public RepConvenSecServicio getRepConvenSecServicio() {
		return repConvenSecServicio;
	}

	public void setRepConvenSecServicio(RepConvenSecServicio repConvenSecServicio) {
		this.repConvenSecServicio = repConvenSecServicio;
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
