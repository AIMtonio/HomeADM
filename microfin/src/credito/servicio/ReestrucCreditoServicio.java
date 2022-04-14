package credito.servicio;

import general.servicio.BaseServicio;
import herramientas.Utileria;
 
import java.io.ByteArrayOutputStream;
import java.util.List;
import reporte.ParametrosReporte;
import reporte.Reporte;
import credito.dao.ReestrucCreditoDAO;
import credito.bean.ReestrucCreditoBean;
 
public class ReestrucCreditoServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	ReestrucCreditoDAO reestrucCreditoDAO = null;			   
	
	//---------- Tipo de Transacciones ----------------------------------------------------------------	
	
	public static interface Enum_Con_ReesCreditos {
		int existeCredito = 2;
	}
	
	public ReestrucCreditoServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	public ReestrucCreditoBean consulta(int tipoConsulta, ReestrucCreditoBean reesCreditosBean){
		ReestrucCreditoBean creditos = null;
		switch (tipoConsulta) {
			case Enum_Con_ReesCreditos.existeCredito:		
				creditos = reestrucCreditoDAO.consultaExisteCredito(reesCreditosBean, tipoConsulta);				
				break;	
		}
		return creditos;
	}
	
	public ByteArrayOutputStream reporteReestrucCondPDF(ReestrucCreditoBean reestrucCreditoBean, String nomReporte) throws Exception{
	
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_FechaInicio",  reestrucCreditoBean.getFechaInicio() );
		parametrosReporte.agregaParametro("Par_FechaFin",  reestrucCreditoBean.getFechaVencimien() );
		parametrosReporte.agregaParametro("Par_Municipio", Utileria.convierteEntero(reestrucCreditoBean.getMunicipioID()) );
		parametrosReporte.agregaParametro("Par_Estado",  Utileria.convierteEntero( reestrucCreditoBean.getEstadoID() ));
		parametrosReporte.agregaParametro("Par_ProductoCreOrig",  Utileria.convierteEntero( reestrucCreditoBean.getProductoCreOrig()) );
		parametrosReporte.agregaParametro("Par_MonedaID",  Utileria.convierteEntero( reestrucCreditoBean.getMonedaID() ));
		parametrosReporte.agregaParametro("Par_Sucursal",  Utileria.convierteEntero( reestrucCreditoBean.getSucursal() ));
	    parametrosReporte.agregaParametro("Par_NivelDetalle", Utileria.convierteEntero( reestrucCreditoBean.getNivelDetalle() ));
	    parametrosReporte.agregaParametro("Par_FechaEmision",  reestrucCreditoBean.getFechaEmision() );
		parametrosReporte.agregaParametro("Par_ProductoCreDest",  Utileria.convierteEntero( reestrucCreditoBean.getProductoCreDest() ));
		parametrosReporte.agregaParametro("Par_UsuarioID",  Utileria.convierteEntero(reestrucCreditoBean.getUsuarioID()));	

		parametrosReporte.agregaParametro("Par_NomInstitucion",  !reestrucCreditoBean.getNomInstitucion().isEmpty()?reestrucCreditoBean.getNomInstitucion():"" );
		parametrosReporte.agregaParametro("Par_NomUsuario",  !reestrucCreditoBean.getNomUsuario().isEmpty()?reestrucCreditoBean.getNomUsuario():"" );
		parametrosReporte.agregaParametro("Par_NomMunicipio",  !reestrucCreditoBean.getNomMunicipio().isEmpty()?reestrucCreditoBean.getNomMunicipio():"TODOS" );
		parametrosReporte.agregaParametro("Par_NomEstado",  !reestrucCreditoBean.getNomEstado().isEmpty()?reestrucCreditoBean.getNomEstado():"TODOS" );
		parametrosReporte.agregaParametro("Par_NomProductoCreOrig", !reestrucCreditoBean.getNomProductoCreOrig().isEmpty()?reestrucCreditoBean.getNomProductoCreOrig():"TODOS" );
	    parametrosReporte.agregaParametro("Par_NomProductoCreDest",  !reestrucCreditoBean.getNomProductoCreDest().isEmpty()?reestrucCreditoBean.getNomProductoCreDest() :"TODOS" );
		parametrosReporte.agregaParametro("Par_NomUsuarioReest",  !reestrucCreditoBean.getNomUsuarioReest().isEmpty()?reestrucCreditoBean.getNomUsuarioReest():"TODOS" );
		parametrosReporte.agregaParametro("Par_NomMoneda",  !reestrucCreditoBean.getNomMoneda().isEmpty()?reestrucCreditoBean.getNomMoneda() :"TODAS" );
		parametrosReporte.agregaParametro("Par_NomSucursal",  !reestrucCreditoBean.getNomSucursal().isEmpty()?reestrucCreditoBean.getNomSucursal():"TODAS" );
		parametrosReporte.agregaParametro("Aud_Usuario",String.valueOf(parametrosAuditoriaBean.getUsuario()));

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	

	
	 //lista para el reporte en excel
	public List reporteExceReestruc (ReestrucCreditoBean reestrucCreditoBean , int tipoLista){
		List listaResultado = null;
		listaResultado= reestrucCreditoDAO.listaReporteReestrucExcel(reestrucCreditoBean, tipoLista);
		return listaResultado;
	}

	public ReestrucCreditoDAO getReestrucCreditoDAO() {
		return reestrucCreditoDAO;
	}


	public void setReestrucCreditoDAO(ReestrucCreditoDAO reestrucCreditoDAO) {
		this.reestrucCreditoDAO = reestrucCreditoDAO;
	}

	
	
	
	
}

