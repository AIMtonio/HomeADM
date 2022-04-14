package credito.reporte;

import herramientas.Utileria;

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
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.bean.ReportePolizaBean;
import credito.bean.AvaladosCreditoRepBean;
import credito.servicio.AvaladosCreditoRepServicio;

public class PDFAvaladosCreditoRepControlador extends AbstractCommandController{
	AvaladosCreditoRepServicio avaladosCreditoRepServicio = null;
	String nombreReporte = null;
	String successView = null;

	String cadena_Vacia ="";
	String fecha_Vacia ="1900-01-01";

	public static interface Enum_Con_TipRepor {;
	int  ReporPDF= 1 ;
	int  ReporExcel= 2 ;
	}

	public PDFAvaladosCreditoRepControlador(){
		setCommandClass(AvaladosCreditoRepBean.class);
		setCommandName("avaladosCreditoRepBean");
	}


	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {	
		AvaladosCreditoRepBean avaladosCreditoRepBean =(AvaladosCreditoRepBean) command;
		// TODO Auto-generated method stub
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
				String htmlString= "";

				int tipoLista =(request.getParameter("tipoLista")!=null)?
						Integer.parseInt(request.getParameter("tipoLista")):
							0;


						switch(tipoReporte){
						case Enum_Con_TipRepor.ReporPDF:
							ByteArrayOutputStream htmlStringPDF = AvaladosCreditoPDF(avaladosCreditoRepBean,nombreReporte ,response);
							break;
						case Enum_Con_TipRepor.ReporExcel:
							List<AvaladosCreditoRepBean>  listaReportes = AvaladosCreditoExcel(tipoLista,avaladosCreditoRepBean,response,request);
							break;

						}
						return null;
	}


	private ByteArrayOutputStream AvaladosCreditoPDF(
			AvaladosCreditoRepBean avaladosCreditoRepBean, String nombreReporte2,
			HttpServletResponse response) {	ByteArrayOutputStream htmlStringPDF = null;
			try {
				htmlStringPDF = avaladosCreditoRepServicio.reporteAvaladosCreditoPDF(avaladosCreditoRepBean, nombreReporte);
				response.addHeader("Content-Disposition","inline; filename=AvaladosCredito.pdf");
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



	private List <AvaladosCreditoRepBean> AvaladosCreditoExcel(int tipoLista, AvaladosCreditoRepBean avaladosCreditoRepBean,
			HttpServletResponse response, HttpServletRequest request) {
		// TODO Auto-generated method stub
		List  <AvaladosCreditoRepBean> listaAvalesCredito =null;
		String fechaVar=avaladosCreditoRepBean.getFechaSistema();
		String etiquetaSocio = avaladosCreditoRepBean.getEtiquetaSocio();
		listaAvalesCredito = avaladosCreditoRepServicio.ListaAvalesCredito(tipoLista,avaladosCreditoRepBean,response); 

		try {
			HSSFWorkbook libro = new HSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);

			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			HSSFFont fuenteNegrita8= libro.createFont();
			fuenteNegrita8.setFontHeightInPoints((short)8);
			fuenteNegrita8.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita8.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);

			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			HSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);

			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);

			HSSFCellStyle estiloDatosCentrado = libro.createCellStyle();
			estiloDatosCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);  
			estiloDatosCentrado.setFont(fuenteNegrita10);
			estiloDatosCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);

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
			HSSFSheet hoja = libro.createSheet("Reporte Creditos Avalados");
			HSSFRow fila= hoja.createRow(0);
		  	// inicio fecha, usuario,institucion y hora
			HSSFCell celdaUsu=fila.createCell((short)1);
			celdaUsu = fila.createCell((short)5);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)6);
			celdaUsu.setCellValue((!avaladosCreditoRepBean.getNombreUsuario().isEmpty())?avaladosCreditoRepBean.getNombreUsuario(): "TODOS");

			fila = hoja.createRow(1);
			HSSFCell celdaFec=fila.createCell((short)1);
		  	celdaFec = fila.createCell((short)5);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)6);
			celdaFec.setCellValue(fechaVar);
			
			HSSFCell celdaInst=fila.createCell((short)1);
			celdaInst=fila.createCell((short)1);
			celdaInst.setCellValue(request.getParameter("nombreInstitucion"));
			 hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
			            1, //primera fila (0-based)
			            1, //ultima fila  (0-based)
			            1, //primer celda (0-based)
			            4  //ultima celda (0-based)
			    ));
			 celdaInst.setCellStyle(estiloDatosCentrado);

			Calendar calendario = new GregorianCalendar();
			fila = hoja.createRow(2);
			HSSFCell celdaHora=fila.createCell((short)1);
			celdaHora = fila.createCell((short)5);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);	
			celdaHora = fila.createCell((short)6);
			celdaHora.setCellValue(calendario.get(Calendar.HOUR_OF_DAY) + ":" + calendario.get(Calendar.MINUTE) + ":" + calendario.get(Calendar.SECOND));
			// fin fecha usuario,institucion y hora
			  
			HSSFCell celdaTit=fila.createCell((short)1);
			celdaTit = fila.createCell((short)1);
			celdaTit.setCellValue("Reporte de Avalados del "+avaladosCreditoRepBean.getFechaInicial()+" al "+avaladosCreditoRepBean.getFechaFinal());
			
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
		            2, //primera fila (0-based)
		            2, //ultima fila  (0-based)
		            1, //primer celda (0-based)
		            4  //ultima celda (0-based)
		    ));
			celdaTit.setCellStyle(estiloDatosCentrado);

			fila = hoja.createRow(3);
			fila = hoja.createRow(4);

			if(avaladosCreditoRepBean.getClienteInicial().equals("0")){
				avaladosCreditoRepBean.setClienteInicial(cadena_Vacia);
			}
			if(avaladosCreditoRepBean.getClienteFinal().equals("0")){
				avaladosCreditoRepBean.setClienteFinal(cadena_Vacia);
			}

			if(!avaladosCreditoRepBean.getClienteInicial().equals("")){
				if(avaladosCreditoRepBean.getClienteFinal().equals(cadena_Vacia)){
					avaladosCreditoRepBean.setNombreClienteFinal("NA");
				}
			}else{
				avaladosCreditoRepBean.getNombreClienteFinal();
			}

			if(avaladosCreditoRepBean.getPromotor().equals("0")){
				avaladosCreditoRepBean.setPromotor(cadena_Vacia);
			}
			if(avaladosCreditoRepBean.getDiasMora().equals("-1")){
				avaladosCreditoRepBean.setDiasMora("TODOS");
			}
			if(avaladosCreditoRepBean.getFechaInicial().equals(fecha_Vacia)){
				avaladosCreditoRepBean.setFechaInicial("TODOS");
			}
			if(avaladosCreditoRepBean.getFechaFinal().equals(fecha_Vacia)){
				avaladosCreditoRepBean.setFechaFinal("TODOS");
			}
			if(avaladosCreditoRepBean.getEstatus().equalsIgnoreCase("I")){
				avaladosCreditoRepBean.setEstatus("INACTIVO");
			}
			if(avaladosCreditoRepBean.getEstatus().equalsIgnoreCase("A")){
				avaladosCreditoRepBean.setEstatus("AUTORIZADO");

			}
			if(avaladosCreditoRepBean.getEstatus().equalsIgnoreCase("V")){
				avaladosCreditoRepBean.setEstatus("VIGENTE");
			}
			if(avaladosCreditoRepBean.getEstatus().equalsIgnoreCase("P")){
				avaladosCreditoRepBean.setEstatus("PAGADO");
			}
			if(avaladosCreditoRepBean.getEstatus().equalsIgnoreCase("C")){
				avaladosCreditoRepBean.setEstatus("CANCELADO");
			}
			if(avaladosCreditoRepBean.getEstatus().equalsIgnoreCase("B")){
				avaladosCreditoRepBean.setEstatus("VENCIDO");
			}
			if(avaladosCreditoRepBean.getEstatus().equalsIgnoreCase("K")){
				avaladosCreditoRepBean.setEstatus("CASTIGADO");
			}

			if(avaladosCreditoRepBean.getNombreProducto().equalsIgnoreCase("")){
				avaladosCreditoRepBean.setNombreProducto("TODOS");
			}


			HSSFCell celdaFiltros=fila.createCell((short)1);
			celdaFiltros=fila.createCell((short)0);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue(etiquetaSocio+" Inicio: "+avaladosCreditoRepBean.getClienteInicial()+" "+avaladosCreditoRepBean.getNombreClienteInicial());
			celdaFiltros=fila.createCell((short)1);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue(etiquetaSocio+" Final: "+avaladosCreditoRepBean.getClienteFinal()+" "+ avaladosCreditoRepBean.getNombreClienteFinal());
			
			celdaFiltros=fila.createCell((short)2);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("Días de Mora: "+avaladosCreditoRepBean.getDiasMora());

			celdaFiltros=fila.createCell((short)3);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("Promotor: "+avaladosCreditoRepBean.getPromotor()+" "+avaladosCreditoRepBean.getNombrePromotor());

			celdaFiltros=fila.createCell((short)4);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("Sucursal: "+avaladosCreditoRepBean.getNombreSucursal());

			celdaFiltros=fila.createCell((short)5);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("Estatus: "+avaladosCreditoRepBean.getEstatus());


			celdaFiltros=fila.createCell((short)6);
			celdaFiltros.setCellStyle(estiloNeg10);
			celdaFiltros.setCellValue("Producto de Crédito: "+avaladosCreditoRepBean.getNombreProducto());



			fila = hoja.createRow(5);
			fila = hoja.createRow(6);
			HSSFCell celda=fila.createCell((short)1);
			//Inicio en la segunda fila y que el fila uno tiene los encabezados
			celda = fila.createCell((short)0);
			celda.setCellValue("No. "+etiquetaSocio);
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)1);
			celda.setCellValue("Nombre "+etiquetaSocio);
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)2);
			celda.setCellValue("Crédito");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)3);
			celda.setCellValue("Monto Original Crédito");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)4);
			celda.setCellValue("Producto de Crédito");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)5);
			celda.setCellValue("Saldo Actual");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)6);
			celda.setCellValue("Monto Exigible");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)7);
			celda.setCellValue("Fecha Próximo Pago");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)8);
			celda.setCellValue("Días de Mora");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)9);
			celda.setCellValue("Número de Aval");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)10);
			celda.setCellValue("Nombre Aval");
			celda.setCellStyle(estiloNeg8);

			int i=8;
			for(AvaladosCreditoRepBean avalados : listaAvalesCredito){
				fila=hoja.createRow(i);

				String numeroAval ="";
				String nombreAval="";

				nombreAval=	avalados.getNombreAval();
				if(!avalados.getAvalID().equalsIgnoreCase("0") && avalados.getCliente().equalsIgnoreCase("0") && avalados.getProspectoID().equalsIgnoreCase("0") ||
						!avalados.getAvalID().equalsIgnoreCase("0") && avalados.getCliente().equalsIgnoreCase("0") && !avalados.getProspectoID().equalsIgnoreCase("0")){
					numeroAval =avalados.getAvalID();
				}else{
					if(avalados.getAvalID().equalsIgnoreCase("0") && !avalados.getCliente().equalsIgnoreCase("0") && 
							avalados.getProspectoID().equalsIgnoreCase("0") ||
							!avalados.getAvalID().equalsIgnoreCase("0") && !avalados.getCliente().equalsIgnoreCase("0") && 
							avalados.getProspectoID().equalsIgnoreCase("0")||
							!avalados.getAvalID().equalsIgnoreCase("0") && !avalados.getCliente().equalsIgnoreCase("0") && 
							!avalados.getProspectoID().equalsIgnoreCase("0") ||
							avalados.getAvalID().equalsIgnoreCase("0") && !avalados.getCliente().equalsIgnoreCase("0") && 
							!avalados.getProspectoID().equalsIgnoreCase("0")){

						numeroAval =avalados.getCliente();

					}else{
						if(avalados.getAvalID().equalsIgnoreCase("0") && avalados.getCliente().equalsIgnoreCase("0") && 
								!avalados.getProspectoID().equalsIgnoreCase("0")){
							numeroAval =avalados.getProspectoID();
						}else{
							numeroAval="NA";
							nombreAval = "NA";
						}
					}
				}

				if(avaladosCreditoRepBean.getEstatus().equalsIgnoreCase("INACTIVO")){
					avalados.setFechaExigible("NA");
					avalados.setDiasMora("NA");
				}else{
					if(avaladosCreditoRepBean.getEstatus().equalsIgnoreCase("AUTORIZADO")){
						avalados.setFechaExigible("NA");
						avalados.setDiasMora("NA");
					}else{
						if(avaladosCreditoRepBean.getEstatus().equalsIgnoreCase("PAGADO")){
							avalados.setFechaExigible("NA");
						}else{
							if(!avalados.getDiasMora().equalsIgnoreCase("0")){
								avalados.setFechaExigible("INMEDIATO");
							}
						}
					}
				}



				celda=fila.createCell((short)0);
				celda.setCellValue(Utileria.completaCerosIzquierda(avalados.getClienteID(),10));

				celda=fila.createCell((short)1);
				celda.setCellValue(avalados.getNombreCliente());

				celda=fila.createCell((short)2);
				celda.setCellValue(avalados.getCreditoID());

				celda=fila.createCell((short)3);
				celda.setCellValue(Double.parseDouble(avalados.getMontoCredito()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)4);
				celda.setCellValue(avalados.getNombreProducto());

				celda=fila.createCell((short)5);
				celda.setCellValue(Double.parseDouble(avalados.getSaldoActual()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)6);
				celda.setCellValue(Double.parseDouble(avalados.getSaldoExigible()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)7);
				celda.setCellValue(avalados.getFechaExigible());

				celda=fila.createCell((short)8);
				celda.setCellValue(avalados.getDiasMora());

				celda=fila.createCell((short)9);
				celda.setCellValue(numeroAval);

				celda=fila.createCell((short)10);
				celda.setCellValue(nombreAval);

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

			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteAvaladosCreditos.xls");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();


		}catch(Exception e){
			e.printStackTrace();
			System.out.println("error en el reporte de Avalados Controlador ");
		}
		return listaAvalesCredito;
	}


	public AvaladosCreditoRepServicio getAvaladosCreditoRepServicio() {
		return avaladosCreditoRepServicio;
	}

	public void setAvaladosCreditoRepServicio(
			AvaladosCreditoRepServicio avaladosCreditoRepServicio) {
		this.avaladosCreditoRepServicio = avaladosCreditoRepServicio;
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
