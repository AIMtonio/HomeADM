package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import soporte.bean.RelacionadosFiscalesBean;
import soporte.dao.RelacionadosFiscalesDAO;

public class RelacionadosFiscalesServicio extends BaseServicio {
	RelacionadosFiscalesDAO relacionadosFiscalesDAO = null;
	TransaccionDAO transaccionDAO = null;
	protected TransactionTemplate transactionTemplate;
	
	public static interface Enum_Transancciones {
		int graba	 = 1;
	}

	public interface Enum_Listas_Grid{
		int relaFisGrid = 1;			// lista de relacionados fiscales por cliente
	}
	
	public interface Enum_Consulta{
		int participacion = 1;
	}
	
	public RelacionadosFiscalesServicio(){
		super();
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, RelacionadosFiscalesBean relacionadosFiscalesBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Transancciones.graba:				
				mensaje = altaBajaRelacionadosFiscales(relacionadosFiscalesBean);		
				break;
		}
		return mensaje;
	}
	

	public MensajeTransaccionBean altaBajaRelacionadosFiscales(final RelacionadosFiscalesBean relacionadosFiscalesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean)transactionTemplate.execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();	
				//Lista de relacionados
				ArrayList listaBean = (ArrayList) listaGridRelacionados(relacionadosFiscalesBean);
				
				try {
					if(listaBean == null 
						||	listaBean.size() <= 0){
						throw new Exception("Error al generar la lista de personas relacionadas");
					}
					
					int tipoBaja = 1;
					// Baja personas relacionadas del cliente					
					mensajeBean = relacionadosFiscalesDAO.bajaRelacionadosFiscalCte(relacionadosFiscalesBean, tipoBaja);
					if(mensajeBean.getNumero()!= 0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					
					RelacionadosFiscalesBean bean;
					if(listaBean.size() > 0){
						for(int i=0; i<listaBean.size(); i++){	
							/* obtenemos un bean de la lista */
							bean = new RelacionadosFiscalesBean();
							bean = (RelacionadosFiscalesBean)listaBean.get(i);
							
							//Alta de relacionado
							mensajeBean = relacionadosFiscalesDAO.altaRelacionadoFiscal(bean);
							if(mensajeBean.getNumero()!= 0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}	
					}else{
						mensajeBean.setDescripcion("Lista de relacionados vacia");
						throw new Exception(mensajeBean.getDescripcion());
					}				
											
					if(mensajeBean.getNumero() == 0){
						mensajeBean.setDescripcion("Persona Relacionada Grabada Exitosamente: "+relacionadosFiscalesBean.getClienteID());
						mensajeBean.setConsecutivoString(relacionadosFiscalesBean.getClienteID());
						mensajeBean.setNombreControl("clienteID");
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Proceso de Grabar la Personas Relacionadas " + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	

	public List listaGridRelacionados(RelacionadosFiscalesBean relacionadosFiscalesBean){
		
		List<String> tipoRelacionadoLis = relacionadosFiscalesBean.getLisTipoRelacionado();
		List<String> cteRelacionadoIDLis = relacionadosFiscalesBean.getLisCteRelacionadoID();

		List<String> participacionFiscalLis = relacionadosFiscalesBean.getLisParticipacionFiscal();
		List<String> tipoPersonaLis = relacionadosFiscalesBean.getLisTipoPersona();
		List<String> primerNombreLis = relacionadosFiscalesBean.getLisPrimerNombre();
		List<String> segundoNombreLis = relacionadosFiscalesBean.getLisSegundoNombre();
		List<String> tercerNombreLis = relacionadosFiscalesBean.getLisTercerNombre();

		List<String> apellidoPaternoLis = relacionadosFiscalesBean.getLisApellidoPaterno();
		List<String> apellidoMaternoLis = relacionadosFiscalesBean.getLisApellidoMaterno();
		List<String> registroHaciendaLis = relacionadosFiscalesBean.getLisRegistroHacienda();
		List<String> nacionLis = relacionadosFiscalesBean.getLisNacion();
		List<String> paisResidenciaLis = relacionadosFiscalesBean.getLisPaisResidencia();

		List<String> rFCLis = relacionadosFiscalesBean.getLisRFC();
		List<String> cURPLis = relacionadosFiscalesBean.getLisCURP();
		List<String> estadoIDLis = relacionadosFiscalesBean.getLisEstadoID();
		List<String> municipioIDLis = relacionadosFiscalesBean.getLisMunicipioID();
		List<String> localidadIDLis = relacionadosFiscalesBean.getLisLocalidadID();

		List<String> coloniaIDLis = relacionadosFiscalesBean.getLisColoniaID();
		List<String> calleLis = relacionadosFiscalesBean.getLisCalle();
		List<String> numeroCasaLis = relacionadosFiscalesBean.getLisNumeroCasa();
		List<String> numInteriorLis = relacionadosFiscalesBean.getLisNumInterior();
		List<String> pisoLis = relacionadosFiscalesBean.getLisPiso();

		List<String> cPLis = relacionadosFiscalesBean.getLisCP();
		List<String> loteLis = relacionadosFiscalesBean.getLisLote();
		List<String> manzanaLis = relacionadosFiscalesBean.getLisManzana();
		List<String> direccionCompletaLis = relacionadosFiscalesBean.getLisDireccionCompleta();
		
		ArrayList<RelacionadosFiscalesBean> listaDetalle = new ArrayList();
		RelacionadosFiscalesBean bean = null;

		if(cteRelacionadoIDLis != null){
			try{
				int tamanio = cteRelacionadoIDLis.size();
				int aux = 0;

				for(int i = 0; i < tamanio; i++){
					bean = new RelacionadosFiscalesBean();

					bean.setClienteID(relacionadosFiscalesBean.getClienteID());
					bean.setParticipaFiscalCte(relacionadosFiscalesBean.getParticipaFiscalCte());
					bean.setEjercicio(relacionadosFiscalesBean.getEjercicio());
					bean.setCteRelacionadoID(cteRelacionadoIDLis.get(i)); 
					
					if((cteRelacionadoIDLis.get(i)).equals("0") || (cteRelacionadoIDLis.get(i)).equals("")){
						bean.setTipoRelacionado("R"); 
						bean.setParticipacionFiscal(participacionFiscalLis.get(i)); 
						bean.setTipoPersona(tipoPersonaLis.get(i)); 
						bean.setPrimerNombre(primerNombreLis.get(i)); 
						bean.setSegundoNombre(segundoNombreLis.get(i)); 
						bean.setTercerNombre(tercerNombreLis.get(i)); 
						bean.setApellidoPaterno(apellidoPaternoLis.get(i)); 
						bean.setApellidoMaterno(apellidoMaternoLis.get(i)); 
						bean.setRegistroHacienda(registroHaciendaLis.get(i)); 
						bean.setNacion(nacionLis.get(i)); 
						bean.setPaisResidencia(paisResidenciaLis.get(i)); 
						bean.setRFC(rFCLis.get(i)); 
						bean.setCURP(cURPLis.get(i)); 
						bean.setEstadoID(estadoIDLis.get(i)); 
						bean.setMunicipioID(municipioIDLis.get(i)); 
						bean.setLocalidadID(localidadIDLis.get(i)); 
						bean.setColoniaID(coloniaIDLis.get(i)); 
						bean.setCalle(calleLis.get(i)); 
						bean.setNumeroCasa(numeroCasaLis.get(i)); 
						bean.setNumInterior(numInteriorLis.get(i)); 
						bean.setPiso(pisoLis.get(i)); 
						bean.setCP(cPLis.get(i)); 
						bean.setLote(loteLis.get(i)); 
						bean.setManzana(manzanaLis.get(i)); 
						bean.setDireccionCompleta(direccionCompletaLis.get(i)); 						
					}else{
						bean.setTipoRelacionado("C"); 
						bean.setParticipacionFiscal(participacionFiscalLis.get(i)); 
						bean.setTipoPersona(Constantes.STRING_VACIO); 
						bean.setPrimerNombre(Constantes.STRING_VACIO); 
						bean.setSegundoNombre(Constantes.STRING_VACIO); 
						bean.setTercerNombre(Constantes.STRING_VACIO); 
						bean.setApellidoPaterno(Constantes.STRING_VACIO); 
						bean.setApellidoMaterno(Constantes.STRING_VACIO); 
						bean.setRegistroHacienda(Constantes.STRING_VACIO); 
						bean.setNacion(Constantes.STRING_VACIO); 
						bean.setPaisResidencia(Constantes.STRING_CERO); 
						bean.setRFC(Constantes.STRING_CERO); 
						bean.setCURP(Constantes.STRING_CERO); 
						bean.setEstadoID(Constantes.STRING_CERO); 
						bean.setMunicipioID(Constantes.STRING_CERO); 
						bean.setLocalidadID(Constantes.STRING_CERO); 
						bean.setColoniaID(Constantes.STRING_CERO); 
						bean.setCalle(Constantes.STRING_CERO); 
						bean.setNumeroCasa(Constantes.STRING_CERO); 
						bean.setNumInterior(Constantes.STRING_CERO); 
						bean.setPiso(Constantes.STRING_CERO); 
						bean.setCP(Constantes.STRING_CERO); 
						bean.setLote(Constantes.STRING_CERO); 
						bean.setManzana(Constantes.STRING_CERO); 
						bean.setDireccionCompleta(Constantes.STRING_VACIO);												
					}

					listaDetalle.add(aux, bean);
					aux++;
				}
			}catch(Exception e){
				listaDetalle = null;
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de grid de personas relacionadas fiscales", e);	
			}
		}

		return listaDetalle;
	}	
	
	// Lista comprobantes de gasto
	public List listaRelacionadosFiscalsGrid(int tipoLista,RelacionadosFiscalesBean bean){		
		List listaBean = null;
		switch (tipoLista) {
			case Enum_Listas_Grid.relaFisGrid:		
				listaBean = relacionadosFiscalesDAO.listaRelacionadosFiscalsGrid(tipoLista,bean);				
			break;
		}		
		return listaBean;
	}
	
	public RelacionadosFiscalesBean consulta(int tipoConsulta, RelacionadosFiscalesBean beanCon){
		RelacionadosFiscalesBean bean = null;
		switch (tipoConsulta) {
			case Enum_Consulta.participacion:
				bean = relacionadosFiscalesDAO.conParticipacionCte(tipoConsulta, beanCon);
				break;
		}

		return bean;
	}
	
	// REPORTE RELACIONADOS FISCALES RETENCION EN EXCEL
	public List listaReporteRelFiscalRetExcel(int tipoLista,RelacionadosFiscalesBean relacionadosFiscalesBean,  HttpServletResponse response){
		List <RelacionadosFiscalesBean>listaBean = null;
		listaBean = relacionadosFiscalesDAO.repRelFiscalRet(relacionadosFiscalesBean);
				
		if(listaBean != null){
			try {
				Workbook libro = new SXSSFWorkbook();
				// Se crea una Fuente Negrita 	con tamaño 10 para el titulo del reporte
				Font fuenteNegrita10= libro.createFont();
				fuenteNegrita10.setFontHeightInPoints((short)10);
				fuenteNegrita10.setFontName("Arial");
				fuenteNegrita10.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				// Crea un Fuente Negrita con tamaño 8 para informacion del reporte.
				Font fuenteNegrita8= libro.createFont();
				fuenteNegrita8.setFontHeightInPoints((short)8);
				fuenteNegrita8.setFontName("Arial");
				fuenteNegrita8.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				Font fuenteNeg8= libro.createFont();
				fuenteNeg8.setFontHeightInPoints((short)8);
				fuenteNeg8.setFontName("Arial");
				fuenteNeg8.setBoldweight(Font.BOLDWEIGHT_BOLD);
				
				// Estilo negrita de 10 para encabezados del reporte
				XSSFCellStyle estiloNeg10 = (XSSFCellStyle) libro.createCellStyle();
				estiloNeg10.setFont(fuenteNegrita10);
				
				// Estilo de datos centrado en la información del reporte
				XSSFCellStyle estiloDatosCentrado = (XSSFCellStyle) libro.createCellStyle();
				estiloDatosCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER); 
				
				// Estrilo centrado fuente negrita 10
				XSSFCellStyle estiloCentrado10 = (XSSFCellStyle) libro.createCellStyle();			
				estiloCentrado10.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloCentrado10.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloCentrado10.setFont(fuenteNegrita10);
				
				// Estilo centrado fuente negrita 8
				XSSFCellStyle estiloCentrado = (XSSFCellStyle) libro.createCellStyle();
				estiloCentrado.setFont(fuenteNegrita8);
				estiloCentrado.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloCentrado.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloCentrado.setWrapText(true);
				
				// Estilo centrado fuente  8
				XSSFCellStyle estiloCentra = (XSSFCellStyle) libro.createCellStyle();
				estiloCentra.setAlignment((short)XSSFCellStyle.ALIGN_CENTER);
				estiloCentra.setVerticalAlignment((short)XSSFCellStyle.VERTICAL_CENTER);
				estiloCentra.setWrapText(true);
				
				// Estilo negrita de 8 para encabezados del reporte
				XSSFCellStyle estiloNeg8 = (XSSFCellStyle) libro.createCellStyle();
				estiloNeg8.setFont(fuenteNegrita8);
				
				XSSFCellStyle estiloNegro8 = (XSSFCellStyle) libro.createCellStyle();
				estiloNegro8.setFont(fuenteNeg8);
				
				// Estilo negrita de 8  y color de fondo
				XSSFCellStyle estiloColor = (XSSFCellStyle) libro.createCellStyle();
				estiloColor.setFont(fuenteNegrita8);
				estiloColor.setFillForegroundColor(IndexedColors.CORNFLOWER_BLUE.index);
				estiloColor.setFillPattern(XSSFCellStyle.SOLID_FOREGROUND);

				// Estilo Formato decimal (0.00)
				XSSFCellStyle estiloFormatoDecimal = (XSSFCellStyle) libro.createCellStyle();
				DataFormat format = libro.createDataFormat();
				estiloFormatoDecimal.setDataFormat(format.getFormat("$ #,##0.00"));
				
				// Estilo Formato porcentaje (0.00)
				XSSFCellStyle estiloFormatoDecimalPorcentaje = (XSSFCellStyle) libro.createCellStyle();
				DataFormat formatP = libro.createDataFormat();
				estiloFormatoDecimalPorcentaje.setDataFormat(formatP.getFormat("0.00%"));

				//NUEVA HOJA DE EXCEL
				SXSSFSheet hoja = (SXSSFSheet) libro.createSheet("Reporte Relacionados Fiscales");
				
				//PRIMER FILA
				Row fila = hoja.createRow(0);

				// Nombre Institucion	
				Cell celdaInst=fila.createCell((short)1);
				celdaInst.setCellValue(relacionadosFiscalesBean.getNombreInstitucion());
				celdaInst.setCellStyle(estiloCentrado10);				
				hoja.addMergedRegion(new CellRangeAddress(
		            0, //primera fila 
		            0, //ultima fila 
		            1, //primer celda
		            8 //ultima celda
			    ));	
				
				// Nombre Usuario
				Cell celdaUsu=fila.createCell((short)9);
				celdaUsu.setCellValue("Usuario:");
				celdaUsu.setCellStyle(estiloNegro8);	
				celdaUsu = fila.createCell((short)10);				
				celdaUsu.setCellValue(relacionadosFiscalesBean.getClaveUsuario());				
					
				// SEGUNDA FILA
				fila = hoja.createRow(1);		
				
				// Titulo del Reporte
				Cell celda=fila.createCell((short)1);
				celda.setCellValue("REPORTE DE FISCALES RELACIONADOS");
				celda.setCellStyle(estiloCentrado10);					
				hoja.addMergedRegion(new CellRangeAddress(
		            1, //primera fila 
		            1, //ultima fila 
		            1, //primer celda
		            8 //ultima celda
			    ));	
				
				// Fecha en que se genera el reporte
				Cell celdaFec=fila.createCell((short)9);
				celdaFec.setCellValue("Fecha:");
				celdaFec.setCellStyle(estiloNegro8);	
				celdaFec = fila.createCell((short)10);
				celdaFec.setCellValue(relacionadosFiscalesBean.getFechaSistema());	
				
				// TERCER FILA
				fila = hoja.createRow(2);
								
				// Hora en que se genera el reporte
				Cell celdaHora=fila.createCell((short)9);
				celdaHora.setCellValue("Hora:");
				celdaHora.setCellStyle(estiloNegro8);	
				celdaHora = fila.createCell((short)10);
				
				String horaVar="";
				Calendar calendario = Calendar.getInstance();	 
				int hora = calendario.get(Calendar.HOUR_OF_DAY);
				int minutos = calendario.get(Calendar.MINUTE);
				int segundos = calendario.get(Calendar.SECOND);
				
				String h = "";
				String m = "";
				String s = "";
				if(hora<10)h="0"+Integer.toString(hora); else h=Integer.toString(hora);
				if(minutos<10)m="0"+Integer.toString(minutos); else m=Integer.toString(minutos);
				if(segundos<10)s="0"+Integer.toString(segundos); else s=Integer.toString(segundos);				 
				horaVar= h+":"+m+":"+s;
				
				celdaHora.setCellValue(horaVar);					
				
				// CUARTA FILA SEPARADOR
				fila = hoja.createRow(3);						
				
				// QUINTA FILA
				fila = hoja.createRow(4);

				celda = fila.createCell((short)1);
				celda.setCellValue("Ejercicio:");										
				celda.setCellStyle(estiloNegro8);	
				celda = fila.createCell((short)2);
				celda.setCellValue(relacionadosFiscalesBean.getEjercicio());
				celda.setCellStyle(estiloCentra);
				
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Aportante:");										
				celda.setCellStyle(estiloNegro8);	
				celda = fila.createCell((short)5);
				celda.setCellValue(relacionadosFiscalesBean.getClienteID()+"-"+relacionadosFiscalesBean.getNombreCompletoCte());
				
				// SEXTA FILA SEPARADOR
				fila = hoja.createRow(5);
				
				// SEPTIMA FILA
				fila = hoja.createRow(6);

				celda = fila.createCell((short)0);
				celda.setCellValue("Tipo");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)1);
				celda.setCellValue("Número");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)2);
				celda.setCellValue("Nombre");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)3);
				celda.setCellValue("Tipo Persona");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)4);
				celda.setCellValue("Nacionalidad");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)5);
				celda.setCellValue("País Residencia");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)6);
				celda.setCellValue("Registro Hacienda");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)7);
				celda.setCellValue("RFC");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)8);
				celda.setCellValue("CURP");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)9);
				celda.setCellValue("Domicilio Fiscal");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)10);
				celda.setCellValue("Participación Fiscal");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)11);
				celda.setCellValue("Capital");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)12);
				celda.setCellValue("Interés Real Periodo");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)13);
				celda.setCellValue("Interés Nominal Periodo");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)14);
				celda.setCellValue("ISR Retenido");
				celda.setCellStyle(estiloCentrado);
				
				celda = fila.createCell((short)15);
				celda.setCellValue("Pérdida Real");
				celda.setCellStyle(estiloCentrado);
								
				int i=7, iter=0;
				int tamanioLista = listaBean.size();
				RelacionadosFiscalesBean beanLis = null;
				
				for(iter=0; iter<tamanioLista; iter ++){
					beanLis = (RelacionadosFiscalesBean) listaBean.get(iter);
					
					fila = hoja.createRow(i);
					
					celda = fila.createCell((short)0);
					celda.setCellValue(beanLis.getTipo());
					celda.setCellStyle(estiloNeg8);
					
					celda = fila.createCell((short)1);
					celda.setCellValue(beanLis.getClienteID());
					
					celda = fila.createCell((short)2);
					celda.setCellValue(beanLis.getNombreCompletoCte());
					
					celda = fila.createCell((short)3);
					celda.setCellValue(beanLis.getTipoPersona());
					
					celda = fila.createCell((short)4);
					celda.setCellValue(beanLis.getNacion());
					
					celda = fila.createCell((short)5);
					celda.setCellValue(beanLis.getPaisResidencia());
					
					celda = fila.createCell((short)6);
					celda.setCellValue(beanLis.getRegistroHacienda());
					
					celda = fila.createCell((short)7);
					celda.setCellValue(beanLis.getRFC());
					
					celda = fila.createCell((short)8);
					celda.setCellValue(beanLis.getCURP());

					celda = fila.createCell((short)9);
					celda.setCellValue(beanLis.getDireccionCompleta());

					celda = fila.createCell((short)10);
					celda.setCellValue(Utileria.convierteDoble(beanLis.getParticipacionFiscal())/100);
					celda.setCellStyle(estiloFormatoDecimalPorcentaje);
					
					celda = fila.createCell((short)11);
					celda.setCellValue(Utileria.convierteDoble(beanLis.getCapital()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)12);
					celda.setCellValue(Utileria.convierteDoble(beanLis.getInteresRealPeriodo()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)13);
					celda.setCellValue(Utileria.convierteDoble(beanLis.getInteresNominalPeriodo()));
					celda.setCellStyle(estiloFormatoDecimal);

					celda = fila.createCell((short)14);
					celda.setCellValue(Utileria.convierteDoble(beanLis.getISRRetenido()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					celda = fila.createCell((short)15);
					celda.setCellValue(Utileria.convierteDoble(beanLis.getPerdidaReal()));
					celda.setCellStyle(estiloFormatoDecimal);
					
					i++;
				}	
				i = i+2;
				fila=hoja.createRow(i);
				celda = fila.createCell((short)0);
				celda.setCellValue("Registros Exportados");
				celda.setCellStyle(estiloNegro8);
				celda=fila.createCell((short)1);
				celda.setCellValue(tamanioLista);			

				hoja.setColumnWidth(0, 10 * 256);
				hoja.setColumnWidth(1, 10 * 256);
				hoja.setColumnWidth(2, 30 * 256);
				hoja.setColumnWidth(3, 15 * 256);
				hoja.setColumnWidth(4, 10 * 256);
				hoja.setColumnWidth(5, 30 * 256);
				hoja.setColumnWidth(6, 10 * 256);
				hoja.setColumnWidth(7, 20 * 256);
				hoja.setColumnWidth(8, 20 * 256);
				hoja.setColumnWidth(9, 40 * 256);
				hoja.setColumnWidth(10, 15 * 256);
				hoja.setColumnWidth(11, 15 * 256);
				hoja.setColumnWidth(12, 15 * 256);
				hoja.setColumnWidth(13, 15 * 256);
				hoja.setColumnWidth(14, 15 * 256);
				hoja.setColumnWidth(15, 15 * 256);

				//Creo la cabecera
				response.addHeader("Content-Disposition","inline; filename=ReporteRelacionadosFiscales.xls");
				response.setContentType("application/vnd.ms-excel");
				
				ServletOutputStream outputStream = response.getOutputStream();
				libro.write(outputStream);
				outputStream.flush();
				outputStream.close();
				
				
			}catch(Exception e){
				
				e.printStackTrace();
			}//Fin del catch
		}
		return  listaBean;
	}
	
	public RelacionadosFiscalesDAO getRelacionadosFiscalesDAO() {
		return relacionadosFiscalesDAO;
	}

	public void setRelacionadosFiscalesDAO(
			RelacionadosFiscalesDAO relacionadosFiscalesDAO) {
		this.relacionadosFiscalesDAO = relacionadosFiscalesDAO;
	}

	public TransaccionDAO getTransaccionDAO() {
		return transaccionDAO;
	}

	public void setTransaccionDAO(TransaccionDAO transaccionDAO) {
		this.transaccionDAO = transaccionDAO;
	}

	public TransactionTemplate getTransactionTemplate() {
		return transactionTemplate;
	}

	public void setTransactionTemplate(TransactionTemplate transactionTemplate) {
		this.transactionTemplate = transactionTemplate;
	}
}
