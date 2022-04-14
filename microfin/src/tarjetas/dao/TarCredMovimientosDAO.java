package tarjetas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import tarjetas.bean.TarCredMovimientosBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class TarCredMovimientosDAO extends BaseDAO{
	public TarCredMovimientosDAO() {
		super();
	}
	 
	public List listaGridMovimientos(int tipoLista,TarCredMovimientosBean tarCredMovimientosBean) {
		String query = "call TC_BITACORAMOVSLIS(?,?,?,?,    ?,?,?,?,?,?,?);";
		Object[] parametros = {
				tarCredMovimientosBean.getTarjetaID(),
				tarCredMovimientosBean.getAnioPeriodo(),
				tarCredMovimientosBean.getMesPeriodo(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"TarCredMovimientosDAO.listaGridMovimientos",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TC_BITACORAMOVSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				TarCredMovimientosBean movimientosBean = new TarCredMovimientosBean();
				movimientosBean.setFechaOperacion(resultSet.getString("FechaOperacion"));
				movimientosBean.setReferencia(resultSet.getString("Referencia"));
				movimientosBean.setNombreComercio(resultSet.getString("NombreComercio"));
				movimientosBean.setCargos(resultSet.getString("Cargos"));
				movimientosBean.setAbonos(resultSet.getString("Abonos"));
				return movimientosBean;
			}
		});
		return matches;
	}
}
