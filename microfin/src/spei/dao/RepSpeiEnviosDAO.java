package spei.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import spei.bean.RepSpeiEnviosBean;

import general.dao.BaseDAO;
import herramientas.Constantes;

public class RepSpeiEnviosDAO extends BaseDAO{
	public RepSpeiEnviosDAO(){
		super();
	}
	
	// Metodo para obtener los datos de las ordenes de pago de la tabla SPEIENVIOS
	public List listaReporte(final RepSpeiEnviosBean repSpeiEnviosBean, int numReporte){	
		List ListaResultado=null;
		
		try{
		String query = "CALL SPEIENVIOSSTPREP(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?)";

		Object[] parametros ={
				repSpeiEnviosBean.getFechaInicio(),
				repSpeiEnviosBean.getFechaFin(),
				repSpeiEnviosBean.getMontoTransferIni(),
				repSpeiEnviosBean.getMontoTransferFin(),
				repSpeiEnviosBean.getCuentaAhoID(),
				
				numReporte,
				
	    		parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
		};
		
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL SPEIENVIOSSTPREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RepSpeiEnviosBean repSpeiEnviosBean= new RepSpeiEnviosBean();
				
				repSpeiEnviosBean.setNombreOrd(resultSet.getString("NombreOrd"));
				repSpeiEnviosBean.setCuentaOrd(resultSet.getString("CuentaOrd"));
				repSpeiEnviosBean.setNombreBeneficiario(resultSet.getString("NombreBeneficiario"));
				repSpeiEnviosBean.setCuentaBeneficiario(resultSet.getString("CuentaBeneficiario"));
				repSpeiEnviosBean.setConceptoPago(resultSet.getString("ConceptoPago"));
				repSpeiEnviosBean.setTotalCargoCuenta(resultSet.getString("TotalCargoCuenta"));
				repSpeiEnviosBean.setMontoTransferir(resultSet.getString("MontoTransferir"));
				repSpeiEnviosBean.setiVAPorPagar(resultSet.getString("IVAPorPagar"));
				repSpeiEnviosBean.setiVAComision(resultSet.getString("IVAComision"));
				repSpeiEnviosBean.setCuentaAhoID(resultSet.getString("CuentaAho"));
				repSpeiEnviosBean.setFechaOperacion(resultSet.getString("FechaOperacion"));
				repSpeiEnviosBean.setTipoPago(resultSet.getString("TipoPago"));
				repSpeiEnviosBean.setInsRemitente(resultSet.getString("InsRemitente"));
				repSpeiEnviosBean.setInsReceptora(resultSet.getString("InsReceptora"));
				repSpeiEnviosBean.setEstatus(resultSet.getString("Estatus"));
				repSpeiEnviosBean.setEstatusEnv(resultSet.getString("EstatusEnv"));
				repSpeiEnviosBean.setClaveRastreo(resultSet.getString("ClaveRastreo"));
				repSpeiEnviosBean.setCausaDevol(resultSet.getString("CausaDevol"));
				repSpeiEnviosBean.setFolioSpeiID(resultSet.getString("FolioSpeiID"));
				repSpeiEnviosBean.setFolioSTP(resultSet.getString("FolioSTP"));
				repSpeiEnviosBean.setOrigenOperacion(resultSet.getString("OrigenOperacion"));
				
				return repSpeiEnviosBean ;
			}
		});
		ListaResultado= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de spei envios", e);
		}
		return ListaResultado;
	}
}