package contabilidad.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import contabilidad.bean.CuentasBalanzaBean;
import contabilidad.bean.CuentasBalanzaBean;

import javax.sql.DataSource;

public class CuentasBalanzaDAO extends BaseDAO{
	public CuentasBalanzaDAO() {
		super();
	}

	
	public CuentasBalanzaBean consultaForanea(CuentasBalanzaBean cuentasBalanza, int tipoConsulta){
		String query = "call CUENTASBALANZACON(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = { 
				cuentasBalanza.getCuentaContable(),
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasBalanzaDAO.consultaForanea",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASBALANZACON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasBalanzaBean cuentasBalanza = new CuentasBalanzaBean();
				cuentasBalanza.setConBalanzaID(resultSet.getString(1));
				cuentasBalanza.setCuentaContable(resultSet.getString(2));
				return cuentasBalanza;
			}
		});
		return matches.size() > 0 ? (CuentasBalanzaBean) matches.get(0) : null;
	}
	
}

