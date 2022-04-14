package cliente.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import cliente.bean.EstadoCuentaUnicoBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;

public class EdoCuentaUnicoRepDAO extends BaseDAO{
		public EdoCuentaUnicoRepDAO(){
			super();			
		}
		
		// Consulta Ruta Estado de Cuenta
		public EstadoCuentaUnicoBean consultaPrincipal(int tipoConsulta) {
			EstadoCuentaUnicoBean estadoCuentaUnico = null; 
			
			try{
				String query = "call EDOCTAPARAMSCON(?,?,?,?,?, ?,?,?);";
				Object[] parametros = { 								
										tipoConsulta,																
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										OperacionesFechas.FEC_VACIA,
										Constantes.STRING_VACIO,
										"consultaPrincipal",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};
				
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAPARAMSCON(" + Arrays.toString(parametros) +")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)
							throws SQLException {
						EstadoCuentaUnicoBean estadoCuentaUnico = new EstadoCuentaUnicoBean();
						
						estadoCuentaUnico.setRutapdf(resultSet.getString("RutaExpPDF"));
				
						return estadoCuentaUnico;
					}
				});
			estadoCuentaUnico = matches.size() > 0 ? (EstadoCuentaUnicoBean) matches.get(0) : null;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta Principal del Estado de Cuenta Unico", e);
			}
			return estadoCuentaUnico ;
		}

}

