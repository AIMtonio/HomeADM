package cliente.servicio;

import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.core.task.TaskExecutor;
import java.io.ByteArrayOutputStream;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Locale;

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

import reporte.ParametrosReporte;
import reporte.Reporte;

import cliente.bean.RepEstadisticoBean;
import cliente.dao.RepEstadisticoDAO;


public class RepEstadisticoServicio extends BaseServicio {
	RepEstadisticoDAO  repEstadisticoDAO = null;
	ParametrosSesionBean parametrosSesionBean;
	
	
	public RepEstadisticoServicio (){
		super();
	}
	

	
	//tipo consulta 5
			public List<RepEstadisticoBean>  repEstadisticoDetCartera(String nombreReporte,RepEstadisticoBean repEstadisticoBean,  HttpServletResponse response){
				List<RepEstadisticoBean> listaRepEStadistico=null;
				listaRepEStadistico = listaRepEstadisticoDetCartera(repEstadisticoBean); 	
			 
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
				fuenteNegrita8.setFontHeightInPoints((short)10);
				fuenteNegrita8.setFontName("Negrita");
				fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				HSSFCellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				
				//Estilo negrita de 8  para encabezados del reporte
				HSSFCellStyle estiloNeg8 = libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita8);
				
				// Se define una fuente Arial 10 para los datos obtenidos
				HSSFFont fuenteArial10 = libro.createFont();
				fuenteArial10.setFontHeightInPoints((short)10);
				fuenteArial10.setFontName("Arial");
				

				HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
				estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER); 
				
				HSSFCellStyle estiloDatosIzquierda = libro.createCellStyle();
				estiloDatosIzquierda.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT); 
				
				HSSFCellStyle estiloDatosDerecha = libro.createCellStyle();
				estiloDatosDerecha.setAlignment((short)HSSFCellStyle.ALIGN_LEFT); 
				
				HSSFCellStyle estiloCentrado = libro.createCellStyle();
				estiloCentrado.setFont((fuenteNegrita10));
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
				HSSFSheet hoja = libro.createSheet("REPORTE ESTADISTICO");
				HSSFRow fila= hoja.createRow(0);

				int itera=0;
				RepEstadisticoBean repEstadistico = repEstadisticoBean;
				if(!listaRepEStadistico.isEmpty()){
					for( itera=0; itera<1; itera ++){
						repEstadistico = (RepEstadisticoBean) listaRepEStadistico.get(itera);								
					}
				}
				fila = hoja.createRow(1);
				// inicio usuario,fecha y hora
				HSSFCell celdaUsu=fila.createCell((short)1);
				celdaUsu = fila.createCell((short)6);
				celdaUsu.setCellValue("Usuario:");
				celdaUsu.setCellStyle(estiloNeg8);	
				celdaUsu = fila.createCell((short)7);
				celdaUsu.setCellValue((!repEstadisticoBean.getClaveUsuario().isEmpty())?repEstadisticoBean.getClaveUsuario(): "TODOS");
				
				String horaEmision	=repEstadisticoBean.getHoraEmision();
				String fechaVar		= repEstadisticoBean.getFechaEmision();
				String incluirGL	= repEstadisticoBean.getIncluirGL();
				
				// Nombre Institucion	
				HSSFCell celdaInst=fila.createCell((short)1);
				//celdaInst.setCellStyle(estiloNeg10);
				celdaInst.setCellValue(repEstadisticoBean.getNombreInstitucion());
									
				  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				            1, //primera fila (0-based)
				            1, //ultima fila  (0-based)
				            1, //primer celda (0-based)
				            5 //ultima celda   (0-based)
				    ));
				  
				 celdaInst.setCellStyle(estiloCentrado);	
				
				
				fila = hoja.createRow(2);
				HSSFCell celdaFec=fila.createCell((short)1);
				
				celdaFec = fila.createCell((short)6);
				celdaFec.setCellValue("Fecha:");
				celdaFec.setCellStyle(estiloNeg8);	
				celdaFec = fila.createCell((short)7);
				celdaFec.setCellValue(fechaVar);
				
				String Descripcion = (repEstadisticoBean.getTipoRep().equals("1"))?"CARTERA":"CAPTACION";
				
				// Titulo del Reporte	
				HSSFCell celda=fila.createCell((short)1);
				celda.setCellValue("REPORTE ESTADISTICO DE "+Descripcion+" AL "+repEstadisticoBean.getFechaCorte() );
				celda.setCellStyle(estiloCentrado);
			   hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            2, //primera fila (0-based)
			            2, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            5  //ultima celda   (0-based)
			    ));
			   
			    fila = hoja.createRow(3); // Fila vacia
			    HSSFCell celdaHora=fila.createCell((short)1);
				celdaHora = fila.createCell((short)6);
				celdaHora.setCellValue("Hora:");
				celdaHora.setCellStyle(estiloNeg8);	
				celdaHora = fila.createCell((short)7);
				celdaHora.setCellValue(horaEmision);
			   
			    fila = hoja.createRow(4); // Fila vacia
			    
				fila = hoja.createRow(5);// Campos
				
				celda = fila.createCell((short)1);
				celda.setCellValue("ClienteID");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("No. Crédito");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Nombre Cliente");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Producto");
				celda.setCellStyle(estiloCentrado);	
				
				celda = fila.createCell((short)5);
				celda.setCellValue("Monto Crédito");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("Saldo Capital");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("Saldo Interés");
				celda.setCellStyle(estiloCentrado);

				celda = fila.createCell((short)8);
				celda.setCellValue("Sucursal");
				celda.setCellStyle(estiloCentrado);
				
				// Recorremos la lista para la parte de los datos 	
				int i=7,iter=0;
				int tamanioLista = listaRepEStadistico.size();
				repEstadistico = null;
				
				for( iter=0; iter<tamanioLista; iter ++){
				
					repEstadistico =  listaRepEStadistico.get(iter);
					fila=hoja.createRow(i);

					celda=fila.createCell((short)1);
					celda.setCellValue(repEstadistico.getClienteID());
					celda.setCellStyle(estiloDatosDerecha);
					
					celda=fila.createCell((short)2);
					celda.setCellValue(repEstadistico.getNumCredito());
					celda.setCellStyle(estiloDatosDerecha);
					
					celda=fila.createCell((short)3); 
					celda.setCellValue(repEstadistico.getNomCliente());
					celda.setCellStyle(estiloDatosDerecha);
					
					celda=fila.createCell((short)4);
					celda.setCellValue(repEstadistico.getProducto()); 
					celda.setCellStyle(estiloDatosDerecha);

					celda=fila.createCell((short)5);
					celda.setCellValue(Utileria.convierteDoble(repEstadistico.getMontoCredito()));
					celda.setCellStyle(estiloFormatoDecimal); 

					celda=fila.createCell((short)6);
					celda.setCellValue(Utileria.convierteDoble(repEstadistico.getSaldoCapital())); 
					celda.setCellStyle(estiloFormatoDecimal); 
					
					celda=fila.createCell((short)7);
					celda.setCellValue(Utileria.convierteDoble(repEstadistico.getSaldo())); 
					celda.setCellStyle(estiloFormatoDecimal); 
					
					celda=fila.createCell((short)8);
					celda.setCellValue(repEstadistico.getSucursalID()); 
					celda.setCellStyle(estiloDatosDerecha); 
				 
					i++;
				}
				 
				i = i+2;
				fila=hoja.createRow(i); // Fila Registros Exportados
				celda = fila.createCell((short)0);
				celda.setCellValue("Registros Exportados");
				celda.setCellStyle(estiloNeg8);
				
				i = i+1;
				fila=hoja.createRow(i); // Fila Total de Registros Exportados
				celda=fila.createCell((short)0);
				celda.setCellValue(tamanioLista);
				

				for(int celd=0; celd<=15; celd++)
				hoja.autoSizeColumn((short)celd);
				
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReporteEstadistico.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
				loggerSAFI.debug("Termina Reporte");
				}catch(Exception e){
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte: " + e.getMessage());
					e.printStackTrace();
				}//Fin del catch
			//} 
				
				
			return  listaRepEStadistico;
			
			
			}
			
			public List <RepEstadisticoBean> listaRepEstadisticoDetCartera(RepEstadisticoBean estadisticoBean){
				List<RepEstadisticoBean> listaOperaciones=null;
				listaOperaciones = repEstadisticoDAO.repEstadisticoDetCartera(estadisticoBean);
				return listaOperaciones;
			}
	
	//tipo consulta 7
		public List<RepEstadisticoBean>  repEstadisticoDetCap(String nombreReporte,RepEstadisticoBean repEstadisticoBean,  HttpServletResponse response){
			List<RepEstadisticoBean> listaRepEStadistico=null;
			listaRepEStadistico = listaRepEstadisticoDetCap(repEstadisticoBean); 	
		 
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
			fuenteNegrita8.setFontHeightInPoints((short)10);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			HSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);
			
			// Se define una fuente Arial 10 para los datos obtenidos
			HSSFFont fuenteArial10 = libro.createFont();
			fuenteArial10.setFontHeightInPoints((short)10);
			fuenteArial10.setFontName("Arial");
			

			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER); 
			
			HSSFCellStyle estiloDatosIzquierda = libro.createCellStyle();
			estiloDatosIzquierda.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT); 
			
			HSSFCellStyle estiloDatosDerecha = libro.createCellStyle();
			estiloDatosDerecha.setAlignment((short)HSSFCellStyle.ALIGN_LEFT); 
			
			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont((fuenteNegrita10));
			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
					
			//Estilo negrita de 8  y color de fondo
			HSSFCellStyle estiloColor = libro.createCellStyle();
			estiloColor.setFont(fuenteNegrita8);
			estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
			estiloColor.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			
			//Estilo Formato decimal (0.00)
			//Estilo Formato decimal (0.00)
			HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			HSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			
			// Creacion de hoja					
			HSSFSheet hoja = libro.createSheet("REPORTE ESTADISTICO");
			HSSFRow fila= hoja.createRow(0);

			int itera=0;
			RepEstadisticoBean repEstadistico = repEstadisticoBean;
			if(!listaRepEStadistico.isEmpty()){
				for( itera=0; itera<1; itera ++){
					repEstadistico = (RepEstadisticoBean) listaRepEStadistico.get(itera);								
				}
			}
			fila = hoja.createRow(1);
			// inicio usuario,fecha y hora
			HSSFCell celdaUsu=fila.createCell((short)1);
			celdaUsu = fila.createCell((short)8);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)9);
			celdaUsu.setCellValue((!repEstadisticoBean.getClaveUsuario().isEmpty())?repEstadisticoBean.getClaveUsuario(): "TODOS");
			
			String horaEmision	=repEstadisticoBean.getHoraEmision();
			String fechaVar		= repEstadisticoBean.getFechaEmision();
			String incluirGL	= repEstadisticoBean.getIncluirGL();
			
			// Nombre Institucion	
			HSSFCell celdaInst=fila.createCell((short)1);
			//celdaInst.setCellStyle(estiloNeg10);
			celdaInst.setCellValue(repEstadisticoBean.getNombreInstitucion());
								
			  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            7 //ultima celda   (0-based)
			    ));
			  
			 celdaInst.setCellStyle(estiloCentrado);	
			
			
			fila = hoja.createRow(2);
			HSSFCell celdaFec=fila.createCell((short)1);
			
			celdaFec = fila.createCell((short)8);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)9);
			celdaFec.setCellValue(fechaVar);
			
			String Descripcion = (repEstadisticoBean.getTipoRep().equals("1"))?"CARTERA":"CAPTACION";
			
			// Titulo del Reporte	
			HSSFCell celda=fila.createCell((short)1);
			celda.setCellValue("REPORTE ESTADISTICO DE "+Descripcion+" AL "+repEstadisticoBean.getFechaCorte() );
			celda.setCellStyle(estiloCentrado);
		   hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            7  //ultima celda   (0-based)
		    ));
		   
		    fila = hoja.createRow(3); // Fila vacia
		    HSSFCell celdaHora=fila.createCell((short)1);
			celdaHora = fila.createCell((short)8);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell((short)9);
			celdaHora.setCellValue(horaEmision);
		   
		    fila = hoja.createRow(4); // Fila vacia
		    
			fila = hoja.createRow(5);// Campos
			celda = fila.createCell((short)1);
			celda.setCellValue("Incluir Garantía Liquida:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)2);
			celda.setCellValue((repEstadisticoBean.getIncluirGL().equals("S"))?"SI":"NO");
			
			celda = fila.createCell((short)3);
			celda.setCellValue("Saldo Mínimo:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)4);
			celda.setCellValue(Utileria.convierteDoble(repEstadisticoBean.getSaldoMinimo()));
			celda.setCellStyle(estiloFormatoDecimal); 
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Incluir Cuentas sin Autorizar:");
			celda.setCellStyle(estiloNeg8);	
			celda = fila.createCell((short)6);
			celda.setCellValue((repEstadisticoBean.getIncluirCuentaSA().equals("S"))?"SI":"NO");
			
			// Creacion de fila
			fila = hoja.createRow(6); // Fila vacia	
			
			fila = hoja.createRow(7);
			
			celda = fila.createCell((short)1);
			celda.setCellValue("ClienteID");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)2);
			celda.setCellValue("No. Cuenta");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)3);
			celda.setCellValue("Nombre Cliente");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)4);
			celda.setCellValue("Descripción");
			celda.setCellStyle(estiloCentrado);	
			
			celda = fila.createCell((short)5);
			celda.setCellValue("Estatus");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)6);
			celda.setCellValue("Producto");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)7);
			celda.setCellValue("Tipo");
			celda.setCellStyle(estiloCentrado);

			celda = fila.createCell((short)8);
			celda.setCellValue("Saldo");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)9);
			celda.setCellValue("Saldo GL");
			celda.setCellStyle(estiloCentrado);
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Sucursal");
			celda.setCellStyle(estiloCentrado);
			// Recorremos la lista para la parte de los datos 	
			int i=9,iter=0;
			int tamanioLista = listaRepEStadistico.size();
			repEstadistico = null;
			
			for( iter=0; iter<tamanioLista; iter ++){
			
				repEstadistico =  listaRepEStadistico.get(iter);
				fila=hoja.createRow(i);

				celda=fila.createCell((short)1);
				celda.setCellValue(repEstadistico.getClienteID());
				celda.setCellStyle(estiloDatosDerecha);
				
				celda=fila.createCell((short)2);
				celda.setCellValue(repEstadistico.getNumCuenta());
				celda.setCellStyle(estiloDatosDerecha);
				
				celda=fila.createCell((short)3); 
				celda.setCellValue(repEstadistico.getNomCliente());
				celda.setCellStyle(estiloDatosDerecha);
				
				celda=fila.createCell((short)4);
				celda.setCellValue(repEstadistico.getDescripcion()); 
				celda.setCellStyle(estiloDatosDerecha);

				celda=fila.createCell((short)5);
				celda.setCellValue(repEstadistico.getEstatus());
				celda.setCellStyle(estiloDatosDerecha); 

				celda=fila.createCell((short)6);
				celda.setCellValue(repEstadistico.getProducto()); 
				celda.setCellStyle(estiloDatosDerecha); 
				
				celda=fila.createCell((short)7);
				celda.setCellValue(repEstadistico.getTipoProducto()); 
				celda.setCellStyle(estiloDatosDerecha); 
				
				celda=fila.createCell((short)8);
				celda.setCellValue(Utileria.convierteDoble(repEstadistico.getSaldo())); 
				celda.setCellStyle(estiloFormatoDecimal); 
				
				celda=fila.createCell((short)9);
				celda.setCellValue(Utileria.convierteDoble(repEstadistico.getSaldoGL())); 
				celda.setCellStyle(estiloFormatoDecimal); 
				
				celda=fila.createCell((short)10);
				celda.setCellValue(repEstadistico.getSucursalID()); 
				celda.setCellStyle(estiloDatosDerecha); 
			 
				i++;
			}
			 
			i = i+2;
			fila=hoja.createRow(i); // Fila Registros Exportados
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados");
			celda.setCellStyle(estiloNeg8);
			
			i = i+1;
			fila=hoja.createRow(i); // Fila Total de Registros Exportados
			celda=fila.createCell((short)0);
			celda.setCellValue(tamanioLista);
			

			for(int celd=0; celd<=15; celd++)
			hoja.autoSizeColumn((short)celd);
			
			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteEstadistico.xls");
			response.setContentType("application/vnd.ms-excel");
			
			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();
			
			loggerSAFI.debug("Termina Reporte");
			}catch(Exception e){
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte: " + e.getMessage());
				e.printStackTrace();
			}//Fin del catch
		//} 
			
			
		return  listaRepEStadistico;
		
		
		}
		
		public List <RepEstadisticoBean> listaRepEstadisticoDetCap(RepEstadisticoBean estadisticoBean){
			List<RepEstadisticoBean> listaOperaciones=null;
			listaOperaciones = repEstadisticoDAO.repEstadisticoDetCap(estadisticoBean);
			return listaOperaciones;
		}
	//consulta 6
	public List<RepEstadisticoBean>  repEstadisticoSumCartera(String nombreReporte,RepEstadisticoBean repEstadisticoBean,  HttpServletResponse response){
		List<RepEstadisticoBean> listaRepEStadistico=null;
		listaRepEStadistico = listaRepEstadisticoSumCar(repEstadisticoBean); 	
	 
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
		fuenteNegrita8.setFontHeightInPoints((short)10);
		fuenteNegrita8.setFontName("Negrita");
		fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		
		// La fuente se mete en un estilo para poder ser usada.
		//Estilo negrita de 10 para el titulo del reporte
		HSSFCellStyle estiloNeg10 = libro.createCellStyle();
		estiloNeg10.setFont(fuenteNegrita10);
		
		//Estilo negrita de 8  para encabezados del reporte
		HSSFCellStyle estiloNeg8 = libro.createCellStyle();
		estiloNeg8.setFont(fuenteNegrita8);
		
		// Se define una fuente Arial 10 para los datos obtenidos
		HSSFFont fuenteArial10 = libro.createFont();
		fuenteArial10.setFontHeightInPoints((short)10);
		fuenteArial10.setFontName("Arial");
		

		HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
		estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER); 
		
		HSSFCellStyle estiloDatosIzquierda = libro.createCellStyle();
		estiloDatosIzquierda.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT); 
		
		HSSFCellStyle estiloDatosDerecha = libro.createCellStyle();
		estiloDatosDerecha.setAlignment((short)HSSFCellStyle.ALIGN_LEFT); 
		
		HSSFCellStyle estiloCentrado = libro.createCellStyle();
		estiloCentrado.setFont((fuenteNegrita10));
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
		HSSFSheet hoja = libro.createSheet("REPORTE ESTADISTICO");
		HSSFRow fila= hoja.createRow(0);

		int itera=0;
		RepEstadisticoBean repEstadistico = repEstadisticoBean;
		if(!listaRepEStadistico.isEmpty()){
			for( itera=0; itera<1; itera ++){
				repEstadistico = (RepEstadisticoBean) listaRepEStadistico.get(itera);								
			}
		}
		fila = hoja.createRow(1);
		// inicio usuario,fecha y hora
		HSSFCell celdaUsu=fila.createCell((short)1);
		celdaUsu = fila.createCell((short)6);
		celdaUsu.setCellValue("Usuario:");
		celdaUsu.setCellStyle(estiloNeg8);	
		celdaUsu = fila.createCell((short)7);
		celdaUsu.setCellValue((!repEstadisticoBean.getClaveUsuario().isEmpty())?repEstadisticoBean.getClaveUsuario(): "TODOS");
		
		String horaEmision	=repEstadisticoBean.getHoraEmision();
		String fechaVar		= repEstadisticoBean.getFechaEmision();
		String incluirGL	= repEstadisticoBean.getIncluirGL();
		
		// Nombre Institucion	
		HSSFCell celdaInst=fila.createCell((short)1);
		//celdaInst.setCellStyle(estiloNeg10);
		celdaInst.setCellValue(repEstadisticoBean.getNombreInstitucion());
							
		  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            1, //primera fila (0-based)
		            1, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            5  //ultima celda   (0-based)
		    ));
		  
		 celdaInst.setCellStyle(estiloCentrado);	
		
		
		fila = hoja.createRow(2);
		HSSFCell celdaFec=fila.createCell((short)1);
		
		celdaFec = fila.createCell((short)6);
		celdaFec.setCellValue("Fecha:");
		celdaFec.setCellStyle(estiloNeg8);	
		celdaFec = fila.createCell((short)7);
		celdaFec.setCellValue(fechaVar);
		
		String Descripcion = (repEstadisticoBean.getTipoRep().equals("1"))?"CARTERA":"CAPTACION";
		
		// Titulo del Reporte	
		HSSFCell celda=fila.createCell((short)1);
		celda.setCellValue("REPORTE ESTADISTICO DE "+Descripcion+" AL "+repEstadisticoBean.getFechaCorte() );
		celda.setCellStyle(estiloCentrado);
	   hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
	            2, //primera fila (0-based)
	            2, //ultima fila  (0-based)
	            1, //primer celda (0-based)
	            5  //ultima celda   (0-based)
	    ));
	   
	    fila = hoja.createRow(3); // Fila vacia
	    HSSFCell celdaHora=fila.createCell((short)1);
		celdaHora = fila.createCell((short)6);
		celdaHora.setCellValue("Hora:");
		celdaHora.setCellStyle(estiloNeg8);	
		celdaHora = fila.createCell((short)7);
		celdaHora.setCellValue(horaEmision);
	   
	    fila = hoja.createRow(4); // Fila vacia
	    
		
		fila = hoja.createRow(5);
		celda = fila.createCell((short)1);
		celda.setCellValue("Cantidad de Registros");
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)2);
		celda.setCellValue("Producto");
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)3);
		celda.setCellValue("Monto Crédito");
		celda.setCellStyle(estiloCentrado);	
		
		celda = fila.createCell((short)4);
		celda.setCellValue("Saldo Capital");
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)5);
		celda.setCellValue("Saldo Interés");
		celda.setCellStyle(estiloCentrado);
		
		// Recorremos la lista para la parte de los datos 	
		int i=6,iter=0;
		int tamanioLista = listaRepEStadistico.size();
		repEstadistico = null;
		
		for( iter=0; iter<tamanioLista; iter ++){
		
			repEstadistico =  listaRepEStadistico.get(iter);
			fila=hoja.createRow(i);

			celda=fila.createCell((short)1);
			celda.setCellValue(repEstadistico.getCantidadRegistros());
			celda.setCellStyle(estiloDatosDerecha);
			
			celda=fila.createCell((short)2); 
			celda.setCellValue(repEstadistico.getProducto());
			celda.setCellStyle(estiloDatosDerecha);
			
			celda=fila.createCell((short)3);
			celda.setCellValue(Utileria.convierteDoble(repEstadistico.getMontoCredito())); 
			celda.setCellStyle(estiloFormatoDecimal);

			celda=fila.createCell((short)4);
			celda.setCellValue(Utileria.convierteDoble(repEstadistico.getSaldoCapital()));
			celda.setCellStyle(estiloFormatoDecimal); 

			celda=fila.createCell((short)5);
			celda.setCellValue(Utileria.convierteDoble(repEstadistico.getSaldo())); 
			celda.setCellStyle(estiloFormatoDecimal); 
		 
			i++;
		}
		 
		i = i+2;
		fila=hoja.createRow(i); // Fila Registros Exportados
		celda = fila.createCell((short)0);
		celda.setCellValue("Registros Exportados");
		celda.setCellStyle(estiloNeg8);
		
		i = i+1;
		fila=hoja.createRow(i); // Fila Total de Registros Exportados
		celda=fila.createCell((short)0);
		celda.setCellValue(tamanioLista);
		

		for(int celd=0; celd<=15; celd++)
		hoja.autoSizeColumn((short)celd);
		
		//Creo la cabecera
		response.addHeader("Content-Disposition","inline; filename=ReporteEstadistico.xls");
		response.setContentType("application/vnd.ms-excel");
		
		ServletOutputStream outputStream = response.getOutputStream();
		hoja.getWorkbook().write(outputStream);
		outputStream.flush();
		outputStream.close();
		
		loggerSAFI.debug("Termina Reporte");
		}catch(Exception e){
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte: " + e.getMessage());
			e.printStackTrace();
		}//Fin del catch
	//} 
		
		
	return  listaRepEStadistico;
	
	
	}
	
	public List <RepEstadisticoBean> listaRepEstadisticoSumCar(RepEstadisticoBean estadisticoBean){
		List<RepEstadisticoBean> listaOperaciones=null;
		listaOperaciones = repEstadisticoDAO.repEstadisticoSumCartera(estadisticoBean);
		return listaOperaciones;
	}
	
	//tipo consulta 8
	public List<RepEstadisticoBean>  repEstadisticoSumCaptacion(String nombreReporte,RepEstadisticoBean repEstadisticoBean,  HttpServletResponse response){
		List<RepEstadisticoBean> listaRepEStadistico=null;
		listaRepEStadistico = listaRepEstadistico(repEstadisticoBean); 	
	 
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
		fuenteNegrita8.setFontHeightInPoints((short)10);
		fuenteNegrita8.setFontName("Negrita");
		fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		
		// La fuente se mete en un estilo para poder ser usada.
		//Estilo negrita de 10 para el titulo del reporte
		HSSFCellStyle estiloNeg10 = libro.createCellStyle();
		estiloNeg10.setFont(fuenteNegrita10);
		
		//Estilo negrita de 8  para encabezados del reporte
		HSSFCellStyle estiloNeg8 = libro.createCellStyle();
		estiloNeg8.setFont(fuenteNegrita8);
		
		// Se define una fuente Arial 10 para los datos obtenidos
		HSSFFont fuenteArial10 = libro.createFont();
		fuenteArial10.setFontHeightInPoints((short)10);
		fuenteArial10.setFontName("Arial");
		

		HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
		estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER); 
		
		HSSFCellStyle estiloDatosIzquierda = libro.createCellStyle();
		estiloDatosIzquierda.setAlignment((short)HSSFCellStyle.ALIGN_RIGHT); 
		
		HSSFCellStyle estiloDatosDerecha = libro.createCellStyle();
		estiloDatosDerecha.setAlignment((short)HSSFCellStyle.ALIGN_LEFT); 
		
		HSSFCellStyle estiloCentrado = libro.createCellStyle();
		estiloCentrado.setFont((fuenteNegrita10));
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
		HSSFSheet hoja = libro.createSheet("REPORTE ESTADISTICO");
		HSSFRow fila= hoja.createRow(0);

		int itera=0;
		RepEstadisticoBean repEstadistico = repEstadisticoBean;
		if(!listaRepEStadistico.isEmpty()){
			for( itera=0; itera<1; itera ++){
				repEstadistico = (RepEstadisticoBean) listaRepEStadistico.get(itera);								
			}
		}
		fila = hoja.createRow(1);
		// inicio usuario,fecha y hora
		HSSFCell celdaUsu=fila.createCell((short)1);
		celdaUsu = fila.createCell((short)6);
		celdaUsu.setCellValue("Usuario:");
		celdaUsu.setCellStyle(estiloNeg8);	
		celdaUsu = fila.createCell((short)7);
		celdaUsu.setCellValue((!repEstadisticoBean.getClaveUsuario().isEmpty())?repEstadisticoBean.getClaveUsuario(): "TODOS");
		
		String horaEmision	=repEstadisticoBean.getHoraEmision();
		String fechaVar		= repEstadisticoBean.getFechaEmision();
		String incluirGL	= repEstadisticoBean.getIncluirGL();
		
		// Nombre Institucion	
		HSSFCell celdaInst=fila.createCell((short)1);
		//celdaInst.setCellStyle(estiloNeg10);
		celdaInst.setCellValue(repEstadisticoBean.getNombreInstitucion());
							
		  hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            1, //primera fila (0-based)
		            1, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            5 //ultima celda   (0-based)
		    ));
		  
		 celdaInst.setCellStyle(estiloCentrado);	
		
		
		fila = hoja.createRow(2);
		HSSFCell celdaFec=fila.createCell((short)1);
		
		celdaFec = fila.createCell((short)6);
		celdaFec.setCellValue("Fecha:");
		celdaFec.setCellStyle(estiloNeg8);	
		celdaFec = fila.createCell((short)7);
		celdaFec.setCellValue(fechaVar);
		
		String Descripcion = (repEstadisticoBean.getTipoRep().equals("1"))?"CARTERA":"CAPTACION";
		
		// Titulo del Reporte	
		HSSFCell celda=fila.createCell((short)1);
		celda.setCellValue("REPORTE ESTADISTICO DE "+Descripcion+" AL "+repEstadisticoBean.getFechaCorte() );
		celda.setCellStyle(estiloCentrado);
	   hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
	            2, //primera fila (0-based)
	            2, //ultima fila  (0-based)
	            1, //primer celda (0-based)
	            5  //ultima celda   (0-based)
	    ));
	   
	    fila = hoja.createRow(3); // Fila vacia
	    HSSFCell celdaHora=fila.createCell((short)1);
		celdaHora = fila.createCell((short)6);
		celdaHora.setCellValue("Hora:");
		celdaHora.setCellStyle(estiloNeg8);	
		celdaHora = fila.createCell((short)7);
		celdaHora.setCellValue(horaEmision);
	   
	    fila = hoja.createRow(4); // Fila vacia
	    
		fila = hoja.createRow(5);// Campos
		celda = fila.createCell((short)1);
		celda.setCellValue("Incluir Garantía Liquida:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)2);
		celda.setCellValue((repEstadisticoBean.getIncluirGL().equals("S"))?"SI":"NO");
		
		celda = fila.createCell((short)3);
		celda.setCellValue("Saldo Mínimo:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)4);
		celda.setCellValue(Utileria.convierteDoble(repEstadisticoBean.getSaldoMinimo()));
		celda.setCellStyle(estiloFormatoDecimal); 
		
		celda = fila.createCell((short)5);
		celda.setCellValue("Incluir Cuentas sin Autorizar:");
		celda.setCellStyle(estiloNeg8);	
		celda = fila.createCell((short)6);
		celda.setCellValue((repEstadisticoBean.getIncluirCuentaSA().equals("S"))?"SI":"NO");
		
		// Creacion de fila
		fila = hoja.createRow(6); // Fila vacia	
		
		fila = hoja.createRow(7);
		celda = fila.createCell((short)1);
		celda.setCellValue("Cantidad de Registros");
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)2);
		celda.setCellValue("Producto");
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)3);
		celda.setCellValue("Tipo");
		celda.setCellStyle(estiloCentrado);	
		
		celda = fila.createCell((short)4);
		celda.setCellValue("Saldo");
		celda.setCellStyle(estiloCentrado);
		
		celda = fila.createCell((short)5);
		celda.setCellValue("Saldo GL");
		celda.setCellStyle(estiloCentrado);
		
		// Recorremos la lista para la parte de los datos 	
		int i=8,iter=0;
		int tamanioLista = listaRepEStadistico.size();
		repEstadistico = null;
		
		for( iter=0; iter<tamanioLista; iter ++){
		
			repEstadistico =  listaRepEStadistico.get(iter);
			fila=hoja.createRow(i);

			celda=fila.createCell((short)1);
			celda.setCellValue(repEstadistico.getCantidadRegistros());
			celda.setCellStyle(estiloDatosDerecha);
			
			celda=fila.createCell((short)2); 
			celda.setCellValue(repEstadistico.getProducto());
			celda.setCellStyle(estiloDatosDerecha);
			
			celda=fila.createCell((short)3);
			celda.setCellValue(repEstadistico.getTipoProducto()); 
			celda.setCellStyle(estiloDatosDerecha);

			celda=fila.createCell((short)4);
			celda.setCellValue(Utileria.convierteDoble(repEstadistico.getSaldo()));
			celda.setCellStyle(estiloFormatoDecimal); 

			celda=fila.createCell((short)5);
			celda.setCellValue(Utileria.convierteDoble(repEstadistico.getSaldoGL())); 
			celda.setCellStyle(estiloFormatoDecimal); 
		 
			i++;
		}
		 
		i = i+2;
		fila=hoja.createRow(i); // Fila Registros Exportados
		celda = fila.createCell((short)0);
		celda.setCellValue("Registros Exportados");
		celda.setCellStyle(estiloNeg8);
		
		i = i+1;
		fila=hoja.createRow(i); // Fila Total de Registros Exportados
		celda=fila.createCell((short)0);
		celda.setCellValue(tamanioLista);
		

		for(int celd=0; celd<=15; celd++)
		hoja.autoSizeColumn((short)celd);
		
		//Creo la cabecera
		response.addHeader("Content-Disposition","inline; filename=ReporteEstadistico.xls");
		response.setContentType("application/vnd.ms-excel");
		
		ServletOutputStream outputStream = response.getOutputStream();
		hoja.getWorkbook().write(outputStream);
		outputStream.flush();
		outputStream.close();
		
		loggerSAFI.debug("Termina Reporte");
		}catch(Exception e){
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al crear el reporte: " + e.getMessage());
			e.printStackTrace();
		}//Fin del catch
	//} 
		
		
	return  listaRepEStadistico;
	
	
	}
	
	public List <RepEstadisticoBean> listaRepEstadistico(RepEstadisticoBean estadisticoBean){
		List<RepEstadisticoBean> listaOperaciones=null;
		listaOperaciones = repEstadisticoDAO.repEstadisticoSumCap(estadisticoBean);
		return listaOperaciones;
	}
	
	//Reporte de Estadistico  PDF
	public ByteArrayOutputStream reporteEstadisticoPDF(RepEstadisticoBean repEstadisticoBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();

		parametrosReporte.agregaParametro("Par_NumCon", ""+repEstadisticoBean.getTipoReporte());
		parametrosReporte.agregaParametro("Par_FechaCorte", repEstadisticoBean.getFechaCorte());
		parametrosReporte.agregaParametro("Par_TipoReporte",repEstadisticoBean.getDetReporte());
		parametrosReporte.agregaParametro("Par_MostrarGL",repEstadisticoBean.getIncluirGL());
		parametrosReporte.agregaParametro("Par_MinimoSaldo", repEstadisticoBean.getSaldoMinimo());
		parametrosReporte.agregaParametro("Par_CtasEstRegis", repEstadisticoBean.getIncluirCuentaSA());
		parametrosReporte.agregaParametro("Par_NomInstitucion", repEstadisticoBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_NomUsuario",repEstadisticoBean.getClaveUsuario());
		parametrosReporte.agregaParametro("Par_FechaEmision", repEstadisticoBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_RutaImagen", repEstadisticoBean.getRutaImagen());
		parametrosReporte.agregaParametro("Par_Titulo", ((repEstadisticoBean.getTipoRep().equals("1"))?"CARTERA":"CAPTACION"));
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}	

	public RepEstadisticoDAO getRepEstadisticoDAO() {
		return repEstadisticoDAO;
	}


	public void setRepEstadisticoDAO(RepEstadisticoDAO repEstadisticoDAO) {
		this.repEstadisticoDAO = repEstadisticoDAO;
	}


	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}


	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	
	
}
