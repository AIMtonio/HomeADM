package cobranza.dao;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import cobranza.bean.RepPagosAsignacionBean;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class RepPagosAsignacionDAO extends BaseDAO {
	public RepPagosAsignacionDAO(){
			
		}


		public List reportePagosAsignados(int tipoLista,RepPagosAsignacionBean repPagosAsignacionBean){
		String query = "call COBCARTERAPAGOSASIGNAREP(?,?,?,	?,?,?,?,?,?,?);";
		Object[] parametros = {	
				
				repPagosAsignacionBean.getFechaInicioAsigna(),
				repPagosAsignacionBean.getFechaFinAsigna(),
				Utileria.convierteEntero(repPagosAsignacionBean.getGestorID()), 

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"RepPagosAsignacionDAO.reportePagosAsignados",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COBCARTERAPAGOSASIGNAREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RepPagosAsignacionBean repPagosAsignacionBean = new RepPagosAsignacionBean();
				
				repPagosAsignacionBean.setFecha(resultSet.getString("Fecha"));
				repPagosAsignacionBean.setClienteID(resultSet.getString("ClienteID"));
				repPagosAsignacionBean.setCreditoID(resultSet.getString("CreditoID"));
				repPagosAsignacionBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				repPagosAsignacionBean.setNombreSucursal(resultSet.getString("NombreSucursal"));
				
				repPagosAsignacionBean.setMonto(resultSet.getString("Monto"));
				repPagosAsignacionBean.setDescripcionMov(resultSet.getString("DescripcionMov"));
				repPagosAsignacionBean.setCapital(resultSet.getString("Capital"));
				repPagosAsignacionBean.setInteresNormal(resultSet.getString("InteresNormal"));
				repPagosAsignacionBean.setIvaInteresNor(resultSet.getString("IVAIntNormal"));
				
				repPagosAsignacionBean.setInteresMora(resultSet.getString("InteresMora"));
				repPagosAsignacionBean.setIvaInteresMora(resultSet.getString("IVAIntMora"));
				repPagosAsignacionBean.setPorcComision(resultSet.getString("PorcComision"));
				repPagosAsignacionBean.setComision(resultSet.getString("Comision"));
				repPagosAsignacionBean.setSumaMonto(resultSet.getString("MontoTotal"));
				
				repPagosAsignacionBean.setSumaComision(resultSet.getString("ComisionTotal"));
				repPagosAsignacionBean.setNombreGestor(resultSet.getString("NombreGestor"));
				
				
				return repPagosAsignacionBean;
			}
		});
		return matches;
	}
}
