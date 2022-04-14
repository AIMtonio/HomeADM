package cliente.reporte;

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

import tesoreria.bean.ReporteChequesSBCBean;
import tesoreria.reporte.PDFReporteChequesSBCControlador.Enum_Con_TipRepor;

import cliente.bean.RepoteClientesMenoresBean;
import cliente.servicio.ReporteClienteMenoresServicio;

public class PDFClientesMenoresControlador extends AbstractCommandController{


	ReporteClienteMenoresServicio reporteClienteMenoresServicio = null;	
	String nombreReporte = null;
	String successView = null;	
	String nomTipoReporte = "";

	public static interface Enum_Con_TipRepor {;
	int  ReporPDF= 1 ;
	int  ReporExcel= 2 ;
	}


	public PDFClientesMenoresControlador(){
		setCommandClass(RepoteClientesMenoresBean.class);
		setCommandName("repoteClientesMenoresBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		RepoteClientesMenoresBean repoteClientesMenoresBean = (RepoteClientesMenoresBean) command;

		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
				String htmlString= "";


				switch(tipoReporte){
				case Enum_Con_TipRepor.ReporPDF:
					ByteArrayOutputStream htmlStringPDF = ClientesMenoresPDF(repoteClientesMenoresBean,nombreReporte ,response);
					break;
				case Enum_Con_TipRepor.ReporExcel:
					List<RepoteClientesMenoresBean>  listaReportes = socioMenorRepExcel(repoteClientesMenoresBean,response,request);
					break;

				}
				return null;
	}

	public ByteArrayOutputStream ClientesMenoresPDF(RepoteClientesMenoresBean repoteClientesMenoresBean, String nomReporte, HttpServletResponse response){
		ByteArrayOutputStream htmlStringPDF = null;
		try {
			htmlStringPDF = reporteClienteMenoresServicio.reporteClientesMenoresPDF(repoteClientesMenoresBean, nomReporte);
			response.addHeader("Content-Disposition","inline; filename=ReporteSociosMenores.pdf");
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


	private List <RepoteClientesMenoresBean> socioMenorRepExcel(
			RepoteClientesMenoresBean repoteClientesMenoresBean,
			HttpServletResponse response, HttpServletRequest request) {
		// TODO Auto-generated method stub
		List  <RepoteClientesMenoresBean> listaSociosMenores =null;
		String fechaVar=repoteClientesMenoresBean.getFechaSistema();

		listaSociosMenores = reporteClienteMenoresServicio.ListaSocioMenor(repoteClientesMenoresBean,response); 

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
			HSSFSheet hoja = libro.createSheet("Reporte Socio Menor");
			HSSFRow fila= hoja.createRow(0);

			HSSFCell celdaUsu=fila.createCell((short)1);
			celdaUsu.setCellValue(request.getParameter("nombreInstitucion"));
			celdaUsu.setCellStyle(estiloNeg8);

			celdaUsu=fila.createCell((short)1);
			celdaUsu.setCellStyle(estiloNeg10);
			celdaUsu.setCellValue("Reporte Socio Menor");

			celdaUsu = fila.createCell((short)9);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)10);
			celdaUsu.setCellValue((!repoteClientesMenoresBean.getUsuario().isEmpty())?repoteClientesMenoresBean.getUsuario(): "TODOS");


			fila = hoja.createRow(1);
			HSSFCell celdaFec=fila.createCell((short)1);
			celdaFec = fila.createCell((short)9);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)10);
			celdaFec.setCellValue(fechaVar);

			fila = hoja.createRow(3);
			fila = hoja.createRow(4);

			if(repoteClientesMenoresBean.getEstatusCta().equals("")){
				repoteClientesMenoresBean.setEstatusCta("TODOS");
			}else{
				if(repoteClientesMenoresBean.getEstatusCta().equals("A")){
					repoteClientesMenoresBean.setEstatusCta("ACTIVA");
				}else{
					if(repoteClientesMenoresBean.getEstatusCta().equals("B")){
						repoteClientesMenoresBean.setEstatusCta("BLOQUEADA");
					}else{
						if(repoteClientesMenoresBean.getEstatusCta().equals("C")){
							repoteClientesMenoresBean.setEstatusCta("CANCELADA");
						}else{
							if(repoteClientesMenoresBean.getEstatusCta().equals("I")){
								repoteClientesMenoresBean.setEstatusCta("INACTIVA");
							}else{
								if(repoteClientesMenoresBean.getEstatusCta().equals("R")){
									repoteClientesMenoresBean.setEstatusCta("REGISTRADA");
								}
							}
						}
					}
				}
			}


			HSSFCell celdaFiltros=fila.createCell((short)1);
			celdaFiltros=fila.createCell((short)0);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("Sucursal: "+repoteClientesMenoresBean.getNombreSucurs());

			celdaFiltros=fila.createCell((short)1);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("Estatus Cuenta: "+repoteClientesMenoresBean.getEstatusCta());

			celdaFiltros=fila.createCell((short)2);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("Promotor: "+repoteClientesMenoresBean.getNombrePromotor());



			fila = hoja.createRow(5);
			fila = hoja.createRow(6);
			HSSFCell celda=fila.createCell((short)1);
			//Inicio en la segunda fila y que el fila uno tiene los encabezados
			celda = fila.createCell((short)0);
			celda.setCellValue("Sucursal");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)1);
			celda.setCellValue("Número Promotor");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)2);
			celda.setCellValue("Nombre Promotor");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)3);
			celda.setCellValue("Número Socio Menor");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)4);
			celda.setCellValue("Nombre Socio Menor");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)5);
			celda.setCellValue("Dirección Socio Menor");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)6);
			celda.setCellValue("Edad");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)7);
			celda.setCellValue("Fecha de Nacimiento");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)8);
			celda.setCellValue("Número Socio Tutor");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)9);
			celda.setCellValue("Nombre Tutor");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)10);
			celda.setCellValue("No Cuenta Socio Menor");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)11);
			celda.setCellValue("Estatus de Cuenta");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)12);
			celda.setCellValue("Saldo");
			celda.setCellStyle(estiloNeg8);

			int i=8;
			for(RepoteClientesMenoresBean socioMenor : listaSociosMenores){
				fila=hoja.createRow(i);


				if(socioMenor.getClienteTutorID().equals("0")){
					socioMenor.setClienteTutorID("NA");
				}
				
				if(socioMenor.getCuentaAhoID().equals("0")){
					socioMenor.setCuentaAhoID("NA");
				}

				if(socioMenor.getEstatusCta().equals("")){
					socioMenor.setEstatusCta("NA");
				}else{
					if(socioMenor.getEstatusCta().equals("A")){
						socioMenor.setEstatusCta("ACTIVA");
					}else{
						if(socioMenor.getEstatusCta().equals("B")){
							socioMenor.setEstatusCta("BLOQUEADA");
						}else{
							if(socioMenor.getEstatusCta().equals("C")){
								socioMenor.setEstatusCta("CANCELADA");
							}else{
								if(socioMenor.getEstatusCta().equals("I")){
									socioMenor.setEstatusCta("INACTIVA");
								}else{
									if(socioMenor.getEstatusCta().equals("R")){
										socioMenor.setEstatusCta("REGISTRADA");
									}
								}
							}
						}
					}
				}



				celda=fila.createCell((short)0);
				celda.setCellValue(socioMenor.getNombreSucurs());

				celda=fila.createCell((short)1);
				celda.setCellValue(socioMenor.getPromotorActual());

				celda=fila.createCell((short)2);
				celda.setCellValue(socioMenor.getNombrePromotor());

				celda=fila.createCell((short)3);
				celda.setCellValue(socioMenor.getNoSocioMenor());

				celda=fila.createCell((short)4);
				celda.setCellValue(socioMenor.getNombreSocioMenor());

				celda=fila.createCell((short)5);
				celda.setCellValue(socioMenor.getDirecSocioMenor());

				celda=fila.createCell((short)6);
				celda.setCellValue(socioMenor.getEdad());

				celda=fila.createCell((short)7);
				celda.setCellValue(socioMenor.getFechaNacimiento());

				celda=fila.createCell((short)8);
				celda.setCellValue(socioMenor.getClienteTutorID());
				
				if(socioMenor.getClienteTutorID().equals("NA")){
					celda=fila.createCell((short)9);
					celda.setCellValue(socioMenor.getNombreTutorSocMe());
				}else{
					celda=fila.createCell((short)9);
					celda.setCellValue(socioMenor.getNombreTutor());
				}
				
				celda=fila.createCell((short)10);
				celda.setCellValue(socioMenor.getCuentaAhoID());

				celda=fila.createCell((short)11);
				celda.setCellValue(socioMenor.getEstatusCta());
				if(socioMenor.getCuentaAhoID().equals("NA")){
					celda=fila.createCell((short)12);
					celda.setCellValue("NA");
				}else{
					celda=fila.createCell((short)12);
					celda.setCellValue(Double.parseDouble(socioMenor.getSaldo()));
				}

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

			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteSociosMenores.xls");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();


		}catch(Exception e){
			e.printStackTrace();
			System.out.println("error en el reporte de Socio Menor Controlador ");
		}
		return listaSociosMenores;
	}

	public ReporteClienteMenoresServicio getReporteClienteMenoresServicio() {
		return reporteClienteMenoresServicio;
	}

	public void setReporteClienteMenoresServicio(
			ReporteClienteMenoresServicio reporteClienteMenoresServicio) {
		this.reporteClienteMenoresServicio = reporteClienteMenoresServicio;
	}

	public String getNomTipoReporte() {
		return nomTipoReporte;
	}

	public void setNomTipoReporte(String nomTipoReporte) {
		this.nomTipoReporte = nomTipoReporte;
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