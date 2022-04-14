package ventanilla.reporte;
 
import general.bean.ParametrosAuditoriaBean;

import java.io.ByteArrayOutputStream;
import java.util.Calendar;
import java.util.GregorianCalendar;
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

import reporte.ParametrosReporte;
import reporte.Reporte;
import tesoreria.bean.ReporteChequesSBCBean;
import ventanilla.bean.RepPagServBean;
import ventanilla.servicio.RepPagoServiciosServicio;

public class RepPagServControlador extends AbstractCommandController{
	
	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	public static interface Enum_Con_TipRepor {
		  int  ReporPDF= 1 ;
		  int  ReporExcel= 2 ;
	}
	
	String nomReporte = null;
	String successView = null;
	
	RepPagoServiciosServicio repPagoServiciosServicio = null;
	
	public RepPagServControlador(){
		setCommandClass(RepPagServBean.class);
		setCommandName("repPagServBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		RepPagServBean repPagServBean = (RepPagServBean) command;
		
		
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):
			0;
				
		ByteArrayOutputStream htmlStringPDF = null;
		switch(tipoReporte){
			case Enum_Con_TipRepor.ReporPDF:
				 htmlStringPDF = reportePDFPagoServicios(repPagServBean, nomReporte, response);
			break;
			case Enum_Con_TipRepor.ReporExcel:
				List<RepPagServBean> listaReportes = pagoServiciosExcel(Enum_Con_TipRepor.ReporExcel,repPagServBean,response,request);
			break;
		}
		return null;
	}
	public ByteArrayOutputStream reportePDFPagoServicios(RepPagServBean repPagServBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			ParametrosReporte parametrosReporte = new ParametrosReporte();
			parametrosReporte.agregaParametro("Par_Sucursal",repPagServBean.getSucursal());
			parametrosReporte.agregaParametro("Par_NombreSucurs",repPagServBean.getNombreSucurs());
			parametrosReporte.agregaParametro("Par_Servicio",repPagServBean.getServicio());
			parametrosReporte.agregaParametro("Par_NombreServicio",repPagServBean.getNombreServicio());
			parametrosReporte.agregaParametro("Par_FechaCargaInicial",repPagServBean.getFechaCargaInicial());
			parametrosReporte.agregaParametro("Par_FechaCargaFinal",repPagServBean.getFechaCargaFinal());
			parametrosReporte.agregaParametro("Par_NomInstitucion",repPagServBean.getNomInstitucion());
			parametrosReporte.agregaParametro("Par_ClaUsuario",repPagServBean.getClaUsuario());
			parametrosReporte.agregaParametro("Par_Fecha",repPagServBean.getFecha());
			parametrosReporte.agregaParametro("Par_OrigenPago",repPagServBean.getOrigenPago());
			htmlStringPDF =  Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			response.addHeader("Content-Disposition","inline; filename=ReportePagoServicio.pdf");
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
	private List <RepPagServBean> pagoServiciosExcel(int tipoLista,
			RepPagServBean repPagServBean,
			HttpServletResponse response, HttpServletRequest request) {
		// TODO Auto-generated method stub
		List  <RepPagServBean> listaServiciosPagados =null;
//		String fechaVar=repPagServBean.getFechaSistema();
		String todos ="TODOS";
		String noAplica="NA";
		Calendar calendario = new GregorianCalendar();
		int hora, minutos;
		hora =calendario.get(Calendar.HOUR_OF_DAY);
		minutos = calendario.get(Calendar.MINUTE);
		
		listaServiciosPagados =  repPagoServiciosServicio.listaReporte(tipoLista,repPagServBean); 

		try {
	
			HSSFWorkbook libro = new HSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Negrita");
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			
			HSSFFont fuente10= libro.createFont();
			fuente10.setFontHeightInPoints((short)10);

			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			HSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName("Negrita");
			fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			
			
			HSSFFont fuente8= libro.createFont();
			fuente10.setFontHeightInPoints((short)8);

			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			HSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);

			HSSFCellStyle estilo10 = libro.createCellStyle();
			estilo10.setFont(fuente10);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);

			HSSFCellStyle estilo8 = libro.createCellStyle();
			estilo8.setFont(fuente8);
			
			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);  


			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita8);
			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);

			
			HSSFCellStyle estiloCentrado10 = libro.createCellStyle();
			estiloCentrado10.setFont(fuenteNegrita10);
			estiloCentrado10.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado10.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			
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
			HSSFSheet hoja = libro.createSheet("ReportePagosServicios");
			HSSFRow fila= hoja.createRow(0);

			HSSFCell celdaUsu=fila.createCell((short)0);
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				0, //primera fila (0-based)
				0, //ultima fila  (0-based)
				0, //primer celda (0-based)
				5  //ultima celda   (0-based)
			));

			celdaUsu.setCellValue(repPagServBean.getNomInstitucion());
			celdaUsu.setCellStyle(estiloCentrado10);
			
			celdaUsu = fila.createCell((short)6);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);
			celdaUsu = fila.createCell((short)7);
			celdaUsu.setCellValue((!repPagServBean.getClaUsuario().isEmpty())?repPagServBean.getClaUsuario(): "TODOS");
			celdaUsu.setCellStyle(estilo8);


			fila = hoja.createRow(1);
			HSSFCell celdaNomrep=fila.createCell((short)0);
			celdaNomrep.setCellValue("Reporte de Pago de Servicios del " +repPagServBean.getFechaCargaInicial()+ " al "+repPagServBean.getFechaCargaFinal());
			celdaNomrep.setCellStyle(estiloCentrado10);   
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				1, //primera fila (0-based)
				1, //ultima fila  (0-based)
				0, //primer celda (0-based)
				5  //ultima celda   (0-based)
			));
			
			
			HSSFCell celdaFec=fila.createCell((short)6);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)7);
			celdaFec.setCellValue(repPagServBean.getFecha());
			celdaFec.setCellStyle(estilo8);
			
			fila = hoja.createRow(2);
			HSSFCell celdaHora=fila.createCell((short)6);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);
			celdaHora = fila.createCell((short)7);
			celdaHora.setCellValue(hora+":"+minutos);
			
			
			fila = hoja.createRow(4);
			
			HSSFCell celdaFiltros=fila.createCell((short)0);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("Sucursal:");
								
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					3, //primera fila (0-based)
					3, //ultima fila  (0-based)
					1, //primer celda (0-based)
					2  //ultima celda   (0-based)
				));
			celdaFiltros=fila.createCell((short)1);
			celdaFiltros.setCellValue(repPagServBean.getNombreSucurs());
			celdaFiltros.setCellStyle(estilo10);
			
			celdaFiltros=fila.createCell((short)3);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("Servicio:");
			
			celdaFiltros=fila.createCell((short)4);
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					3, //primera fila (0-based)
					3, //ultima fila  (0-based)
					4, //primer celda (0-based)
					6  //ultima celda   (0-based)					
			));
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					3, //primera fila (0-based)
					3, //ultima fila  (0-based)
					8, //primer celda (0-based)
					9  //ultima celda   (0-based)					
			));
			celdaFiltros.setCellValue(repPagServBean.getNombreServicio());
			celdaFiltros.setCellStyle(estilo10);
			
			celdaFiltros=fila.createCell((short)7);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("Origen:");
			
			celdaFiltros=fila.createCell((short)8);			
			celdaFiltros.setCellValue(repPagServBean.getNombreOrigenPago());
			celdaFiltros.setCellStyle(estilo10);
			
			fila = hoja.createRow(6);
			HSSFCell celda=fila.createCell((short)0);
			//Inicio en la segunda fila y que el fila uno tiene los encabezados
			
			celda.setCellValue("Fecha Recepción");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)1);
			celda.setCellValue("Sucursal");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)2);
			celda.setCellValue("Servicio");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)3);
			celda.setCellValue("Referencia");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)4);
			celda.setCellValue("Número de Caja");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)5);
			celda.setCellValue("Monto Pago");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)6);
			celda.setCellValue("IVA");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)7);
			celda.setCellValue("Comisión");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)8);
			celda.setCellValue("IVA Comisión");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)9);
			celda.setCellValue("Pago Compensado");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Origen de pago");
			celda.setCellStyle(estiloNeg8);
			
			int i=7;
			double montoServicio 	= 0;
			double ivaServicio 		= 0;
			double montoComision 	= 0;
			double ivaComision 		= 0;
			String Sucursal = "";
			String Servicio = "";
			for(RepPagServBean PagoServicio : listaServiciosPagados){
				fila=hoja.createRow(i);

				if(PagoServicio.getAplicado().equals("S")){
					PagoServicio.setAplicado("Aplicado");
				}else{
					PagoServicio.setAplicado("No Aplicado");
				}
				
				if(PagoServicio.getCajaID().equals("0")){
					PagoServicio.setCajaID("");
				}
				
				if(PagoServicio.getOrigenPago().equals("B")){
						PagoServicio.setOrigenPago("Banca Elec.");
				}else if(PagoServicio.getOrigenPago().equals("V")){
						PagoServicio.setOrigenPago("Ventanilla");
				}
//				if( !PagoServicio.getSucursalID().equals(Sucursal) ||  !PagoServicio.getCatalogoServID().equals(Servicio)){
//					Sucursal = PagoServicio.getSucursalID();
//					Servicio = PagoServicio.getCatalogoServID();
//					
//					celda=fila.createCell((short)0);
//					celda.setCellValue("Sucursal:"+PagoServicio.getSucursalID()+"-"+PagoServicio.getNombreSucurs()+" - Servicio:"+PagoServicio.getCatalogoServID()+"-"+ PagoServicio.getNombreServicio());
//					hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
//							i, //primera fila (0-based)
//							i, //ultima fila  (0-based)
//							0, //primer celda (0-based)
//							7  //ultima celda   (0-based)
//						));
//					i++;
//					fila=hoja.createRow(i);
//				}
				
				
				celda=fila.createCell((short)0);
				celda.setCellValue(PagoServicio.getFecha());
				
				celda=fila.createCell((short)1);
				celda.setCellValue(PagoServicio.getNombreSucurs());
				
				celda=fila.createCell((short)2);
				celda.setCellValue(PagoServicio.getNombreServicio());

				celda=fila.createCell((short)3);
				celda.setCellValue(PagoServicio.getReferencia());

				celda=fila.createCell((short)4);
				celda.setCellValue(PagoServicio.getCajaID());

				celda=fila.createCell((short)5);
				celda.setCellValue(Double.parseDouble(PagoServicio.getMontoServicio()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)6);
				celda.setCellValue(Double.parseDouble(PagoServicio.getIvaServicio()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)7);
				celda.setCellValue(Double.parseDouble(PagoServicio.getComision()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)8);
				celda.setCellValue(Double.parseDouble(PagoServicio.getIvaComision()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)9);
				celda.setCellValue(PagoServicio.getAplicado());
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)10);
				celda.setCellValue(PagoServicio.getOrigenPago());
				celda.setCellStyle(estiloFormatoDecimal);
				
				
				montoServicio 	= montoServicio+Double.parseDouble(PagoServicio.getMontoServicio());
				ivaServicio 	= ivaServicio+Double.parseDouble(PagoServicio.getIvaServicio());
				montoComision 	= montoComision+Double.parseDouble(PagoServicio.getComision());
				ivaComision 	= ivaComision+Double.parseDouble(PagoServicio.getIvaComision());
				
				i++;
			}

			fila=hoja.createRow(i);
			HSSFCell celdaTotales=fila.createCell((short)0);
			
			celdaTotales=fila.createCell((short)0);
			celdaTotales.setCellStyle(estiloNeg10);
			celdaTotales.setCellValue("Total General:");
			
			celda=fila.createCell((short)5);
			celda.setCellValue(montoServicio);
			celda.setCellStyle(estiloFormatoDecimal);

			celda=fila.createCell((short)6);
			celda.setCellValue(ivaServicio);
			celda.setCellStyle(estiloFormatoDecimal);

			celda=fila.createCell((short)7);
			celda.setCellValue(montoComision);
			celda.setCellStyle(estiloFormatoDecimal);

			celda=fila.createCell((short)8);
			celda.setCellValue(ivaComision);
			celda.setCellStyle(estiloFormatoDecimal);

			


			hoja.autoSizeColumn((short)0);
			hoja.autoSizeColumn((short)1);
			hoja.autoSizeColumn((short)2);
			hoja.autoSizeColumn((short)3);
			hoja.autoSizeColumn((short)4);
			hoja.autoSizeColumn((short)5);
			hoja.autoSizeColumn((short)6);
			hoja.autoSizeColumn((short)7);
			hoja.autoSizeColumn((short)8);
			hoja.autoSizeColumn((short)9);

			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReportePagoServicios.xls");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();


		}catch(Exception e){
			e.printStackTrace();
			System.out.println("error en el reporte de Pago de Servicios Controlador ");
		}
		return listaServiciosPagados;
	} 

	public String getNomReporte() {
		return nomReporte;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public RepPagoServiciosServicio getRepPagoServiciosServicio() {
		return repPagoServiciosServicio;
	}

	public void setRepPagoServiciosServicio(
			RepPagoServiciosServicio repPagoServiciosServicio) {
		this.repPagoServiciosServicio = repPagoServiciosServicio;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
}
