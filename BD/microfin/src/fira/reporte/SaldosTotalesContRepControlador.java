package fira.reporte;

import herramientas.Utileria;

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
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;
import credito.bean.CreditosBean;
import fira.bean.AnaliticoContBean;
import fira.servicio.CreditosAgroServicio;
import fira.servicio.CreditosAgroServicio.Enum_Lis_CredRep;

public class SaldosTotalesContRepControlador extends AbstractCommandController {
	
	ParametrosSisServicio	parametrosSisServicio	= null;
	CreditosAgroServicio	creditosAgroServicio	= null;
	String					nomReporte				= null;
	String					successView				= null;
	
	public static interface Enum_Con_TipRepor {
		int	ReporPantalla	= 1;
		int	ReporPDF		= 2;
		int	ReporExcel		= 3;
	}
	
	public SaldosTotalesContRepControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		CreditosBean creditosBean = (CreditosBean) command;
		
		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		
		String htmlString = "";
		
		switch (tipoReporte) {
			case Enum_Con_TipRepor.ReporExcel :
				List<AnaliticoContBean> listaReportes = SaldosTotalesCreditoExcel(tipoLista, creditosBean, response);
				break;
		}
		return null;
	}
	
	// Reporte de saldos totales de credito en excel
	public List SaldosTotalesCreditoExcel(int tipoLista, CreditosBean creditosBean, HttpServletResponse response) {
		List<AnaliticoContBean> listaCreditos = null;
		listaCreditos = creditosAgroServicio.listaReportesCreditos(Enum_Lis_CredRep.anliticoCont, creditosBean, response);
		ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.tipoInstitFin, parametrosSisBean);
		
		String safilocaleCliente = "safilocale.cliente";
		safilocaleCliente = Utileria.generaLocale(safilocaleCliente, parametrosSisBean.getNombreCortoInst());
		
		if (listaCreditos != null) {
			try {
				SXSSFWorkbook libro = new SXSSFWorkbook(100);
				
				//Se crea una Fuente Negrita con tamaño 10 para el titulo del reporte
				Font fuenteNegrita10 = libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short) 10);
				fuenteNegrita10.setFontName("Arial");
				fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				//Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				Font fuenteNegrita8 = libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short) 8);
				fuenteNegrita8.setFontName("Arial");
				fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				Font fuente8Cuerpo = libro.createFont();
				fuente8Cuerpo.setFontHeightInPoints((short) 8);
				fuente8Cuerpo.setFontName(HSSFFont.FONT_ARIAL);
				
				// La fuente se mete en un estilo para poder ser usada.
				//Estilo negrita de 10 para el titulo del reporte
				CellStyle estiloNeg10 = libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				
				CellStyle estiloCentrado = libro.createCellStyle();
				estiloCentrado.setFont(fuenteNegrita8);
				estiloCentrado.setAlignment((short) CellStyle.ALIGN_CENTER);
				estiloCentrado.setVerticalAlignment((short) CellStyle.VERTICAL_CENTER);
				
				//Estilo negrita de 8  para encabezados del reporte
				CellStyle estiloNeg8 = libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita8);
				
				//Estilo negrita de 8  y color de fondo
				CellStyle estiloColor = libro.createCellStyle();
				estiloColor.setFont(fuenteNegrita8);
				estiloColor.setFillForegroundColor(IndexedColors.CORNFLOWER_BLUE.index);
				estiloColor.setFillPattern(CellStyle.SOLID_FOREGROUND);
				
				//Estilo Formato decimal (0.00)
				CellStyle estiloFormatoDecimal = libro.createCellStyle();
				DataFormat format = libro.createDataFormat();
				estiloFormatoDecimal.setDataFormat(format.getFormat("$#,##0.00"));
				
				// Creacion de hoja
				Sheet hoja = null;
				hoja = libro.createSheet("Reporte Analítico Cartera Contingente");
				
				Row fila = hoja.createRow(0);
				
				Cell celdaini = fila.createCell((short) 1);
				celdaini = fila.createCell((short) 38);
				celdaini.setCellValue("Usuario:");
				celdaini.setCellStyle(estiloNeg8);
				celdaini = fila.createCell((short) 39);
				celdaini.setCellValue((!creditosBean.getNombreUsuario().isEmpty()) ? creditosBean.getNombreUsuario() : "TODOS");
				
				fila = hoja.createRow(1);
				
				Cell celdafin = fila.createCell((short) 38);
				celdafin.setCellValue("Fecha:");
				celdafin.setCellStyle(estiloNeg8);
				celdafin = fila.createCell((short) 39);
				celdafin.setCellValue(creditosBean.getFechaSistema());
				
				Cell celdaInst = fila.createCell((short) 1);
				celdaInst = fila.createCell((short) 7);
				celdaInst.setCellValue(creditosBean.getNombreInstitucion());
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				1, //primera fila (0-based)
				1, //ultima fila  (0-based)
				7, //primer celda (0-based)
				10 //ultima celda   (0-based)
				));
				celdaInst.setCellStyle(estiloCentrado);
				
				fila = hoja.createRow(2);
				Cell celda = fila.createCell((short) 1);
				celda = fila.createCell((short) 38);
				celda.setCellValue("Hora:");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short) 39);
				celda.setCellValue(creditosBean.getHora());
				
				Cell celdaR = fila.createCell((short) 2);
				celdaR = fila.createCell((short) 7);
				celdaR.setCellValue("REPORTE ANALÍTICO CARTERA CONTINGENTE DEL " + creditosBean.getFechaInicio());
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				2, //primera fila (0-based)
				2, //ultima fila  (0-based)
				7, //primer celda (0-based)
				10 //ultima celda   (0-based)
				));
				celdaR.setCellStyle(estiloCentrado);
				
				fila = hoja.createRow(3); // Fila vacia
				fila = hoja.createRow(4);// Campos
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				4, //primera fila (0-based)
				4, //ultima fila  (0-based)
				0, //primer celda (0-based)
				28 //ultima celda   (0-based)
				));
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				4, //primera fila (0-based)
				4, //ultima fila  (0-based)
				29, //primer celda (0-based)
				39 //ultima celda   (0-based)
				));
				hoja.addMergedRegion(new CellRangeAddress(//funcion para unir celdas
				4, //primera fila (0-based)
				4, //ultima fila  (0-based)
				40, //primer celda (0-based)
				41//ultima celda   (0-based)
				));
				celda = fila.createCell((short) 0);
				celda.setCellValue("Contingente");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short) 29);
				celda.setCellValue("Activo");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell((short) 40);
				celda.setCellValue("Pasivo");
				celda.setCellStyle(estiloNeg8);
				
				// Creacion de fila
				fila = hoja.createRow(5);
				int numCelda = 0;
				//Inicio en la segunda fila y que el fila uno tiene los encabezados
				celda = fila.createCell(numCelda++);//0
				celda.setCellValue("Crédito Fondeo Origen");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Id Crédito Activo Origen");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("ID Crédito Contingente");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("ID Crédito Fondeador");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("ID Acreditado Fondeador");
				celda.setCellStyle(estiloNeg8);
				
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Número de " + safilocaleCliente);
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Nombre Acreditado");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("CreditoID de Créd. Sin Fondeo con Serv. de Garantía");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Nuevo CreditoID con Pago de Garantía con FIRA");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Fecha de Otorgamiento");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Monto de garantia afectado");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Fecha próximo vencimiento");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Monto próximo vencimiento");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Fecha último vencimiento");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Estatus");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Saldo Cap.Vigente");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Saldo Cap. Atrasado");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Saldo Interés Vigente");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Saldo Interés Atrasado");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Saldo Moratorios");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Capital Vencido");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Interés Vencido");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Saldo Comisión Falta Pago");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Saldo Otras Comisiones");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("IVA Interés Pagado");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("IVA interés vencido");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("IVA Moratorio Pagado");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("IVA Com. Falta Pago");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("IVA Otras Comisiones Pagado");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Sucursal");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Tipo de Garantía");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Clase de Crédito");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Rama");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Actividad");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Cadena");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Programa Especial");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Tipo Persona");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Concepto de inversión (principal)");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Unidades");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Tipo de unidades");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Tasa pasiva");
				celda.setCellStyle(estiloNeg8);
				celda = fila.createCell(numCelda++);
				celda.setCellValue("Núm. De Socios");
				celda.setCellStyle(estiloNeg8);
				

				
				/*Auto Ajusto las Comulmnas*/
				Utileria.autoAjustaColumnas(63, hoja);
				
				int i = 6, iter = 0;
				int tamanioLista = listaCreditos.size();
				AnaliticoContBean credito = null;
				for (iter = 0; iter < tamanioLista; iter++) {
					credito = (AnaliticoContBean) listaCreditos.get(iter);
					fila = hoja.createRow(i);
					numCelda = 0;
					
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getCreditoFondeoID());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getCreditoID());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getCreditoIDCont());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getAcreditadoIDFIRA());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getCreditoIDFIRA());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getClienteID());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getNombreCompleto());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getCreditoIDSinFon());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getCreditoIDPagoFira());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getFechaOtorgamiento());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getMontoGarAfec()));
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getFechaProxVenc());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getMontoProxVenc()));
					celda.setCellStyle(estiloFormatoDecimal);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getFechaUltVenc());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getEstatus());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSalCapVigente()));
					celda.setCellStyle(estiloFormatoDecimal);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSalCapAtrasado()));
					celda.setCellStyle(estiloFormatoDecimal);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSalIntProvision()));
					celda.setCellStyle(estiloFormatoDecimal);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSalIntVencido()));
					celda.setCellStyle(estiloFormatoDecimal);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoMoraCarVen()));
					celda.setCellStyle(estiloFormatoDecimal);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoCapVencido()));
					celda.setCellStyle(estiloFormatoDecimal);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSaldoInterVenc()));
					celda.setCellStyle(estiloFormatoDecimal);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSalComFaltaPago()));
					celda.setCellStyle(estiloFormatoDecimal);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getSalOtrasComisi()));
					celda.setCellStyle(estiloFormatoDecimal);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getIVAInteresPagado()));
					celda.setCellStyle(estiloFormatoDecimal);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getIVAInteresVenc()));
					celda.setCellStyle(estiloFormatoDecimal);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getIVAMoraPag()));
					celda.setCellStyle(estiloFormatoDecimal);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getIVAComFaltaPago()));
					celda.setCellStyle(estiloFormatoDecimal);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(Utileria.convierteDoble(credito.getIVAOtrasCom()));
					celda.setCellStyle(estiloFormatoDecimal);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getNombreSucurs());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getGarantiaDes());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getClasificacionCred());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getRamaFiraDes());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getActividadDes());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getCadenaProDes());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getProgEspecialDes());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getTipoPersona());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getConceptoInversion());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getUnidades());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getConceptoUnidades());
					celda.getCellStyle().setFont(fuente8Cuerpo);
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getTasaPasiva());
					celda = fila.createCell(numCelda++);
					celda.setCellValue(credito.getNumSocios());

					i++;
				}
				
				i = i + 1;
				fila = hoja.createRow(i);
				celda = fila.createCell((short) 0);
				celda.setCellValue("Registros Exportados");
				celda.setCellStyle(estiloNeg8);
				
				i = i + 1;
				fila = hoja.createRow(i);
				celda = fila.createCell((short) 0);
				celda.setCellValue(tamanioLista);
				
				//Creo la cabecera
				response.addHeader("Content-Disposition", "inline; filename=RepAnaliticoCarteraCont-" + creditosBean.getFechaInicio() + ".xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				hoja.getWorkbook().write(outputStream);
				outputStream.flush();
				outputStream.close();
			} catch (Exception e) {
				e.printStackTrace();
			}//Fin del catch
		}
		return listaCreditos;
	}
	
	public String getNomReporte() {
		return nomReporte;
	}
	
	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}
	
	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}
	
	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
	
	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public CreditosAgroServicio getCreditosAgroServicio() {
		return creditosAgroServicio;
	}

	public void setCreditosAgroServicio(CreditosAgroServicio creditosAgroServicio) {
		this.creditosAgroServicio = creditosAgroServicio;
	}
	
}