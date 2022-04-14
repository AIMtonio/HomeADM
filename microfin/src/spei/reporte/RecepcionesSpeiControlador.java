package spei.reporte;

import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
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
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.RepoteClientesMenoresBean;
import cliente.reporte.PDFClientesMenoresControlador.Enum_Con_TipRepor;

import spei.bean.RepRecepcionesSpeiiBean;
import spei.servicio.RepRecepcionesSpeiiServicio;


public class RecepcionesSpeiControlador extends AbstractCommandController{
	
	RepRecepcionesSpeiiServicio repRecepcionesSpeiiServicio = null; 

	String nombreReporte = null;
	String successView = null;	
	String nomTipoReporte = "";
	

	public static interface Enum_Con_TipRepor {;
	int  ReporExcel= 2 ;
	}


	public RecepcionesSpeiControlador(){
		setCommandClass(RepRecepcionesSpeiiBean.class);
		setCommandName("repRecepcionesSpeiiBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		RepRecepcionesSpeiiBean repRecepcionesSpeiiBean = (RepRecepcionesSpeiiBean) command;

		int tipoReporte =(request.getParameter("tipoReporte")!=null)?
				Integer.parseInt(request.getParameter("tipoReporte")):0;
				String htmlString= "";
				

				switch(tipoReporte){
			
				case Enum_Con_TipRepor.ReporExcel:
					List<RepRecepcionesSpeiiBean>  listaReportes = RepExcel(repRecepcionesSpeiiBean,response,request);
					break;

				}
				return null;
	}
	

	private List <RepRecepcionesSpeiiBean> RepExcel(
			RepRecepcionesSpeiiBean repRecepcionesSpeiiBean,
			HttpServletResponse response, HttpServletRequest request) {
		// TODO Auto-generated method stub
		List  <RepRecepcionesSpeiiBean> ListaRep =null;
		String fechaVar=repRecepcionesSpeiiBean.getFechaEmision();

		ListaRep = repRecepcionesSpeiiServicio.ListaRep(repRecepcionesSpeiiBean,response);
		
		Calendar calendario = Calendar.getInstance();

		try {
			HSSFWorkbook libro = new HSSFWorkbook();
			//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
			HSSFFont fuenteNegrita10= libro.createFont();
			fuenteNegrita10.setFontHeightInPoints((short)10);
			fuenteNegrita10.setFontName("Arial");
			fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);						
			
			//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
			HSSFFont fuente10= libro.createFont();
			fuente10.setFontHeightInPoints((short)10);
			fuente10.setFontName("Arial");
			
			// La fuente se mete en un estilo para poder ser usada.
			//Estilo negrita de 10 para el titulo del reporte
			HSSFCellStyle estiloNeg10 = libro.createCellStyle();
			estiloNeg10.setFont(fuenteNegrita10);
			estiloNeg10.setAlignment(CellStyle.ALIGN_CENTER);			
			
			//Estilo negrita de 8  para encabezados del reporte												
			HSSFCellStyle estiloCentrado = libro.createCellStyle();
			estiloCentrado.setFont(fuenteNegrita10);
			estiloCentrado.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			estiloCentrado.setVerticalAlignment((short)HSSFCellStyle.VERTICAL_CENTER);
			
			//Estilo negrita de 8  para encabezados del reporte												
			HSSFCellStyle estiloCentradoNoNeg = libro.createCellStyle();
			estiloCentradoNoNeg.setFont(fuente10);
			estiloCentradoNoNeg.setAlignment((short)HSSFCellStyle.ALIGN_CENTER);
			
			//Estilo negrita de 8  para encabezados del reporte
			HSSFCellStyle estiloNeg8 = libro.createCellStyle();
			estiloNeg8.setFont(fuenteNegrita10);
			
			//Estilo Formato decimal (0.00)
			HSSFCellStyle estiloFormatoDecimal = libro.createCellStyle();
			HSSFDataFormat format = libro.createDataFormat();
			estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));

			// Creacion de hoja
			HSSFSheet hoja = libro.createSheet("Reporte Recepciones SPEI");
			HSSFRow fila= hoja.createRow(0);
			
			fila = hoja.createRow(1);
			HSSFCell celdaUsu=fila.createCell((short)0);
			celdaUsu=fila.createCell((short)0);
			celdaUsu.setCellStyle(estiloNeg10);
			celdaUsu.setCellValue(request.getParameter("institucion"));
			CellRangeAddress region = new CellRangeAddress(1,1,0,12);
			hoja.addMergedRegion(region);
		
			celdaUsu = fila.createCell((short)13);
			celdaUsu.setCellValue("Usuario:");
			celdaUsu.setCellStyle(estiloNeg8);	
			celdaUsu = fila.createCell((short)14);
			celdaUsu.setCellValue((!repRecepcionesSpeiiBean.getClaveUsuario().isEmpty())?repRecepcionesSpeiiBean.getClaveUsuario(): "TODOS");

			fila = hoja.createRow(2);
			HSSFCell celdaFec=fila.createCell((short)0);
			celdaFec = fila.createCell((short)0);
			celdaFec.setCellStyle(estiloNeg10);
			celdaFec.setCellValue("Reporte de Recepciones SPEI " + repRecepcionesSpeiiBean.getFechaInicio() + " al " + repRecepcionesSpeiiBean.getFechaFin());
			CellRangeAddress region2 = new CellRangeAddress(2,2,0,12);
			hoja.addMergedRegion(region2);
			
			celdaFec = fila.createCell((short)13);
			celdaFec.setCellValue("Fecha:");
			celdaFec.setCellStyle(estiloNeg8);	
			celdaFec = fila.createCell((short)14);
			celdaFec.setCellValue(fechaVar);
			
			fila = hoja.createRow(3);
			HSSFCell celdaHora=fila.createCell((short)0);
			celdaHora = fila.createCell((short)13);
			celdaHora.setCellValue("Hora:");
			celdaHora.setCellStyle(estiloNeg8);
			celdaHora = fila.createCell((short)14);
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
			celdaHora.setCellValue(horaVar);

			fila = hoja.createRow(4);

	
			HSSFCell celdaFiltros=fila.createCell((short)0);
			celdaFiltros=fila.createCell((short)0);
			celdaFiltros.setCellStyle(estiloNeg8);
			celdaFiltros.setCellValue("Monto Mínimo: "+repRecepcionesSpeiiBean.getMontoMin());
			
			celdaFiltros=fila.createCell((short)1);
			celdaFiltros.setCellStyle(estiloNeg8);
			celdaFiltros.setCellValue("Monto Máximo: "+repRecepcionesSpeiiBean.getMontoMax());
			
			fila = hoja.createRow(5);
			fila = hoja.createRow(6);
			HSSFCell celda=fila.createCell((short)0);
			//Inicio en la segunda fila y que el fila uno tiene los encabezados

			celda = fila.createCell((short)0);
			celda.setCellValue("Folio SPEI");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)1);
			celda.setCellValue("Clave Rastreo");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)2);
			celda.setCellValue("Tipo de Pago");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)3);
			celda.setCellValue("Nombre Ordenante");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)4);
			celda.setCellValue("Cuenta Ordenante");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)5);
			celda.setCellValue("Concepto Pago");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)6);
			celda.setCellValue("Monto Transferido");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)7);
			celda.setCellValue("IVA Comisión");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)8);
			celda.setCellValue("Institución Receptora");
			celda.setCellStyle(estiloNeg8);

			celda = fila.createCell((short)9);
			celda.setCellValue("Institución Remitente");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)10);
			celda.setCellValue("Cuenta Beneficiario");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)11);
			celda.setCellValue("Nombre Beneficiario");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)12);
			celda.setCellValue("Fecha Captura");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)13);
			celda.setCellValue("Estatus ");
			celda.setCellStyle(estiloNeg8);
			
			celda = fila.createCell((short)14);
			celda.setCellValue("Causa de Devolución");
			celda.setCellStyle(estiloNeg8);

			int i=7;
			int tamanioLista = ListaRep.size();
			for(RepRecepcionesSpeiiBean rep : ListaRep){
				fila=hoja.createRow(i);

				if(rep.getEstatus().equals("R")){
					rep.setEstatus("Registrada");
				}else{
					if(rep.getEstatus().equals("A")){
						rep.setEstatus("Abonada");
					}else{
						if(rep.getEstatus().equals("D")){
							rep.setEstatus("Devuelta");
						}
					}
				}
							
				celda=fila.createCell((short)0);
				celda.setCellValue(rep.getFolioSpeiRecID());

				celda=fila.createCell((short)1);
				celda.setCellValue(rep.getClaveRastreo());

				celda=fila.createCell((short)2);
				celda.setCellValue(rep.getTipoPagoID());

				celda=fila.createCell((short)3);
				celda.setCellValue(rep.getNombreOrd());

				celda=fila.createCell((short)4);
				celda.setCellValue(rep.getCuentaAho());

				celda=fila.createCell((short)5);
				celda.setCellValue(rep.getConceptoPago());
				
				celda=fila.createCell((short)6);
				celda.setCellValue(Utileria.convierteDoble(rep.getMontoTransferir()));
				celda.setCellStyle(estiloFormatoDecimal);
				
				celda=fila.createCell((short)7);
				celda.setCellValue(Utileria.convierteDoble(rep.getIVAComision()));
				celda.setCellStyle(estiloFormatoDecimal);

				celda=fila.createCell((short)8);
				celda.setCellValue(rep.getInstiReceptoraID());
				
				celda=fila.createCell((short)9);
				celda.setCellValue(rep.getInstiRemitenteID());
				
				celda=fila.createCell((short)10);
				celda.setCellValue(rep.getCuentaBeneficiario());
				
				celda=fila.createCell((short)11);
				celda.setCellValue(rep.getNombreBeneficiario());
				
				celda=fila.createCell((short)12);
				celda.setCellValue(rep.getFechaCaptura().substring(0, 10));
				celda.setCellStyle(estiloCentradoNoNeg);
				
				celda=fila.createCell((short)13);
				celda.setCellValue(rep.getEstatus());
				
				celda=fila.createCell((short)14);
				celda.setCellValue(rep.getCausaDevol());
				
				i++;
			}
			
			i = i+2;
			fila=hoja.createRow(i);
			celda = fila.createCell((short)0);
			celda.setCellValue("Registros Exportados:");
			celda.setCellStyle(estiloNeg8);
			celda=fila.createCell((short)1);
			celda.setCellValue(tamanioLista);
			
			celda = fila.createCell((short)13);
			celda.setCellValue("Procedure:");
			celda.setCellStyle(estiloNeg8);
			celda=fila.createCell((short)14);
			celda.setCellValue("SPEIRECEPCIONESSTPREP");

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
			hoja.autoSizeColumn((short)14);

			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=ReporteRecepcionesSPEI.xls");
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();


		}catch(Exception e){
			e.printStackTrace();
		}
		return ListaRep;
	}
	
	public RepRecepcionesSpeiiServicio getRepRecepcionesSpeiiServicio() {
		return repRecepcionesSpeiiServicio;
	}

	public void setRepRecepcionesSpeiiServicio(
			RepRecepcionesSpeiiServicio repRecepcionesSpeiiServicio) {
		this.repRecepcionesSpeiiServicio = repRecepcionesSpeiiServicio;
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

	public String getNomTipoReporte() {
		return nomTipoReporte;
	}

	public void setNomTipoReporte(String nomTipoReporte) {
		this.nomTipoReporte = nomTipoReporte;
	}



}
