package credito.reporte;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import credito.bean.ReporteServiciosAdicionalesBean;
import credito.bean.RepVencimiBean;
import credito.servicio.CreditosServicio;
import general.bean.ParametrosSesionBean;
import herramientas.Utileria;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;

public class RepServiciosAdicionalesControlador extends AbstractCommandController {

	CreditosServicio		creditosServicio		= null;
	String					nomReporte				= null;
	String					successView				= null;
	ParametrosSisServicio	parametrosSisServicio	= null;
	ParametrosSesionBean	parametrosSesionBean	= null;

	public static interface Enum_Con_TipRepor {
		int ReporteExcel = 1;
	}

	public RepServiciosAdicionalesControlador() {
		setCommandClass(ReporteServiciosAdicionalesBean.class);
		setCommandName("ReporteServiciosAdicionalesBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		ReporteServiciosAdicionalesBean reporteServiciosAdicionalesBean = (ReporteServiciosAdicionalesBean) command;
		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));

		String htmlString = "";
		switch (tipoReporte) {
		case Enum_Con_TipRepor.ReporteExcel:
			List<CreditosBean> listaReportes = repServiciosAdicionalesExcel(tipoLista,reporteServiciosAdicionalesBean,response);
			break;
		}

		return null;

	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	// Reporte de saldos capital de credito en excel
	public List<CreditosBean> repServiciosAdicionalesExcel(int tipoLista, ReporteServiciosAdicionalesBean creditosBean, HttpServletResponse response) {
		List listaCreditos = null;
		try {

			// Se obtiene el tipo de institucion financiera
			ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
			parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.tipoInstitFin, parametrosSisBean);
			String safilocale = Utileria.generaLocale("safilocale.cliente", parametrosSisBean.getNombreCortoInst());
			int regExport = 0;
			listaCreditos = creditosServicio.listaReportesCreditosServiciosAdicionales(tipoLista,creditosBean,response);

			SXSSFWorkbook libro = new SXSSFWorkbook(100);

			// Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte

			// Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			Font fuenteNegrita14 = libro.createFont();
			fuenteNegrita14.setFontHeightInPoints((short) 14);
			fuenteNegrita14.setFontName("Arial");
			fuenteNegrita14.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			
			Font font10 = libro.createFont();
			font10.setFontHeightInPoints((short) 10);
			font10.setFontName("Arial");
			
			Font font10Der = libro.createFont();
			font10Der.setFontHeightInPoints((short) 10);
			font10Der.setFontName("Arial");
			
			Font fuente10Cen= libro.createFont();
			fuente10Cen.setFontHeightInPoints((short)10);
			fuente10Cen.setFontName(HSSFFont.FONT_ARIAL);
			
			// Estilo Formato decimal (0.00)
			Font fontDecimal10 = libro.createFont();
			fontDecimal10.setFontHeightInPoints((short) 10);
			fontDecimal10.setFontName("Arial");
				
			Font fontCentrado10 = libro.createFont();
			fontCentrado10.setFontHeightInPoints((short) 10);
			fontCentrado10.setFontName("Arial");
			
			// Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			Font fuenteDatos = libro.createFont();
			fuenteDatos.setFontHeightInPoints((short) 8);
			fuenteDatos.setFontName(HSSFFont.FONT_ARIAL);
			
			Font fuente8Izq = libro.createFont();
			fuente8Izq.setFontHeightInPoints((short) 8);
			fuente8Izq.setFontName(HSSFFont.FONT_ARIAL);
			
			Font fuente8Der = libro.createFont();
			fuente8Der.setFontHeightInPoints((short) 8);
			fuente8Der.setFontName(HSSFFont.FONT_ARIAL);
						
			Font fuenteNegrita8Centrado= libro.createFont();
			fuenteNegrita8Centrado.setFontHeightInPoints((short)8);
			fuenteNegrita8Centrado.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita8Centrado.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			Font fuenteNegrita8= libro.createFont();
			fuenteNegrita8Centrado.setFontHeightInPoints((short)8);
			fuenteNegrita8Centrado.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita8Centrado.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			Font fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			Font fuenteNegrita10C= libro.createFont();
			fuenteNegrita10C.setFontHeightInPoints((short)10);
			fuenteNegrita10C.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10C.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			Font fuenteNegrita10Centrado= libro.createFont();
			fuenteNegrita10Centrado.setFontHeightInPoints((short)10);
			fuenteNegrita10Centrado.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10Centrado.setBoldweight(Font.BOLDWEIGHT_BOLD);
			
			Font fuenteNegrita10Izq = libro.createFont();
			fuenteNegrita10Izq.setFontHeightInPoints((short) 10);
			fuenteNegrita10Izq.setFontName(HSSFFont.FONT_ARIAL);
			fuenteNegrita10Izq.setBoldweight(Font.BOLDWEIGHT_BOLD);
			// La fuente se mete en un estilo para poder ser usada.
			CellStyle estiloNeg14 = libro.createCellStyle();
			estiloNeg14.setFont(fuenteNegrita14);
			estiloNeg14.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			estiloNeg14.setVerticalAlignment((short) CellStyle.VERTICAL_CENTER);

			//Letra 8
			CellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita8);		
			estiloNeg8.setWrapText(true);
			
			CellStyle estiloCentrado8 = libro.createCellStyle();
			estiloCentrado8.setAlignment((short)CellStyle.ALIGN_CENTER);
			estiloCentrado8.setVerticalAlignment((short)CellStyle.VERTICAL_CENTER);
			estiloCentrado8.setFont(fuenteNegrita8Centrado);
			estiloCentrado8.setWrapText(true);
			
			// fuente tamaño 8
			CellStyle estilo8 = libro.createCellStyle();
			estilo8.setFont(fuenteDatos);
			estilo8.setAlignment(CellStyle.ALIGN_LEFT);
			estilo8.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
			estilo8.setWrapText(true);
			
			//Alineado a la izq
			CellStyle estilo8Izq = libro.createCellStyle();
			estilo8Izq.setFont(fuente8Izq);
			estilo8Izq.setAlignment(CellStyle.ALIGN_LEFT);
			
			//Alineado a la derecha
			CellStyle estilo8Der = libro.createCellStyle();
			estilo8Izq.setFont(fuente8Der);
			estilo8Izq.setAlignment(CellStyle.ALIGN_RIGHT);
			

			//Estilo Formato decimal (0.00)
			CellStyle estiloFormatoDecimalTit = libro.createCellStyle();
			DataFormat formatTit = libro.createDataFormat();
			estiloFormatoDecimalTit.setDataFormat(formatTit.getFormat("$#,###,##0.00"));
			estiloFormatoDecimalTit.setFont(fuenteDatos);
			
			// Fin tamaño 8 
			CellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);			

			CellStyle estilo10Der = libro.createCellStyle();
			estilo10Der.setFont(font10Der);
			estilo10Der.setAlignment(CellStyle.ALIGN_RIGHT);
			
			CellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setAlignment((short)CellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)CellStyle.VERTICAL_CENTER);
			estiloCentrado.setFont(fuenteNegrita10Centrado);
			estiloCentrado.setWrapText(true);
			
			CellStyle estiloNeg10Centrado = libro.createCellStyle();
			estiloNeg10Centrado.setFont(fuenteNegrita10C);	
			estiloNeg10Centrado.setAlignment((short)CellStyle.ALIGN_CENTER);
			estiloNeg10Centrado.setVerticalAlignment((short)CellStyle.VERTICAL_CENTER);
			
			CellStyle estilo10 = libro.createCellStyle();
			estilo10.setFont(font10);
			estilo10.setVerticalAlignment((short) CellStyle.VERTICAL_CENTER);
			
			//Estilo 10 centrado
			CellStyle estiloFormatoICentrado = libro.createCellStyle();
			estiloFormatoICentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
			estiloFormatoICentrado.setFont(fuente10Cen);			
			
			CellStyle estiloFormatoDecimal = libro.createCellStyle();
			DataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
			estiloFormatoDecimal.setFont(fontDecimal10);		
			
			//Alineado a la izq
			CellStyle estiloNeg10Izq = libro.createCellStyle();
			estiloNeg10Izq.setFont(fuenteNegrita10Izq);
			estiloNeg10Izq.setAlignment(CellStyle.ALIGN_LEFT);
			
			
			// Creacion de hoja
			Sheet hoja = null;
			hoja = libro.createSheet("ReporteServciosAdicionales");

			/** =========  NOMBRE INSTITUCION ===========**/
			
			Row fila = hoja.createRow(1);
			
			Cell celdaInstP = fila.createCell((short) 1);
			celdaInstP.setCellStyle(estiloNeg10Centrado);
			celdaInstP.setCellValue(parametrosSesionBean.getNombreCortoInst());
			hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
					1, //primera fila (0-based)
					1, //ultima fila  (0-based)
					1, //primer celda (0-based)
					12 //ultima celda   (0-based)
					));
			celdaInstP.setCellStyle(estiloNeg10Centrado);
			/** =========  NOMBRE INSTITUCION ===========**/

			Cell celdaini = fila.createCell((short) 13);
			celdaini.setCellValue("Usuario:");
			celdaini.setCellStyle(estiloNeg10);
			celdaini = fila.createCell((short) 14);
			celdaini.setCellValue(parametrosSesionBean.getClaveUsuario().toUpperCase());
			celdaini.setCellStyle(estilo10);
			String fechaVar = parametrosSesionBean.getFechaSucursal().toString();

			Calendar calendario = new GregorianCalendar();
			SimpleDateFormat postFormater = new SimpleDateFormat("HH:mm");

			fila = hoja.createRow(2);

			Cell celdafin = fila.createCell((short) 13);
			celdafin.setCellValue("Fecha:");
			celdafin.setCellStyle(estiloNeg10);
			celdafin = fila.createCell((short) 14);
			celdafin.setCellValue(fechaVar);
			celdafin.setCellStyle(estilo10);

			
			/** ============ NOMBRE REPORTE ================**/
			Cell celda2 = fila.createCell((short) 1);
			celda2.setCellValue("REPORTE DE SERVICIOS ADICIONALES");
			
			hoja.addMergedRegion(new CellRangeAddress(// funcion para unir celdas
					2, // primera fila (0-based)
					2, // ultima fila (0-based)
					1, // primer celda (0-based)
					12 // ultima celda (0-based)
			));
			celda2.setCellStyle(estiloNeg10Centrado);
			
			fila = hoja.createRow(3);			
			Cell celdaHora = fila.createCell((short) 13);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg10);

			String horaVar = "";

			int hora = calendario.get(Calendar.HOUR_OF_DAY);
			int minutos = calendario.get(Calendar.MINUTE);
			int segundos = calendario.get(Calendar.SECOND);

			String h = Integer.toString(hora);
			String m = "";
			String s = "";
			if (minutos < 10)
				m = "0" + Integer.toString(minutos);
			else
				m = Integer.toString(minutos);
			if (segundos < 10)
				s = "0" + Integer.toString(segundos);
			else
				s = Integer.toString(segundos);

			horaVar = h + ":" + m + ":" + s;

			celdaHora = fila.createCell((short) 14);
			celdaHora.setCellValue(horaVar);
			celdaHora.setCellStyle(estilo10);
			Cell celda = fila.createCell((short) 0);
			celda.setCellStyle(estiloNeg14);
			
			
			
			Cell celdaSucrsal = fila.createCell((short) 1);
			celdaSucrsal.setCellValue("Sucursal:");
			celdaSucrsal.setCellStyle(estiloNeg10);
			celdaSucrsal = fila.createCell((short) 2);
			celdaSucrsal.setCellValue((!creditosBean.getNombreSucursal().isEmpty())?creditosBean.getNombreSucursal():"TODAS");
			celdaSucrsal.setCellStyle(estilo10);
			
			Cell celdaProductoCredito = fila.createCell((short) 5);
			celdaProductoCredito.setCellValue("Producto Crédito:");
			celdaProductoCredito.setCellStyle(estiloNeg10);
			celdaProductoCredito = fila.createCell((short) 6);
			celdaProductoCredito.setCellValue((!creditosBean.getProductoCreDescri().isEmpty())?creditosBean.getProductoCreDescri():"TODOS");
			celdaProductoCredito.setCellStyle(estilo10);
			fila = hoja.createRow(4);
			
			Cell celdaInstitucionNomina = fila.createCell((short) 1);
			celdaInstitucionNomina.setCellValue("Institución Nómina:");
			celdaInstitucionNomina.setCellStyle(estiloNeg10);
			celdaInstitucionNomina  = fila.createCell((short) 2);
			celdaInstitucionNomina.setCellValue((!creditosBean.getNombreInstit().isEmpty())?creditosBean.getNombreInstit():"TODAS");
			celdaInstitucionNomina.setCellStyle(estilo10);
			Cell celdaConvenio = fila.createCell((short) 5);
			celdaConvenio.setCellValue("No. Convenio: ");
			celdaConvenio.setCellStyle(estiloNeg10);
			celdaConvenio  = fila.createCell((short) 6);
			celdaConvenio.setCellValue((!creditosBean.getDesConvenio().isEmpty())?creditosBean.getDesConvenio():"TODOS");;
			celdaConvenio.setCellStyle(estilo10);
			/****************************************************** FILTRO REPORTE ************************************************* */
			int col=1;
			int filaN=7;
			fila = hoja.createRow(filaN++);
			/*Nombre credito*/
			Cell cel= fila.createCell(col);
			cel.setCellValue("ID Crédito");
			cel.setCellStyle(estiloNeg10Izq);
			col++;
			cel= fila.createCell(col);
			cel.setCellValue("ID servicio");
			cel.setCellStyle(estiloNeg10Izq);
			col++;
			cel= fila.createCell(col);
			cel.setCellValue("Descripción Servicio");
			cel.setCellStyle(estiloNeg10Izq);
			col++;
			cel= fila.createCell(col);
			cel.setCellValue("Institución Nómina");
			cel.setCellStyle(estiloNeg10Izq);
			col++;
			cel= fila.createCell(col);
			cel.setCellValue("Convenio");
			cel.setCellStyle(estiloNeg10Izq);
			col++;
			cel= fila.createCell(col);
			cel.setCellValue("No. Cliente");
			cel.setCellStyle(estiloNeg10Izq);
			col++;
			cel= fila.createCell(col);
			cel.setCellValue("Nombre del Cliente");
			cel.setCellStyle(estiloNeg10Izq);
			col++;
			cel= fila.createCell(col);
			cel.setCellValue("Nombre del Producto");
			cel.setCellStyle(estiloNeg10Izq);
			col++;
			cel= fila.createCell(col);
			cel.setCellValue("Sucursal");
			cel.setCellStyle(estiloNeg10Izq);
			col++;
			cel= fila.createCell(col);
			cel.setCellValue("Género");
			cel.setCellStyle(estiloNeg10Izq);
			col++;
			cel= fila.createCell(col);
			cel.setCellValue("RFC");
			cel.setCellStyle(estiloNeg10Izq);
			col++;
			cel= fila.createCell(col);
			cel.setCellValue("Estado Civil");
			cel.setCellStyle(estiloNeg10Izq);
			col++;
			cel= fila.createCell(col);
			cel.setCellValue("Tipo de Persona");
			cel.setCellStyle(estiloNeg10Izq);
			col++;
			cel= fila.createCell(col);
			cel.setCellValue("Dirección Completa");
			cel.setCellStyle(estiloNeg10Izq);
			col++;
			cel= fila.createCell(col);
			cel.setCellValue("CuentaClabe");
			cel.setCellStyle(estiloNeg10Izq);
			col++;
			cel= fila.createCell(col);
			cel.setCellValue("Tarjeta");
			cel.setCellStyle(estiloNeg10Izq);
			
			
			int totalFilas;
			int i=filaN,iter;
			int tamanioLista = listaCreditos.size();
			totalFilas=listaCreditos.size();
			ReporteServiciosAdicionalesBean  credito = null;
			for( iter=0; iter<tamanioLista; iter ++){
				filaN++;//agregamos linea
				credito = (ReporteServiciosAdicionalesBean ) listaCreditos.get(iter);//Iteramos la lista
				fila=hoja.createRow(filaN);
				
				celda=fila.createCell((short)1);
				celda.setCellValue(credito.getCreditoID());
				celda.setCellStyle(estilo10);
				
				celda=fila.createCell((short)2);
				celda.setCellValue(credito.getServiciosId());
				celda.setCellStyle(estilo10);
				
				celda=fila.createCell((short)3);
				celda.setCellValue(credito.getDescripcionServicio());
				celda.setCellStyle(estilo10);
				
				celda=fila.createCell((short)4);
				celda.setCellValue(credito.getNombreInstit());
				celda.setCellStyle(estilo10);
				
				celda=fila.createCell((short)5);
				celda.setCellValue(credito.getDesConvenio());
				celda.setCellStyle(estilo10);
								
				celda=fila.createCell((short)6);
				celda.setCellValue(credito.getClienteID());
				celda.setCellStyle(estilo10);
				
				celda=fila.createCell((short)7);
				celda.setCellValue(credito.getNombreCompleto());
				celda.setCellStyle(estilo10);
				
				celda=fila.createCell((short)8);
				celda.setCellValue(credito.getProductoCreDescri());
				celda.setCellStyle(estilo10);
				
				celda=fila.createCell((short)9);
				celda.setCellValue(credito.getSucursalID());
				celda.setCellStyle(estilo10);
				
				
				celda=fila.createCell((short)10);
				celda.setCellValue(credito.getGenero());
				celda.setCellStyle(estiloFormatoICentrado);
				
				celda=fila.createCell((short)11);
				celda.setCellValue(credito.getRFC());
				celda.setCellStyle(estilo10);
				
				celda=fila.createCell((short)12);
				celda.setCellValue(credito.getEstadoCivil());
				celda.setCellStyle(estilo10);
							
				celda=fila.createCell((short)13);
				celda.setCellValue(credito.getTipoPersona());
				celda.setCellStyle(estiloFormatoICentrado);
				
				
				celda=fila.createCell((short)14);
				celda.setCellValue(credito.getDireccionCliente());
				celda.setCellStyle(estilo10);
				
				celda=fila.createCell((short)15);
				celda.setCellValue(credito.getCuentaCLABE());
				celda.setCellStyle(estilo10);
				
				celda=fila.createCell((short)16);
				celda.setCellValue(credito.getTarjeta());
				celda.setCellStyle(estilo10);
				
				
				
			}
			
			
			
			filaN=filaN+2;
			
			fila = hoja.createRow(filaN);
			Cell celdaF = fila.createCell((short) 1);
			celdaF.setCellValue("Registros Exportados:");
			celdaF.setCellStyle(estiloNeg10);
			filaN=filaN+1;
			fila = hoja.createRow(filaN);
			celdaF = fila.createCell((short) 1);
			celdaF.setCellValue(totalFilas);
			
			
			// Creo la cabecera
			response.addHeader("Content-Disposition", "inline; filename=ReporteServiciosAdicioanles.xls");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();

		} catch (Exception e) {
			e.printStackTrace();
		} // Fin del catch
		return listaCreditos;

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

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	

	

	

}

