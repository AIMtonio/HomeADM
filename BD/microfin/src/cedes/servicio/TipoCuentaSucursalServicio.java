package cedes.servicio;


import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;

import reporte.ParametrosReporte;
import reporte.Reporte;
import cedes.bean.TipoCuentaSucursalBean;
import cedes.dao.TipoCuentaSucursalDAO;

public class TipoCuentaSucursalServicio extends BaseServicio{
	private TipoCuentaSucursalServicio(){
		super();
	}
 
	TipoCuentaSucursalDAO tipoCuentaSucursalDAO = null;
	private ParametrosSesionBean parametrosSesionBean;
	
	public static interface Enum_Tra_TipoCuentaSucursal {
		int alta = 1;
		int baja =2;
	}
	public static interface Enum_Lis_TipoCuentaSucursal {
		int principal = 1;
		int porSucursal = 2;
		int porEstado = 5;
		int porSucTasa=7;
		int porEstadoTasa=10;
		int porPrincipalTasa=12;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TipoCuentaSucursalBean bean){
		MensajeTransaccionBean mensaje = null;		
		switch(tipoTransaccion){
		case Enum_Tra_TipoCuentaSucursal.alta:
				ArrayList listaSucursales = (ArrayList) creaListaDetalle(bean);		
				mensaje = tipoCuentaSucursalDAO.procesarAlta(listaSucursales);	
			break;
		case Enum_Tra_TipoCuentaSucursal.baja:
			mensaje = tipoCuentaSucursalDAO.baja(bean);	
		break;
		}
		return mensaje;
	}
	


	/* Lista todos los detalles */
	public List lista(int tipoLista, TipoCuentaSucursalBean bean){
		List lista = null;
		switch (tipoLista) {			
			case Enum_Lis_TipoCuentaSucursal.principal:
					lista = tipoCuentaSucursalDAO.lista(bean, tipoLista);
				break;	
			case Enum_Lis_TipoCuentaSucursal.porSucursal:
					lista = tipoCuentaSucursalDAO.listaFiltro(bean, tipoLista);		
				break;
			case Enum_Lis_TipoCuentaSucursal.porEstado:
					lista = tipoCuentaSucursalDAO.listaFiltro(bean, tipoLista);		
					break;
			case Enum_Lis_TipoCuentaSucursal.porSucTasa:
				lista = tipoCuentaSucursalDAO.listaFiltro(bean, tipoLista);		
				break;
			case Enum_Lis_TipoCuentaSucursal.porEstadoTasa:
				lista = tipoCuentaSucursalDAO.listaFiltro(bean, tipoLista);		
				break;
			case Enum_Lis_TipoCuentaSucursal.porPrincipalTasa:
				lista = tipoCuentaSucursalDAO.lista(bean, tipoLista);		
				break;				
		}
		return lista;	
	}
	
	
	/* Arma la lista de beans */
	public List creaListaDetalle( TipoCuentaSucursalBean bean) {		
		
		List<String> sucursales  = bean.getlSucursalID();
		List<String> estados	 = bean.getlEstadoID();
		List<String> estatus	 = bean.getlEstatus();

		ArrayList listaDetalle = new ArrayList();
		TipoCuentaSucursalBean beanAux = null;	
		
		if(sucursales != null){
			int tamanio = sucursales.size();			
			for (int i = 0; i < tamanio; i++ ) {
				
					beanAux = new TipoCuentaSucursalBean();
				
					beanAux.setInstrumentoID(bean.getInstrumentoID());
					beanAux.setTipoInstrumentoID(bean.getTipoInstrumentoID());
					beanAux.setSucursalID(sucursales.get(i));
					beanAux.setEstadoID(estados.get(i));
					beanAux.setEstatus(estatus.get(i));

					listaDetalle.add(beanAux);
	
			}
		}
		
		return listaDetalle;
		
	}
	
	
	/* =========  Reporte de Sucursales por producto PDF  =========== */
	public ByteArrayOutputStream reporteTipoCuentaSucursal(int tipoReporte, TipoCuentaSucursalBean bean , String nomReporte) throws Exception{
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();

		parametrosReporte.agregaParametro("Par_TipoCuentaID",Utileria.convierteEntero(bean.getTipoCuentaID()));
		parametrosReporte.agregaParametro("Par_NombreCuenta",bean.getNombreCuenta());
		parametrosReporte.agregaParametro("Par_NumReporte",tipoReporte);
		
		parametrosReporte.agregaParametro("Par_NombreInstitucion", bean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaSistema",Utileria.convierteFecha(bean.getFechaSistema()));
		parametrosReporte.agregaParametro("Par_Usuario",parametrosSesionBean.getClaveUsuario().toUpperCase());
		parametrosReporte.agregaParametro("Par_TipoInstrumento",Utileria.convierteEntero(bean.getTipoInstrumentoID()));
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	

	/* Getter y Setter */
	public TipoCuentaSucursalDAO getTipoCuentaSucursalDAO() {
		return tipoCuentaSucursalDAO;
	}
	public void setTipoCuentaSucursalDAO(TipoCuentaSucursalDAO tipoCuentaSucursalDAO) {
		this.tipoCuentaSucursalDAO = tipoCuentaSucursalDAO;
	}
	
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
