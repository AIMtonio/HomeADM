package tesoreria.reporte;

import java.io.ByteArrayOutputStream;
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
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.AvaladosCreditoRepBean;
import credito.reporte.PDFAvaladosCreditoRepControlador.Enum_Con_TipRepor;

import tesoreria.bean.ReporteChequesSBCBean;
import tesoreria.servicio.ReporteChequesSBCServicio;

public class PDFReporteChequesSBCControlador extends AbstractCommandController {

	ReporteChequesSBCServicio reporteChequesSBCServicio=null;
	String nombreReporte = null;
	String successView = null;
	String fecha_vacia="1900-01-01";

	public static interface Enum_Con_TipRepor {;
	int  ReporPDF= 1 ;
	int  ReporExcel= 2 ;
	}

	public PDFReporteChequesSBCControlador(){
		setCommandClass(ReporteChequesSBCBean.class);
		setCommandName("reporteChequesSBCBean");
	}


	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {	
		ReporteChequesSBCBean reporteChequesSBCBean =(ReporteChequesSBCBean) command;
		// TODO Auto-generated method stub
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
				String htmlString= "";

				int tipoLista =(request.getParameter("tipoLista")!=null)?
						Integer.parseInt(request.getParameter("tipoLista")):
							0;


						switch(tipoReporte){
						case Enum_Con_TipRepor.ReporPDF:
							ByteArrayOutputStream htmlStringPDF = ChequesSBCPDF(reporteChequesSBCBean,nombreReporte ,response);
							break;
						case Enum_Con_TipRepor.ReporExcel:
							List<ReporteChequesSBCBean>  listaReportes = ChequesSBCExcel(tipoLista,reporteChequesSBCBean,response,request);
							break;

						}
						return null;
	}


	private ByteArrayOutputStream ChequesSBCPDF(
			ReporteChequesSBCBean reporteChequesSBCBean, String nombreReporte2,
			HttpServletResponse response) {	ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = reporteChequesSBCServicio.reporteChequesSBCPDF(reporteChequesSBCBean, nombreReporte);
				response.addHeader("Content-Disposition","inline; filename=RepChequesSBC.pdf");
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

	private List <ReporteChequesSBCBean> ChequesSBCExcel(int tipoLista,
			ReporteChequesSBCBean reporteChequesSBCBean,
			HttpServletResponse response, HttpServletRequest request) {
		// TODO Auto-generated method stub
		List  <ReporteChequesSBCBean> listaChequeSBC =null;
		String fechaVar=reporteChequesSBCBean.getFechaSistema();
		String todos ="TODOS";
		String noAplica="NA";

		listaChequeSBC = reporteChequesSBCServicio.ListaChequesSBC(tipoLista,reporteChequesSBCBean,response); 

		try {


			if(reporteChequesSBCBean.getNoCuentaInstituIni().equals("0")){
				reporteChequesSBCBean.setNoCuentaInstituIni(todos);
			}

			if(reporteChequesSBCBean.getClienteIDIni().equals("0")){
				reporteChequesSBCBean.setClienteIDIni("");
			}

			if(reporteChequesSBCBean.getEstatusCheque().equals("")){
				reporteChequesSBCBean.setEstatusCheque(todos);
			}else{
				if(reporteChequesSBCBean.getEstatusCheque().equals("A")){
					reporteChequesSBCBean.setEstatusCheque("APLICADO");
				}else{
					if(reporteChequesSBCBean.getEstatusCheque().equals("R")){
						reporteChequesSBCBean.setEstatusCheque("RECIBIDO");
					}else{
						if(reporteChequesSBCBean.getEstatusCheque().equals("C")){
							reporteChequesSBCBean.setEstatusCheque("CANCELADO");
						}
					}
				}
			}

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
			HSSFSheet hoja = libro.createSheet("Reporte de Cheques SBC");
			HSSFRow fila= hoja.createRow(0);

			HSSFCell celdaUsu=fila.createCell((short)1);
			celdaUsu.setCellValue(request.getParameter("nombreInstitucion"));
			celdaUsu.setCellStyle(estiloNeg8);
			
			celdaUsu=fila.createCell((short)1);
			celdaUsu.setCellStyle(estiloNeg10);
			celdaUsu.setCellValue("Reporte de Cheques SBC del "+reporteChequesSBCBean.getFechaInicial()+" al "+reporteChequesSBCBean.getFechaFinal());

			celdaUsu = fila.createCell((short)9);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)10);
			celdaUsu.setCellValue((!reporteChequesSBCBean.getNombreUsuario().isEmpty())?reporteChequesSBCBean.getNombreUsuario(): "TODOS");


			fila = hoja.createRow(1);
			HSSFCell celdaFec=fila.createCell((short)1);
			celdaFec = fila.createCell((short)9);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)10);
			celdaFec.setCellValue(fechaVar);

			fila = hoja.createRow(3);
			fila = hoja.createRow(4);



			HSSFCell celdaFiltros=fila.createCell((short)1);
			celdaFiltros=fila.createCell((short)0);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("Institución: "+reporteChequesSBCBean.getNombInstitucionIni());

			celdaFiltros=fila.createCell((short)1);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("No Cuenta: "+reporteChequesSBCBean.getNoCuentaInstituIni()); 				


			celdaFiltros=fila.createCell((short)2);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("Cliente/Socio : "+reporteChequesSBCBean.getClienteIDIni()+" "+reporteChequesSBCBean.getNombreClienteIni());


			celdaFiltros=fila.createCell((short)3);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("Sucursal: "+reporteChequesSBCBean.getNombreSucursal());

			celdaFiltros=fila.createCell((short)4);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("Estatus Cheque: "+reporteChequesSBCBean.getEstatusCheque());





			fila = hoja.createRow(5);
			fila = hoja.createRow(6);
			HSSFCell celda=fila.createCell((short)1);
			//Inicio en la segunda fila y que el fila uno tiene los encabezados
			celda = fila.createCell((short)0);
			celda.setCellValue("Sucursal");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)1);
			celda.setCellValue("Institución");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)2);
			celda.setCellValue("Cuenta Institución");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)3);
			celda.setCellValue("No Cliente/Socio");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)4);
			celda.setCellValue("Nombre Cliente/Socio");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)5);
			celda.setCellValue("Cuenta Cliente/Socio");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)6);
			celda.setCellValue("Nombre Emisor Cheque");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)7);
			celda.setCellValue("Banco Emisor");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)8);
			celda.setCellValue("Número Cheque");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)9);
			celda.setCellValue("Número Cuenta Cheque");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)10);
			celda.setCellValue("Monto");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)11);
			celda.setCellValue("Forma Aplicación");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)12);
			celda.setCellValue("Fecha Recepción");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)13);
			celda.setCellValue("Fecha Aplicación");
			celda.setCellStyle(estiloNeg8);



			int i=8;
			for(ReporteChequesSBCBean chequesSBCBean : listaChequeSBC){
				fila=hoja.createRow(i);

				if(chequesSBCBean.getFechaRecepcion().equals(fecha_vacia)){
					chequesSBCBean.setFechaRecepcion(noAplica);
				}
				if(chequesSBCBean.getFechaAplicacion().equals(fecha_vacia)){
					chequesSBCBean.setFechaAplicacion(noAplica);
					chequesSBCBean.setFormaAplica(noAplica);
				}else{
					if(chequesSBCBean.getFormaAplica().equals("D")){
						chequesSBCBean.setFormaAplica("DEPOSITO");
					}else{
						if(chequesSBCBean.getFormaAplica().equals("E")){
							chequesSBCBean.setFormaAplica("EFECTIVO");
						}
					}
				}
				if(chequesSBCBean.getCuentaAplica().equals("0")){
					chequesSBCBean.setCuentaAplica(noAplica);
					chequesSBCBean.setNombInsAplica(noAplica);
				}

				if(chequesSBCBean.getCuentaAplica().equals("0")){
					chequesSBCBean.setCuentaAplica(noAplica);
				}
				if(chequesSBCBean.getEstatus().equals("C")){
					chequesSBCBean.setFormaAplica(noAplica);
				}
				celda=fila.createCell((short)0);
				celda.setCellValue(chequesSBCBean.getNombreSucursal());

				celda=fila.createCell((short)1);
				celda.setCellValue(chequesSBCBean.getNombInsAplica());

				celda=fila.createCell((short)2);
				celda.setCellValue(chequesSBCBean.getCuentaAplica());

				celda=fila.createCell((short)3);
				celda.setCellValue(chequesSBCBean.getClienteID());

				celda=fila.createCell((short)4);
				celda.setCellValue(chequesSBCBean.getNombreCliente());

				celda=fila.createCell((short)5);
				celda.setCellValue(chequesSBCBean.getCuentaAhoID());

				celda=fila.createCell((short)6);
				celda.setCellValue(chequesSBCBean.getNombreEmisor());

				celda=fila.createCell((short)7);
				celda.setCellValue(chequesSBCBean.getNombreInstitucion());

				celda=fila.createCell((short)8);
				celda.setCellValue(chequesSBCBean.getNumCheque());

				celda=fila.createCell((short)9);
				celda.setCellValue(chequesSBCBean.getCuentaEmisor());

				celda=fila.createCell((short)10);
				celda.setCellValue(chequesSBCBean.getMonto());

				celda=fila.createCell((short)11);
				celda.setCellValue(chequesSBCBean.getFormaAplica());

				celda=fila.createCell((short)12);
				celda.setCellValue(chequesSBCBean.getFechaRecepcion());

				celda=fila.createCell((short)13);
				celda.setCellValue(chequesSBCBean.getFechaAplicacion());


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
			hoja.autoSizeColumn((short)8);
			hoja.autoSizeColumn((short)9);
			hoja.autoSizeColumn((short)10);
			hoja.autoSizeColumn((short)11);
			hoja.autoSizeColumn((short)12);
			hoja.autoSizeColumn((short)13);

			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteChequesSBC.xls");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();


		}catch(Exception e){
			e.printStackTrace();
			System.out.println("error en el reporte de Cheques SBC Controlador ");
		}
		return listaChequeSBC;
	} 


	public ReporteChequesSBCServicio getReporteChequesSBCServicio() {
		return reporteChequesSBCServicio;
	}


	public void setReporteChequesSBCServicio(
			ReporteChequesSBCServicio reporteChequesSBCServicio) {
		this.reporteChequesSBCServicio = reporteChequesSBCServicio;
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
