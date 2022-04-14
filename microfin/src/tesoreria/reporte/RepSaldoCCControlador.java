
	package tesoreria.reporte;

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
	import tesoreria.bean.RepSaldoBancosCCBean;
	import tesoreria.servicio.RepSaldoBancosCCServicio;

	public class RepSaldoCCControlador  extends AbstractCommandController{

		public static interface Enum_Con_TipRepor {
			  int  ReporExcel= 1 ;
		}
		
		RepSaldoBancosCCServicio repSaldoBancosCCServicio = null;
		String nombreReporte = null;
		String successView = null;	
		int    formaReporte = 0; // sumarizado o detallado
		
		
		public RepSaldoCCControlador(){
			setCommandClass(RepSaldoBancosCCBean.class);
			setCommandName("repSaldoBancosCCBean");
		}
		
		protected ModelAndView handle(HttpServletRequest request,
				  HttpServletResponse response,
				  Object command,
				  BindException errors) throws Exception {


			RepSaldoBancosCCBean repSaldoBancosCCBean = (RepSaldoBancosCCBean) command;
			int tipoReporte =(request.getParameter("tipoRep")!=null)?
					Integer.parseInt(request.getParameter("tipoRep")):0;
					
			int tipoLista =(request.getParameter("tipoLista")!=null)?
					Integer.parseInt(request.getParameter("tipoLista")):0;
					
			formaReporte =(request.getParameter("formaRep")!=null)?
					Integer.parseInt(request.getParameter("formaRep")):0;
				
			String htmlString= "";
			
			switch(tipoReporte){	
			case Enum_Con_TipRepor.ReporExcel:		
				 List<RepSaldoBancosCCBean>listaReportes = listaSaldosBancosCentroCosto(tipoLista,repSaldoBancosCCBean,response);
				}
			return null;	
		}
			
		// Reporte de saldos en bancos por centro de costo en Excel
		public List <RepSaldoBancosCCBean> listaSaldosBancosCentroCosto(int tipoLista,RepSaldoBancosCCBean repSaldoBancosCCBean,  HttpServletResponse response){
		List<RepSaldoBancosCCBean> listaSaldos=null;
		List<RepSaldoBancosCCBean> listaDetalle=null;
	    listaSaldos = repSaldoBancosCCServicio.listaReporteSaldosBancos(1,repSaldoBancosCCBean,response); 
	   if(formaReporte == 2){
		listaDetalle = repSaldoBancosCCServicio.listaReporteSaldosBancos(2,repSaldoBancosCCBean,response);
	   }
	     
		int regExport = 0;

		if(listaSaldos != null){
			
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

						//Estilo Formato decimal (0.00)
						HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
						HSSFDataFormat format = libro.createDataFormat();
						estiloFormatoDecimal.setDataFormat(format.getFormat("0.00"));

						// Creacion de hoja
						HSSFSheet hoja = libro.createSheet("Reporte Sumarizado");
						HSSFRow fila= hoja.createRow(0);
						fila = hoja.createRow(1);
						fila = hoja.createRow(2);

						HSSFCell celda=fila.createCell((short)1);
						
						celda.setCellStyle(estiloNeg10);
						celda.setCellValue(repSaldoBancosCCBean.getNombreInstitucion());
						hoja.addMergedRegion(new CellRangeAddress(
						           2,2,1,4));
						
						celda = fila.createCell((short)6);
						celda.setCellValue("Usuario:");
						celda.setCellStyle(estiloNeg8);
						celda = fila.createCell((short)7);
						celda.setCellValue(repSaldoBancosCCBean.getUsuario());
						celda.setCellStyle(estiloNeg8);
						fila = hoja.createRow(3);
						//celda = fila.createCell((short)6);
					
						
						fila = hoja.createRow(3);
						celda = fila.createCell	((short)1);
						celda.setCellStyle(estiloNeg10);
						celda.setCellValue("REPORTE DE SALDOS EN BANCOS POR CENTROS DE COSTOS");
						hoja.addMergedRegion(new CellRangeAddress(
						           3,3,1,4));
						
						
						celda = fila.createCell((short)6);
						celda.setCellValue("Fecha:");
						celda.setCellStyle(estiloNeg8);
						celda = fila.createCell((short)7);
						celda.setCellValue(repSaldoBancosCCBean.getFecha());
						celda.setCellStyle(estiloNeg8);
						fila = hoja.createRow(4);
				
						celda = fila.createCell((short)6);
						celda.setCellValue("Hora:");
						celda.setCellStyle(estiloNeg8);
						celda = fila.createCell((short)7);
						celda.setCellValue(repSaldoBancosCCBean.getHoraEmision());
						celda.setCellStyle(estiloNeg8);
						fila = hoja.createRow(5);
						celda = fila.createCell((short)6);
					
						
						// Creacion de fila
						fila = hoja.createRow(6);
						fila = hoja.createRow(7);

						//Inicio en la segunda fila y que el fila uno tiene los encabezados
						celda = fila.createCell((short)0);
						celda.setCellValue("FECHA");
						celda.setCellStyle(estiloNeg8);
						celda.setCellStyle(estiloColor);
						
						

						celda = fila.createCell((short)1);
						celda.setCellValue("CUENTA BANCARIA");
						celda.setCellStyle(estiloNeg8);
						celda.setCellStyle(estiloColor);
						
						celda = fila.createCell((short)2);
						celda.setCellValue("CUENTA CONTABLE");
						celda.setCellStyle(estiloNeg8);
						celda.setCellStyle(estiloColor);
						
						celda = fila.createCell((short)3);
						celda.setCellValue("CENTRO DE COSTOS");
						celda.setCellStyle(estiloNeg8);
						celda.setCellStyle(estiloColor);
						
						celda = fila.createCell((short)4);
						celda.setCellValue("SALDO INICIAL");
						celda.setCellStyle(estiloNeg8);
						celda.setCellStyle(estiloColor);
						
						celda = fila.createCell((short)5);
						celda.setCellValue("CARGOS");
						celda.setCellStyle(estiloNeg8);
						celda.setCellStyle(estiloColor);
						
						celda = fila.createCell((short)6);
						celda.setCellValue("ABONOS");
						celda.setCellStyle(estiloNeg8);
						celda.setCellStyle(estiloColor);
						
						celda = fila.createCell((short)7);
						celda.setCellValue("SALDO FINAL");
						celda.setCellStyle(estiloNeg8);
						celda.setCellStyle(estiloColor);
						
						
						int i=8;
						for(RepSaldoBancosCCBean saldos : listaSaldos ){
							fila=hoja.createRow(i);
							celda=fila.createCell((short)0);
							celda.setCellValue(saldos.getFechaMov());
							celda.setCellStyle(estilo8);
							
							celda=fila.createCell((short)1);
							celda.setCellValue(saldos.getNumCtaInstit());
							celda.setCellStyle(estilo8);
							
							celda=fila.createCell((short)2);
							celda.setCellValue(saldos.getCuentaContable());
							celda.setCellStyle(estilo8);
							
							celda=fila.createCell((short)3);
							celda.setCellValue(saldos.getCentroCostoID());
							celda.setCellStyle(estilo8);
							
							celda=fila.createCell((short)4);
							celda.setCellValue("$ "+saldos.getSaldoInicial());
							celda.setCellStyle(estilo8);						
							
							celda=fila.createCell((short)5);					
							celda.setCellValue("$ "+saldos.getCargos());
							celda.setCellStyle(estilo8);
							
							celda=fila.createCell((short)6);
							celda.setCellValue("$ "+saldos.getAbonos());
							celda.setCellStyle(estilo8);						
							
							celda=fila.createCell((short)7);
							celda.setCellValue("$ "+saldos.getSaldoFinal());
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
						hoja.autoSizeColumn((short)6);
						hoja.autoSizeColumn((short)7);
					
						
						
						if(formaReporte == 2) {
							
							// Creacion de hoja
							HSSFSheet hoja2 = libro.createSheet("Reporte Detallado");
							HSSFRow fila2= hoja2.createRow(0);
							fila2 = hoja2.createRow(1);
							fila2 = hoja2.createRow(2);
							HSSFCell celda2=fila2.createCell((short)0);
							
							
							celda2.setCellStyle(estiloNeg10);
							celda2.setCellValue(repSaldoBancosCCBean.getNombreInstitucion());
							hoja2.addMergedRegion(new CellRangeAddress(2,2,0,3));
							
							celda2 = fila2.createCell((short)4);
							celda2.setCellValue("Usuario:");
							celda2.setCellStyle(estiloNeg8);
							celda2 = fila2.createCell((short)5);
							celda2.setCellValue(repSaldoBancosCCBean.getUsuario());
							celda2.setCellStyle(estiloNeg8);
							fila2 = hoja2.createRow(3);
						
							
							fila2 = hoja2.createRow(3);
							celda2 = fila2.createCell	((short)0);
							celda2.setCellStyle(estiloNeg10);
							celda2.setCellValue("REPORTE DE SALDOS EN BANCOS POR CENTROS DE COSTOS");
							hoja2.addMergedRegion(new CellRangeAddress(3,3,0,3));
							
							
							celda = fila2.createCell((short)4);
							celda.setCellValue("Fecha:");
							celda.setCellStyle(estiloNeg8);
							celda = fila2.createCell((short)5);
							celda.setCellValue(repSaldoBancosCCBean.getFecha());
							celda.setCellStyle(estiloNeg8);
							fila2 = hoja2.createRow(4);
					
							
							celda2 = fila2.createCell((short)4);
							celda2.setCellValue("Hora:");
							celda2.setCellStyle(estiloNeg8);
							celda2 = fila2.createCell((short)5);
							celda2.setCellValue(repSaldoBancosCCBean.getHoraEmision());
							celda2.setCellStyle(estiloNeg8);
							fila2 = hoja2.createRow(5);
							celda2 = fila2.createCell((short)6);
						
							
							// Creacion de fila
							fila2 = hoja2.createRow(6);
							fila2 = hoja2.createRow(7);

							//Inicio en la segunda fila y que el fila uno tiene los encabezados
							celda2 = fila2.createCell((short)0);
							celda2.setCellValue("FECHA");
							celda2.setCellStyle(estiloNeg8);
							celda2.setCellStyle(estiloColor);
							
							celda2 = fila2.createCell((short)1);
							celda2.setCellValue("CUENTA CONTABLE");
							celda2.setCellStyle(estiloNeg8);
							celda2.setCellStyle(estiloColor);
							
							celda2 = fila2.createCell((short)2);
							celda2.setCellValue("CENTRO DE COSTOS");
							celda2.setCellStyle(estiloNeg8);
							celda2.setCellStyle(estiloColor);
							
							celda2 = fila2.createCell((short)3);
							celda2.setCellValue("CARGOS");
							celda2.setCellStyle(estiloNeg8);
							celda2.setCellStyle(estiloColor);
							
							celda2 = fila2.createCell((short)4);
							celda2.setCellValue("ABONOS");
							celda2.setCellStyle(estiloNeg8);
							celda2.setCellStyle(estiloColor);
						
							int x=8;
							for(RepSaldoBancosCCBean saldosDetalle : listaDetalle ){
								fila2=hoja2.createRow(x);
								celda2=fila2.createCell((short)0);
								celda2.setCellValue(saldosDetalle.getFechaMov());
								celda2.setCellStyle(estilo8);
								
								celda2=fila2.createCell((short)1);
								celda2.setCellValue(saldosDetalle.getCuentaContable());
								celda2.setCellStyle(estilo8);
								
								celda2=fila2.createCell((short)2);
								celda2.setCellValue(saldosDetalle.getCentroCostoID());
								celda2.setCellStyle(estilo8);
								
								celda2=fila2.createCell((short)3);
								celda2.setCellValue("$ "+saldosDetalle.getCargos());
								celda2.setCellStyle(estilo8);
																				
								celda2=fila2.createCell((short)4);					
								celda2.setCellValue("$ "+saldosDetalle.getAbonos());
								celda2.setCellStyle(estilo8);
													
								
								regExport 		= regExport + 1;

								x++;
							}
							
							hoja2.autoSizeColumn((short)0);
							hoja2.autoSizeColumn((short)1);
							hoja2.autoSizeColumn((short)2);
							hoja2.autoSizeColumn((short)3);
							hoja2.autoSizeColumn((short)4);
							hoja2.autoSizeColumn((short)5);
	
							
						}
						
						
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReporteSaldosBancosCC.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
				}catch(Exception e){
				
					e.printStackTrace();
				}//Fin del catch
			}
						
			return  listaSaldos;
			
			}

						
						

	public String getNombreReporte() {
		return nombreReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setRepSaldoBancosCCServicio(
			RepSaldoBancosCCServicio repSaldoBancosCCServicio) {
		this.repSaldoBancosCCServicio = repSaldoBancosCCServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
}
