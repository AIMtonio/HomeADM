package nomina.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import nomina.bean.ProcesaDomiciliacionPagosBean;
import nomina.bean.ResultadoCargaArchivosDomiciliaBean;
import nomina.dao.ProcesaDomiciliacionPagosDAO;


public class ProcesaDomiciliacionPagosServicio extends BaseServicio{
	ProcesaDomiciliacionPagosDAO procesaDomiciliacionPagosDAO = null;

	public ProcesaDomiciliacionPagosServicio (){
		super();
	}
	
	// -------------- Tipo Transaccion ----------------
	public static interface Enum_Tipo_Transaccion{
		int procesar     = 1;			// Procesar Domiciliación de Pagos
		int generar      = 2;			// Genera Información para el Layout

	}
	
	// -------------- Tipo Lista ----------------
	public static interface Enum_Lis_Domiciliacion{
		int porProcesar	= 1;
	}
	
	// -------------- Tipo Actualizacion  ----------------
	public static interface Enum_Act_Domiciliacion {
		int actualizaEstatus = 1;			// Actualiza Estatus Domiciliacion de Pagos
	}
			
	/**
	 * 
	 * @param tipoTransaccion : Procesar Domiciliacion Pagos
	 * @param procesaDomiciliacionPagosBean
	 * @return
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean, List listaBean) {
	 	MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tipo_Transaccion.procesar:
				mensaje = procesaDomiciliacionPagosDAO.procesaDomicialiacionPagos(procesaDomiciliacionPagosBean,listaBean);
			break;
			case Enum_Tipo_Transaccion.generar:
				mensaje = procesaDomiciliacionPagosDAO.generaDomiciliacionPagos(procesaDomiciliacionPagosBean,listaBean);
			break;
		}
		return mensaje;
	}
	
	/**
	 * 
	 * @param folio : Número de Folio
	 * @param numLista : Número de Lista
	 * @return
	 */
	public List listaLayoutDomPagos(String folio,int numLista) {
		List listaDomPagos = null;
		
		listaDomPagos =  procesaDomiciliacionPagosDAO.listaLayoutDomPagos(folio,numLista);

		return listaDomPagos;		
	}
	
	/**
	 * 
	 * @param procesaDomiciliacionPagosBean : Generación de Layout de Domiciliación de Pagos
	 * @param consecutivo
	 * @param listaBean
	 * @param response
	 * @throws Exception 
	 */
	public void generaLayout(List procesaDomiciliacionPagosBean, long consecutivo, List listaBean,long transaccion,HttpServletResponse response) throws Exception{
		procesaDomiciliacionPagosDAO.generaLayout(procesaDomiciliacionPagosBean, consecutivo, response);
		
		ProcesaDomiciliacionPagosBean procesaDomiciliacionPagos;
		MensajeTransaccionBean mensaje = null;
		// Se actualiza el Estatus de los Créditos con Estatus Fallido después de generar el Layout de Domiciliación de Pagos
		if(listaBean != null){
			for(int i=0; i<listaBean.size(); i++){
				procesaDomiciliacionPagos = (ProcesaDomiciliacionPagosBean)listaBean.get(i);
				if(!procesaDomiciliacionPagos.getClaveDomiciliacion().equals("00")){
					// Registro de Información de Domiciliación de Pagos 
					mensaje = procesaDomiciliacionPagosDAO.actualizaDomiciliacionPagos(procesaDomiciliacionPagos,transaccion,Enum_Act_Domiciliacion.actualizaEstatus);
				
					if(mensaje.getNumero() != 0){
						throw new Exception(mensaje.getDescripcion());
					}
				}
			}
		}
	}

	/**
	 * 
	 * @param rutaArchivo : Ruta de Alojamiento del Archivo de Domiciliación de Pagos
	 * @param procesaDomiciliacionPagosBean
	 * @return
	 */
	public ResultadoCargaArchivosDomiciliaBean cargaArchivoDomiciliacion(String rutaArchivo, ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean){
		
			ResultadoCargaArchivosDomiciliaBean resultadoCarga = new ResultadoCargaArchivosDomiciliaBean();
			resultadoCarga = procesaDomiciliacionPagosDAO.cargaArchivo(rutaArchivo, procesaDomiciliacionPagosBean);
			
			if(resultadoCarga.getNumero()!=0){
				
			}else{
				resultadoCarga.setNumero(0);
				resultadoCarga.setConsecutivoInt("123");
				resultadoCarga.setConsecutivoString("0000123");
				if(resultadoCarga.getExitosos() <= 0){
					resultadoCarga.setDescripcion(resultadoCarga.getDescripcion());
				}
				
				resultadoCarga.setDescripcion("Proceso Exitoso."+
						"\n"+resultadoCarga.getDescripcion());
				resultadoCarga.setNombreControl("0");
			
			}
		return resultadoCarga;	
	}
	
	/**
	 * 
	 * @param tipoLista : Lista para Procesar Domiciliación de Pagos
	 * @param procesaDomiciliacionPagosBean
	 * @return
	 */
	public List lista(int tipoLista, ProcesaDomiciliacionPagosBean procesaDomiciliacionPagosBean){
		List domiciliaPagosLista = null;
		 switch (tipoLista) {
		    case  Enum_Lis_Domiciliacion.porProcesar:          
		    	domiciliaPagosLista = procesaDomiciliacionPagosDAO.listaPorProcesar(procesaDomiciliacionPagosBean, tipoLista);
		    break;
		}
		return domiciliaPagosLista;
	}

	// ====================== GETTER & SETTER ================ //

	public ProcesaDomiciliacionPagosDAO getProcesaDomiciliacionPagosDAO() {
		return procesaDomiciliacionPagosDAO;
	}

	public void setProcesaDomiciliacionPagosDAO(ProcesaDomiciliacionPagosDAO procesaDomiciliacionPagosDAO) {
		this.procesaDomiciliacionPagosDAO = procesaDomiciliacionPagosDAO;
	}
	
	
}