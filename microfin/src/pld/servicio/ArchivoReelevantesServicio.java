package pld.servicio;

import java.util.ArrayList;
import java.util.List;

import contabilidad.bean.ContaElecPolizasBean.Poliza.Transaccion;
import pld.bean.ArchivoReelevantesBean;
import pld.bean.ReporteReelevantesBean;
import pld.dao.ArchivoReelevantesDAO;
import general.servicio.BaseServicio;


public class ArchivoReelevantesServicio extends BaseServicio {
	//---------- Constructor ------------------------------------------------------------------------
	private ArchivoReelevantesServicio(){
		super();
	}
	//---------- Variables ------------------------------------------------------------------------	
	ArchivoReelevantesDAO archivoReelevantesDAO = null;
	
	public static interface Enum_Con_Reelevantes{
		int principal   = 1;
	}
	
	
	
	/* Exportar archivo de Dipersion */
	public List OpeReelevantes(ReporteReelevantesBean reporteReelevantesBean){
		List<ArchivoReelevantesBean> listaRegistros = null;
		List<ArchivoReelevantesBean> lista = new ArrayList();
		
		String vacio = "";
		long numTransaccion = archivoReelevantesDAO.getNumTransaccion();
		listaRegistros = archivoReelevantesDAO.OpeReelevantes(reporteReelevantesBean, Enum_Con_Reelevantes.principal, numTransaccion);
		
		//Agregar una bandera que indique cuando un registro no cumple con las requisitos, esto para generar al final como error
		
		for (ArchivoReelevantesBean listaRee: listaRegistros){

			String TipoReporte = (listaRee.getTipoReporte()!=null) ? listaRee.getTipoReporte(): vacio;
			String PeriodoReporte = (listaRee.getPeriodoReporte()!=null) ? listaRee.getPeriodoReporte(): vacio;
			String Folio = (listaRee.getFolio()!=null) ? listaRee.getFolio(): vacio;
			String ClaveOrgSupervisor = (listaRee.getClaveOrgSupervisor()!=null) ? listaRee.getClaveOrgSupervisor(): vacio;
			String ClaveEntCasFim = (listaRee.getClaveEntCasFim()!=null) ? listaRee.getClaveEntCasFim(): vacio;
			String LocalidadSuc = (listaRee.getLocalidadSuc()!=null) ? listaRee.getLocalidadSuc(): vacio;
			String SucursalID = (listaRee.getSucursalID()!=null) ? listaRee.getSucursalID(): vacio;
			String TipoOperacionID = (listaRee.getTipoOperacionID()!=null) ? listaRee.getTipoOperacionID(): vacio;
			String InstrumentMonID = (listaRee.getInstrumentMonID()!=null) ? listaRee.getInstrumentMonID(): vacio;
			String CuentaAhoID = (listaRee.getCuentaAhoID()!=null) ? listaRee.getCuentaAhoID(): vacio;
			String Monto = (listaRee.getMonto()!=null) ? listaRee.getMonto(): vacio;
			String ClaveMoneda = (listaRee.getClaveMoneda()!=null) ? listaRee.getClaveMoneda(): vacio;
			String FechaOpe = (listaRee.getFechaOpe()!=null) ? listaRee.getFechaOpe(): vacio;
			String FechaDeteccion = (listaRee.getFechaDeteccion()!=null) ? listaRee.getFechaDeteccion(): vacio;
			String Nacionalidad = (listaRee.getNacionalidad()!=null) ? listaRee.getNacionalidad(): vacio;
			String TipoPersona = (listaRee.getTipoPersona()!=null) ? listaRee.getTipoPersona(): vacio;
			String RazonSocial = (listaRee.getRazonSocial()!=null) ? listaRee.getRazonSocial(): vacio;
			String Nombre = (listaRee.getNombre()!=null) ? listaRee.getNombre(): vacio;
			String ApellidoPat = (listaRee.getApellidoPat()!=null) ? listaRee.getApellidoPat(): vacio;
			//String ApellidoPat = (listaRee.getApellidoPat()!=null) ? listaRee.getApellidoPat(): vacio;
			String ApellidoMat = (listaRee.getApellidoMat()!=null) ? listaRee.getApellidoMat(): vacio;
			String RFC = (listaRee.getRFC()!=null) ? listaRee.getRFC(): vacio;
			String CURP = (listaRee.getCURP()!=null) ? listaRee.getCURP(): vacio;
			String FechaNac = (listaRee.getFechaNac()!=null) ? listaRee.getFechaNac(): vacio;
			String Domicilio = (listaRee.getDomicilio()!=null) ? listaRee.getDomicilio(): vacio;
			String Colonia = (listaRee.getColonia()!=null) ? listaRee.getColonia(): vacio;
			String Localidad = (listaRee.getLocalidad()!=null) ? listaRee.getLocalidad(): vacio;
			String Telefono = (listaRee.getTelefono()!=null) ? listaRee.getTelefono(): vacio;
			String ActEconomica = (listaRee.getActEconomica()!=null) ? listaRee.getActEconomica(): vacio;
			String NomApoderado = (listaRee.getNomApoderado()!=null) ? listaRee.getNomApoderado(): vacio;
			String ApPatApoderado = (listaRee.getApPatApoderado()!=null) ? listaRee.getApPatApoderado(): vacio;
			String ApMatApoderado = (listaRee.getApMatApoderado()!=null) ? listaRee.getApMatApoderado(): vacio;
			String RFCApoderado = (listaRee.getRFCApoderado()!=null) ? listaRee.getRFCApoderado(): vacio;
			String CURPApoderado = (listaRee.getCURPApoderado()!=null) ? listaRee.getCURPApoderado(): vacio;
			String CtaRelacionadoID = (listaRee.getCtaRelacionadoID()!=null) ? listaRee.getCtaRelacionadoID(): vacio;
			String CuenAhoRelacionado = (listaRee.getCuenAhoRelacionado()!=null) ? listaRee.getCuenAhoRelacionado(): vacio;
			String ClaveSujeto = (listaRee.getClaveSujeto()!=null) ? listaRee.getClaveSujeto(): vacio;
			String NomTitular = (listaRee.getNomTitular()!=null) ? listaRee.getNomTitular(): vacio;
			String ApPatTitular = (listaRee.getApPatTitular()!=null) ? listaRee.getApPatTitular(): vacio;
			String ApMatTitular = (listaRee.getApMatTitular()!=null) ? listaRee.getApMatTitular(): vacio;
			String DesOperacion = (listaRee.getDesOperacion()!=null) ? listaRee.getDesOperacion(): vacio;
			String Razones = (listaRee.getRazones()!=null) ? listaRee.getRazones(): vacio;
			
			
			
			/* writer.write(		
					 "'"+beanDispersion.getGridTipoMov()+"\t"+
					 "'"+beanDispersion.getClaveDispersion()+"\t"+
					 "'"+beanDispersion.getGridCuentaAhoID()+"\t"+
					 "'"+beanDispersion.getGridCuentaClabe()+"\t"+
					 "'"+beanDispersion.getGridMonto()+"\t"+
					 "'"+beanDispersion.getGridReferencia()+"\t"+
					 beanDispersion.getGridDescripcion()+"\t"+
					 "'"+beanDispersion.getGridRFC()+"\t"+
					 "'"+beanDispersion.getIva()+"\t"+
					 beanDispersion.getFechaAplicar()+"\t"+
					 beanDispersion.getNombreBeneficiario()
						);        
				writer.newLine(); // Esto es un salto de linea	
		 }*/
		
		
		
		}
	
		return listaRegistros;
	}



	public ArchivoReelevantesDAO getArchivoReelevantesDAO() {
		return archivoReelevantesDAO;
	}



	public void setArchivoReelevantesDAO(ArchivoReelevantesDAO archivoReelevantesDAO) {
		this.archivoReelevantesDAO = archivoReelevantesDAO;
	}
	
	
	
}
