package tarjetas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import tarjetas.bean.TarDebParamBean;
 
public class TarDebParamDAO  extends BaseDAO{
	public TarDebParamDAO() {
		super();
	}
public TarDebParamBean consultaRuta(final int tipoConsulta, TarDebParamBean tardebParam){
	String query = "call TARDEBPARAMSCON(?,?,?,  ?,?,?, ?,?);";
	
	Object[] parametros = { tipoConsulta,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							Constantes.STRING_VACIO,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
							};
	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBPARAMSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			TarDebParamBean tarjetaParametros = new TarDebParamBean();
			tarjetaParametros.setRutaAclaracion(resultSet.getString(1));
			return tarjetaParametros;
		}
	});
	return matches.size() > 0 ? (TarDebParamBean) matches.get(0) : null;
}
}
