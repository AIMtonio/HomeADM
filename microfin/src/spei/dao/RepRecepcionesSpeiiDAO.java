package spei.dao;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;

import spei.bean.RepRecepcionesSpeiiBean;

import cliente.bean.RepoteClientesMenoresBean;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class RepRecepcionesSpeiiDAO extends BaseDAO{
	
	public List<RepRecepcionesSpeiiBean> consulta(
			RepRecepcionesSpeiiBean repRecepcionesSpeiiBean) {
		// TODO Auto-generated method stub
		List listaResultado = null;
		
		try{
		String query = "call SPEIRECEPCIONESSTPREP(?,?,?,?, ?,?,?,?,?, ?,? )";
		
		Object[] parametros ={
				Utileria.convierteFecha(repRecepcionesSpeiiBean.getFechaInicio()),
				Utileria.convierteFecha(repRecepcionesSpeiiBean.getFechaFin()),
				Utileria.convierteDoble(repRecepcionesSpeiiBean.getMontoMin()),
				Utileria.convierteDoble(repRecepcionesSpeiiBean.getMontoMax()),
																			
				
	    		parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SPEIRECEPCIONESSTPREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RepRecepcionesSpeiiBean repRecepcionesSpeiiBean= new RepRecepcionesSpeiiBean();
			
				repRecepcionesSpeiiBean.setFolioSpeiRecID(String.valueOf(resultSet.getString("FolioSpeiRecID")));
				repRecepcionesSpeiiBean.setClaveRastreo(String.valueOf(resultSet.getString("ClaveRastreo")));
				repRecepcionesSpeiiBean.setTipoPagoID(String.valueOf(resultSet.getString("TipoPago")));
				repRecepcionesSpeiiBean.setNombreOrd(String.valueOf(resultSet.getString("NombreOrd")));
				repRecepcionesSpeiiBean.setCuentaAho(String.valueOf(resultSet.getString("CuentaOrd")));
				repRecepcionesSpeiiBean.setConceptoPago(String.valueOf(resultSet.getString("ConceptoPago")));
				repRecepcionesSpeiiBean.setMontoTransferir(String.valueOf(resultSet.getString("MontoTransferir")));
				repRecepcionesSpeiiBean.setIVAComision(String.valueOf(resultSet.getString("IVAComision")));
				repRecepcionesSpeiiBean.setInstiRemitenteID(String.valueOf(resultSet.getString("InstiRemitente")));
				repRecepcionesSpeiiBean.setInstiReceptoraID(String.valueOf(resultSet.getString("InstiReceptora")));
				
				repRecepcionesSpeiiBean.setCuentaBeneficiario(String.valueOf(resultSet.getString("CuentaBeneficiario")));
				repRecepcionesSpeiiBean.setNombreBeneficiario(String.valueOf(resultSet.getString("NombreBeneficiario")));
				repRecepcionesSpeiiBean.setFechaCaptura(String.valueOf(resultSet.getString("FechaCaptura")));
				repRecepcionesSpeiiBean.setEstatus(String.valueOf(resultSet.getString("Estatus")));
				repRecepcionesSpeiiBean.setCausaDevol(String.valueOf(resultSet.getString("CausaDevol")));
				
				return repRecepcionesSpeiiBean ;
			}
		});
		listaResultado= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de reporte de recepciones SPEI", e);
		}
		return listaResultado;
	}

}
