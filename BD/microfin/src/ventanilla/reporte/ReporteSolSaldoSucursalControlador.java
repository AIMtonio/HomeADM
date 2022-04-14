package ventanilla.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.RepSaldosSocioBean;
import cliente.reporte.ReporteSaldosSocioControlador.Enum_Con_TipRepor;
import cuentas.bean.IDEMensualBean;
import ventanilla.bean.SolSaldoSucursalBean;
import ventanilla.servicio.SolSaldoSucursalServicio;
import ventanilla.servicio.SolSaldoSucursalServicio.Enum_Rep_Saldos;

public class ReporteSolSaldoSucursalControlador extends AbstractCommandController {

	SolSaldoSucursalServicio solSaldoSucursalServicio = null;
	String nombreReporte = null;
	String successView = null;	
	
	public ReporteSolSaldoSucursalControlador(){
 		setCommandClass(SolSaldoSucursalBean.class);
 		setCommandName("solSaldoSucursalBean");
 	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		SolSaldoSucursalBean solSaldoSucursalBean = (SolSaldoSucursalBean) command;
		
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):
					0;
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
					0;

		switch(tipoReporte){
			case Enum_Rep_Saldos.excelRep:		
				 List listaReportes = reporteSolicitudExcel(tipoLista,solSaldoSucursalBean,response);
			break;
			case Enum_Rep_Saldos.ReporPDF:
				ByteArrayOutputStream htmlStringPDF = reporteSolicitudPDF(solSaldoSucursalBean, nombreReporte, response);
			break;
		}
		return null;			
	}
	
	
	// Reporte   en PDF
		public ByteArrayOutputStream reporteSolicitudPDF(SolSaldoSucursalBean solSaldoSucursalBean, String nomReporte, HttpServletResponse response){
			ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = solSaldoSucursalServicio.reporteSolicitudSucPDF(solSaldoSucursalBean, nomReporte);
				response.addHeader("Content-Disposition","inline; filename=RepSolSaldosSuc.pdf");
				response.setContentType("application/pdf");
				byte[] bytes = htmlStringPDF.toByteArray();
				response.getOutputStream().write(bytes,0,bytes.length);
				response.getOutputStream().flush();
				response.getOutputStream().close();
			} catch (Exception e) {
				e.printStackTrace();
				// TODO Auto-generated catch block
				e.printStackTrace();
			}		
		return htmlStringPDF;
		}
	
	// Reporte en Excel
		public List  reporteSolicitudExcel(int tipoLista,SolSaldoSucursalBean solSaldoSucursalBean, HttpServletResponse response){
			
			List listaSolicitudes = null;
			String horaVar			= "";
			String varFechaSistema	="";
			String varUsuario="";
	       	int itera=0;
	       	
	       	SolSaldoSucursalBean repSaldoSucursalBean = null;
	     // SE EJECUTA EL SP QUE NOS DEVUELVE LOS VALORES DEL REPORTE
	       	listaSolicitudes = solSaldoSucursalServicio.listaSolicitudSal(tipoLista,solSaldoSucursalBean); 	
	     
	       	try {
				if(!listaSolicitudes.isEmpty()){
					for( itera=0; itera<1; itera ++){
						repSaldoSucursalBean = (SolSaldoSucursalBean) listaSolicitudes.get(itera);
						
					}
				}
				
				//Asigancion de Variables
				varFechaSistema=solSaldoSucursalBean.getFechaReporte();
				varUsuario=solSaldoSucursalBean.getNombreUsuario();
				horaVar=solSaldoSucursalBean.getHoraEmision();
	       	
				/* DECLARACION DE OBJETOS A UTILIZAR */
				XSSFWorkbook libro = new XSSFWorkbook();
				XSSFDataFormat format;
				XSSFCellStyle estiloNeg10;
				XSSFCellStyle estiloNeg8;
				XSSFCellStyle estiloCentrado;
				XSSFCellStyle estiloColor;
				XSSFCellStyle estiloFormatoDecimal;
				XSSFCellStyle estiloNegCentrado10;
				XSSFSheet hoja;
				XSSFFont centradoNegrita10;
				XSSFFont fuenteNegrita10; 
				XSSFFont fuenteNegrita8;
				XSSFCell celda;
				XSSFRow fila;
				
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setFontName("Negrita");
				fuenteNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
				estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				fuenteNegrita8 = libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setFontName("Negrita");
				fuenteNegrita8.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
				estiloNeg8 = libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita8);
				
				// Estilo centrado (S)
				estiloCentrado = libro.createCellStyle();
				estiloCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				
				// Negrita 10 centrado
				centradoNegrita10 = libro.createFont();
				centradoNegrita10.setFontHeightInPoints((short)10);
				centradoNegrita10.setFontName("Negrita");
				centradoNegrita10.setBoldweight(XSSFFont.BOLDWEIGHT_BOLD);
				estiloNegCentrado10 = libro.createCellStyle();
				estiloNegCentrado10.setFont(fuenteNegrita10);
				estiloNegCentrado10.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				
				
				//Estilo negrita de 8  y color de fondo
				estiloColor = libro.createCellStyle();
				estiloColor.setFont(fuenteNegrita8);
				estiloColor.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
				estiloColor.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);
				
				//Estilo Formato decimal (0.00)
				estiloFormatoDecimal = libro.createCellStyle();
				format = libro.createDataFormat();
				estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
				
				// Creacion de hoja					
				hoja = libro.createSheet("Reporte SolSaldosSucursal");
				fila = hoja.createRow(0);

				celda =fila.createCell((short)3);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue(solSaldoSucursalBean.getNombreInstitucion());
				celda.setCellStyle(estiloNegCentrado10);
				hoja.addMergedRegion(new CellRangeAddress(
			            0, //first row (0-based)
			            0, //last row  (0-based)
			            3, //first column (0-based)
			            8  //last column  (0-based)
			    ));
				
				fila	= hoja.createRow(1);	//	FILA 1 ---------------------------------------------------------
				celda	= fila.createCell((short)3);
				celda.setCellStyle(estiloNeg10);
				celda.setCellValue("REPORTE SOLICITUD DE SALDOS POR SUCURSAL DEL "
				+ solSaldoSucursalBean.getFechaIni() +" AL " + solSaldoSucursalBean.getFechaFin() );
				celda.setCellStyle(estiloNegCentrado10);
				hoja.addMergedRegion(new CellRangeAddress(
			            1, //first row (0-based)
			            1, //last row  (0-based)
			            3, //first column (0-based)
			            8  //last column  (0-based)
			    ));
	       		       	
				
				fila	= hoja.createRow(2);	//	FILA 2 ---------------------------------------------------------
				celda = fila.createCell((short)17);
				celda.setCellValue("Usuario:");
				celda.setCellStyle(estiloNeg8);	
				celda = fila.createCell((short)18);
				celda.setCellValue(varUsuario);
				

				fila = hoja.createRow(3);	//	FILA 3 ---------------------------------------------------------
			
				
				
				celda = fila.createCell((short)17);
				celda.setCellValue("Fecha:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)18);
				celda.setCellValue(varFechaSistema);
				
				
				
				fila = hoja.createRow(4);	//	FILA 4 ---------------------------------------------------------
				
				celda = fila.createCell((short)0);
				celda.setCellValue("Sucursal: "+solSaldoSucursalBean.getSucursalID() + " - " + solSaldoSucursalBean.getNombreSucursal());
				celda.setCellStyle(estiloNeg8);
				
				
				celda = fila.createCell((short)17);
				celda.setCellValue("Hora:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short)18);
				celda.setCellValue(horaVar);

				fila = hoja.createRow(5);	//	FILA 5 ---------------------------------------------------------
						
				
				
				
							
				
				// Creacion de fila
				fila = hoja.createRow(6);	//	FILA 6	---------------------------------------------------------			
				celda = fila.createCell((short)0);
				celda.setCellValue("SUCURSAL ");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)1);
				celda.setCellValue("CUENTAS DE BANCOS ");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)2);
				celda.setCellValue("FECHA SOLICITUD");
				celda.setCellStyle(estiloNeg8);			

				celda = fila.createCell((short)3);
				celda.setCellValue("HORA DE LA SOLICITUD ");
				celda.setCellStyle(estiloNeg8);		

				celda = fila.createCell((short)4);
				celda.setCellValue("USUARIO ");
				celda.setCellStyle(estiloNeg8);	
				
				celda = fila.createCell((short)5);
				celda.setCellValue("CANTIDAD CRÉDITOS POR DESEMBOLSAR");
				celda.setCellStyle(estiloNeg8);	

				celda = fila.createCell((short)6);
				celda.setCellValue("MONTO CRÉDITOS POR DESEMBOLSAR");
				celda.setCellStyle(estiloNeg8);	

				celda = fila.createCell((short)7);
				celda.setCellValue("CANTIDAD INVERSIONES POR VENCER ");
				celda.setCellStyle(estiloNeg8);	

				celda = fila.createCell((short)8);
				celda.setCellValue("MONTO INVERSIONES POR VENCER ");
				celda.setCellStyle(estiloNeg8);

				celda = fila.createCell((short)9);
				celda.setCellValue("CANTIDAD CHEQUES EMITIDOS EN TRANSITO");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)10);
				celda.setCellValue("MONTO CHEQUES EMITIDOS EN TRANSITO");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("CANTIDAD CHEQUES INTERNOS RECIBIDOS DÍA ANTERIOR ");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)12);
				celda.setCellValue("MONTO CHEQUES INTERNOS RECIBIDOS DÍA ANTERIOR ");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)13);
				celda.setCellValue("CANTIDAD CHEQUES INTERNOS RECIBIDOS HOY");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)14);
				celda.setCellValue("MONTO CHEQUES INTERNOS RECIBIDOS HOY ");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)15);
				celda.setCellValue("SALDOS EN CAJA PRINCIPAL ");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)16);
				celda.setCellValue("SALDOS EN CAJAS ATENCIÓN ");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)17);
				celda.setCellValue("MONTO SOLICITADO ");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell((short)18);
				celda.setCellValue("COMENTARIOS");
				celda.setCellStyle(estiloNeg8);
				
				
				int numFilaSig = 7, iter=0;
				int tamanioLista = listaSolicitudes.size();
				SolSaldoSucursalBean SolSaldoSucursal=null;
				for( iter=0; iter<tamanioLista; iter ++){
					
					
				 
					SolSaldoSucursal = (SolSaldoSucursalBean) listaSolicitudes.get(iter);
					fila=hoja.createRow(numFilaSig);
					
					celda=fila.createCell((short)0);
					celda.setCellValue(SolSaldoSucursal.getSucursalID()+" - " + SolSaldoSucursal.getSucursalNom());				
					
					
					celda=fila.createCell((short)1);
					celda.setCellValue(SolSaldoSucursal.getCuentas());
					
					celda=fila.createCell((short)2);
					celda.setCellValue(SolSaldoSucursal.getFechaSol());
					
					celda=fila.createCell((short)3);
					celda.setCellValue(SolSaldoSucursal.getHora());
					
					celda=fila.createCell((short)4);
					celda.setCellValue(SolSaldoSucursal.getUsuarioID());
					
					celda=fila.createCell((short)5);
					celda.setCellValue(SolSaldoSucursal.getCanCreDesem());
					
					celda=fila.createCell((short)6);
					celda.setCellValue(Utileria.convierteDoble(SolSaldoSucursal.getMonCreDesem()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)7);
					celda.setCellValue(SolSaldoSucursal.getCanInverVenci());
					
					celda=fila.createCell((short)8);
					celda.setCellValue(Utileria.convierteDoble(SolSaldoSucursal.getMonInverVenci()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)9);
					celda.setCellValue(SolSaldoSucursal.getCanChequeEmi());
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)10);
					celda.setCellValue(Utileria.convierteDoble(SolSaldoSucursal.getMonChequeEmi()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)11);
					celda.setCellValue(SolSaldoSucursal.getCanChequeIntReA());
					
					celda=fila.createCell((short)12);
					celda.setCellValue(Utileria.convierteDoble(SolSaldoSucursal.getMonChequeIntReA()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)13);
					celda.setCellValue(SolSaldoSucursal.getCanChequeIntRe());
					
					celda=fila.createCell((short)14);
					celda.setCellValue(Utileria.convierteDoble(SolSaldoSucursal.getMonChequeIntRe()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)15);
					celda.setCellValue(Utileria.convierteDoble(SolSaldoSucursal.getSaldosCP()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)16);
					celda.setCellValue(Utileria.convierteDoble(SolSaldoSucursal.getSaldosCA()));
					celda.setCellStyle(estiloFormatoDecimal);
					
						
					celda=fila.createCell((short)17);
					celda.setCellValue(Utileria.convierteDoble(SolSaldoSucursal.getMontoSolicitado()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda=fila.createCell((short)18);
					celda.setCellValue(SolSaldoSucursal.getComentarios());
					
						
					numFilaSig++;
				}
				
				
				numFilaSig = numFilaSig+2;
				fila=hoja.createRow(numFilaSig);
				celda = fila.createCell((short)0);
				celda.setCellValue("Registros Exportados");
				celda.setCellStyle(estiloNeg8);
				
				numFilaSig = numFilaSig+1;
				fila=hoja.createRow(numFilaSig);
				celda=fila.createCell((short)0);
				celda.setCellValue(tamanioLista);
				
				// Autoajusta las columnas
				for(int celd=0; celd<=31; celd++)
				hoja.autoSizeColumn((short)celd);
									
				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=RepSolicitudSaldosSucural.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
				
				
	    	}catch(Exception e){
	    		e.printStackTrace();
	    	}//Fin del catch
				
			return listaSolicitudes;
	       	
		}

		public SolSaldoSucursalServicio getSolSaldoSucursalServicio() {
			return solSaldoSucursalServicio;
		}

		public void setSolSaldoSucursalServicio(
				SolSaldoSucursalServicio solSaldoSucursalServicio) {
			this.solSaldoSucursalServicio = solSaldoSucursalServicio;
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
