package nomina.reporte;

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

import nomina.bean.EmpleadoNominaBean;
import nomina.servicio.NominaServicio;





public class RepCambiosEstatusEmpNominaControlador extends AbstractCommandController {

	NominaServicio nominaServicio = null; 
	String successView = null;
	
	public static interface Enum_Con_TipRepor {
		  int  ReporExcel= 2 ;
		}
	public RepCambiosEstatusEmpNominaControlador () {
		setCommandClass(EmpleadoNominaBean.class);
		setCommandName("estatusEmpleadoNomina");
	}
		
		protected ModelAndView handle(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors)throws Exception {
			
			EmpleadoNominaBean nominaBean = (EmpleadoNominaBean) command;

		int tipoReporte =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
			0;
		int tipoLista =(request.getParameter("tipoLista")!=null)?
						Integer.parseInt(request.getParameter("tipoLista")):
			0;		
		String htmlString= "";
		switch(tipoReporte){
		case Enum_Con_TipRepor.ReporExcel:		
			 List listaReportes = conRepEstaNominaExcel(tipoLista,nominaBean,response); 
		break;
	}
		return null;
	}
		// Reporte de Descuentos de Nomina en EXCEL
				public List conRepEstaNominaExcel(int tipoLista,EmpleadoNominaBean nominaBean,  HttpServletResponse response){
				List <EmpleadoNominaBean> listaRepNomina=null;
				listaRepNomina = (List) nominaServicio.listaEstatusEmpleadosNomina(tipoLista,nominaBean,response); 
				
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
					estiloDatosCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
					estiloDatosCentrado.setFont(fuenteNegrita10);
										
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
//					HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
//					HSSFDataFormat format = libro.createDataFormat();
//					estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
					
					// Creacion de hoja					
					HSSFSheet hoja = libro.createSheet("Reporte Cambios de Estatus");
					HSSFRow fila= hoja.createRow(0);
					HSSFCell celda=fila.createCell((short)1);
					
					celda=fila.createCell((short)1);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Reporte Cambios de Estatus");
					
					celda=fila.createCell((short)0);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue(nominaBean.getNombreInstitucion());
					estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER); 
					hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					            0, //primera fila (0-based)
					            0, //ultima fila  (0-based)
					            0, //primer celda (0-based)
					            8  //ultima celda   (0-based)
					    ));
					 celda.setCellStyle(estiloDatosCentrado);
					
					celda=fila.createCell((short)9);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Usuario: "+nominaBean.getUsuario());
					
					fila = hoja.createRow(1);
					celda=fila.createCell((short)9);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Fecha: "+nominaBean.getFechaEmision());
				    
		
					fila = hoja.createRow(2);
					celda=fila.createCell((short)0);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("REPORTE CAMBIOS DE ESTATUS EMPLEADOS");
					celda.setCellStyle(estiloDatosCentrado);
				    hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            2, //primera fila (0-based)
				            2, //ultima fila  (0-based)
				            0, //primer celda (0-based)
				            8  //ultima celda   (0-based)
				    ));
				    if (!listaRepNomina.isEmpty()){
					String hora = listaRepNomina.get(0).getHoraEmision();
					celda=fila.createCell((short)9);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Hora: "+hora);
				    }
				    
					fila = hoja.createRow(4);
				     String empresaNom =  nominaBean.getNombreInstNomina();
				     String empleado = nominaBean.getNombreCompleto();
				     String estatus= nominaBean.getEstatusEmp();
				     String fechaIni = nominaBean.getFechaInicio();
				     String fechaFin = nominaBean.getFechaFin();
				     
				     if(estatus.equals("0")){
				    	 estatus = "TODOS";
				     }
				     if(estatus.equals("I")){
				    	 estatus = "INCAPACIDAD";
				     }
				     if(estatus.equals("B")){
				    	 estatus = "BAJA";
				     }
				     if(estatus.equals("A")){
				    	 estatus = "ACTIVOS";
				     }
				   
				    
				     
				 	celda=fila.createCell((short)0);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Empresa de Nómina: "+empresaNom);

					celda=fila.createCell((short)2);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Empleado: "+empleado);
					
					celda=fila.createCell((short)4);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Estatus: "+estatus);
					
					celda=fila.createCell((short)6);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Fecha Inicial: "+fechaIni);
					
					celda=fila.createCell((short)8);
					celda.setCellStyle(estiloNeg10);
					celda.setCellValue("Fecha Final: "+fechaFin);
				    
				    
				    
				   	// Creacion de filas
					
					fila = hoja.createRow(6);

					celda = fila.createCell((short)0);
					celda.setCellValue("Empresa de Nómina");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)1);
					celda.setCellValue("Fecha Actualización");
					celda.setCellStyle(estiloNeg8);
				   
					celda = fila.createCell((short)2);
					celda.setCellValue("No. Empleado");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)3);
					celda.setCellValue("Nombre");
					celda.setCellStyle(estiloNeg8);
						
					celda = fila.createCell((short)4);
					celda.setCellValue("Estatus Anterior");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)5);
					celda.setCellValue("Estatus Nuevo");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)6);
					celda.setCellValue("Fecha Inicial Incapacidad");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)7);
					celda.setCellValue("Fecha Final Incapacidad");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)8);
					celda.setCellValue("Fecha Baja");
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)9);
					celda.setCellValue("Motivo Baja");
					celda.setCellStyle(estiloNeg8);
				
					 
					 int i=7,iter=0;
						int tamanioLista = listaRepNomina.size();
						nominaBean = null;
						for( iter=0; iter<tamanioLista; iter ++){
					
					nominaBean = (EmpleadoNominaBean) listaRepNomina.get(iter);
					fila=hoja.createRow(i);
					
					// ClienteID,NombreCompleto,CreditoID,FechaPago,MontoExigible
					
					celda=fila.createCell((short)0);
					celda.setCellValue(nominaBean.getNombreInstNomina());
					
					celda=fila.createCell((short)1);
					celda.setCellValue(nominaBean.getFechaAct());
					
					celda=fila.createCell((short)2);
					celda.setCellValue(nominaBean.getClienteID());
					
					celda=fila.createCell((short)3);
					celda.setCellValue(nominaBean.getNombreCompleto());
					
					estatus=nominaBean.getEstatusAnterior();
					  if(estatus.equals("I")){
					    	 estatus = "INCAPACIDAD";
					     }
					     if(estatus.equals("B")){
					    	 estatus = "BAJA";
					     }
					     if(estatus.equals("A")){
					    	 estatus = "ACTIVO";
					     }
					celda=fila.createCell((short)4);
					celda.setCellValue(estatus);//estatus anterior
					

					  estatus = nominaBean.getEstatusEmp();
					  if(estatus.equals("I")){
					    	 estatus = "INCAPACIDAD";
					     }
					     if(estatus.equals("B")){
					    	 estatus = "BAJA";
					     }
					     if(estatus.equals("A")){
					    	 estatus = "ACTIVO";
					     }
					
					celda=fila.createCell((short)5);
					celda.setCellValue(estatus);	
					
					String fechaIniInca=nominaBean.getFechaInicialInca();
					if(fechaIniInca.equals("1900-01-01")){
						fechaIniInca="";
					}
					celda=fila.createCell((short)6);
					celda.setCellValue(fechaIniInca);
					
					String fechaFinInca= nominaBean.getFechaFinInca();
					if(fechaFinInca.equals("1900-01-01")){
						fechaFinInca="";
					}
					celda=fila.createCell((short)7);
					celda.setCellValue(fechaFinInca);
					
					String fechaBaja= nominaBean.getFechaBaja();
					if(fechaBaja.equals("1900-01-01")){
						fechaBaja="";
					}
					celda=fila.createCell((short)8);
					celda.setCellValue(fechaBaja);
					
					celda=fila.createCell((short)9);
					celda.setCellValue(nominaBean.getMotivoBaja());
					
					i++;
					}
					
					i = i+1;
					fila=hoja.createRow(i);
					celda = fila.createCell((short)0);
					celda.setCellValue("Registros Exportados");
					celda.setCellStyle(estiloNeg8);
					
					celda=fila.createCell((short)8);
					celda.setCellValue("Procedure:");
					celda.setCellStyle(estiloNeg8);
					
					celda=fila.createCell((short)9);
					celda.setCellValue("NOMBITACOESTEMPLIS");
					
					i = i+1;
					fila=hoja.createRow(i);
					celda=fila.createCell((short)0);
					celda.setCellValue(tamanioLista);
					

					for(int celd=0; celd<=19; celd++)
					hoja.autoSizeColumn((short)celd);
				
					//Se crea la cabecera
					response.addHeader("Content-Disposition","inline; filename=RepCambiosEstatusNomina.xls");
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
				//} 	
				return  listaRepNomina;		
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
