package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

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
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import tesoreria.bean.CondicionespagoBean;


public class CondicionespagoDAO extends BaseDAO  {
	

	public CondicionespagoDAO() {
		super();
	}
	

	//Consulta de de Dias condiciones pago
		public CondicionespagoBean consultaDias(CondicionespagoBean condicionespagoBean, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call CONDICIONESPAGOCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(condicionespagoBean.getCondicionPagoID()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONDICIONESPAGOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CondicionespagoBean condicionespagoBean = new CondicionespagoBean();
					condicionespagoBean.setNumeroDias(String.valueOf(resultSet.getInt(1)));
					return condicionespagoBean;
				}
			});
			return matches.size() > 0 ? (CondicionespagoBean) matches.get(0) : null;
		}

		
		
	public List listaCondicionespago(CondicionespagoBean condicionespagoBean, int tipoLista){
		String query = "call CONDICIONESPAGOLIS(?,?,?,?,?,?,?,?,?);";

		Object[] parametros = {
					Constantes.ENTERO_CERO,
					tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONDICIONESPAGOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CondicionespagoBean condicionespagoBean = new CondicionespagoBean();
				condicionespagoBean.setCondicionPagoID(String.valueOf(resultSet.getInt(1))); 
				condicionespagoBean.setDescripcion(resultSet.getString(2));
				condicionespagoBean.setNumeroDias(String.valueOf(resultSet.getInt(3)));
				return condicionespagoBean;
			}
		});
		return matches;
	}

	
}

