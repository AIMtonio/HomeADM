package contabilidad.dao;
import general.dao.BaseDAO;
import herramientas.Constantes;

 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.jdbc.core.RowMapper;
import contabilidad.bean.SaldosContablesBean;


public class SaldosContablesDAO extends BaseDAO{

		public SaldosContablesDAO() {
			super();
		}

		public List consultaDebeHaber(String fechaCreacion,int tipoConsulta){
			String query = "call SALDOSCONTABLESCON(?,?,?,?,?   ,?,?,?,?);";
			Object[] parametros = { 
					tipoConsulta,
					fechaCreacion,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"SALDOSCONTABLESCON.consultaDebeHaber",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SALDOSCONTABLESCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SaldosContablesBean saldosContables = new SaldosContablesBean();
					saldosContables.setCuentaCompleta(resultSet.getString("cuentaCompleta"));
					saldosContables.setAbonos(resultSet.getString("Haber"));
					saldosContables.setCargos(resultSet.getString("Debe"));
					saldosContables.setSaldoInicial(resultSet.getString("SaldoInicial"));
					saldosContables.setSaldoFinal(resultSet.getString("SaldoFinal"));
					return saldosContables;
				}
			});
			return matches;
		}





}
