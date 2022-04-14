package regulatorios.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import regulatorios.bean.RegulatorioInsBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class RegulatorioInsDAO extends BaseDAO {

	public RegulatorioInsBean consultaAplicaRegulatorio(RegulatorioInsBean regulatorioInsBean,int tipoConsulta) {
		RegulatorioInsBean regulatorioBeanResp = null;
		try{
			//Query con el Store Procedure
			String query = "call REGULATORIOSINSCON(?,?,?,?,?, ?,?,?,?);";			
			Object[] parametros = {	regulatorioInsBean.getClave(),
									tipoConsulta,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"RegulatoriosInsDan.consultaAplicaRegulatorio",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOSINSCON(" + Arrays.toString(parametros) + ")");

			
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								RegulatorioInsBean regulatorioBean = new RegulatorioInsBean();		
		        				
								regulatorioBean.setClave(resultSet.getString("Clave"));
								regulatorioBean.setAplica(resultSet.getString("Aplica"));
								
							return regulatorioBean;
							
						}
			});
			regulatorioBeanResp= matches.size() > 0 ? (RegulatorioInsBean) matches.get(0) : null;
		}catch(Exception e){
			
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de Regulatorios", e);
			
		}
		return regulatorioBeanResp;
	}	
	
	
	
	public List listaInstitucionesReg(RegulatorioInsBean regulatorioInsBean,int tipoConsulta) {
		List regulatorioBeanResp = null;
		try{
			//Query con el Store Procedure
			String query = "call TIPOSINSTITUCIONLIS(?,?,?,?,?, ?,?,?);";			
			Object[] parametros = {	
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"RegulatoriosInsDan.consultaInstitucionesReg",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSINSTITUCIONLIS(" + Arrays.toString(parametros) + ")");

			
			regulatorioBeanResp = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								RegulatorioInsBean regulatorioBean = new RegulatorioInsBean();		
		        				
								regulatorioBean.setClave(resultSet.getString("TipoInstitID"));
								regulatorioBean.setDescripcion(resultSet.getString("Descripcion"));
								
							return regulatorioBean;
							
						}
			});

		}catch(Exception e){
			
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de Regulatorios", e);
			
		}
		return regulatorioBeanResp;
	}
	
	
	public List listaNivelOperaciones(RegulatorioInsBean regulatorioInsBean,int tipoConsulta) {
		List regulatorioBeanResp = null;
		try{
			//Query con el Store Procedure
			String query = "call CATPRUDENCIALOPERALIS(?,?,?,?,?, ?,?,?);";			
			Object[] parametros = {	
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"RegulatoriosInsDan.listaNivelOperaciones",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATPRUDENCIALOPERALIS(" + Arrays.toString(parametros) + ")");

			
			regulatorioBeanResp = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								RegulatorioInsBean regulatorioBean = new RegulatorioInsBean();		
		        				
								regulatorioBean.setClave(resultSet.getString("NivelID"));
								regulatorioBean.setDescripcion(resultSet.getString("DescOpera"));
								
							return regulatorioBean;
							
						}
			});

		}catch(Exception e){
			
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de Regulatorios", e);
			
		}
		return regulatorioBeanResp;
	}
	
	
	public List listaNivelPrudencial(RegulatorioInsBean regulatorioInsBean,int tipoConsulta) {
		List regulatorioBeanResp = null;
		try{
			//Query con el Store Procedure
			String query = "call CATPRUDENCIALOPERALIS(?,?,?,?,?, ?,?,?);";			
			Object[] parametros = {	
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"RegulatoriosInsDan.listaNivelOperaciones",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATPRUDENCIALOPERALIS(" + Arrays.toString(parametros) + ")");

			
			regulatorioBeanResp = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								RegulatorioInsBean regulatorioBean = new RegulatorioInsBean();		
		        				
								regulatorioBean.setClave(resultSet.getString("NivelID"));
								regulatorioBean.setDescripcion(resultSet.getString("DescPrudencial"));
								
							return regulatorioBean;
							
						}
			});

		}catch(Exception e){
			
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de Regulatorios", e);
			
		}
		return regulatorioBeanResp;
	}
}
