package regulatorios.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import regulatorios.bean.RegulatorioD0842Bean;
import regulatorios.dao.RegulatorioD0842DAO;

public class RegulatorioD0842Servicio extends BaseServicio{	
	RegulatorioD0842DAO regulatorioD0842DAO=null;
 
	public RegulatorioD0842Servicio() {
		super();
	}
	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Lis_RegulatorioD0842 {
		int principal = 1;
		int registros = 2;
	}
	public static interface Enum_Alt_RegulatorioD0842 {
		int alta = 1;
		int altaSofipo 	= 2;
		int modSofipo	= 3;
		int elimina	= 4;
	}
	public static interface Enum_Baj_RegulatorioD0842 {
		int bajaPorPeriodo = 1;
	}
	
	public static interface Enum_Lis_ReportesD0842{
		int excel	 	 = 2;
		int csv 	 	 = 3;
		int excelSofipo	 = 4;
		int csvSofipo 	 = 5;
	}public static interface Enum_Con_RegulatorioD0842 {
		int principal = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	RegulatorioD0842Bean regulatorioD0842Bean ){
		ArrayList listaRegulatorioD0842 = (ArrayList) creaListaDetalle(regulatorioD0842Bean);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Alt_RegulatorioD0842.alta:		
				mensaje = regulatorioD0842DAO.grabaRegulatorioD0842(regulatorioD0842Bean,listaRegulatorioD0842, Enum_Baj_RegulatorioD0842.bajaPorPeriodo);									
				break;	
			case Enum_Alt_RegulatorioD0842.altaSofipo:		
				mensaje = regulatorioD0842DAO.grabaRegulatorioD0842003(regulatorioD0842Bean);									
				break;	
			case Enum_Alt_RegulatorioD0842.modSofipo:		
				mensaje = regulatorioD0842DAO.modRegulatorioD0842003(regulatorioD0842Bean);									
				break;	
			case Enum_Alt_RegulatorioD0842.elimina:		
				mensaje = regulatorioD0842DAO.eliminaRegulatorioD0842003(regulatorioD0842Bean);									
				break;	
		}
		return mensaje;
	}
	
	public List lista(int tipoLista, regulatorios.bean.RegulatorioD0842Bean regulatorioD0842Bean){		
		List regulatorioD0842 = null;
		switch (tipoLista) {	
			case Enum_Lis_RegulatorioD0842.principal:		
				regulatorioD0842 = regulatorioD0842DAO.lista(regulatorioD0842Bean, tipoLista);			
				break; 
			case Enum_Lis_RegulatorioD0842.registros:		
				regulatorioD0842 = regulatorioD0842DAO.listaRegulatorio(regulatorioD0842Bean, tipoLista);			
				break;
				
		}		
		
		
		return regulatorioD0842;
		
	}
	
	public RegulatorioD0842Bean consulta(int tipoConsulta, RegulatorioD0842Bean regulatorioD0842Bean){
		RegulatorioD0842Bean regulatorioD0842 = null;
		switch (tipoConsulta) {
			case Enum_Con_RegulatorioD0842.principal:		
				regulatorioD0842 = regulatorioD0842DAO.consultaPrincipal(regulatorioD0842Bean, tipoConsulta);				
				break;	

		}				
		return regulatorioD0842;
	}
	
	public List creaListaDetalle(RegulatorioD0842Bean regulatorioD0842Bean) {
		
		ArrayList listaDetalle = new ArrayList();
		List<String> numeroIden  	= regulatorioD0842Bean.getlnumeroIden();
		List<String> tipoPrestamista = regulatorioD0842Bean.getltipoPrestamista();
		List<String> clavePrestamista = regulatorioD0842Bean.getlclavePrestamista();
		List<String> numeroContrato = regulatorioD0842Bean.getlnumeroContrato();
		List<String> numeroCuenta   = regulatorioD0842Bean.getlnumeroCuenta();
		List<String> fechaContra  	= regulatorioD0842Bean.getlfechaContra();
		List<String> fechaVencim 	= regulatorioD0842Bean.getlfechaVencim();
		List<String> tasaAnual  	= regulatorioD0842Bean.getltasaAnual();
		List<String> plazo  	    = regulatorioD0842Bean.getlplazo();
		List<String> periodoPago  	= regulatorioD0842Bean.getlperiodoPago();
		List<String> montoRecibido  = regulatorioD0842Bean.getlmontoRecibido();
		List<String> tipoCredito  	= regulatorioD0842Bean.getltipoCredito();
		List<String> destino    	= regulatorioD0842Bean.getldestino();
		List<String> tipoGarantia  	= regulatorioD0842Bean.getltipoGarantia();
		List<String> montoGarantia  = regulatorioD0842Bean.getlmontoGarantia();
		List<String> fechaPago      = regulatorioD0842Bean.getlfechaPago();
		List<String> montoPago      = regulatorioD0842Bean.getlmontoPago();
		List<String> clasificaCortLarg= regulatorioD0842Bean.getlclasificaCortLarg();
		List<String> salInsoluto    = regulatorioD0842Bean.getlsalInsoluto();
		

		RegulatorioD0842Bean regulatorioD0842 = null;	
		if(numeroIden != null){
			int tamanio = numeroIden.size();			
			for (int i = 0; i < tamanio; i++) {
				regulatorioD0842 = new RegulatorioD0842Bean();
				
				regulatorioD0842.setAnio(regulatorioD0842Bean.getAnio());
				regulatorioD0842.setMes(regulatorioD0842Bean.getMes());
				
				regulatorioD0842.setNumeroIden(numeroIden.get(i));
				regulatorioD0842.setTipoPrestamista(tipoPrestamista.get(i));
				regulatorioD0842.setClavePrestamista(clavePrestamista.get(i));
				regulatorioD0842.setNumeroContrato(numeroContrato.get(i));
				regulatorioD0842.setNumeroCuenta(numeroCuenta.get(i));
				regulatorioD0842.setFechaContra (fechaContra.get(i));
				regulatorioD0842.setFechaVencim(fechaVencim.get(i));
				regulatorioD0842.setTasaAnual(tasaAnual.get(i));
				regulatorioD0842.setPlazo(plazo.get(i));
				regulatorioD0842.setPeriodoPago(periodoPago.get(i));
				regulatorioD0842.setMontoRecibido(montoRecibido.get(i));
				regulatorioD0842.setTipoCredito(tipoCredito.get(i));
				regulatorioD0842.setDestino(destino.get(i));
				regulatorioD0842.setTipoGarantia(tipoGarantia.get(i));
				regulatorioD0842.setFechaContra(fechaContra.get(i));
				regulatorioD0842.setMontoGarantia(montoGarantia.get(i));
				regulatorioD0842.setFechaPago(fechaPago.get(i));
				regulatorioD0842.setMontoPago(montoPago.get(i));
				regulatorioD0842.setClasificaCortLarg(clasificaCortLarg.get(i));
				regulatorioD0842.setSalInsoluto(salInsoluto.get(i));
				
				listaDetalle.add(regulatorioD0842);
				
			}
		}
		return listaDetalle;
		
	}
	
	/**
	 * Consulta de reporte D0842
	 * @param tipoLista
	 * @param reporteBean
	 * @param response
	 * @return
	 */
	public List <RegulatorioD0842Bean>listaReporteRegulatorioD0842(int tipoLista,RegulatorioD0842Bean reporteBean, HttpServletResponse response){
		List<RegulatorioD0842Bean> listaReportes=null;
		
		switch(tipoLista){
			case Enum_Lis_ReportesD0842.excel:
				listaReportes = regulatorioD0842DAO.reporteRegulatorioD0842(reporteBean, Enum_Lis_ReportesD0842.excel); 
				break;
			case Enum_Lis_ReportesD0842.csv:
				listaReportes = generarReporteRegulatorioD0842(reporteBean, Enum_Lis_ReportesD0842.csv,  response);		
				break;	
			case Enum_Lis_ReportesD0842.excelSofipo:
				listaReportes = regulatorioD0842DAO.reporteRegulatorioD0842003(reporteBean, Enum_Lis_ReportesD0842.excelSofipo); 
				break;
			case Enum_Lis_ReportesD0842.csvSofipo:
				listaReportes = generarReporteRegulatorioD0842003(reporteBean, Enum_Lis_ReportesD0842.csvSofipo,  response);		
				break;	
		}
		
		return listaReportes;
	}
	
	/**
	 * Genera reporte regulatorio D0842 version CSV
	 * @param reporteBean
	 * @param tipoReporte
	 * @param response
	 * @return
	 */
	private List generarReporteRegulatorioD0842(RegulatorioD0842Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = regulatorioD0842DAO.reporteRegulatorioD0842Csv(reporteBean, tipoReporte);
		nombreArchivo="D_0842_Desagregado_de_Prestamos_Bancarios.csv";
		
		try{
			RegulatorioD0842Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioD0842Bean) listaBeans.get(i);
					writer.write(bean.getRenglon());        
					writer.write("\r\n");	
				}
			}else{
				writer.write("");
			}
			writer.close();

			FileInputStream archivo = new FileInputStream(nombreArchivo);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition","attachment;filename="+nombreArchivo);
			response.setContentType("application/text");
			ServletOutputStream outputStream = response.getOutputStream();
			outputStream.write(datos);
			outputStream.flush();
			outputStream.close();
			
		}catch(IOException io ){	
			io.printStackTrace();
		}
		return listaBeans;
	}
	
	private List generarReporteRegulatorioD0842003(RegulatorioD0842Bean reporteBean,int tipoReporte,HttpServletResponse response){
		String nombreArchivo="";
		List listaBeans = regulatorioD0842DAO.reporteRegulatorioD0842003Csv(reporteBean, tipoReporte);
		nombreArchivo="D_0842_Desagregado_de_Prestamos_Bancarios.csv";
		
		try{
			RegulatorioD0842Bean bean;
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if (!listaBeans.isEmpty()){
				for(int i=0; i < listaBeans.size(); i++){
					bean = (RegulatorioD0842Bean) listaBeans.get(i);
					writer.write(bean.getRenglon());        
					writer.write("\r\n");	
				}
			}else{
				writer.write("");
			}
			writer.close();

			FileInputStream archivo = new FileInputStream(nombreArchivo);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition","attachment;filename="+nombreArchivo);
			response.setContentType("application/text");
			ServletOutputStream outputStream = response.getOutputStream();
			outputStream.write(datos);
			outputStream.flush();
			outputStream.close();
			
		}catch(IOException io ){	
			io.printStackTrace();
		}
		return listaBeans;
	}
	
	
	public String descripcionMes(String meses){
		String mes = "";
		int mese = Integer.parseInt(meses);
        switch (mese) {
            case 1:  mes ="ENERO" ; break;
            case 2:  mes ="FEBRERO"; break;
            case 3:  mes ="MARZO"; break;
            case 4:  mes ="ABRIL"; break;
            case 5:  mes ="MAYO"; break;
            case 6:  mes ="JUNIO"; break;
            case 7:  mes ="JULIO"; break;
            case 8:  mes ="AGOSTO"; break;
            case 9:  mes ="SEPTIEMBRE"; break;
            case 10: mes ="OCTUBRE"; break;
            case 11: mes ="NOVIEMBRE"; break;
            case 12: mes ="DICIEMBRE"; break;
        }
        return mes;
	}

	public RegulatorioD0842DAO getRegulatorioD0842DAO() {
		return regulatorioD0842DAO;
	}

	public void setRegulatorioD0842DAO(RegulatorioD0842DAO regulatorioD0842DAO) {
		this.regulatorioD0842DAO = regulatorioD0842DAO;
	}

	
	
}
