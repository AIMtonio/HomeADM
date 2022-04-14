package originacion.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;

import originacion.bean.AnalistasAsignacionBean;
import originacion.dao.AnalistasAsignacionDAO;
import reporte.ParametrosReporte;
import reporte.Reporte;


public class AnalistasAsignacionServicio extends BaseServicio{
	
	
	
	//---------- Variables ------------------------------------------------------------------------
	AnalistasAsignacionDAO analistasAsignacionDAO;
	String codigo= "";
	int entero_uno=1;

	private AnalistasAsignacionServicio(){
		super();
	}
	//---------- Tipos de Listas---------------------------------------------------------------

	public static interface consultaAnalistaAsignacion {
         int listaTipoAsignacion = 1;
	}
	
	public static interface Enum_Transaccion {
		int altaAsignacionAnalistas = 1;
	}
	
	public static interface Enum_Lis_CatalogoAsignaciones{
		int listaAsignaciones		= 1; 
	}
	
	//---------- Tipos de Lista para Reportes----------------
	public static interface Enum_Tip_Reporte {
		int excel = 2;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, AnalistasAsignacionBean analistasAsignacionBean,String detalles){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Transaccion.altaAsignacionAnalistas:
			mensaje = grabaDetalle(tipoTransaccion, analistasAsignacionBean, detalles);
			break;
		}

		return mensaje;
	}

	private MensajeTransaccionBean grabaDetalle(int tipoTransaccion, AnalistasAsignacionBean analistasAsignacionBean, String detalles) {
		MensajeTransaccionBean mensaje = null;
		try{
			switch (tipoTransaccion) {
			case consultaAnalistaAsignacion.listaTipoAsignacion:
				detalles = analistasAsignacionBean.getDetalleAsignacion();
				break;
			}
			List<AnalistasAsignacionBean> listaDetalle = creaListaDetalle(detalles);
			mensaje=analistasAsignacionDAO.grabaDetalle(analistasAsignacionBean, listaDetalle);
		} catch (Exception e){
			e.printStackTrace();
			return null;
		}
		return mensaje;
	}
	
	private List<AnalistasAsignacionBean> creaListaDetalle(String detalles) {
		StringTokenizer tokensBean = new StringTokenizer(detalles, "[");
	
		String stringCampos;
		String tokensCampos[];
		List<AnalistasAsignacionBean> listaDetalle = new ArrayList<AnalistasAsignacionBean>();
		AnalistasAsignacionBean detalle;
		try {
		while (tokensBean.hasMoreTokens()) {
			detalle = new AnalistasAsignacionBean();
			stringCampos = tokensBean.nextToken();
			
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			detalle.setUsuarioID(tokensCampos[0]);
			detalle.setClave(tokensCampos[1]);
			detalle.setProductoID(tokensCampos[2]);
			detalle.setTipoAsignacionID(tokensCampos[3]);
			
			listaDetalle.add(detalle);
		}
		} catch (Exception e){
			e.printStackTrace();
		}
		return listaDetalle;
	}
	

	public List lista(int tipoLista, AnalistasAsignacionBean analistasAsignacionBean){
		List productosCreditoLista = null;

		switch (tipoLista) {
	        case  consultaAnalistaAsignacion.listaTipoAsignacion:
	        	productosCreditoLista = analistasAsignacionDAO.lista(analistasAsignacionBean,tipoLista);
	        break;

		}
		return productosCreditoLista;
	}
	
	
	// listas para comboBox tipos activos
	public  Object[] listaComboCatalogoAsignaciones(int tipoLista) {	
		List listaBean = null;
			
		switch(tipoLista){
			case Enum_Lis_CatalogoAsignaciones.listaAsignaciones: 
				listaBean =  analistasAsignacionDAO.listaComboCatalogoAsig(tipoLista);
				break;
			
		}
		return listaBean.toArray();		
	}
	
		
	public ByteArrayOutputStream reporteProductividadAnalistaPDF(AnalistasAsignacionBean analistasAsignacionBean, String nombreReporte) throws Exception {
		// TODO Auto-generated method stub
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		try {
			parametrosReporte.agregaParametro("Par_NombreInstitucion", analistasAsignacionBean.getNombreInstitucion().toUpperCase());
			parametrosReporte.agregaParametro("Par_FechaInicio", analistasAsignacionBean.getFechaInicio());
			parametrosReporte.agregaParametro("Par_FechaFin", analistasAsignacionBean.getFechaFin());
			parametrosReporte.agregaParametro("Par_FechaSistema", analistasAsignacionBean.getFechaSistema());
			parametrosReporte.agregaParametro("Par_Usuario", analistasAsignacionBean.getUsuario());
			parametrosReporte.agregaParametro("Par_NomUsuario", analistasAsignacionBean.getNombreCompleto());
			parametrosReporte.agregaParametro("Par_UsuarioID", analistasAsignacionBean.getUsuarioID());
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el Reporte de productividad analista", e);
		}
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte,
				parametrosAuditoriaBean.getRutaReportes(),
				parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
	public List<AnalistasAsignacionBean> listaReporte(int tipoLista,AnalistasAsignacionBean analistasAsignacionBean) {
		List<AnalistasAsignacionBean> listaRep = null;
		switch (tipoLista) {
		case Enum_Tip_Reporte.excel:
			listaRep = analistasAsignacionDAO.listaReporte(analistasAsignacionBean);
			break;
		}
		return listaRep;
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	
	public void setAnalistasAsignacionDAO(AnalistasAsignacionDAO analistasAsignacionDAO) {
		this.analistasAsignacionDAO = analistasAsignacionDAO;
	}

	public AnalistasAsignacionDAO getAnalistasAsignacionDAO() {
		return analistasAsignacionDAO;
	}	
	

	


}
