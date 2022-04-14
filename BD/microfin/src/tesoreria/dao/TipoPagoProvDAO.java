package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
 
import tesoreria.bean.TipoPagoProvBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class TipoPagoProvDAO extends BaseDAO{
	
	public TipoPagoProvDAO(){
		super();
	}
	
	
	public List listaTipoPago(TipoPagoProvBean pagoProveedoresBean, int tipoLista){
		String query = "call TIPOPAGOPROVLIS(?,?,?,?,?,?,?,?,?);";

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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOPAGOPROVLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TipoPagoProvBean pagoProvBean = new TipoPagoProvBean();
				pagoProvBean.setTipoPagoProvID(String.valueOf(resultSet.getInt(1))); 
				pagoProvBean.setDescripcion(resultSet.getString(2));
				pagoProvBean.setCuentaContable(resultSet.getString(3));
				return pagoProvBean;
			}
		});
		return matches;
	}

	

}
